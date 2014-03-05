Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbaCEOZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:25:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40809 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745AbaCEOY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:24:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        "Dr. Tilmann Bubeck" <t.bubeck@reinform.de>,
        Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 022/131] ext4: fix error paths in swap_inode_boot_loader()
Date: Wed,  5 Mar 2014 14:22:26 +0000
Message-Id: <1394029455-23128-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Liu <wenqing.lz@taobao.com>

commit 30d29b119ef01776e0a301444ab24defe8d8bef3 upstream.

In swap_inode_boot_loader() we forgot to release ->i_mutex and resume
unlocked dio for inode and inode_bl if there is an error starting the
journal handle.  This commit fixes this issue.

Reported-by: Ahmed Tamrawi <ahmedtamrawi@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Dr. Tilmann Bubeck <t.bubeck@reinform.de>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index c0427e2..42624a9 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -145,7 +145,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	handle = ext4_journal_start(inode_bl, EXT4_HT_MOVE_EXTENTS, 2);
 	if (IS_ERR(handle)) {
 		err = -EINVAL;
-		goto swap_boot_out;
+		goto journal_err_out;
 	}
 
 	/* Protect extent tree against block allocations via delalloc */
@@ -203,6 +203,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 
 	ext4_double_up_write_data_sem(inode, inode_bl);
 
+journal_err_out:
 	ext4_inode_resume_unlocked_dio(inode);
 	ext4_inode_resume_unlocked_dio(inode_bl);
 
-- 
1.9.0

