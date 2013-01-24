Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab3AXHIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 02:08:44 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:3881 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076Ab3AXHId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 02:08:33 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(z3121kzzz1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <artem.bityutskiy@linux.intel.com>, <computersforpeace@gmail.com>,
        <shmulik.ladkani@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH v2 1/3] mtd: add new fields to nand_flash_dev{}
Date: Thu, 24 Jan 2013 14:11:39 +0800
Message-ID: <1359007901-26464-2-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1359007901-26464-1-git-send-email-b32955@freescale.com>
References: <1359007901-26464-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As time goes on, we begin to meet the situation that we can not get enough
information from some nand chips's id data. Take some Toshiba's nand chips
for example. I have 4 Toshiba's nand chips in my hand:
	TC58NVG2S0F, TC58NVG3S0F, TC58NVG5D2, TC58NVG6D2

When we read these chips' datasheets, we will get the geometry of these chips:
	TC58NVG2S0F : 4096 + 224
	TC58NVG3S0F : 4096 + 232
	TC58NVG5D2  : 8192 + 640
	TC58NVG6D2  : 8192 + 640

But we can not parse out the correct oob size for these chips from the id data.
So it is time to add some new fields to the nand_flash_dev{}, and update the
detection mechanisms.

This patch just adds some new fields to the nand_flash_dev{}.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/devices/doc2000.c     |    2 +-
 drivers/mtd/devices/doc2001.c     |    2 +-
 drivers/mtd/devices/doc2001plus.c |    2 +-
 drivers/mtd/nand/nand_base.c      |    2 +-
 drivers/mtd/nand/nand_ids.c       |  176 +++++++++++++++++++------------------
 drivers/mtd/nand/nandsim.c        |    2 +-
 drivers/mtd/nand/pxa3xx_nand.c    |    2 +-
 drivers/mtd/nand/sm_common.c      |   61 ++++++-------
 include/linux/mtd/nand.h          |   10 ++-
 9 files changed, 133 insertions(+), 126 deletions(-)

