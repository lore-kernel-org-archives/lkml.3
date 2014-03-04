Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbaCDVmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:42:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40732 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaCDUCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:02:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ahmed Tamrawi <ahmedtamrawi@gmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Dr. Tilmann Bubeck" <t.bubeck@reinform.de>,
        Zheng Liu <wenqing.lz@taobao.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [PATCH 3.13 010/172] ext4: fix error paths in swap_inode_boot_loader()
Date: Tue,  4 Mar 2014 12:01:34 -0800
Message-Id: <20140304200300.032554266@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -144,7 +144,7 @@ static long swap_inode_boot_loader(struc
 	handle = ext4_journal_start(inode_bl, EXT4_HT_MOVE_EXTENTS, 2);
 	if (IS_ERR(handle)) {
 		err = -EINVAL;
-		goto swap_boot_out;
+		goto journal_err_out;
 	}
 
 	/* Protect extent tree against block allocations via delalloc */
@@ -202,6 +202,7 @@ static long swap_inode_boot_loader(struc
 
 	ext4_double_up_write_data_sem(inode, inode_bl);
 
+journal_err_out:
 	ext4_inode_resume_unlocked_dio(inode);
 	ext4_inode_resume_unlocked_dio(inode_bl);
 


