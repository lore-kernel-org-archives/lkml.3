Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaB0KiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 05:38:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:33132 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbaB0KiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 05:38:18 -0500
X-IronPort-AV: E=Sophos;i="4.97,553,1389715200"; 
   d="scan'208";a="9615210"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, bcrl@kvack.org, jmoyer@redhat.com,
        kosaki.motohiro@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com
Cc: linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] aio, mem-hotplug: Add memory barrier to aio ring page migration.
Date: Thu, 27 Feb 2014 18:40:16 +0800
Message-Id: <1393497616-16428-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1393497616-16428-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1393497616-16428-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/27 18:35:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/27 18:35:04,
	Serialize complete at 2014/02/27 18:35:04
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

So add a wmb to synchronize them.

Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 fs/aio.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index 50c089c..f0ed838 100644
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
-- 
1.8.3.1

