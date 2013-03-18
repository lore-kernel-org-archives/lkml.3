Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032Ab3CRVvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:51:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab3CRVHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:07:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guo Chao <yan@linux.vnet.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "M. Hindess" <hindessm@uk.ibm.com>,
        Nikanth Karthikesan <knikanth@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [ 53/75] block: use i_size_write() in bd_set_size()
Date: Mon, 18 Mar 2013 14:07:16 -0700
Message-Id: <20130318210514.075337290@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/block_dev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1033,7 +1033,9 @@ void bd_set_size(struct block_device *bd
 {
 	unsigned bsize = bdev_logical_block_size(bdev);
 
-	bdev->bd_inode->i_size = size;
+	mutex_lock(&bdev->bd_inode->i_mutex);
+	i_size_write(bdev->bd_inode, size);
+	mutex_unlock(&bdev->bd_inode->i_mutex);
 	while (bsize < PAGE_CACHE_SIZE) {
 		if (size & bsize)
 			break;


