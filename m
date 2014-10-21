Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbaJUNyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:54:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56533 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932711AbaJUNyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:54:13 -0400
From: Roger Quadros <rogerq@ti.com>
To: <computersforpeace@gmail.com>, <dwmw2@infradead.org>
CC: <akinobu.mita@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: [PATCH 2/2] mtd: mtd_oobtest: add bitflip_limit parameter
Date: Tue, 21 Oct 2014 16:53:28 +0300
Message-ID: <1413899608-3911-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413899608-3911-1-git-send-email-rogerq@ti.com>
References: <1413899608-3911-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is common for NAND devices to have bitflip errors.
Add a bitflip_limit parameter to specify how many bitflips per
page we can tolerate without flagging an error.
By default zero bitflips are tolerated.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
---
 drivers/mtd/tests/oobtest.c | 65 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 18 deletions(-)

diff --git a/drivers/mtd/tests/oobtest.c b/drivers/mtd/tests/oobtest.c
index edd859d..1fd2cda 100644
--- a/drivers/mtd/tests/oobtest.c
+++ b/drivers/mtd/tests/oobtest.c
@@ -34,8 +34,11 @@
 #include "mtd_test.h"
 
 static int dev = -EINVAL;
+static int bitflip_limit;
 module_param(dev, int, S_IRUGO);
 MODULE_PARM_DESC(dev, "MTD device number to use");
+module_param(bitflip_limit, int, S_IRUGO);
+MODULE_PARM_DESC(bitflip_limit, "Max. allowed bitflips per page");
 
 static struct mtd_info *mtd;
 static unsigned char *readbuf;
@@ -115,24 +118,27 @@ static int write_whole_device(void)
 	return 0;
 }
 
-/* Display the address, offset and data bytes at comparison failure */
-static int memcmpshow(loff_t addr, const void *cs, const void *ct, size_t count)
+/*
+ * Display the address, offset and data bytes at comparison failure.
+ * Return number of bitflips encountered.
+ */
+static size_t memcmpshow(loff_t addr, const void *cs, const void *ct, size_t count)
 {
 	const unsigned char *su1, *su2;
 	int res;
-	int ret = 0;
 	size_t i = 0;
+	size_t bitflips = 0;
 
 	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--, i++) {
 		res = *su1 ^ *su2;
 		if (res) {
 			pr_info("error @addr[0x%lx:0x%x] 0x%x -> 0x%x diff 0x%x\n",
 				(unsigned long)addr, i, *su1, *su2, res);
-			ret = 1;
+			bitflips += hweight8(res);
 		}
 	}
 
-	return ret;
+	return bitflips;
 }
 
 static int verify_eraseblock(int ebnum)
@@ -141,6 +147,7 @@ static int verify_eraseblock(int ebnum)
 	struct mtd_oob_ops ops;
 	int err = 0;
 	loff_t addr = (loff_t)ebnum * mtd->erasesize;
+	size_t bitflips;
 
 	prandom_bytes_state(&rnd_state, writebuf, use_len_max * pgcnt);
 	for (i = 0; i < pgcnt; ++i, addr += mtd->writesize) {
@@ -159,9 +166,11 @@ static int verify_eraseblock(int ebnum)
 			errcnt += 1;
 			return err ? err : -1;
 		}
-		if (memcmpshow(addr, readbuf,
-			       writebuf + (use_len_max * i) + use_offset,
-			       use_len)) {
+
+		bitflips = memcmpshow(addr, readbuf,
+				      writebuf + (use_len_max * i) + use_offset,
+				      use_len);
+		if (bitflips > bitflip_limit) {
 			pr_err("error: verify failed at %#llx\n",
 			       (long long)addr);
 			errcnt += 1;
@@ -169,7 +178,10 @@ static int verify_eraseblock(int ebnum)
 				pr_err("error: too many errors\n");
 				return -1;
 			}
+		} else if (bitflips) {
+			pr_info("ignoring error as within bitflip_limit\n");
 		}
+
 		if (use_offset != 0 || use_len < mtd->ecclayout->oobavail) {
 			int k;
 
@@ -188,9 +200,10 @@ static int verify_eraseblock(int ebnum)
 				errcnt += 1;
 				return err ? err : -1;
 			}
-			if (memcmpshow(addr, readbuf + use_offset,
-				       writebuf + (use_len_max * i) + use_offset,
-				       use_len)) {
+			bitflips = memcmpshow(addr, readbuf + use_offset,
+					      writebuf + (use_len_max * i) + use_offset,
+					      use_len);
+			if (bitflips > bitflip_limit) {
 				pr_err("error: verify failed at %#llx\n",
 						(long long)addr);
 				errcnt += 1;
@@ -198,7 +211,10 @@ static int verify_eraseblock(int ebnum)
 					pr_err("error: too many errors\n");
 					return -1;
 				}
+			} else if (bitflips) {
+				pr_info("ignoring error as within bitflip_limit\n");
 			}
+
 			for (k = 0; k < use_offset; ++k)
 				if (readbuf[k] != 0xff) {
 					pr_err("error: verify 0xff "
@@ -237,6 +253,9 @@ static int verify_eraseblock_in_one_go(int ebnum)
 	int err = 0;
 	loff_t addr = (loff_t)ebnum * mtd->erasesize;
 	size_t len = mtd->ecclayout->oobavail * pgcnt;
+	size_t oobavail = mtd->ecclayout->oobavail;
+	size_t bitflips;
+	int i;
 
 	prandom_bytes_state(&rnd_state, writebuf, len);
 	ops.mode      = MTD_OPS_AUTO_OOB;
@@ -247,6 +266,8 @@ static int verify_eraseblock_in_one_go(int ebnum)
 	ops.ooboffs   = 0;
 	ops.datbuf    = NULL;
 	ops.oobbuf    = readbuf;
+
+	/* read entire block's OOB at one go */
 	err = mtd_read_oob(mtd, addr, &ops);
 	if (err || ops.oobretlen != len) {
 		pr_err("error: readoob failed at %#llx\n",
@@ -254,13 +275,21 @@ static int verify_eraseblock_in_one_go(int ebnum)
 		errcnt += 1;
 		return err ? err : -1;
 	}
-	if (memcmpshow(addr, readbuf, writebuf, len)) {
-		pr_err("error: verify failed at %#llx\n",
-		       (long long)addr);
-		errcnt += 1;
-		if (errcnt > 1000) {
-			pr_err("error: too many errors\n");
-			return -1;
+
+	/* verify one page OOB at a time for bitflip per page limit check */
+	for (i = 0; i < pgcnt; ++i, addr += mtd->writesize) {
+		bitflips = memcmpshow(addr, readbuf + (i * oobavail),
+				      writebuf + (i * oobavail), oobavail);
+		if (bitflips > bitflip_limit) {
+			pr_err("error: verify failed at %#llx\n",
+			       (long long)addr);
+			errcnt += 1;
+			if (errcnt > 1000) {
+				pr_err("error: too many errors\n");
+				return -1;
+			}
+		} else if (bitflips) {
+			pr_info("ignoring error as within bitflip_limit\n");
 		}
 	}
 
-- 
1.8.3.2

