Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3AYK4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:56:36 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:56806 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab3AYK4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:56:33 -0500
From: Guo Chao <yan@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/7] block: use i_size_write() in bd_set_size()
Date: Fri, 25 Jan 2013 18:56:16 +0800
Message-Id: <1359111382-12654-2-git-send-email-yan@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359111382-12654-1-git-send-email-yan@linux.vnet.ibm.com>
References: <1359111382-12654-1-git-send-email-yan@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012510-2674-0000-0000-00000799E0BC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkdev_ioctl(GETBLKSIZE) uses i_size_read() to read size
of block device. If we update block size directly, reader
may see intermediate result in some machines and configurations.
Use i_size_write() instead.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/block_dev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 172f849..82b7c9a 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1032,7 +1032,9 @@ void bd_set_size(struct block_device *bdev, loff_t size)
 {
 	unsigned bsize = bdev_logical_block_size(bdev);
 
-	bdev->bd_inode->i_size = size;
+	mutex_lock(&bdev->bd_inode->i_mutex);
+	i_size_write(bdev->bd_inode, size);
+	mutex_unlock(&bdev->bd_inode->i_mutex);
 	while (bsize < PAGE_CACHE_SIZE) {
 		if (size & bsize)
 			break;
-- 
1.7.9.5

