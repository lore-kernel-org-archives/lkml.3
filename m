Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbaHFLai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 07:30:38 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:37382 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898AbaHFLag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 07:30:36 -0400
Message-ID: <53E211D9.7030102@plexistor.com>
Date: Wed, 06 Aug 2014 14:30:33 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Ross Zwisler <ross.zwisler@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 2/4] brd: Add getgeo to block ops
References: <53E21125.9080308@plexistor.com>
In-Reply-To: <53E21125.9080308@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ross Zwisler <ross.zwisler@linux.intel.com>

Some programs require HDIO_GETGEO work, which requires we implement
getgeo.  Based off of the work done to the NVMe driver in this commit:

4cc09e2dc4cb NVMe: Add getgeo to block ops

[Boaz] Converted original work done for prd.c for here.
       This is needed if we want to support partitions, fdisk
       calls this.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/block/brd.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index a10a0a9..3f07cb4 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -19,6 +19,7 @@
 #include <linux/radix-tree.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/hdreg.h>
 
 #include <asm/uaccess.h>
 
@@ -424,6 +425,15 @@ static int brd_ioctl(struct block_device *bdev, fmode_t mode,
 	return error;
 }
 
+static int brd_getgeo(struct block_device *bd, struct hd_geometry *geo)
+{
+	/* some standard values */
+	geo->heads = 1 << 6;
+	geo->sectors = 1 << 5;
+	geo->cylinders = get_capacity(bd->bd_disk) >> 11;
+	return 0;
+}
+
 static const struct block_device_operations brd_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		brd_rw_page,
@@ -431,6 +441,7 @@ static const struct block_device_operations brd_fops = {
 #ifdef CONFIG_BLK_DEV_XIP
 	.direct_access =	brd_direct_access,
 #endif
+	.getgeo =		brd_getgeo,
 };
 
 /*
-- 
1.9.3

