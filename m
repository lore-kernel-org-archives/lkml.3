Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbaKEOK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:10:57 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34937 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbaKEOKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:10:53 -0500
Message-ID: <545A2FEA.3050101@plexistor.com>
Date: Wed, 05 Nov 2014 16:10:50 +0200
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jens Axboe <axboe@fb.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 5/5] brd: Add getgeo to block ops for fdisk
References: <545A2D69.8090003@plexistor.com>
In-Reply-To: <545A2D69.8090003@plexistor.com>
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
 drivers/block/brd.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 0026998..e0bc072 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -19,6 +19,7 @@
 #include <linux/radix-tree.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/hdreg.h>
 
 #include <asm/uaccess.h>
 
@@ -426,6 +427,23 @@ static int brd_ioctl(struct block_device *bdev, fmode_t mode,
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
@@ -433,6 +451,7 @@ static const struct block_device_operations brd_fops = {
 #ifdef CONFIG_BLK_DEV_XIP
 	.direct_access =	brd_direct_access,
 #endif
+	.getgeo =		brd_getgeo,
 };
 
 /*
-- 
1.9.3


