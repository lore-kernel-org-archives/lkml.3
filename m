Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbaGLMKI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 08:10:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:60392 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbaGLMKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 08:10:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,649,1400050800"; 
   d="scan'208";a="542394062"
From: Huang Ying <ying.huang@intel.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH v2] f2fs: Add f2fs_balance_fs for direct IO
Date: Sat, 12 Jul 2014 20:10:00 +0800
Message-Id: <1405167000-23477-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, if a large amount of direct IO writes were done, the
segment allocation may be failed because no enough segments are gced.

Changes:

v2: add f2fs_balance_fs into __get_data_block instead of f2fs_direct_IO.

Signed-off-by: Huang, Ying <ying.huang@intel.com>
---
 fs/f2fs/data.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -626,8 +626,10 @@ static int __get_data_block(struct inode
 	if (check_extent_cache(inode, pgofs, bh_result))
 		goto out;
 
-	if (create)
+	if (create) {
+		f2fs_balance_fs(sbi);
 		f2fs_lock_op(sbi);
+	}
 
 	/* When reading holes, we need its node page */
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
