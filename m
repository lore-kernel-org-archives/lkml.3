Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbaAHObB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:31:01 -0500
Received: from 10.mo3.mail-out.ovh.net ([87.98.165.232]:47258 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756868AbaAHOaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:30:06 -0500
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jan 2014 09:30:06 EST
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, dev@linux-sunxi.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [RFC PATCH 1/9] mtd: nand: retrieve ECC requirements from Hynix READ ID byte 4
Date: Wed,  8 Jan 2014 15:21:56 +0100
Message-Id: <1389190924-26226-2-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 6872774506862508222
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.500001/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Hynix nand flashes store their ECC requirements in byte 4 of its id
(returned on READ ID command).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/mtd/nand/nand_base.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index bd39f7b..15069ec 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -3202,6 +3202,43 @@ static void nand_decode_ext_id(struct mtd_info *mtd, struct nand_chip *chip,
 		else
 			mtd->erasesize = (64 * 1024) << tmp;
 		*busw = 0;
+
+		/* Retrieve ECC infos */
+		switch ((id_data[4] >> 4) & 0x7) {
+		case 1:
+			chip->ecc_step_ds = 512;
+			chip->ecc_strength_ds = 1;
+			break;
+		case 2:
+			chip->ecc_step_ds = 512;
+			chip->ecc_strength_ds = 2;
+			break;
+		case 3:
+			chip->ecc_step_ds = 512;
+			chip->ecc_strength_ds = 4;
+			break;
+		case 4:
+			chip->ecc_step_ds = 512;
+			chip->ecc_strength_ds = 8;
+			break;
+		case 5:
+			chip->ecc_step_ds = 1024;
+			chip->ecc_strength_ds = 24;
+			break;
+		case 6:
+			chip->ecc_step_ds = 1024;
+			chip->ecc_strength_ds = 32;
+			break;
+		case 7:
+			chip->ecc_step_ds = 1024;
+			chip->ecc_strength_ds = 40;
+			break;
+		case 0:
+		default:
+			chip->ecc_step_ds = 0;
+			chip->ecc_strength_ds = 0;
+			break;
+		}
 	} else {
 		/* Calc pagesize */
 		mtd->writesize = 1024 << (extid & 0x03);
-- 
1.7.9.5

