Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab3K2MZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 07:25:52 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:34112 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab3K2MUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 07:20:05 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org
Cc: linus.walleij@linaro.org, linux-mtd@lists.infradead.org,
        angus.clark@st.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v3 15/36] mtd: st_spi_fsm: Fetch boot-device from mode pins
Date: Fri, 29 Nov 2013 12:19:04 +0000
Message-Id: <1385727565-25794-16-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's important for us to determine which device was used to boot from in
order to make some correct decisions surrounding Power Management. On
each of the platforms which support the FSM this is communicated via
a set of mode pins held in the system configuration area. This patch
determine the boot device and stores the result.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 41 ++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/devices/st_spi_fsm.h |  1 +
 2 files changed, 42 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index e04de62..bb642a1 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -14,7 +14,9 @@
  */
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/regmap.h>
 #include <linux/platform_device.h>
+#include <linux/mfd/syscon.h>
 #include <linux/mtd/mtd.h>
 #include <linux/sched.h>
 #include <linux/delay.h>
@@ -346,9 +348,48 @@ static void stfsm_fetch_platform_configs(struct platform_device *pdev)
 {
 	struct stfsm *fsm = platform_get_drvdata(pdev);
 	struct flash_info *info = fsm->info;
+	struct device_node *np = pdev->dev.of_node;
+	struct regmap *regmap;
+	uint32_t boot_device_reg;
+	uint32_t boot_device_spi;
+	uint32_t boot_device;     /* Value we read from *boot_device_reg */
+	int ret;
 
+	/* Booting from SPI NOR Flash is the default */
+	fsm->booted_from_spi = true;
+
+	/* Use device size to determine address width */
 	if (info->sector_size * info->n_sectors > 0xFFFFFF)
 		info->flags |= FLASH_FLAG_32BIT_ADDR;
+
+	regmap = syscon_regmap_lookup_by_phandle(np, "st,syscfg");
+	if (!IS_ERR(regmap)) {
+		ret = PTR_ERR(regmap);
+		goto boot_device_fail;
+	}
+
+	/* Where in the syscon the boot device information lives */
+	ret = of_property_read_u32(np, "boot-device-reg", &boot_device_reg);
+	if (ret)
+		goto boot_device_fail;
+
+	/* Boot device value when booted from SPI NOR */
+	ret = of_property_read_u32(np, "boot-device-spi", &boot_device_spi);
+	if (ret)
+		goto boot_device_fail;
+
+	ret = regmap_read(regmap, boot_device_reg, &boot_device);
+	if (ret)
+		goto boot_device_fail;
+
+	if (boot_device != boot_device_spi)
+		fsm->booted_from_spi = false;
+
+	return;
+
+boot_device_fail:
+	dev_warn(&pdev->dev,
+		 "failed to fetch boot device, assuming boot from SPI\n");
 }
 
 static int stfsm_probe(struct platform_device *pdev)
diff --git a/drivers/mtd/devices/st_spi_fsm.h b/drivers/mtd/devices/st_spi_fsm.h
index 6fafa07..a0eafa9 100644
--- a/drivers/mtd/devices/st_spi_fsm.h
+++ b/drivers/mtd/devices/st_spi_fsm.h
@@ -238,6 +238,7 @@ struct stfsm {
 	struct flash_info 	*info;
 
 	uint32_t		fifo_dir_delay;
+	bool			booted_from_spi;
 };
 
 struct stfsm_seq {
-- 
1.8.3.2

