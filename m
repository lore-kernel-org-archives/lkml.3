Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838AbaJUNye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:54:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60973 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932627AbaJUNyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:54:11 -0400
From: Roger Quadros <rogerq@ti.com>
To: <computersforpeace@gmail.com>, <dwmw2@infradead.org>
CC: <akinobu.mita@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: [PATCH 1/2] mtd: mtd_oobtest: Show the verification error location and data
Date: Tue, 21 Oct 2014 16:53:27 +0300
Message-ID: <1413899608-3911-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413899608-3911-1-git-send-email-rogerq@ti.com>
References: <1413899608-3911-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function memcmpshow() that compares the 2 data buffers
and shows the address:offset and data bytes on comparison failure.
This function  does not break at a comparison failure but runs the
check for the whole data buffer.

Use memcmpshow() instead of memcmp() for all the verification paths.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
---
 drivers/mtd/tests/oobtest.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/tests/oobtest.c b/drivers/mtd/tests/oobtest.c
index dc4f960..edd859d 100644
--- a/drivers/mtd/tests/oobtest.c
+++ b/drivers/mtd/tests/oobtest.c
@@ -115,6 +115,26 @@ static int write_whole_device(void)
 	return 0;
 }
 
+/* Display the address, offset and data bytes at comparison failure */
+static int memcmpshow(loff_t addr, const void *cs, const void *ct, size_t count)
+{
+	const unsigned char *su1, *su2;
+	int res;
+	int ret = 0;
+	size_t i = 0;
+
+	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--, i++) {
+		res = *su1 ^ *su2;
+		if (res) {
+			pr_info("error @addr[0x%lx:0x%x] 0x%x -> 0x%x diff 0x%x\n",
+				(unsigned long)addr, i, *su1, *su2, res);
+			ret = 1;
+		}
+	}
+
+	return ret;
+}
+
 static int verify_eraseblock(int ebnum)
 {
 	int i;
@@ -139,8 +159,9 @@ static int verify_eraseblock(int ebnum)
 			errcnt += 1;
 			return err ? err : -1;
 		}
-		if (memcmp(readbuf, writebuf + (use_len_max * i) + use_offset,
-			   use_len)) {
+		if (memcmpshow(addr, readbuf,
+			       writebuf + (use_len_max * i) + use_offset,
+			       use_len)) {
 			pr_err("error: verify failed at %#llx\n",
 			       (long long)addr);
 			errcnt += 1;
@@ -167,9 +188,9 @@ static int verify_eraseblock(int ebnum)
 				errcnt += 1;
 				return err ? err : -1;
 			}
-			if (memcmp(readbuf + use_offset,
-				   writebuf + (use_len_max * i) + use_offset,
-				   use_len)) {
+			if (memcmpshow(addr, readbuf + use_offset,
+				       writebuf + (use_len_max * i) + use_offset,
+				       use_len)) {
 				pr_err("error: verify failed at %#llx\n",
 						(long long)addr);
 				errcnt += 1;
@@ -233,7 +254,7 @@ static int verify_eraseblock_in_one_go(int ebnum)
 		errcnt += 1;
 		return err ? err : -1;
 	}
-	if (memcmp(readbuf, writebuf, len)) {
+	if (memcmpshow(addr, readbuf, writebuf, len)) {
 		pr_err("error: verify failed at %#llx\n",
 		       (long long)addr);
 		errcnt += 1;
@@ -610,7 +631,8 @@ static int __init mtd_oobtest_init(void)
 		err = mtd_read_oob(mtd, addr, &ops);
 		if (err)
 			goto out;
-		if (memcmp(readbuf, writebuf, mtd->ecclayout->oobavail * 2)) {
+		if (memcmpshow(addr, readbuf, writebuf,
+			       mtd->ecclayout->oobavail * 2)) {
 			pr_err("error: verify failed at %#llx\n",
 			       (long long)addr);
 			errcnt += 1;
-- 
1.8.3.2

