Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbaLEPTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 10:19:17 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60843 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbaLEPTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 10:19:14 -0500
From: Roger Quadros <rogerq@ti.com>
To: <computersforpeace@gmail.com>, <dwmw2@infradead.org>
CC: <akinobu.mita@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 2/2] mtd: mtd_oobtest: Fix the address offset with vary_offset case
Date: Fri, 5 Dec 2014 17:18:40 +0200
Message-ID: <1417792720-3017-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1417792720-3017-1-git-send-email-rogerq@ti.com>
References: <1417792720-3017-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When vary_offset is set (e.g. test case 3), the offset is not always
zero so memcmpshow() will show the wrong offset in the print message.
To fix this we introduce a new function memcmpshowoffset() which takes
offset as a parameter and displays the right offset and use it in
the case where offset is non zero.

The old memcmpshow() functionality is preserved by converting it into
a macro with offset preset to 0.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mtd/tests/oobtest.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/tests/oobtest.c b/drivers/mtd/tests/oobtest.c
index 4da877b..0d5e85d 100644
--- a/drivers/mtd/tests/oobtest.c
+++ b/drivers/mtd/tests/oobtest.c
@@ -122,7 +122,8 @@ static int write_whole_device(void)
  * Display the address, offset and data bytes at comparison failure.
  * Return number of bitflips encountered.
  */
-static size_t memcmpshow(loff_t addr, const void *cs, const void *ct, size_t count)
+static size_t memcmpshowoffset(loff_t addr, loff_t offset, const void *cs,
+			       const void *ct, size_t count)
 {
 	const unsigned char *su1, *su2;
 	int res;
@@ -132,8 +133,9 @@ static size_t memcmpshow(loff_t addr, const void *cs, const void *ct, size_t cou
 	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--, i++) {
 		res = *su1 ^ *su2;
 		if (res) {
-			pr_info("error @addr[0x%lx:0x%x] 0x%x -> 0x%x diff 0x%x\n",
-				(unsigned long)addr, i, *su1, *su2, res);
+			pr_info("error @addr[0x%lx:0x%lx] 0x%x -> 0x%x diff 0x%x\n",
+				(unsigned long)addr, (unsigned long)offset + i,
+				*su1, *su2, res);
 			bitflips += hweight8(res);
 		}
 	}
@@ -141,6 +143,9 @@ static size_t memcmpshow(loff_t addr, const void *cs, const void *ct, size_t cou
 	return bitflips;
 }
 
+#define memcmpshow(addr, cs, ct, count) memcmpshowoffset((addr), 0, (cs), (ct),\
+							 (count))
+
 /*
  * Compare with 0xff and show the address, offset and data bytes at
  * comparison failure. Return number of bitflips encountered.
@@ -224,9 +229,10 @@ static int verify_eraseblock(int ebnum)
 				errcnt += 1;
 				return err ? err : -1;
 			}
-			bitflips = memcmpshow(addr, readbuf + use_offset,
-					      writebuf + (use_len_max * i) + use_offset,
-					      use_len);
+			bitflips = memcmpshowoffset(addr, use_offset,
+						    readbuf + use_offset,
+						    writebuf + (use_len_max * i) + use_offset,
+						    use_len);
 
 			/* verify pre-offset area for 0xff */
 			bitflips += memffshow(addr, 0, readbuf, use_offset);
-- 
2.1.0

