Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbaBRO4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:56:55 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:60663 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbaBRO4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:56:52 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, DCG_UPD_stlinux_kernel@list.st.com,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        computersforpeace@gmail.com, Angus.Clark@st.com
Subject: [PATCH 09/35] mtd: st_spi_fsm: Dynamically setup flash device based on JEDEC ID
Date: Tue, 18 Feb 2014 14:55:36 +0000
Message-Id: <1392735362-1245-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
References: <1392735362-1245-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using previously added infrastructure we can now extract a device's JEDEC
ID, compare it to a list of known and supported devices and make assumptions
based on known characteristics of a given chip.

Acked-by Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index bc5ed352..90fbd64 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -204,6 +204,7 @@ struct stfsm {
 	struct resource		*region;
 	struct mtd_info		mtd;
 	struct mutex		lock;
+	struct flash_info       *info;
 
 	uint32_t                fifo_dir_delay;
 };
@@ -477,6 +478,7 @@ static void stfsm_read_jedec(struct stfsm *fsm, uint8_t *const jedec)
 
 static struct flash_info *stfsm_jedec_probe(struct stfsm *fsm)
 {
+	struct flash_info	*info;
 	u16                     ext_jedec;
 	u32			jedec;
 	u8			id[5];
@@ -494,6 +496,15 @@ static struct flash_info *stfsm_jedec_probe(struct stfsm *fsm)
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
 
@@ -588,6 +599,7 @@ static int stfsm_init(struct stfsm *fsm)
 static int stfsm_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
+	struct flash_info *info;
 	struct resource *res;
 	struct stfsm *fsm;
 	int ret;
@@ -626,7 +638,10 @@ static int stfsm_probe(struct platform_device *pdev)
 	}
 
 	/* Detect SPI FLASH device */
-	stfsm_jedec_probe(fsm);
+	info = stfsm_jedec_probe(fsm);
+	if (!info)
+		return -ENODEV;
+	fsm->info = info;
 
 	platform_set_drvdata(pdev, fsm);
 
@@ -635,6 +650,15 @@ static int stfsm_probe(struct platform_device *pdev)
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
-- 
1.8.3.2

