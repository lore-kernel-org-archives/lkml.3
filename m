Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061AbaICWVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:21:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46238 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933916AbaICWS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Mason <clm@fb.com>, Miao Xie <miaox@cn.fujitsu.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH 3.16 090/125] Btrfs: fix filemap_flush call in btrfs_file_release
Date: Wed,  3 Sep 2014 15:07:27 -0700
Message-Id: <20140903220626.375367163@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@fb.com>

commit f6dc45c7a93a011dff6eb9b2ffda59c390c7705a upstream.

We should only be flushing on close if the file was flagged as needing
it during truncate.  I broke this with my ordered data vs transaction
commit deadlock fix.

Thanks to Miao Xie for catching this.

Signed-off-by: Chris Mason <clm@fb.com>
Reported-by: Miao Xie <miaox@cn.fujitsu.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/file.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1840,7 +1840,15 @@ int btrfs_release_file(struct inode *ino
 {
 	if (filp->private_data)
 		btrfs_ioctl_trans_end(filp);
-	filemap_flush(inode->i_mapping);
+	/*
+	 * ordered_data_close is set by settattr when we are about to truncate
+	 * a file from a non-zero size to a zero size.  This tries to
+	 * flush down new bytes that may have been written if the
+	 * application were using truncate to replace a file in place.
+	 */
+	if (test_and_clear_bit(BTRFS_INODE_ORDERED_DATA_CLOSE,
+			       &BTRFS_I(inode)->runtime_flags))
+			filemap_flush(inode->i_mapping);
 	return 0;
 }
 


