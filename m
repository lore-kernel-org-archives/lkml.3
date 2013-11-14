Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab3KNOYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:24:49 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38225 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab3KNOXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:23:11 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, angus.clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/10] mtd: st_spi_fsm: Dynamically setup flash device based on JEDEC ID
Date: Thu, 14 Nov 2013 14:22:35 +0000
Message-Id: <1384438956-31153-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1384438956-31153-1-git-send-email-lee.jones@linaro.org>
References: <1384438956-31153-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using previously added infrastructure we can now extract a device's JEDEC
ID, compare it to a list of known and supported devices and make assumptions
based on known characteristics of a given chip.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 230024c..42dd4d9 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -357,6 +357,7 @@ static int stfsm_read_jedec(struct stfsm *fsm, uint8_t *const jedec)
 
 static struct flash_info * stfsm_jedec_probe(struct stfsm *fsm)
 {
+	struct flash_info	*info;
 	u16                     ext_jedec;
 	u32			jedec;
 	u8			id[5];
@@ -380,6 +381,15 @@ static struct flash_info * stfsm_jedec_probe(struct stfsm *fsm)
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
 
@@ -490,6 +500,7 @@ static int stfsm_init(struct stfsm *fsm)
 static int stfsm_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
+	struct flash_info *info;
 	struct resource *res;
 	struct stfsm *fsm;
 	int ret;
@@ -536,7 +547,9 @@ static int stfsm_probe(struct platform_device *pdev)
 	}
 
 	/* Detect SPI FLASH device */
-	stfsm_jedec_probe(fsm);
+	info = stfsm_jedec_probe(fsm);
+	if (!info)
+		return -ENODEV;
 
 	platform_set_drvdata(pdev, fsm);
 
@@ -545,6 +558,15 @@ static int stfsm_probe(struct platform_device *pdev)
 	fsm->mtd.writesize    = 4;
 	fsm->mtd.writebufsize = fsm->mtd.writesize;
 	fsm->mtd.flags        = MTD_CAP_NORFLASH;
+	fsm->mtd.size         = info->sector_size * info->n_sectors;
+	fsm->mtd.erasesize    = info->sector_size;
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
1.8.1.2

