Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbaKEPOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:14:23 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46554 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528AbaKEPOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:14:20 -0500
Message-ID: <545A3EC8.3060203@plexistor.com>
Date: Wed, 05 Nov 2014 17:14:16 +0200
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Boaz Harrosh <boaz@plexistor.com>, Jens Axboe <axboe@fb.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 5/5 v4] brd: Add getgeo to block ops for fdisk
References: <545A2D69.8090003@plexistor.com> <545A2FEA.3050101@plexistor.com>
In-Reply-To: <545A2FEA.3050101@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boaz Harrosh <boaz@plexistor.com>

Now when fdisk is run on brd it will ask some cryptic
questions about CHS. This is because the getgeo block operation
is not implemented.

With the usual emulated values of 64, 32, X and the default
size of 4M device, fdisk will offer 34 as possible first-sector,
And after the previous patch of 4K sectores it will offer
40 as possible first-sector.

But with the values presented here of 1, 1, 1 fdisk will offer
8 (4K) as possible first sector.

I have done a quick audit of the fdisk code. The CHS calculation
is very convoluted but at the end it comes out with a number.
Which is taken into consideration in first-sector to allow. With
all 1(s) this numbers is very small and other numbers come into
account. Also note that if the device is big like 1G (not sure what
is the threshold) fdisk will offer 1M (2048) as possible first-
sector, and it does not matter what numbers we give here.

Only fdisk is problematic both libgparted (and all applications
that use it) and cfdisk always offer 1M alignment and do not call
getgeo at all.

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 drivers/block/brd.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 0026998..7965bf9 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -19,6 +19,7 @@
 #include <linux/radix-tree.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/hdreg.h>
 
 #include <asm/uaccess.h>
 
@@ -426,6 +427,22 @@ static int brd_ioctl(struct block_device *bdev, fmode_t mode,
 	return error;
 }
 
+static int brd_getgeo(struct block_device *bd, struct hd_geometry *geo)
+{
+	/* With the usual emulated values of 64, 32, X and the
+	 * default size of 4M device, fdisk will offer 40 as possible
+	 * first-sector.
+	 * But with the values presented here of 1, 1, 1 fdisk will
+	 * offer 8 (4K) as possible first sector.
+	 * Otherwise, either way, it effects nothing. Only fdisk calls
+	 * this vector at all.
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
@@ -433,6 +450,7 @@ static const struct block_device_operations brd_fops = {
 #ifdef CONFIG_BLK_DEV_XIP
 	.direct_access =	brd_direct_access,
 #endif
+	.getgeo =		brd_getgeo,
 };
 
 /*
-- 
1.9.3


