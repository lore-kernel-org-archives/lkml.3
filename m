Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436Ab3LFVxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:53:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396Ab3LFVxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mateusz Guzik <mguzik@redhat.com>, Eryu Guan <eguan@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Kent Overstreet <kmo@daterainc.com>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 3.10 44/58] aio: restore locking of ioctx list on removal
Date: Fri,  6 Dec 2013 13:52:15 -0800
Message-Id: <20131206214848.976371883@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Guzik <mguzik@redhat.com>

Commit 36f5588905c10a8c4568a210d601fe8c3c27e0f0
"aio: refcounting cleanup" resulted in ioctx_lock not being held
during ctx removal, leaving the list susceptible to corruptions.

In mainline kernel the issue went away as a side effect of
db446a08c23d5475e6b08c87acca79ebb20f283c "aio: convert the ioctx list to
table lookup v3".

Fix the problem by restoring appropriate locking.

Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
Reported-by: Eryu Guan <eguan@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Acked-by: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -423,10 +423,12 @@ static void kill_ioctx_rcu(struct rcu_he
  *	when the processes owning a context have all exited to encourage
  *	the rapid destruction of the kioctx.
  */
-static void kill_ioctx(struct kioctx *ctx)
+static void kill_ioctx(struct mm_struct *mm, struct kioctx *ctx)
 {
 	if (!atomic_xchg(&ctx->dead, 1)) {
+		spin_lock(&mm->ioctx_lock);
 		hlist_del_rcu(&ctx->list);
+		spin_unlock(&mm->ioctx_lock);
 
 		/*
 		 * It'd be more correct to do this in free_ioctx(), after all
@@ -494,7 +496,7 @@ void exit_aio(struct mm_struct *mm)
 		 */
 		ctx->mmap_size = 0;
 
-		kill_ioctx(ctx);
+		kill_ioctx(mm, ctx);
 	}
 }
 
@@ -852,7 +854,7 @@ SYSCALL_DEFINE2(io_setup, unsigned, nr_e
 	if (!IS_ERR(ioctx)) {
 		ret = put_user(ioctx->user_id, ctxp);
 		if (ret)
-			kill_ioctx(ioctx);
+			kill_ioctx(current->mm, ioctx);
 		put_ioctx(ioctx);
 	}
 
@@ -870,7 +872,7 @@ SYSCALL_DEFINE1(io_destroy, aio_context_
 {
 	struct kioctx *ioctx = lookup_ioctx(ctx);
 	if (likely(NULL != ioctx)) {
-		kill_ioctx(ioctx);
+		kill_ioctx(current->mm, ioctx);
 		put_ioctx(ioctx);
 		return 0;
 	}


