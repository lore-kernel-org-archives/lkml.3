Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab3EQViN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:38:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310Ab3EQViK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:38:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Harney <eharney@redhat.com>, Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 102/102] target: Use FD_MAX_SECTORS/FD_BLOCKSIZE for blockdevs using fileio
Date: Fri, 17 May 2013 14:36:57 -0700
Message-Id: <20130517213254.984959330@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Grover <agrover@redhat.com>

commit e3e84cda321703b123f36488f50700f371bc7230 upstream.

We can still see the error reported in

https://patchwork.kernel.org/patch/2338981/

when using fileio backed by a block device.

I'm assuming this will get us past that error (from sbc_parse_cdb),
and also assuming it's OK to have our max_sectors be larger than
the block's queue max hw sectors?

Reported-by: Eric Harney <eharney@redhat.com>
Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/target/target_core_file.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -148,13 +148,8 @@ static int fd_configure_device(struct se
 	 */
 	inode = file->f_mapping->host;
 	if (S_ISBLK(inode->i_mode)) {
-		struct request_queue *q = bdev_get_queue(inode->i_bdev);
 		unsigned long long dev_size;
 
-		dev->dev_attrib.hw_block_size =
-			bdev_logical_block_size(inode->i_bdev);
-		dev->dev_attrib.hw_max_sectors = queue_max_hw_sectors(q);
-
 		/*
 		 * Determine the number of bytes from i_size_read() minus
 		 * one (1) logical sector from underlying struct block_device
@@ -173,13 +168,12 @@ static int fd_configure_device(struct se
 				" block_device\n");
 			goto fail;
 		}
-
-		dev->dev_attrib.hw_block_size = FD_BLOCKSIZE;
-		dev->dev_attrib.hw_max_sectors = FD_MAX_SECTORS;
 	}
 
 	fd_dev->fd_block_size = dev->dev_attrib.hw_block_size;
 
+	dev->dev_attrib.hw_block_size = FD_BLOCKSIZE;
+	dev->dev_attrib.hw_max_sectors = FD_MAX_SECTORS;
 	dev->dev_attrib.hw_queue_depth = FD_MAX_DEVICE_QUEUE_DEPTH;
 
 	if (fd_dev->fbd_flags & FDBD_HAS_BUFFERED_IO_WCE) {


