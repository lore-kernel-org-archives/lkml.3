Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab3DWJGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 05:06:18 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:9792
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755907Ab3DWJGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 05:06:14 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH V3 2/9] mtd: add data structures for Extended Parameter Page
Date: Tue, 23 Apr 2013 16:54:50 +0800
Message-ID: <1366707297-31309-3-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366707297-31309-1-git-send-email-b32955@freescale.com>
References: <1366707297-31309-1-git-send-email-b32955@freescale.com>
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

This patch adds
    [1] the neccessary fields for nand_onfi_params{},
    [2] and adds the onfi_ext_ecc_info{} for Extended ECC information,
    [3] adds onfi_ext_section{} for extended sections,
    [4] and adds onfi_ext_param_page{} for the Extended Parameter Page.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 include/linux/mtd/nand.h |   39 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index c1cc690..3f47ad9 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -224,7 +224,10 @@ struct nand_onfi_params {
 	__le16 revision;
 	__le16 features;
 	__le16 opt_cmd;
-	u8 reserved[22];
+	u8 reserved0[2];
+	__le16 ext_param_page_length; /* since ONFI 2.1 */
+	u8 num_of_param_pages;        /* since ONFI 2.1 */
+	u8 reserved1[17];
 
 	/* manufacturer information block */
 	char manufacturer[12];
@@ -281,6 +284,40 @@ struct nand_onfi_params {
 
 #define ONFI_CRC_BASE	0x4F4E
 
+/* Extended ECC information Block Definition (since ONFI 2.1) */
+struct onfi_ext_ecc_info {
+	u8 ecc_bits;
+	u8 codeword_size;
+	__le16 bb_per_lun;
+	__le16 block_endurance;
+	u8 reserved[2];
+} __attribute__((packed));
+
+#define ONFI_SECTION_TYPE_0	0	/* Unused section. */
+#define ONFI_SECTION_TYPE_1	1	/* for additional sections. */
+#define ONFI_SECTION_TYPE_2	2	/* for ECC information. */
+struct onfi_ext_section {
+	u8 type;
+	u8 length;
+} __attribute__((packed));
+
+#define ONFI_EXT_SECTION_MAX 8
+
+/* Extended Parameter Page Definition (since ONFI 2.1) */
+struct onfi_ext_param_page {
+	__le16 crc;
+	u8 sig[4];             /* 'E' 'P' 'P' 'S' */
+	u8 reserved0[10];
+	struct onfi_ext_section sections[ONFI_EXT_SECTION_MAX];
+
+	/*
+	 * The actual size of the Extended Parameter Page is in
+	 * @ext_param_page_length of nand_onfi_params{}.
+	 * The following are the variable length sections.
+	 * So we do not add any fields below. Please see the ONFI spec.
+	 */
+} __attribute__((packed));
+
 /**
  * struct nand_hw_control - Control structure for hardware controller (e.g ECC generator) shared among independent devices
  * @lock:               protection lock
-- 
1.7.1


