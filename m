Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab3DVIBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 04:01:16 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:26095 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755282Ab3DVH66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 03:58:58 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VS5(z616jzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH v2 3/8] mtd: get the ECC info from the Extended Parameter Page
Date: Mon, 22 Apr 2013 15:47:53 +0800
Message-ID: <1366616878-29481-4-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366616878-29481-1-git-send-email-b32955@freescale.com>
References: <1366616878-29481-1-git-send-email-b32955@freescale.com>
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

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/nand/nand_base.c |   54 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index beff911..48ff097 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2846,6 +2846,56 @@ static u16 onfi_crc16(u16 crc, u8 const *p, size_t len)
 	return crc;
 }
 
+/* Parse the Extended Parameter Page. */
+static void nand_flash_detect_ext_param_page(struct mtd_info *mtd,
+		struct nand_chip *chip, struct nand_onfi_params *p, int last)
+{
+	struct onfi_ext_param_page *ep;
+	struct onfi_ext_section *s;
+	struct onfi_ext_ecc_info *ecc;
+	uint8_t *cursor;
+	int len;
+	int i;
+
+	len = le16_to_cpu(p->ext_param_page_length) * 16;
+	ep = kcalloc(1, max_t(int, len, sizeof(*p)), GFP_KERNEL);
+	if (!ep)
+		goto ext_out;
+
+	/*
+	 * Skip the ONFI Parameter Pages.
+	 * The Change Read Columm command may does not works here.
+	 */
+	for (i = last + 1; i < p->num_of_param_pages; i++)
+		chip->read_buf(mtd, (uint8_t *)ep, sizeof(*p));
+
+	/* Read out the Extended Parameter Page. */
+	chip->read_buf(mtd, (uint8_t *)ep, len);
+	if ((onfi_crc16(ONFI_CRC_BASE, ((uint8_t *)ep) + 2, len - 2)
+		!= le16_to_cpu(ep->crc)) || strncmp(ep->sig, "EPPS", 4))
+		goto ext_out;
+
+	/* find the ECC section. */
+	cursor = (uint8_t *)(ep + 1);
+	for (i = 0; i < ONFI_EXT_SECTION_MAX; i++) {
+		s = ep->sections + i;
+		if (s->type == ONFI_SECTION_TYPE_2)
+			break;
+		cursor += s->length * 16;
+	}
+	if (i == ONFI_EXT_SECTION_MAX)
+		goto ext_out;
+
+	/* get the info we want. */
+	ecc = (struct onfi_ext_ecc_info *)cursor;
+	chip->ecc_strength = ecc->ecc_bits;
+	chip->ecc_size = 1 << ecc->codeword_size;
+
+	pr_info("ONFI extended param page detected.\n");
+ext_out:
+	kfree(ep);
+}
+
 /*
  * Check if the NAND chip is ONFI compliant, returns 1 if it is, 0 otherwise.
  */
@@ -2914,6 +2964,10 @@ static int nand_flash_detect_onfi(struct mtd_info *mtd, struct nand_chip *chip,
 	if (p->ecc_bits != 0xff) {
 		chip->ecc_strength = p->ecc_bits;
 		chip->ecc_size = 512;
+	} else if (chip->onfi_version >= 21 &&
+		(onfi_feature(chip) & ONFI_FEATURE_EXT_PARAM_PAGE)) {
+		/* The Extended Parameter Page is supported since ONFI 2.1. */
+		nand_flash_detect_ext_param_page(mtd, chip, p, i);
 	}
 
 	pr_info("ONFI flash detected\n");
-- 
1.7.1


