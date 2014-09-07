Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaIGXEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 19:04:41 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:61923 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbaIGXEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 19:04:16 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] bdi: explain the dirty list transferring in bdi_destroy()
Date: Mon,  8 Sep 2014 08:04:00 +0900
Message-Id: <1410131041-1881-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410131041-1881-1-git-send-email-tj@kernel.org>
References: <1410131041-1881-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bdi_destroy() has code to transfer the remaining dirty inodes to the
default_backing_dev_info; however, given the shutdown sequence, it
isn't clear how such condition would happen.  Also, it isn't a full
solution as the transferred inodes stlil point to the bdi which is
being destroyed.  Operations on those inodes can end up accessing
already released fields such as the percpu stat fields.

Digging through the history, it seems that the code was added as a
quick workaround for a bug report without fully root-causing the
issue.  We probably want to remove the code in time but for now let's
add a comment noting that it is a quick workaround.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/backing-dev.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index cb7c5e3..b65fe93 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -475,8 +475,17 @@ void bdi_destroy(struct backing_dev_info *bdi)
 	int i;
 
 	/*
-	 * Splice our entries to the default_backing_dev_info, if this
-	 * bdi disappears
+	 * Splice our entries to the default_backing_dev_info.  This
+	 * condition shouldn't happen.  @wb must be empty at this point and
+	 * dirty inodes on it might cause other issues.  This workaround is
+	 * added by ce5f8e779519 ("writeback: splice dirty inode entries to
+	 * default bdi on bdi_destroy()") without root-causing the issue.
+	 *
+	 * http://lkml.kernel.org/g/1253038617-30204-11-git-send-email-jens.axboe@oracle.com
+	 * http://thread.gmane.org/gmane.linux.file-systems/35341/focus=35350
+	 *
+	 * We should probably add WARN_ON() to find out whether it still
+	 * happens and track it down if so.
 	 */
 	if (bdi_has_dirty_io(bdi)) {
 		struct bdi_writeback *dst = &default_backing_dev_info.wb;
-- 
1.9.3

