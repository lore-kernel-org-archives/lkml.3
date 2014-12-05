Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaLEPTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 10:19:16 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46812 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbaLEPTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 10:19:14 -0500
From: Roger Quadros <rogerq@ti.com>
To: <computersforpeace@gmail.com>, <dwmw2@infradead.org>
CC: <akinobu.mita@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 1/2] mtd: mtd_oobtest: Fix bitflip_limit usage in test case 3
Date: Fri, 5 Dec 2014 17:18:39 +0200
Message-ID: <1417792720-3017-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1417792720-3017-1-git-send-email-rogerq@ti.com>
References: <1417792720-3017-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In test case 3, we set vary_offset to write at different
offsets and lengths in the OOB available area. We need to
do the bitflip_limit check while checking for 0xff outside the
OOB offset + length area that we didn't modify during write.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mtd/tests/oobtest.c | 61 +++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 27 deletions(-)

diff --git a/drivers/mtd/tests/oobtest.c b/drivers/mtd/tests/oobtest.c
index 1fd2cda..4da877b 100644
--- a/drivers/mtd/tests/oobtest.c
+++ b/drivers/mtd/tests/oobtest.c
@@ -141,6 +141,30 @@ static size_t memcmpshow(loff_t addr, const void *cs, const void *ct, size_t cou
 	return bitflips;
 }
 
+/*
+ * Compare with 0xff and show the address, offset and data bytes at
+ * comparison failure. Return number of bitflips encountered.
+ */
+static size_t memffshow(loff_t addr, loff_t offset, const void *cs,
+			size_t count)
+{
+	const unsigned char *su1;
+	int res;
+	size_t i = 0;
+	size_t bitflips = 0;
+
+	for (su1 = cs; 0 < count; ++su1, count--, i++) {
+		res = *su1 ^ 0xff;
+		if (res) {
+			pr_info("error @addr[0x%lx:0x%lx] 0x%x -> 0xff diff 0x%x\n",
+				(unsigned long)addr, (unsigned long)offset + i,
+				*su1, res);
+			bitflips += hweight8(res);
+		}
+	}
+
+	return bitflips;
+}
 static int verify_eraseblock(int ebnum)
 {
 	int i;
@@ -203,6 +227,15 @@ static int verify_eraseblock(int ebnum)
 			bitflips = memcmpshow(addr, readbuf + use_offset,
 					      writebuf + (use_len_max * i) + use_offset,
 					      use_len);
+
+			/* verify pre-offset area for 0xff */
+			bitflips += memffshow(addr, 0, readbuf, use_offset);
+
+			/* verify post-(use_offset + use_len) area for 0xff */
+			k = use_offset + use_len;
+			bitflips += memffshow(addr, k, readbuf + k,
+					      mtd->ecclayout->oobavail - k);
+
 			if (bitflips > bitflip_limit) {
 				pr_err("error: verify failed at %#llx\n",
 						(long long)addr);
@@ -212,34 +245,8 @@ static int verify_eraseblock(int ebnum)
 					return -1;
 				}
 			} else if (bitflips) {
-				pr_info("ignoring error as within bitflip_limit\n");
+				pr_info("ignoring errors as within bitflip limit\n");
 			}
-
-			for (k = 0; k < use_offset; ++k)
-				if (readbuf[k] != 0xff) {
-					pr_err("error: verify 0xff "
-					       "failed at %#llx\n",
-					       (long long)addr);
-					errcnt += 1;
-					if (errcnt > 1000) {
-						pr_err("error: too "
-						       "many errors\n");
-						return -1;
-					}
-				}
-			for (k = use_offset + use_len;
-			     k < mtd->ecclayout->oobavail; ++k)
-				if (readbuf[k] != 0xff) {
-					pr_err("error: verify 0xff "
-					       "failed at %#llx\n",
-					       (long long)addr);
-					errcnt += 1;
-					if (errcnt > 1000) {
-						pr_err("error: too "
-						       "many errors\n");
-						return -1;
-					}
-				}
 		}
 		if (vary_offset)
 			do_vary_offset();
-- 
2.1.0