diff --git a/drivers/mtd/devices/doc2000.c b/drivers/mtd/devices/doc2000.c
index a4eb8b5..93f037f 100644
--- a/drivers/mtd/devices/doc2000.c
+++ b/drivers/mtd/devices/doc2000.c
@@ -379,7 +379,7 @@ static int DoC_IdentChip(struct DiskOnChip *doc, int floor, int chip)
 
 	/* Print and store the manufacturer and ID codes. */
 	for (i = 0; nand_flash_ids[i].name != NULL; i++) {
-		if (id == nand_flash_ids[i].id) {
+		if (id == nand_flash_ids[i].id[1]) {
 			/* Try to identify manufacturer */
 			for (j = 0; nand_manuf_ids[j].id != 0x0; j++) {
 				if (nand_manuf_ids[j].id == mfr)
diff --git a/drivers/mtd/devices/doc2001.c b/drivers/mtd/devices/doc2001.c
index f692795..15dd177 100644
--- a/drivers/mtd/devices/doc2001.c
+++ b/drivers/mtd/devices/doc2001.c
@@ -206,7 +206,7 @@ static int DoC_IdentChip(struct DiskOnChip *doc, int floor, int chip)
 
 	/* FIXME: to deal with multi-flash on multi-Millennium case more carefully */
 	for (i = 0; nand_flash_ids[i].name != NULL; i++) {
-		if ( id == nand_flash_ids[i].id) {
+		if (id == nand_flash_ids[i].id[1]) {
 			/* Try to identify manufacturer */
 			for (j = 0; nand_manuf_ids[j].id != 0x0; j++) {
 				if (nand_manuf_ids[j].id == mfr)
diff --git a/drivers/mtd/devices/doc2001plus.c b/drivers/mtd/devices/doc2001plus.c
index 4f2220a..80aef1b 100644
--- a/drivers/mtd/devices/doc2001plus.c
+++ b/drivers/mtd/devices/doc2001plus.c
@@ -314,7 +314,7 @@ static int DoC_IdentChip(struct DiskOnChip *doc, int floor, int chip)
 		return 0;
 
 	for (i = 0; nand_flash_ids[i].name != NULL; i++) {
-		if (id == nand_flash_ids[i].id) {
+		if (id == nand_flash_ids[i].id[1]) {
 			/* Try to identify manufacturer */
 			for (j = 0; nand_manuf_ids[j].id != 0x0; j++) {
 				if (nand_manuf_ids[j].id == mfr)
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index a8c1fb4..0e80ec4 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -3204,7 +3204,7 @@ static struct nand_flash_dev *nand_get_flash_type(struct mtd_info *mtd,
 		type = nand_flash_ids;
 
 	for (; type->name != NULL; type++)
-		if (*dev_id == type->id)
+		if (*dev_id == type->id[1])
 			break;
 
 	chip->onfi_version = 0;
diff --git a/drivers/mtd/nand/nand_ids.c b/drivers/mtd/nand/nand_ids.c
index e3aa274..9dc2e54 100644
--- a/drivers/mtd/nand/nand_ids.c
+++ b/drivers/mtd/nand/nand_ids.c
@@ -10,6 +10,8 @@
  */
 #include <linux/module.h>
 #include <linux/mtd/nand.h>
+#include <linux/sizes.h>
+
 /*
 *	Chip ID list
 *
@@ -24,47 +26,47 @@
 struct nand_flash_dev nand_flash_ids[] = {
 
 #ifdef CONFIG_MTD_NAND_MUSEUM_IDS
-	{"NAND 1MiB 5V 8-bit",		0x6e, 256, 1, 0x1000, 0},
-	{"NAND 2MiB 5V 8-bit",		0x64, 256, 2, 0x1000, 0},
-	{"NAND 4MiB 5V 8-bit",		0x6b, 512, 4, 0x2000, 0},
-	{"NAND 1MiB 3,3V 8-bit",	0xe8, 256, 1, 0x1000, 0},
-	{"NAND 1MiB 3,3V 8-bit",	0xec, 256, 1, 0x1000, 0},
-	{"NAND 2MiB 3,3V 8-bit",	0xea, 256, 2, 0x1000, 0},
-	{"NAND 4MiB 3,3V 8-bit",	0xd5, 512, 4, 0x2000, 0},
-	{"NAND 4MiB 3,3V 8-bit",	0xe3, 512, 4, 0x2000, 0},
-	{"NAND 4MiB 3,3V 8-bit",	0xe5, 512, 4, 0x2000, 0},
-	{"NAND 8MiB 3,3V 8-bit",	0xd6, 512, 8, 0x2000, 0},
-
-	{"NAND 8MiB 1,8V 8-bit",	0x39, 512, 8, 0x2000, 0},
-	{"NAND 8MiB 3,3V 8-bit",	0xe6, 512, 8, 0x2000, 0},
-	{"NAND 8MiB 1,8V 16-bit",	0x49, 512, 8, 0x2000, NAND_BUSWIDTH_16},
-	{"NAND 8MiB 3,3V 16-bit",	0x59, 512, 8, 0x2000, NAND_BUSWIDTH_16},
+	{"NAND 1MiB 5V 8-bit",		{0, 0x6e}, 256, 1, 0x1000, 0},
+	{"NAND 2MiB 5V 8-bit",		{0, 0x64}, 256, 2, 0x1000, 0},
+	{"NAND 4MiB 5V 8-bit",		{0, 0x6b}, 512, 4, 0x2000, 0},
+	{"NAND 1MiB 3,3V 8-bit",	{0, 0xe8}, 256, 1, 0x1000, 0},
+	{"NAND 1MiB 3,3V 8-bit",	{0, 0xec}, 256, 1, 0x1000, 0},
+	{"NAND 2MiB 3,3V 8-bit",	{0, 0xea}, 256, 2, 0x1000, 0},
+	{"NAND 4MiB 3,3V 8-bit",	{0, 0xd5}, 512, 4, 0x2000, 0},
+	{"NAND 4MiB 3,3V 8-bit",	{0, 0xe3}, 512, 4, 0x2000, 0},
+	{"NAND 4MiB 3,3V 8-bit",	{0, 0xe5}, 512, 4, 0x2000, 0},
+	{"NAND 8MiB 3,3V 8-bit",	{0, 0xd6}, 512, 8, 0x2000, 0},
+
+	{"NAND 8MiB 1,8V 8-bit",	{0, 0x39}, 512, 8, 0x2000, 0},
+	{"NAND 8MiB 3,3V 8-bit",	{0, 0xe6}, 512, 8, 0x2000, 0},
+	{"NAND 8MiB 1,8V 16-bit",	{0, 0x49}, 512, 8, 0x2000, NAND_BUSWIDTH_16},
+	{"NAND 8MiB 3,3V 16-bit",	{0, 0x59}, 512, 8, 0x2000, NAND_BUSWIDTH_16},
 #endif
 
-	{"NAND 16MiB 1,8V 8-bit",	0x33, 512, 16, 0x4000, 0},
-	{"NAND 16MiB 3,3V 8-bit",	0x73, 512, 16, 0x4000, 0},
-	{"NAND 16MiB 1,8V 16-bit",	0x43, 512, 16, 0x4000, NAND_BUSWIDTH_16},
-	{"NAND 16MiB 3,3V 16-bit",	0x53, 512, 16, 0x4000, NAND_BUSWIDTH_16},
+	{"NAND 16MiB 1,8V 8-bit",	{0, 0x33}, 512, 16, 0x4000, 0},
+	{"NAND 16MiB 3,3V 8-bit",	{0, 0x73}, 512, 16, 0x4000, 0},
+	{"NAND 16MiB 1,8V 16-bit",	{0, 0x43}, 512, 16, 0x4000, NAND_BUSWIDTH_16},
+	{"NAND 16MiB 3,3V 16-bit",	{0, 0x53}, 512, 16, 0x4000, NAND_BUSWIDTH_16},
 
-	{"NAND 32MiB 1,8V 8-bit",	0x35, 512, 32, 0x4000, 0},
-	{"NAND 32MiB 3,3V 8-bit",	0x75, 512, 32, 0x4000, 0},
-	{"NAND 32MiB 1,8V 16-bit",	0x45, 512, 32, 0x4000, NAND_BUSWIDTH_16},
-	{"NAND 32MiB 3,3V 16-bit",	0x55, 512, 32, 0x4000, NAND_BUSWIDTH_16},
+	{"NAND 32MiB 1,8V 8-bit",	{0, 0x35}, 512, 32, 0x4000, 0},
+	{"NAND 32MiB 3,3V 8-bit",	{0, 0x75}, 512, 32, 0x4000, 0},
+	{"NAND 32MiB 1,8V 16-bit",	{0, 0x45}, 512, 32, 0x4000, NAND_BUSWIDTH_16},
+	{"NAND 32MiB 3,3V 16-bit",	{0, 0x55}, 512, 32, 0x4000, NAND_BUSWIDTH_16},
 
-	{"NAND 64MiB 1,8V 8-bit",	0x36, 512, 64, 0x4000, 0},
-	{"NAND 64MiB 3,3V 8-bit",	0x76, 512, 64, 0x4000, 0},
-	{"NAND 64MiB 1,8V 16-bit",	0x46, 512, 64, 0x4000, NAND_BUSWIDTH_16},
-	{"NAND 64MiB 3,3V 16-bit",	0x56, 512, 64, 0x4000, NAND_BUSWIDTH_16},
+	{"NAND 64MiB 1,8V 8-bit",	{0, 0x36}, 512, 64, 0x4000, 0},
+	{"NAND 64MiB 3,3V 8-bit",	{0, 0x76}, 512, 64, 0x4000, 0},
+	{"NAND 64MiB 1,8V 16-bit",	{0, 0x46}, 512, 64, 0x4000, NAND_BUSWIDTH_16},
+	{"NAND 64MiB 3,3V 16-bit",	{0, 0x56}, 512, 64, 0x4000, NAND_BUSWIDTH_16},
 
-	{"NAND 128MiB 1,8V 8-bit",	0x78, 512, 128, 0x4000, 0},
-	{"NAND 128MiB 1,8V 8-bit",	0x39, 512, 128, 0x4000, 0},
-	{"NAND 128MiB 3,3V 8-bit",	0x79, 512, 128, 0x4000, 0},
-	{"NAND 128MiB 1,8V 16-bit",	0x72, 512, 128, 0x4000, NAND_BUSWIDTH_16},
-	{"NAND 128MiB 1,8V 16-bit",	0x49, 512, 128, 0x4000, NAND_BUSWIDTH_16},
-	{"NAND 128MiB 3,3V 16-bit",	0x74, 512, 128, 0x4000, NAND_BUSWIDTH_16},
-	{"NAND 128MiB 3,3V 16-bit",	0x59, 512, 128, 0x4000, NAND_BUSWIDTH_16},
+	{"NAND 128MiB 1,8V 8-bit",	{0, 0x78}, 512, 128, 0x4000, 0},
+	{"NAND 128MiB 1,8V 8-bit",	{0, 0x39}, 512, 128, 0x4000, 0},
+	{"NAND 128MiB 3,3V 8-bit",	{0, 0x79}, 512, 128, 0x4000, 0},
+	{"NAND 128MiB 1,8V 16-bit",	{0, 0x72}, 512, 128, 0x4000, NAND_BUSWIDTH_16},
+	{"NAND 128MiB 1,8V 16-bit",	{0, 0x49}, 512, 128, 0x4000, NAND_BUSWIDTH_16},
+	{"NAND 128MiB 3,3V 16-bit",	{0, 0x74}, 512, 128, 0x4000, NAND_BUSWIDTH_16},
+	{"NAND 128MiB 3,3V 16-bit",	{0, 0x59}, 512, 128, 0x4000, NAND_BUSWIDTH_16},
 
-	{"NAND 256MiB 3,3V 8-bit",	0x71, 512, 256, 0x4000, 0},
+	{"NAND 256MiB 3,3V 8-bit",	{0, 0x71}, 512, 256, 0x4000, 0},
 
 	/*
 	 * These are the new chips with large page size. The pagesize and the
@@ -74,77 +76,77 @@ struct nand_flash_dev nand_flash_ids[] = {
 #define LP_OPTIONS16 (LP_OPTIONS | NAND_BUSWIDTH_16)
 
 	/* 512 Megabit */
-	{"NAND 64MiB 1,8V 8-bit",	0xA2, 0,  64, 0, LP_OPTIONS},
-	{"NAND 64MiB 1,8V 8-bit",	0xA0, 0,  64, 0, LP_OPTIONS},
-	{"NAND 64MiB 3,3V 8-bit",	0xF2, 0,  64, 0, LP_OPTIONS},
-	{"NAND 64MiB 3,3V 8-bit",	0xD0, 0,  64, 0, LP_OPTIONS},
-	{"NAND 64MiB 3,3V 8-bit",	0xF0, 0,  64, 0, LP_OPTIONS},
-	{"NAND 64MiB 1,8V 16-bit",	0xB2, 0,  64, 0, LP_OPTIONS16},
-	{"NAND 64MiB 1,8V 16-bit",	0xB0, 0,  64, 0, LP_OPTIONS16},
-	{"NAND 64MiB 3,3V 16-bit",	0xC2, 0,  64, 0, LP_OPTIONS16},
-	{"NAND 64MiB 3,3V 16-bit",	0xC0, 0,  64, 0, LP_OPTIONS16},
+	{"NAND 64MiB 1,8V 8-bit",	{0, 0xA2}, 0,  64, 0, LP_OPTIONS},
+	{"NAND 64MiB 1,8V 8-bit",	{0, 0xA0}, 0,  64, 0, LP_OPTIONS},
+	{"NAND 64MiB 3,3V 8-bit",	{0, 0xF2}, 0,  64, 0, LP_OPTIONS},
+	{"NAND 64MiB 3,3V 8-bit",	{0, 0xD0}, 0,  64, 0, LP_OPTIONS},
+	{"NAND 64MiB 3,3V 8-bit",	{0, 0xF0}, 0,  64, 0, LP_OPTIONS},
+	{"NAND 64MiB 1,8V 16-bit",	{0, 0xB2}, 0,  64, 0, LP_OPTIONS16},
+	{"NAND 64MiB 1,8V 16-bit",	{0, 0xB0}, 0,  64, 0, LP_OPTIONS16},
+	{"NAND 64MiB 3,3V 16-bit",	{0, 0xC2}, 0,  64, 0, LP_OPTIONS16},
+	{"NAND 64MiB 3,3V 16-bit",	{0, 0xC0}, 0,  64, 0, LP_OPTIONS16},
 
 	/* 1 Gigabit */
-	{"NAND 128MiB 1,8V 8-bit",	0xA1, 0, 128, 0, LP_OPTIONS},
-	{"NAND 128MiB 3,3V 8-bit",	0xF1, 0, 128, 0, LP_OPTIONS},
-	{"NAND 128MiB 3,3V 8-bit",	0xD1, 0, 128, 0, LP_OPTIONS},
-	{"NAND 128MiB 1,8V 16-bit",	0xB1, 0, 128, 0, LP_OPTIONS16},
-	{"NAND 128MiB 3,3V 16-bit",	0xC1, 0, 128, 0, LP_OPTIONS16},
-	{"NAND 128MiB 1,8V 16-bit",     0xAD, 0, 128, 0, LP_OPTIONS16},
+	{"NAND 128MiB 1,8V 8-bit",	{0, 0xA1}, 0, 128, 0, LP_OPTIONS},
+	{"NAND 128MiB 3,3V 8-bit",	{0, 0xF1}, 0, 128, 0, LP_OPTIONS},
+	{"NAND 128MiB 3,3V 8-bit",	{0, 0xD1}, 0, 128, 0, LP_OPTIONS},
+	{"NAND 128MiB 1,8V 16-bit",	{0, 0xB1}, 0, 128, 0, LP_OPTIONS16},
+	{"NAND 128MiB 3,3V 16-bit",	{0, 0xC1}, 0, 128, 0, LP_OPTIONS16},
+	{"NAND 128MiB 1,8V 16-bit",     {0, 0xAD}, 0, 128, 0, LP_OPTIONS16},
 
 	/* 2 Gigabit */
-	{"NAND 256MiB 1,8V 8-bit",	0xAA, 0, 256, 0, LP_OPTIONS},
-	{"NAND 256MiB 3,3V 8-bit",	0xDA, 0, 256, 0, LP_OPTIONS},
-	{"NAND 256MiB 1,8V 16-bit",	0xBA, 0, 256, 0, LP_OPTIONS16},
-	{"NAND 256MiB 3,3V 16-bit",	0xCA, 0, 256, 0, LP_OPTIONS16},
+	{"NAND 256MiB 1,8V 8-bit",	{0, 0xAA}, 0, 256, 0, LP_OPTIONS},
+	{"NAND 256MiB 3,3V 8-bit",	{0, 0xDA}, 0, 256, 0, LP_OPTIONS},
+	{"NAND 256MiB 1,8V 16-bit",	{0, 0xBA}, 0, 256, 0, LP_OPTIONS16},
+	{"NAND 256MiB 3,3V 16-bit",	{0, 0xCA}, 0, 256, 0, LP_OPTIONS16},
 
 	/* 4 Gigabit */
-	{"NAND 512MiB 1,8V 8-bit",	0xAC, 0, 512, 0, LP_OPTIONS},
-	{"NAND 512MiB 3,3V 8-bit",	0xDC, 0, 512, 0, LP_OPTIONS},
-	{"NAND 512MiB 1,8V 16-bit",	0xBC, 0, 512, 0, LP_OPTIONS16},
-	{"NAND 512MiB 3,3V 16-bit",	0xCC, 0, 512, 0, LP_OPTIONS16},
+	{"NAND 512MiB 1,8V 8-bit",	{0, 0xAC}, 0, 512, 0, LP_OPTIONS},
+	{"NAND 512MiB 3,3V 8-bit",	{0, 0xDC}, 0, 512, 0, LP_OPTIONS},
+	{"NAND 512MiB 1,8V 16-bit",	{0, 0xBC}, 0, 512, 0, LP_OPTIONS16},
+	{"NAND 512MiB 3,3V 16-bit",	{0, 0xCC}, 0, 512, 0, LP_OPTIONS16},
 
 	/* 8 Gigabit */
-	{"NAND 1GiB 1,8V 8-bit",	0xA3, 0, 1024, 0, LP_OPTIONS},
-	{"NAND 1GiB 3,3V 8-bit",	0xD3, 0, 1024, 0, LP_OPTIONS},
-	{"NAND 1GiB 1,8V 16-bit",	0xB3, 0, 1024, 0, LP_OPTIONS16},
-	{"NAND 1GiB 3,3V 16-bit",	0xC3, 0, 1024, 0, LP_OPTIONS16},
+	{"NAND 1GiB 1,8V 8-bit",	{0, 0xA3}, 0, 1024, 0, LP_OPTIONS},
+	{"NAND 1GiB 3,3V 8-bit",	{0, 0xD3}, 0, 1024, 0, LP_OPTIONS},
+	{"NAND 1GiB 1,8V 16-bit",	{0, 0xB3}, 0, 1024, 0, LP_OPTIONS16},
+	{"NAND 1GiB 3,3V 16-bit",	{0, 0xC3}, 0, 1024, 0, LP_OPTIONS16},
 
 	/* 16 Gigabit */
-	{"NAND 2GiB 1,8V 8-bit",	0xA5, 0, 2048, 0, LP_OPTIONS},
-	{"NAND 2GiB 3,3V 8-bit",	0xD5, 0, 2048, 0, LP_OPTIONS},
-	{"NAND 2GiB 1,8V 16-bit",	0xB5, 0, 2048, 0, LP_OPTIONS16},
-	{"NAND 2GiB 3,3V 16-bit",	0xC5, 0, 2048, 0, LP_OPTIONS16},
+	{"NAND 2GiB 1,8V 8-bit",	{0, 0xA5}, 0, 2048, 0, LP_OPTIONS},
+	{"NAND 2GiB 3,3V 8-bit",	{0, 0xD5}, 0, 2048, 0, LP_OPTIONS},
+	{"NAND 2GiB 1,8V 16-bit",	{0, 0xB5}, 0, 2048, 0, LP_OPTIONS16},
+	{"NAND 2GiB 3,3V 16-bit",	{0, 0xC5}, 0, 2048, 0, LP_OPTIONS16},
 
 	/* 32 Gigabit */
-	{"NAND 4GiB 1,8V 8-bit",	0xA7, 0, 4096, 0, LP_OPTIONS},
-	{"NAND 4GiB 3,3V 8-bit",	0xD7, 0, 4096, 0, LP_OPTIONS},
-	{"NAND 4GiB 1,8V 16-bit",	0xB7, 0, 4096, 0, LP_OPTIONS16},
-	{"NAND 4GiB 3,3V 16-bit",	0xC7, 0, 4096, 0, LP_OPTIONS16},
+	{"NAND 4GiB 1,8V 8-bit",	{0, 0xA7}, 0, 4096, 0, LP_OPTIONS},
+	{"NAND 4GiB 3,3V 8-bit",	{0, 0xD7}, 0, 4096, 0, LP_OPTIONS},
+	{"NAND 4GiB 1,8V 16-bit",	{0, 0xB7}, 0, 4096, 0, LP_OPTIONS16},
+	{"NAND 4GiB 3,3V 16-bit",	{0, 0xC7}, 0, 4096, 0, LP_OPTIONS16},
 
 	/* 64 Gigabit */
-	{"NAND 8GiB 1,8V 8-bit",	0xAE, 0, 8192, 0, LP_OPTIONS},
-	{"NAND 8GiB 3,3V 8-bit",	0xDE, 0, 8192, 0, LP_OPTIONS},
-	{"NAND 8GiB 1,8V 16-bit",	0xBE, 0, 8192, 0, LP_OPTIONS16},
-	{"NAND 8GiB 3,3V 16-bit",	0xCE, 0, 8192, 0, LP_OPTIONS16},
+	{"NAND 8GiB 1,8V 8-bit",	{0, 0xAE}, 0, 8192, 0, LP_OPTIONS},
+	{"NAND 8GiB 3,3V 8-bit",	{0, 0xDE}, 0, 8192, 0, LP_OPTIONS},
+	{"NAND 8GiB 1,8V 16-bit",	{0, 0xBE}, 0, 8192, 0, LP_OPTIONS16},
+	{"NAND 8GiB 3,3V 16-bit",	{0, 0xCE}, 0, 8192, 0, LP_OPTIONS16},
 
 	/* 128 Gigabit */
-	{"NAND 16GiB 1,8V 8-bit",	0x1A, 0, 16384, 0, LP_OPTIONS},
-	{"NAND 16GiB 3,3V 8-bit",	0x3A, 0, 16384, 0, LP_OPTIONS},
-	{"NAND 16GiB 1,8V 16-bit",	0x2A, 0, 16384, 0, LP_OPTIONS16},
-	{"NAND 16GiB 3,3V 16-bit",	0x4A, 0, 16384, 0, LP_OPTIONS16},
+	{"NAND 16GiB 1,8V 8-bit",	{0, 0x1A}, 0, 16384, 0, LP_OPTIONS},
+	{"NAND 16GiB 3,3V 8-bit",	{0, 0x3A}, 0, 16384, 0, LP_OPTIONS},
+	{"NAND 16GiB 1,8V 16-bit",	{0, 0x2A}, 0, 16384, 0, LP_OPTIONS16},
+	{"NAND 16GiB 3,3V 16-bit",	{0, 0x4A}, 0, 16384, 0, LP_OPTIONS16},
 
 	/* 256 Gigabit */
-	{"NAND 32GiB 1,8V 8-bit",	0x1C, 0, 32768, 0, LP_OPTIONS},
-	{"NAND 32GiB 3,3V 8-bit",	0x3C, 0, 32768, 0, LP_OPTIONS},
-	{"NAND 32GiB 1,8V 16-bit",	0x2C, 0, 32768, 0, LP_OPTIONS16},
-	{"NAND 32GiB 3,3V 16-bit",	0x4C, 0, 32768, 0, LP_OPTIONS16},
+	{"NAND 32GiB 1,8V 8-bit",	{0, 0x1C}, 0, 32768, 0, LP_OPTIONS},
+	{"NAND 32GiB 3,3V 8-bit",	{0, 0x3C}, 0, 32768, 0, LP_OPTIONS},
+	{"NAND 32GiB 1,8V 16-bit",	{0, 0x2C}, 0, 32768, 0, LP_OPTIONS16},
+	{"NAND 32GiB 3,3V 16-bit",	{0, 0x4C}, 0, 32768, 0, LP_OPTIONS16},
 
 	/* 512 Gigabit */
-	{"NAND 64GiB 1,8V 8-bit",	0x1E, 0, 65536, 0, LP_OPTIONS},
-	{"NAND 64GiB 3,3V 8-bit",	0x3E, 0, 65536, 0, LP_OPTIONS},
-	{"NAND 64GiB 1,8V 16-bit",	0x2E, 0, 65536, 0, LP_OPTIONS16},
-	{"NAND 64GiB 3,3V 16-bit",	0x4E, 0, 65536, 0, LP_OPTIONS16},
+	{"NAND 64GiB 1,8V 8-bit",	{0, 0x1E}, 0, 65536, 0, LP_OPTIONS},
+	{"NAND 64GiB 3,3V 8-bit",	{0, 0x3E}, 0, 65536, 0, LP_OPTIONS},
+	{"NAND 64GiB 1,8V 16-bit",	{0, 0x2E}, 0, 65536, 0, LP_OPTIONS16},
+	{"NAND 64GiB 3,3V 16-bit",	{0, 0x4E}, 0, 65536, 0, LP_OPTIONS16},
 
 	/*
 	 * Renesas AND 1 Gigabit. Those chips do not support extended id and
@@ -156,7 +158,7 @@ struct nand_flash_dev nand_flash_ids[] = {
 	 * erased in one go There are more speed improvements for reads and
 	 * writes possible, but not implemented now
 	 */
-	{"AND 128MiB 3,3V 8-bit",	0x01, 2048, 128, 0x4000,
+	{"AND 128MiB 3,3V 8-bit",	{0, 0x01}, 2048, 128, 0x4000,
 	 NAND_IS_AND | NAND_4PAGE_ARRAY | BBT_AUTO_REFRESH},
 
 	{NULL,}
diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
index 4c31798..d6120a4 100644
--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -770,7 +770,7 @@ static int init_nandsim(struct mtd_info *mtd)
 
 	/* Detect how many ID bytes the NAND chip outputs */
         for (i = 0; nand_flash_ids[i].name != NULL; i++) {
-                if (second_id_byte != nand_flash_ids[i].id)
+                if (second_id_byte != nand_flash_ids[i].id[1])
                         continue;
 	}
 
diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
index 37ee75c..78a8fd1 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -989,7 +989,7 @@ static int pxa3xx_nand_scan(struct mtd_info *mtd)
 	}
 
 	pxa3xx_flash_ids[0].name = f->name;
-	pxa3xx_flash_ids[0].id = (f->chip_id >> 8) & 0xffff;
+	pxa3xx_flash_ids[0].id[1] = (f->chip_id >> 8) & 0xffff;
 	pxa3xx_flash_ids[0].pagesize = f->page_size;
 	chipsize = (uint64_t)f->num_blocks * f->page_per_block * f->page_size;
 	pxa3xx_flash_ids[0].chipsize = chipsize >> 20;
diff --git a/drivers/mtd/nand/sm_common.c b/drivers/mtd/nand/sm_common.c
index 082bcdc..bd5cc43 100644
--- a/drivers/mtd/nand/sm_common.c
+++ b/drivers/mtd/nand/sm_common.c
@@ -69,41 +69,40 @@ static int sm_block_markbad(struct mtd_info *mtd, loff_t ofs)
 
 
 static struct nand_flash_dev nand_smartmedia_flash_ids[] = {
-	{"SmartMedia 1MiB 5V",          0x6e, 256, 1, 0x1000, 0},
-	{"SmartMedia 1MiB 3,3V",        0xe8, 256, 1, 0x1000, 0},
-	{"SmartMedia 1MiB 3,3V",        0xec, 256, 1, 0x1000, 0},
-	{"SmartMedia 2MiB 3,3V",        0xea, 256, 2, 0x1000, 0},
-	{"SmartMedia 2MiB 5V",          0x64, 256, 2, 0x1000, 0},
-	{"SmartMedia 2MiB 3,3V ROM",    0x5d, 512, 2, 0x2000, NAND_ROM},
-	{"SmartMedia 4MiB 3,3V",        0xe3, 512, 4, 0x2000, 0},
-	{"SmartMedia 4MiB 3,3/5V",      0xe5, 512, 4, 0x2000, 0},
-	{"SmartMedia 4MiB 5V",          0x6b, 512, 4, 0x2000, 0},
-	{"SmartMedia 4MiB 3,3V ROM",    0xd5, 512, 4, 0x2000, NAND_ROM},
-	{"SmartMedia 8MiB 3,3V",        0xe6, 512, 8, 0x2000, 0},
-	{"SmartMedia 8MiB 3,3V ROM",    0xd6, 512, 8, 0x2000, NAND_ROM},
-	{"SmartMedia 16MiB 3,3V",       0x73, 512, 16, 0x4000, 0},
-	{"SmartMedia 16MiB 3,3V ROM",   0x57, 512, 16, 0x4000, NAND_ROM},
-	{"SmartMedia 32MiB 3,3V",       0x75, 512, 32, 0x4000, 0},
-	{"SmartMedia 32MiB 3,3V ROM",   0x58, 512, 32, 0x4000, NAND_ROM},
-	{"SmartMedia 64MiB 3,3V",       0x76, 512, 64, 0x4000, 0},
-	{"SmartMedia 64MiB 3,3V ROM",   0xd9, 512, 64, 0x4000, NAND_ROM},
-	{"SmartMedia 128MiB 3,3V",      0x79, 512, 128, 0x4000, 0},
-	{"SmartMedia 128MiB 3,3V ROM",  0xda, 512, 128, 0x4000, NAND_ROM},
-	{"SmartMedia 256MiB 3,3V",      0x71, 512, 256, 0x4000 },
-	{"SmartMedia 256MiB 3,3V ROM",  0x5b, 512, 256, 0x4000, NAND_ROM},
+	{"SmartMedia 1MiB 5V",          {0, 0x6e}, 256, 1, 0x1000, 0},
+	{"SmartMedia 1MiB 3,3V",        {0, 0xe8}, 256, 1, 0x1000, 0},
+	{"SmartMedia 1MiB 3,3V",        {0, 0xec}, 256, 1, 0x1000, 0},
+	{"SmartMedia 2MiB 3,3V",        {0, 0xea}, 256, 2, 0x1000, 0},
+	{"SmartMedia 2MiB 5V",          {0, 0x64}, 256, 2, 0x1000, 0},
+	{"SmartMedia 2MiB 3,3V ROM",    {0, 0x5d}, 512, 2, 0x2000, NAND_ROM},
+	{"SmartMedia 4MiB 3,3V",        {0, 0xe3}, 512, 4, 0x2000, 0},
+	{"SmartMedia 4MiB 3,3/5V",      {0, 0xe5}, 512, 4, 0x2000, 0},
+	{"SmartMedia 4MiB 5V",          {0, 0x6b}, 512, 4, 0x2000, 0},
+	{"SmartMedia 4MiB 3,3V ROM",    {0, 0xd5}, 512, 4, 0x2000, NAND_ROM},
+	{"SmartMedia 8MiB 3,3V",        {0, 0xe6}, 512, 8, 0x2000, 0},
+	{"SmartMedia 8MiB 3,3V ROM",    {0, 0xd6}, 512, 8, 0x2000, NAND_ROM},
+	{"SmartMedia 16MiB 3,3V",       {0, 0x73}, 512, 16, 0x4000, 0},
+	{"SmartMedia 16MiB 3,3V ROM",   {0, 0x57}, 512, 16, 0x4000, NAND_ROM},
+	{"SmartMedia 32MiB 3,3V",       {0, 0x75}, 512, 32, 0x4000, 0},
+	{"SmartMedia 32MiB 3,3V ROM",   {0, 0x58}, 512, 32, 0x4000, NAND_ROM},
+	{"SmartMedia 64MiB 3,3V",       {0, 0x76}, 512, 64, 0x4000, 0},
+	{"SmartMedia 64MiB 3,3V ROM",   {0, 0xd9}, 512, 64, 0x4000, NAND_ROM},
+	{"SmartMedia 128MiB 3,3V",      {0, 0x79}, 512, 128, 0x4000, 0},
+	{"SmartMedia 128MiB 3,3V ROM",  {0, 0xda}, 512, 128, 0x4000, NAND_ROM},
+	{"SmartMedia 256MiB 3,3V",      {0, 0x71}, 512, 256, 0x4000 },
+	{"SmartMedia 256MiB 3,3V ROM",  {0, 0x5b}, 512, 256, 0x4000, NAND_ROM},
 	{NULL,}
 };
 
 static struct nand_flash_dev nand_xd_flash_ids[] = {
-
-	{"xD 16MiB 3,3V",    0x73, 512, 16, 0x4000, 0},
-	{"xD 32MiB 3,3V",    0x75, 512, 32, 0x4000, 0},
-	{"xD 64MiB 3,3V",    0x76, 512, 64, 0x4000, 0},
-	{"xD 128MiB 3,3V",   0x79, 512, 128, 0x4000, 0},
-	{"xD 256MiB 3,3V",   0x71, 512, 256, 0x4000, NAND_BROKEN_XD},
-	{"xD 512MiB 3,3V",   0xdc, 512, 512, 0x4000, NAND_BROKEN_XD},
-	{"xD 1GiB 3,3V",     0xd3, 512, 1024, 0x4000, NAND_BROKEN_XD},
-	{"xD 2GiB 3,3V",     0xd5, 512, 2048, 0x4000, NAND_BROKEN_XD},
+	{"xD 16MiB 3,3V",    {0, 0x73}, 512, 16, 0x4000, 0},
+	{"xD 32MiB 3,3V",    {0, 0x75}, 512, 32, 0x4000, 0},
+	{"xD 64MiB 3,3V",    {0, 0x76}, 512, 64, 0x4000, 0},
+	{"xD 128MiB 3,3V",   {0, 0x79}, 512, 128, 0x4000, 0},
+	{"xD 256MiB 3,3V",   {0, 0x71}, 512, 256, 0x4000, NAND_BROKEN_XD},
+	{"xD 512MiB 3,3V",   {0, 0xdc}, 512, 512, 0x4000, NAND_BROKEN_XD},
+	{"xD 1GiB 3,3V",     {0, 0xd3}, 512, 1024, 0x4000, NAND_BROKEN_XD},
+	{"xD 2GiB 3,3V",     {0, 0xd5}, 512, 2048, 0x4000, NAND_BROKEN_XD},
 	{NULL,}
 };
 
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 7ccb3c5..5293447 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -585,7 +585,7 @@ struct nand_chip {
 /**
  * struct nand_flash_dev - NAND Flash Device ID Structure
  * @name:	Identify the device type
- * @id:		device ID code
+ * @id:		ID data
  * @pagesize:	Pagesize in bytes. Either 256 or 512 or 0
  *		If the pagesize is 0, then the real pagesize
  *		and the eraseize are determined from the
@@ -593,14 +593,20 @@ struct nand_chip {
  * @erasesize:	Size of an erase block in the flash device.
  * @chipsize:	Total chipsize in Mega Bytes
  * @options:	Bitfield to store chip relevant options
+ * @id_len:	The valid length of the id data.
+ * @oobsize:	OOB size
+ * @ecc_len:	The required ECC length.
  */
 struct nand_flash_dev {
 	char *name;
-	int id;
+	u8 id[8];
 	unsigned long pagesize;
 	unsigned long chipsize;
 	unsigned long erasesize;
 	unsigned long options;
+	unsigned int id_len;
+	unsigned long oobsize;
+	unsigned long ecc_len;
 };
 
 /**
-- 
1.7.0.4


