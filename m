Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbaHGODN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:03:13 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:45496 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757577AbaHGODL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:03:11 -0400
Message-ID: <53E3871C.4020008@plexistor.com>
Date: Thu, 07 Aug 2014 17:03:08 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Ross Zwisler <ross.zwisler@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 2/4 v2] brd: Add getgeo to block ops
References: <53E21125.9080308@plexistor.com> <53E211D9.7030102@plexistor.com>
In-Reply-To: <53E211D9.7030102@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boaz Harrosh <boaz@plexistor.com>

Some programs like fdisk, require HDIO_GETGEO to work, which requires we
implement getgeo.

We set all hd_geometry members to 1, because this way fdisk
math will not try its crazy geometry math and get stuff totally wrong.

I was trying to get some values that will make fdisk Want to align
first sector on 4K (like 8, 16, 20, ... sectors) but nothing worked,
I searched the net the math is not your regular simple multiplication
at all.

If you managed to get these magic values please tell me. I would love to
solve this.

But for now we use 4k physical_sector for fixing fdisk alignment
issues, and setting these here to something that will not make
fdisk serve us with crazy numbers.

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/block/brd.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index a10a0a9..8be3747 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -19,6 +19,7 @@
 #include <linux/radix-tree.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/hdreg.h>
 
 #include <asm/uaccess.h>
 
@@ -424,6 +425,23 @@ static int brd_ioctl(struct block_device *bdev, fmode_t mode,
 	return error;
 }
 
+static int brd_getgeo(struct block_device *bd, struct hd_geometry *geo)
+{
+	/* Just tell fdisk to get out of the way. The math here is so
+	 * convoluted and does not make any sense at all. With all 1s
+	 * The math just gets out of the way.
+	 * NOTE: I was trying to get some values that will make fdisk
+	 * Want to align first sector on 4K (like 8, 16, 20, ... sectors) but
+	 * nothing worked, I searched the net the math is not your regular
+	 * simple multiplication at all. If you managed to get these please
+	 * fix here. For now we use 4k physical sectors for this
+	 */
+	geo->heads = 1;
+	geo->sectors = 1;
+	geo->cylinders = 1;
+	return 0;
+}
+
 static const struct block_device_operations brd_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		brd_rw_page,
@@ -431,6 +449,7 @@ static const struct block_device_operations brd_fops = {
 #ifdef CONFIG_BLK_DEV_XIP
 	.direct_access =	brd_direct_access,
 #endif
+	.getgeo =		brd_getgeo,
 };
 
 /*
-- 
1.9.3

