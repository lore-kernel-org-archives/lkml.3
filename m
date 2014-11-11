Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaKKLKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:10:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57601 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbaKKLKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 100/170] mtd: move support for struct flash_platform_data into m25p80
Date: Tue, 11 Nov 2014 11:07:39 +0000
Message-Id: <1415704129-12709-101-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>

commit 32f1b7c8352fd33d41bcec3cfb054ccdcfd40a42 upstream.

This "type" seems to be an extra hint for m25p80 about the flash. Some
archs register flash_platform_data with "name" set to "m25p80" and then
with a real flash name set in "type". It seems to be a trick specific
to the m25p80 so let's move it out of spi-nor.
Btw switch to the spi_nor_match_id instead of iterating spi_nor_ids.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mtd/devices/m25p80.c  | 22 ++++++++++++++++++++--
 drivers/mtd/spi-nor/spi-nor.c | 28 +---------------------------
 2 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index ed7e0a1bed3c..dcda6287228d 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -193,11 +193,14 @@ static int m25p_probe(struct spi_device *spi)
 {
 	struct mtd_part_parser_data	ppdata;
 	struct flash_platform_data	*data;
+	const struct spi_device_id *id = NULL;
 	struct m25p *flash;
 	struct spi_nor *nor;
 	enum read_mode mode = SPI_NOR_NORMAL;
 	int ret;
 
+	data = dev_get_platdata(&spi->dev);
+
 	flash = devm_kzalloc(&spi->dev, sizeof(*flash), GFP_KERNEL);
 	if (!flash)
 		return -ENOMEM;
@@ -223,11 +226,26 @@ static int m25p_probe(struct spi_device *spi)
 		mode = SPI_NOR_QUAD;
 	else if (spi->mode & SPI_RX_DUAL)
 		mode = SPI_NOR_DUAL;
-	ret = spi_nor_scan(nor, spi_get_device_id(spi), mode);
+
+	if (data && data->name)
+		flash->mtd.name = data->name;
+
+	/* For some (historical?) reason many platforms provide two different
+	 * names in flash_platform_data: "name" and "type". Quite often name is
+	 * set to "m25p80" and then "type" provides a real chip name.
+	 * If that's the case, respect "type" and ignore a "name".
+	 */
+	if (data && data->type)
+		id = spi_nor_match_id(data->type);
+
+	/* If we didn't get name from platform, simply use "modalias". */
+	if (!id)
+		id = spi_get_device_id(spi);
+
+	ret = spi_nor_scan(nor, id, mode);
 	if (ret)
 		return ret;
 
-	data = dev_get_platdata(&spi->dev);
 	ppdata.of_node = spi->dev.of_node;
 
 	return mtd_device_parse_register(&flash->mtd, NULL, &ppdata,
diff --git a/drivers/mtd/spi-nor/spi-nor.c b/drivers/mtd/spi-nor/spi-nor.c
index c713c8656710..ce80fc4f5f26 100644
--- a/drivers/mtd/spi-nor/spi-nor.c
+++ b/drivers/mtd/spi-nor/spi-nor.c
@@ -871,7 +871,6 @@ int spi_nor_scan(struct spi_nor *nor, const struct spi_device_id *id,
 			enum read_mode mode)
 {
 	struct flash_info		*info;
-	struct flash_platform_data	*data;
 	struct device *dev = nor->dev;
 	struct mtd_info *mtd = nor->mtd;
 	struct device_node *np = dev->of_node;
@@ -882,28 +881,6 @@ int spi_nor_scan(struct spi_nor *nor, const struct spi_device_id *id,
 	if (ret)
 		return ret;
 
-	/* Platform data helps sort out which chip type we have, as
-	 * well as how this board partitions it.  If we don't have
-	 * a chip ID, try the JEDEC id commands; they'll work for most
-	 * newer chips, even if we don't recognize the particular chip.
-	 */
-	data = dev_get_platdata(dev);
-	if (data && data->type) {
-		const struct spi_device_id *plat_id;
-
-		for (i = 0; i < ARRAY_SIZE(spi_nor_ids) - 1; i++) {
-			plat_id = &spi_nor_ids[i];
-			if (strcmp(data->type, plat_id->name))
-				continue;
-			break;
-		}
-
-		if (i < ARRAY_SIZE(spi_nor_ids) - 1)
-			id = plat_id;
-		else
-			dev_warn(dev, "unrecognized id %s\n", data->type);
-	}
-
 	info = (void *)id->driver_data;
 
 	if (info->jedec_id) {
@@ -941,11 +918,8 @@ int spi_nor_scan(struct spi_nor *nor, const struct spi_device_id *id,
 		write_sr(nor, 0);
 	}
 
-	if (data && data->name)
-		mtd->name = data->name;
-	else
+	if (!mtd->name)
 		mtd->name = dev_name(dev);
-
 	mtd->type = MTD_NORFLASH;
 	mtd->writesize = 1;
 	mtd->flags = MTD_CAP_NORFLASH;
-- 
2.1.0

