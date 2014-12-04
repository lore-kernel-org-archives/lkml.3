Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbaLDKXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:23:43 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:42725 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbaLDKW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:22:29 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org,
        Christophe Kerello <christophe.kerello@st.com>
Subject: [PATCH v2 RESEND 10/11] mtd: st_spi_fsm: Provide mask to obtain correct boot device pins
Date: Thu,  4 Dec 2014 10:21:51 +0000
Message-Id: <1417688512-7644-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417688512-7644-1-git-send-email-lee.jones@linaro.org>
References: <1417688512-7644-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christophe Kerello <christophe.kerello@st.com>

This patch adds a mask to be able to get the right boot device selection.

For example:
    for STiH415, value = SYSTEM_STATUS398[4:0]
    for STiH416, value = SYSTEM_STATUS2598[4:0]
    for STiH407, value = SYSTEM_STATUS5561[6:2]

Signed-off-by: Christophe Kerello <christophe.kerello@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 18f6f0b..f992f00 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -2123,6 +2123,7 @@ static void stfsm_fetch_platform_configs(struct platform_device *pdev)
 	struct regmap *regmap;
 	uint32_t boot_device_reg;
 	uint32_t boot_device_spi;
+	uint32_t boot_device_msk;
 	uint32_t boot_device;     /* Value we read from *boot_device_reg */
 	int ret;
 
@@ -2147,10 +2148,17 @@ static void stfsm_fetch_platform_configs(struct platform_device *pdev)
 	if (ret)
 		goto boot_device_fail;
 
+	/* Mask to apply on boot_device_reg */
+	ret = of_property_read_u32(np, "st,boot-device-msk", &boot_device_msk);
+	if (ret)
+		goto boot_device_fail;
+
 	ret = regmap_read(regmap, boot_device_reg, &boot_device);
 	if (ret)
 		goto boot_device_fail;
 
+	boot_device &= boot_device_msk;
+
 	if (boot_device != boot_device_spi)
 		fsm->booted_from_spi = false;
 
-- 
1.9.1

