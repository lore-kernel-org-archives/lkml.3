Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965147Ab3CZPwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:52:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53785 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965042Ab3CZPWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guo Chao <yan@linux.vnet.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "M. Hindess" <hindessm@uk.ibm.com>,
        Nikanth Karthikesan <knikanth@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 024/150] block: use i_size_write() in bd_set_size()
Date: Tue, 26 Mar 2013 15:18:43 +0000
Message-Id: <1364311249-14454-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guo Chao <yan@linux.vnet.ibm.com>

commit d646a02a9d44d1421f273ae3923d97b47b918176 upstream.

blkdev_ioctl(GETBLKSIZE) uses i_size_read() to read size of block device.
If we update block size directly, reader may see intermediate result in
some machines and configurations.  Use i_size_write() instead.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Guo Chao <yan@linux.vnet.ibm.com>
Cc: M. Hindess <hindessm@uk.ibm.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/block_dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index db64e31..77e86b3 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1086,7 +1086,9 @@ void bd_set_size(struct block_device *bdev, loff_t size)
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
1.8.1.2

