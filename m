Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab3GaERD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 00:17:03 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:34980 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750858Ab3GaEQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 00:16:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgDAKOO+FF5LPxHgWdsb2JhbABbwz0XDgEBFiYogiQBAQUnLyMQCBgxOQMbGYgPuGqQG4NzA6xRKg
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, davej@redhat.com,
        viro@zeniv.linux.org.uk, jack@suse.cz, glommer@parallels.com
Subject: [PATCH 07/11] writeback: periodically trim the writeback list
Date: Wed, 31 Jul 2013 14:15:46 +1000
Message-Id: <1375244150-27296-8-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375244150-27296-1-git-send-email-david@fromorbit.com>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Inodes are removed lazily from the bdi writeback list, so in the
absence of sync(2) work inodes will build up on the bdi writback
list even though they are no longer under IO. Use the periodic
kupdate work check to remove inodes no longer under IO from the
writeback list.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/fs-writeback.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 638f122..7c9bbf0 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -962,6 +962,23 @@ static long wb_check_background_flush(struct bdi_writeback *wb)
 	return 0;
 }
 
+/*
+ * clean out writeback list for all inodes that don't have IO in progress
+ */
+static void wb_trim_writeback_list(struct bdi_writeback *wb)
+{
+	struct inode *inode;
+	struct inode *tmp;
+
+	spin_lock(&wb->list_lock);
+	list_for_each_entry_safe(inode, tmp, &wb->b_writeback, i_wb_list) {
+		if (!mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK))
+			list_del_init(&inode->i_wb_list);
+	}
+	spin_unlock(&wb->list_lock);
+
+}
+
 static long wb_check_old_data_flush(struct bdi_writeback *wb)
 {
 	unsigned long expired;
@@ -978,6 +995,8 @@ static long wb_check_old_data_flush(struct bdi_writeback *wb)
 	if (time_before(jiffies, expired))
 		return 0;
 
+	wb_trim_writeback_list(wb);
+
 	wb->last_old_flush = jiffies;
 	nr_pages = get_nr_dirty_pages();
 
-- 
1.8.3.2

