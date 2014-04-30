Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165AbaD3RDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:03:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758917AbaD3RDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:03:02 -0400
Date: Wed, 30 Apr 2014 19:02:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <kmo@daterainc.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] aio: change exit_aio() to load mm->ioctx_table once
	and avoid rcu_read_lock()
Message-ID: <20140430170248.GA22640@redhat.com>
References: <20140429183915.GA32513@redhat.com> <20140429184004.GB32521@redhat.com> <20140429204217.GO14608@kvack.org> <20140429212222.GA28959@kvack.org> <20140430141552.GA18539@redhat.com> <20140430141616.GB18539@redhat.com> <20140430152344.GD28959@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430152344.GD28959@kvack.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30, Benjamin LaHaise wrote:
>
> > -		ctx->mmap_size = 0;
> > -
> > -		kill_ioctx(mm, ctx, NULL);
> > +		if (ctx) {
> > +			ctx->mmap_size = 0;
> > +			kill_ioctx(mm, ctx, NULL);
> > +		}
>
> Rather than indenting and moving the two lines changing mmap_size and the
> kill_ioctx() call, why not just do "if (!ctx) ... continue;"?  That reduces
> the number of lines changed and avoid excessive indentation.

OK. To me the code looks better/simpler with "if (ctx)", but this is subjective
of course, I won't argue.

The patch still removes the empty line between mmap_size = 0 and kill_ioctx(),
we reset mmap_size only for kill_ioctx(). But feel free to remove this change.

-------------------------------------------------------------------------------
Subject: [PATCH v3 1/2] aio: change exit_aio() to load mm->ioctx_table once and avoid rcu_read_lock()

1. We can read ->ioctx_table only once and we do not read rcu_read_lock()
   or even rcu_dereference().

   This mm has no users, nobody else can play with ->ioctx_table. Otherwise
   the code is buggy anyway, if we need rcu_read_lock() in a loop because
   ->ioctx_table can be updated then kfree(table) is obviously wrong.

2. Update the comment. "exit_mmap(mm) is coming" is the good reason to avoid
   munmap(), but another reason is that we simply can't do vm_munmap() unless
   current->mm == mm and this is not true in general, the caller is mmput().

3. We do not really need to nullify mm->ioctx_table before return, probably
   the current code does this to catch the potential problems. But in this
   case RCU_INIT_POINTER(NULL) looks better.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/aio.c |   42 ++++++++++++++++--------------------------
 1 files changed, 16 insertions(+), 26 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 79b7e69..b67f3e2 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -791,40 +791,30 @@ EXPORT_SYMBOL(wait_on_sync_kiocb);
  */
 void exit_aio(struct mm_struct *mm)
 {
-	struct kioctx_table *table;
-	struct kioctx *ctx;
-	unsigned i = 0;
-
-	while (1) {
-		rcu_read_lock();
-		table = rcu_dereference(mm->ioctx_table);
-
-		do {
-			if (!table || i >= table->nr) {
-				rcu_read_unlock();
-				rcu_assign_pointer(mm->ioctx_table, NULL);
-				if (table)
-					kfree(table);
-				return;
-			}
+	struct kioctx_table *table = rcu_dereference_raw(mm->ioctx_table);
+	int i;
 
-			ctx = table->table[i++];
-		} while (!ctx);
+	if (!table)
+		return;
 
-		rcu_read_unlock();
+	for (i = 0; i < table->nr; ++i) {
+		struct kioctx *ctx = table->table[i];
 
+		if (!ctx)
+			continue;
 		/*
-		 * We don't need to bother with munmap() here -
-		 * exit_mmap(mm) is coming and it'll unmap everything.
-		 * Since aio_free_ring() uses non-zero ->mmap_size
-		 * as indicator that it needs to unmap the area,
-		 * just set it to 0; aio_free_ring() is the only
-		 * place that uses ->mmap_size, so it's safe.
+		 * We don't need to bother with munmap() here - exit_mmap(mm)
+		 * is coming and it'll unmap everything. And we simply can't,
+		 * this is not necessarily our ->mm.
+		 * Since kill_ioctx() uses non-zero ->mmap_size as indicator
+		 * that it needs to unmap the area, just set it to 0.
 		 */
 		ctx->mmap_size = 0;
-
 		kill_ioctx(mm, ctx, NULL);
 	}
+
+	RCU_INIT_POINTER(mm->ioctx_table, NULL);
+	kfree(table);
 }
 
 static void put_reqs_available(struct kioctx *ctx, unsigned nr)
-- 
1.5.5.1


