Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab3K2M0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:26:48 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:64540 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab3K2MT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:19:56 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org
Cc: linus.walleij@linaro.org, linux-mtd@lists.infradead.org,
        angus.clark@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v3 10/36] mtd: st_spi_fsm: Dynamically setup flash device based on JEDEC ID
Date: Fri, 29 Nov 2013 12:18:59 +0000
Message-Id: <1385727565-25794-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using previously added infrastructure we can now extract a device's JEDEC
ID, compare it to a list of known and supported devices and make assumptions
based on known characteristics of a given chip.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 26 +++++++++++++++++++++++++-
 drivers/mtd/devices/st_spi_fsm.h |  1 +
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 71b6188..ef177e5 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -140,6 +140,7 @@ static void stfsm_read_jedec(struct stfsm *fsm, uint8_t *const jedec)
 
 static struct flash_info * stfsm_jedec_probe(struct stfsm *fsm)
 {
+	struct flash_info	*info;
 	u16                     ext_jedec;
 	u32			jedec;
 	u8			id[5];
@@ -157,6 +158,15 @@ static struct flash_info * stfsm_jedec_probe(struct stfsm *fsm)
 	dev_dbg(fsm->dev, "JEDEC =  0x%08x [%02x %02x %02x %02x %02x]\n",
 		jedec, id[0], id[1], id[2], id[3], id[4]);
 
+	for (info = flash_types; info->name; info++) {
+		if (info->jedec_id == jedec) {
+			if (info->ext_id && info->ext_id != ext_jedec)
+				continue;
+			return info;
+		}
+	}
+	dev_err(fsm->dev, "Unrecognized JEDEC id %06x\n", jedec);
+
 	return NULL;
 }
 
@@ -251,6 +261,7 @@ static int stfsm_init(struct stfsm *fsm)
 static int stfsm_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
+	struct flash_info *info;
 	struct resource *res;
 	struct stfsm *fsm;
 	int ret;
@@ -297,7 +308,11 @@ static int stfsm_probe(struct platform_device *pdev)
 	}
 
 	/* Detect SPI FLASH device */
-	stfsm_jedec_probe(fsm);
+	info = stfsm_jedec_probe(fsm);
+	if (!info)
+		return -ENODEV;
+
+	fsm->info = info;
 
 	platform_set_drvdata(pdev, fsm);
 
@@ -306,6 +321,15 @@ static int stfsm_probe(struct platform_device *pdev)
 	fsm->mtd.writesize	= 4;
 	fsm->mtd.writebufsize	= fsm->mtd.writesize;
 	fsm->mtd.flags		= MTD_CAP_NORFLASH;
+	fsm->mtd.size		= info->sector_size * info->n_sectors;
+	fsm->mtd.erasesize	= info->sector_size;
+
+	dev_err(&pdev->dev,
+		"Found serial flash device: %s\n"
+		" size = %llx (%lldMiB) erasesize = 0x%08x (%uKiB)\n",
+		info->name,
+		(long long)fsm->mtd.size, (long long)(fsm->mtd.size >> 20),
+		fsm->mtd.erasesize, (fsm->mtd.erasesize >> 10));
 
 	return mtd_device_parse_register(&fsm->mtd, NULL, NULL, NULL, 0);
 }
diff --git a/drivers/mtd/devices/st_spi_fsm.h b/drivers/mtd/devices/st_spi_fsm.h
index fd1472e..0a6272c 100644
--- a/drivers/mtd/devices/st_spi_fsm.h
+++ b/drivers/mtd/devices/st_spi_fsm.h
@@ -235,6 +235,7 @@ struct stfsm {
 	struct resource		*region;
 	struct mtd_info		mtd;
 	struct mutex		lock;
+	struct flash_info 	*info;
 
 	uint32_t		fifo_dir_delay;
 };
-- 
1.8.3.2

