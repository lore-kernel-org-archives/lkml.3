Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaCJINT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:13:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:48326 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbaCJINN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:13:13 -0400
X-IronPort-AV: E=Sophos;i="4.97,622,1389715200"; 
   d="scan'208";a="9670976"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, bcrl@kvack.org, jmoyer@redhat.com,
        kosaki.motohiro@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com
Cc: guz.fnst@cn.fujitsu.com, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        miaox@cn.fujitsu.com
Subject: [RESEND v2 PATCH 2/2] aio, mem-hotplug: Add memory barrier to aio ring page migration.
Date: Mon, 10 Mar 2014 16:15:34 +0800
Message-Id: <1394439334-28523-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1394439334-28523-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1394439334-28523-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/10 16:10:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/10 16:10:19,
	Serialize complete at 2014/03/10 16:10:19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing aio ring page migration, we migrated the page, and update
ctx->ring_pages[]. Like the following:

aio_migratepage()
 |-> migrate_page_copy(new, old)
 |   ......				/* Need barrier here */
 |-> ctx->ring_pages[idx] = new

Actually, we need a memory barrier between these two operations.
Otherwise, if ctx->ring_pages[] is updated before memory copy due to
the compiler optimization, other processes may have an opportunity
to access to the not fully initialized new ring page.

So add a wmb and rmb to synchronize them.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
v2: change smp_rmb() to smp_read_barrier_depends(). Thanks Miao.
---
 fs/aio.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index dc70246..4133ba9 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -327,6 +327,14 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
 		pgoff_t idx;
 		spin_lock_irqsave(&ctx->completion_lock, flags);
 		migrate_page_copy(new, old);
+
+		/*
+		 * Ensure memory copy is finished before updating
+		 * ctx->ring_pages[]. Otherwise other processes may access to
+		 * new ring pages which are not fully initialized.
+		 */
+		smp_wmb();
+
 		idx = old->index;
 		if (idx < (pgoff_t)ctx->nr_pages) {
 			/* And only do the move if things haven't changed */
@@ -1069,6 +1077,12 @@ static long aio_read_events_ring(struct kioctx *ctx,
 		page = ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE];
 		pos %= AIO_EVENTS_PER_PAGE;
 
+		/*
+		 * Ensure that the page's data was copied from old one by
+		 * aio_migratepage().
+		 */
+		smp_read_barrier_depends();
+
 		ev = kmap(page);
 		copy_ret = copy_to_user(event + ret, ev + pos,
 					sizeof(*ev) * avail);
-- 
1.7.7

