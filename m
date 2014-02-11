Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaBKTFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:05:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaBKTE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:04:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Chris Ball <chris@printf.net>
Subject: [PATCH 3.13 022/120] mmc: core: sd: implement proper support for sd3.0 au sizes
Date: Tue, 11 Feb 2014 11:04:23 -0800
Message-Id: <20140211184824.175046435@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa@the-dreams.de>

commit 9288cac05405a7da406097a44721aa4004609b4d upstream.

This reverts and updates commit 77776fd0a4cc541b9 ("mmc: sd: fix the
maximum au_size for SD3.0"). The au_size for SD3.0 cannot be achieved
by a simple bit shift, so this needs to be implemented differently.
Also, don't print the warning in case of 0 since 'not defined' is
different from 'invalid'.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Acked-by: Jaehoon Chung <jh80.chung@samsung.com>
Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Chris Ball <chris@printf.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/sd.c |   37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/err.h>
+#include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/stat.h>
 #include <linux/pm_runtime.h>
@@ -45,6 +46,13 @@ static const unsigned int tacc_mant[] =
 	35,	40,	45,	50,	55,	60,	70,	80,
 };
 
+static const unsigned int sd_au_size[] = {
+	0,		SZ_16K / 512,		SZ_32K / 512,	SZ_64K / 512,
+	SZ_128K / 512,	SZ_256K / 512,		SZ_512K / 512,	SZ_1M / 512,
+	SZ_2M / 512,	SZ_4M / 512,		SZ_8M / 512,	(SZ_8M + SZ_4M) / 512,
+	SZ_16M / 512,	(SZ_16M + SZ_8M) / 512,	SZ_32M / 512,	SZ_64M / 512,
+};
+
 #define UNSTUFF_BITS(resp,start,size)					\
 	({								\
 		const int __size = size;				\
@@ -216,7 +224,7 @@ static int mmc_decode_scr(struct mmc_car
 static int mmc_read_ssr(struct mmc_card *card)
 {
 	unsigned int au, es, et, eo;
-	int err, i, max_au;
+	int err, i;
 	u32 *ssr;
 
 	if (!(card->csd.cmdclass & CCC_APP_SPEC)) {
@@ -240,26 +248,25 @@ static int mmc_read_ssr(struct mmc_card
 	for (i = 0; i < 16; i++)
 		ssr[i] = be32_to_cpu(ssr[i]);
 
-	/* SD3.0 increases max AU size to 64MB (0xF) from 4MB (0x9) */
-	max_au = card->scr.sda_spec3 ? 0xF : 0x9;
-
 	/*
 	 * UNSTUFF_BITS only works with four u32s so we have to offset the
 	 * bitfield positions accordingly.
 	 */
 	au = UNSTUFF_BITS(ssr, 428 - 384, 4);
-	if (au > 0 && au <= max_au) {
-		card->ssr.au = 1 << (au + 4);
-		es = UNSTUFF_BITS(ssr, 408 - 384, 16);
-		et = UNSTUFF_BITS(ssr, 402 - 384, 6);
-		eo = UNSTUFF_BITS(ssr, 400 - 384, 2);
-		if (es && et) {
-			card->ssr.erase_timeout = (et * 1000) / es;
-			card->ssr.erase_offset = eo * 1000;
+	if (au) {
+		if (au <= 9 || card->scr.sda_spec3) {
+			card->ssr.au = sd_au_size[au];
+			es = UNSTUFF_BITS(ssr, 408 - 384, 16);
+			et = UNSTUFF_BITS(ssr, 402 - 384, 6);
+			if (es && et) {
+				eo = UNSTUFF_BITS(ssr, 400 - 384, 2);
+				card->ssr.erase_timeout = (et * 1000) / es;
+				card->ssr.erase_offset = eo * 1000;
+			}
+		} else {
+			pr_warning("%s: SD Status: Invalid Allocation Unit size.\n",
+				   mmc_hostname(card->host));
 		}
-	} else {
-		pr_warning("%s: SD Status: Invalid Allocation Unit "
-			"size.\n", mmc_hostname(card->host));
 	}
 out:
 	kfree(ssr);


