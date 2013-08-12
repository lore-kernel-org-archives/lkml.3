Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab3HLKWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:22:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49212 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab3HLKWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:22:45 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 2/4] mtd: m25p80: make CONFIG_M25PXX_USE_FAST_READ safe to enable
Date: Mon, 12 Aug 2013 12:22:24 +0200
Message-Id: <1376302946-11534-3-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.8.4.rc1
In-Reply-To: <1376302946-11534-1-git-send-email-s.hauer@pengutronix.de>
References: <1376302946-11534-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a flag to struct flash_info indicating that
fast_read is not supported. This now gives the following logic
when determing whether to enable fastread:

1) enable fast_read if device node contains m25p,fast-read
2) enable fast_read unconditionally if forced in Kconfig
3) Disable fast_read if the chip does not support it

This makes enabling CONFIG_M25PXX_USE_FAST_READ a safe option
since we no longer enable the fast_read option unconditionally.

For now fast_read is disabled for the everspin mr25h256 and the
catalyst devices. Others may need the flag aswell.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/mtd/devices/m25p80.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 75d4391..8e30b07 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -682,6 +682,7 @@ struct flash_info {
 #define	SECT_4K		0x01		/* OPCODE_BE_4K works uniformly */
 #define	M25P_NO_ERASE	0x02		/* No erase command needed */
 #define	SST_WRITE	0x04		/* use SST byte programming */
+#define	M25P_NO_FR	0x08		/* Can't do fastread */
 };
 
 #define INFO(_jedec_id, _ext_id, _sector_size, _n_sectors, _flags)	\
@@ -732,7 +733,7 @@ static const struct spi_device_id m25p_ids[] = {
 	{ "en25qh256", INFO(0x1c7019, 0, 64 * 1024, 512, 0) },
 
 	/* Everspin */
-	{ "mr25h256", CAT25_INFO(  32 * 1024, 1, 256, 2, M25P_NO_ERASE) },
+	{ "mr25h256", CAT25_INFO(  32 * 1024, 1, 256, 2, M25P_NO_ERASE | M25P_NO_FR) },
 
 	/* GigaDevice */
 	{ "gd25q32", INFO(0xc84016, 0, 64 * 1024,  64, SECT_4K) },
@@ -846,11 +847,11 @@ static const struct spi_device_id m25p_ids[] = {
 	{ "w25q256", INFO(0xef4019, 0, 64 * 1024, 512, SECT_4K) },
 
 	/* Catalyst / On Semiconductor -- non-JEDEC */
-	{ "cat25c11", CAT25_INFO(  16, 8, 16, 1, M25P_NO_ERASE) },
-	{ "cat25c03", CAT25_INFO(  32, 8, 16, 2, M25P_NO_ERASE) },
-	{ "cat25c09", CAT25_INFO( 128, 8, 32, 2, M25P_NO_ERASE) },
-	{ "cat25c17", CAT25_INFO( 256, 8, 32, 2, M25P_NO_ERASE) },
-	{ "cat25128", CAT25_INFO(2048, 8, 64, 2, M25P_NO_ERASE) },
+	{ "cat25c11", CAT25_INFO(  16, 8, 16, 1, M25P_NO_ERASE | M25P_NO_FR) },
+	{ "cat25c03", CAT25_INFO(  32, 8, 16, 2, M25P_NO_ERASE | M25P_NO_FR) },
+	{ "cat25c09", CAT25_INFO( 128, 8, 32, 2, M25P_NO_ERASE | M25P_NO_FR) },
+	{ "cat25c17", CAT25_INFO( 256, 8, 32, 2, M25P_NO_ERASE | M25P_NO_FR) },
+	{ "cat25128", CAT25_INFO(2048, 8, 64, 2, M25P_NO_ERASE | M25P_NO_FR) },
 	{ },
 };
 MODULE_DEVICE_TABLE(spi, m25p_ids);
@@ -1037,6 +1038,9 @@ static int m25p_probe(struct spi_device *spi)
 	flash->fast_read = true;
 #endif
 
+	if (info->flags & M25P_NO_FR)
+		flash->fast_read = false;
+
 	if (info->addr_width)
 		flash->addr_width = info->addr_width;
 	else {
-- 
1.8.4.rc1

