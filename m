Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677Ab3E1VWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:22:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59540 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab3E1VVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:21:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 14/78] target: Use FD_MAX_SECTORS/FD_BLOCKSIZE for blockdevs using fileio
Date: Tue, 28 May 2013 14:19:23 -0700
Message-Id: <1369776027-17859-15-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/target_core_file.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index b9c8849..89aa3b2a 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -151,10 +151,6 @@ static int fd_configure_device(struct se_device *dev)
 		struct request_queue *q = bdev_get_queue(inode->i_bdev);
 		unsigned long long dev_size;
 
-		dev->dev_attrib.hw_block_size =
-			bdev_logical_block_size(inode->i_bdev);
-		dev->dev_attrib.hw_max_sectors = queue_max_hw_sectors(q);
-
 		/*
 		 * Determine the number of bytes from i_size_read() minus
 		 * one (1) logical sector from underlying struct block_device
@@ -173,13 +169,12 @@ static int fd_configure_device(struct se_device *dev)
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
-- 
1.8.1.2

