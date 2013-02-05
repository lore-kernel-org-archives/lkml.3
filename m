Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab3BEDUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 22:20:05 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:46673
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755138Ab3BEDUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 22:20:01 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH 2/2] mtd: torturetest: add the support for random data pattern
Date: Tue, 5 Feb 2013 10:20:20 +0800
Message-ID: <1360030820-21491-2-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1360030820-21491-1-git-send-email-b32955@freescale.com>
References: <1360030820-21491-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new module parameter 'pattern'. If it is set to zero,
we will use the 55/AA pattern to torture the nand blocks; if it is set
to a non-zero value, we will use the random data pattern.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/tests/mtd_torturetest.c |   72 ++++++++++++++++++++++++-----------
 1 files changed, 50 insertions(+), 22 deletions(-)

diff --git a/drivers/mtd/tests/mtd_torturetest.c b/drivers/mtd/tests/mtd_torturetest.c
index 516cf66..07655bc 100644
--- a/drivers/mtd/tests/mtd_torturetest.c
+++ b/drivers/mtd/tests/mtd_torturetest.c
@@ -32,6 +32,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/random.h>
 
 #define RETRIES 3
 
@@ -64,6 +65,11 @@ module_param(cycles_count, uint, S_IRUGO);
 MODULE_PARM_DESC(cycles_count, "how many erase cycles to do "
 			       "(infinite by default)");
 
+static int pattern;
+module_param(pattern, int, S_IRUGO);
+MODULE_PARM_DESC(pattern, "0 for 55/AA pattern(default), else for
+				the random pattern");
+
 static struct mtd_info *mtd;
 
 /* This buffer contains 0x555555...0xAAAAAA... pattern */
@@ -72,6 +78,8 @@ static unsigned char *patt_5A5;
 static unsigned char *patt_A5A;
 /* This buffer contains all 0xFF bytes */
 static unsigned char *patt_FF;
+/* This buffer contains the random data. */
+static unsigned char *patt_rd;
 /* This a temporary buffer is use when checking data */
 static unsigned char *check_buf;
 /* How many erase cycles were done */
@@ -228,6 +236,8 @@ static int __init tort_init(void)
 		pr_info("torturing just %d pages per eraseblock\n",
 			pgcnt);
 	pr_info("write verify %s\n", check ? "enabled" : "disabled");
+	pr_info("Test pattern is %s\n",
+			pattern ? "random data pattern" : "55/AA pattern");
 
 	mtd = get_mtd_device(NULL, dev);
 	if (IS_ERR(mtd)) {
@@ -249,16 +259,24 @@ static int __init tort_init(void)
 	}
 
 	err = -ENOMEM;
-	patt_5A5 = kmalloc(mtd->erasesize, GFP_KERNEL);
-	if (!patt_5A5) {
-		pr_err("error: cannot allocate memory\n");
-		goto out_mtd;
-	}
+	if (!pattern) {
+		patt_5A5 = kmalloc(mtd->erasesize, GFP_KERNEL);
+		if (!patt_5A5) {
+			pr_err("error: cannot allocate memory\n");
+			goto out_mtd;
+		}
 
-	patt_A5A = kmalloc(mtd->erasesize, GFP_KERNEL);
-	if (!patt_A5A) {
-		pr_err("error: cannot allocate memory\n");
-		goto out_patt_5A5;
+		patt_A5A = kmalloc(mtd->erasesize, GFP_KERNEL);
+		if (!patt_A5A) {
+			pr_err("error: cannot allocate memory\n");
+			goto out_patt_5A5;
+		}
+	} else {
+		patt_rd = kmalloc(mtd->erasesize, GFP_KERNEL);
+		if (!patt_rd) {
+			pr_err("error: cannot allocate memory\n");
+			goto out_patt_rd;
+		}
 	}
 
 	patt_FF = kmalloc(mtd->erasesize, GFP_KERNEL);
@@ -277,13 +295,15 @@ static int __init tort_init(void)
 
 	/* Initialize patterns */
 	memset(patt_FF, 0xFF, mtd->erasesize);
-	for (i = 0; i < mtd->erasesize / pgsize; i++) {
-		if (!(i & 1)) {
-			memset(patt_5A5 + i * pgsize, 0x55, pgsize);
-			memset(patt_A5A + i * pgsize, 0xAA, pgsize);
-		} else {
-			memset(patt_5A5 + i * pgsize, 0xAA, pgsize);
-			memset(patt_A5A + i * pgsize, 0x55, pgsize);
+	if (!pattern) {
+		for (i = 0; i < mtd->erasesize / pgsize; i++) {
+			if (!(i & 1)) {
+				memset(patt_5A5 + i * pgsize, 0x55, pgsize);
+				memset(patt_A5A + i * pgsize, 0xAA, pgsize);
+			} else {
+				memset(patt_5A5 + i * pgsize, 0xAA, pgsize);
+				memset(patt_A5A + i * pgsize, 0x55, pgsize);
+			}
 		}
 	}
 
@@ -335,10 +355,15 @@ static int __init tort_init(void)
 			}
 
 			/* Write the pattern */
-			if ((eb + erase_cycles) & 1)
-				patt = patt_5A5;
-			else
-				patt = patt_A5A;
+			if (!pattern) {
+				if ((eb + erase_cycles) & 1)
+					patt = patt_5A5;
+				else
+					patt = patt_A5A;
+			} else {
+				patt = patt_rd;
+				prandom_bytes(patt, mtd->erasesize);
+			}
 			err = write_pattern(i, patt);
 			if (err)
 				goto out;
@@ -350,8 +375,9 @@ static int __init tort_init(void)
 				if (err) {
 					pr_info("verify failed for %s"
 					       " pattern\n",
-					       ((eb + erase_cycles) & 1) ?
-					       "0x55AA55..." : "0xAA55AA...");
+					       pattern ? "random pattern" :
+					       (((eb + erase_cycles) & 1) ?
+					       "0x55AA55..." : "0xAA55AA..."));
 					goto out;
 				}
 				cond_resched();
@@ -386,6 +412,8 @@ out_patt_A5A:
 	kfree(patt_A5A);
 out_patt_5A5:
 	kfree(patt_5A5);
+out_patt_rd:
+	kfree(patt_rd);
 out_mtd:
 	put_mtd_device(mtd);
 	if (err)
-- 
1.7.0.4


