Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab3EOI4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:56:48 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:39694
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757240Ab3EOI4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 04:56:42 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VS5(z616jzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH v5 06/11] mtd: get the ECC info from the Extended Parameter Page
Date: Wed, 15 May 2013 16:40:29 +0800
Message-ID: <1368607232-2210-7-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368607232-2210-1-git-send-email-b32955@freescale.com>
References: <1368607232-2210-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the ONFI 2.1, the onfi spec adds the Extended Parameter Page
to store the ECC info.

The onfi spec tells us that if the nand chip's recommended ECC codeword
size is not 512 bytes, then the @ecc_bits is 0xff. The host _SHOULD_ then
read the Extended ECC information that is part of the extended parameter
page to retrieve the ECC requirements for this device.

This patch implement the reading of the Extended Parameter Page, and parses
the sections for ECC type, and get the ECC info from the ECC section.

Tested this patch with Micron MT29F64G08CBABAWP.

Acked-by: Pekon Gupta <pekon@ti.com>
Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/nand/nand_base.c |   77 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 15630ef..e98ea69 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2835,6 +2835,68 @@ static u16 onfi_crc16(u16 crc, u8 const *p, size_t len)
 	return crc;
 }
 
+/* Parse the Extended Parameter Page. */
+static int nand_flash_detect_ext_param_page(struct mtd_info *mtd,
+		struct nand_chip *chip, struct nand_onfi_params *p)
+{
+	struct onfi_ext_param_page *ep;
+	struct onfi_ext_section *s;
+	struct onfi_ext_ecc_info *ecc;
+	uint8_t *cursor;
+	int len;
+	int ret;
+	int i;
+
+	len = le16_to_cpu(p->ext_param_page_length) * 16;
+	ep = kmalloc(len, GFP_KERNEL);
+	if (!ep) {
+		ret = -ENOMEM;
+		goto ext_out;
+	}
+
+	/* Send our own NAND_CMD_PARAM. */
+	chip->cmdfunc(mtd, NAND_CMD_PARAM, 0, -1);
+
+	/* Use the Change Read Column command to skip the ONFI param pages. */
+	chip->cmdfunc(mtd, NAND_CMD_RNDOUT,
+			sizeof(*p) * p->num_of_param_pages , -1);
+
+	/* Read out the Extended Parameter Page. */
+	chip->read_buf(mtd, (uint8_t *)ep, len);
+	if ((onfi_crc16(ONFI_CRC_BASE, ((uint8_t *)ep) + 2, len - 2)
+		!= le16_to_cpu(ep->crc)) || strncmp(ep->sig, "EPPS", 4)) {
+		pr_debug("fail in the CRC.\n");
+		ret = -EINVAL;
+		goto ext_out;
+	}
+
+	/* find the ECC section. */
+	cursor = (uint8_t *)(ep + 1);
+	for (i = 0; i < ONFI_EXT_SECTION_MAX; i++) {
+		s = ep->sections + i;
+		if (s->type == ONFI_SECTION_TYPE_2)
+			break;
+		cursor += s->length * 16;
+	}
+	if (i == ONFI_EXT_SECTION_MAX) {
+		pr_debug("We can not find the ECC section.\n");
+		ret = -EINVAL;
+		goto ext_out;
+	}
+
+	/* get the info we want. */
+	ecc = (struct onfi_ext_ecc_info *)cursor;
+	chip->ecc_strength = ecc->ecc_bits;
+	chip->ecc_step = 1 << ecc->codeword_size;
+
+	pr_info("ONFI extended param page detected.\n");
+	return 0;
+
+ext_out:
+	kfree(ep);
+	return ret;
+}
+
 /*
  * Check if the NAND chip is ONFI compliant, returns 1 if it is, 0 otherwise.
  */
@@ -2903,6 +2965,21 @@ static int nand_flash_detect_onfi(struct mtd_info *mtd, struct nand_chip *chip,
 	if (p->ecc_bits != 0xff) {
 		chip->ecc_strength = p->ecc_bits;
 		chip->ecc_step = 512;
+	} else if (chip->onfi_version >= 21 &&
+		(onfi_feature(chip) & ONFI_FEATURE_EXT_PARAM_PAGE)) {
+
+		/*
+		 * The nand_flash_detect_ext_param_page() uses the
+		 * Change Read Column command which maybe not supported
+		 * by the chip->cmdfunc. So try to update the chip->cmdfunc
+		 * now. We do not replace user supplied command function.
+		 */
+		if (mtd->writesize > 512 && chip->cmdfunc == nand_command)
+			chip->cmdfunc = nand_command_lp;
+
+		/* The Extended Parameter Page is supported since ONFI 2.1. */
+		if (nand_flash_detect_ext_param_page(mtd, chip, p))
+			pr_info("Failed to detect the extended param page.\n");
 	}
 
 	pr_info("ONFI flash detected\n");
-- 
1.7.1


