Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296Ab3BGSSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:18:15 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:48452 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758789Ab3BGSSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:18:14 -0500
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>, Thomas Abraham <thomas.ab@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: dw_mmc: No bus setup if default pinctrl is used
Date: Fri,  8 Feb 2013 03:17:58 +0900
Message-Id: <1360261079-24361-1-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.10.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Legacy gpio based bus setup is failed when the bus pins are listed with the
property 'pinctrl-0' and 'pinctrl-names', instead of 'gpios'. The default
pinctrls are handled by device core before probe, no need to configure the
pins again in a device driver.

[    1.190000] Synopsys Designware Multimedia Card Interface Driver
[    1.195000] dwmmc_exynos 12550000.mshc: Using PIO mode.
[    1.200000] dwmmc_exynos 12550000.mshc: DW MMC controller at irq 109, 32 bit host data width, 128 deep fifo
[    1.210000] dwmmc_exynos 12550000.mshc: invalid gpio: -2
[    1.215000] dwmmc_exynos: probe of 12550000.mshc failed with error -22

Cc: Thomas Abraham <thomas.ab@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 drivers/mmc/host/dw_mmc-exynos.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
index aafd485..f568c32 100644
--- a/drivers/mmc/host/dw_mmc-exynos.c
+++ b/drivers/mmc/host/dw_mmc-exynos.c
@@ -156,12 +156,19 @@ static int dw_mci_exynos_setup_bus(struct dw_mci *host,
 				struct device_node *slot_np, u8 bus_width)
 {
 	int idx, gpio, ret;
+	int nr_pins = NUM_PINS(bus_width);
 
 	if (!slot_np)
 		return -EINVAL;
 
+#if defined(CONFIG_PINCTRL)
+	/* Default pinctrl is used */
+	if (!IS_ERR(host->dev->pins->default_state))
+		nr_pins = 0;
+#endif
+
 	/* cmd + clock + bus-width pins */
-	for (idx = 0; idx < NUM_PINS(bus_width); idx++) {
+	for (idx = 0; idx < nr_pins; idx++) {
 		gpio = of_get_gpio(slot_np, idx);
 		if (!gpio_is_valid(gpio)) {
 			dev_err(host->dev, "invalid gpio: %d\n", gpio);
-- 
1.7.10.4

