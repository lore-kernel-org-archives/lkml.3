Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab3JKMiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:38:22 -0400
Received: from briaree.onecert.fr ([134.212.190.4]:54321 "EHLO
	briaree.onecert.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab3JKMiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:38:18 -0400
From: Paul Chavent <Paul.Chavent@onera.fr>
To: nsekhar@ti.com, khilman@deeprootsystems.com, linux@arm.linux.org.uk,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Paul Chavent <Paul.Chavent@onera.fr>
Subject: [PATCH] ARM: davinci: usb: provide minimal support for da850. (v2)
Date: Fri, 11 Oct 2013 14:28:29 +0200
Message-Id: <1381494509-11676-1-git-send-email-paul.chavent@onera.fr>
X-Mailer: git-send-email 1.7.12.1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (briaree.onecert.fr [134.212.190.4]); Fri, 11 Oct 2013 14:35:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As for the da830 and hawk boards, the da850 can provide minimalist usb
1.1 implementation without enabling usb gadget and inventra HC.

This patch is inspired by the hawk board implementation.

Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
---
 arch/arm/mach-davinci/board-da850-evm.c | 135 ++++++++++++++++++++++++++++++++
 1 file changed, 135 insertions(+)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index dd1fb24..43fcab8 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -62,6 +62,9 @@
 
 #define DA850_MII_MDIO_CLKEN_PIN	GPIO_TO_PIN(2, 6)
 
+#define DA850_USB1_VBUS_PIN		GPIO_TO_PIN(2, 4)
+#define DA850_USB1_OC_PIN		GPIO_TO_PIN(6, 13)
+
 static struct mtd_partition da850evm_spiflash_part[] = {
 	[0] = {
 		.name = "UBL",
@@ -1431,6 +1434,137 @@ static __init int da850_wl12xx_init(void)
 
 #endif /* CONFIG_DA850_WL12XX */
 
+#ifdef CONFIG_USB
+
+static irqreturn_t da850_usb_ocic_irq(int irq, void *dev_id);
+static da8xx_ocic_handler_t da850_usb_ocic_handler;
+
+static const short da850_usb11_pins[] = {
+	DA850_GPIO2_4, DA850_GPIO6_13,
+	-1
+};
+
+static int da850_usb_set_power(unsigned port, int on)
+{
+	gpio_set_value(DA850_USB1_VBUS_PIN, on);
+	return 0;
+}
+
+static int da850_usb_get_power(unsigned port)
+{
+	return gpio_get_value(DA850_USB1_VBUS_PIN);
+}
+
+static int da850_usb_get_oci(unsigned port)
+{
+	return !gpio_get_value(DA850_USB1_OC_PIN);
+}
+
+static int da850_usb_ocic_notify(da8xx_ocic_handler_t handler)
+{
+	int irq         = gpio_to_irq(DA850_USB1_OC_PIN);
+	int error       = 0;
+
+	if (handler != NULL) {
+		da850_usb_ocic_handler = handler;
+
+		error = request_irq(irq, da850_usb_ocic_irq,
+					IRQF_DISABLED | IRQF_TRIGGER_RISING |
+					IRQF_TRIGGER_FALLING,
+					"OHCI over-current indicator", NULL);
+		if (error)
+			pr_err("%s: could not request IRQ to watch "
+				"over-current indicator changes\n", __func__);
+	} else {
+		free_irq(irq, NULL);
+	}
+	return error;
+}
+
+static struct da8xx_ohci_root_hub da850_usb11_pdata = {
+	.set_power      = da850_usb_set_power,
+	.get_power      = da850_usb_get_power,
+	.get_oci        = da850_usb_get_oci,
+	.ocic_notify    = da850_usb_ocic_notify,
+	/* TPS2087 switch @ 5V */
+	.potpgt         = (3 + 1) / 2,  /* 3 ms max */
+};
+
+static irqreturn_t da850_usb_ocic_irq(int irq, void *dev_id)
+{
+	da850_usb_ocic_handler(&da850_usb11_pdata, 1);
+	return IRQ_HANDLED;
+}
+
+static __init void da850_usb_init(void)
+{
+	void __iomem *cfg_chip2_base;
+	int ret;
+	u32 val;
+
+	/*
+	 * Set up USB clock/mode in the CFGCHIP2 register.
+	 * USB2.0 PHY reference clock is 24 MHz
+	 */
+
+	cfg_chip2_base = DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP2_REG);
+
+	val = readl(cfg_chip2_base);
+
+	val &= ~CFGCHIP2_REFFREQ;
+	val |=  CFGCHIP2_REFFREQ_24MHZ;
+
+	writel(val, cfg_chip2_base);
+
+	/*
+	 * Set up pin multiplexing
+	 */
+
+	ret = davinci_cfg_reg_list(da850_usb11_pins);
+	if (ret) {
+		pr_warn("%s: USB 1.1 PinMux setup failed: %d\n", __func__, ret);
+		return;
+	}
+
+	ret = gpio_request_one(DA850_USB1_VBUS_PIN,
+			GPIOF_DIR_OUT, "USB1 VBUS");
+	if (ret < 0) {
+		pr_err("%s: failed to request GPIO for USB 1.1 port "
+			"power control: %d\n", __func__, ret);
+		return;
+	}
+
+	ret = gpio_request_one(DA850_USB1_OC_PIN,
+			GPIOF_DIR_IN, "USB1 OC");
+	if (ret < 0) {
+		pr_err("%s: failed to request GPIO for USB 1.1 port "
+			"over-current indicator: %d\n", __func__, ret);
+		goto usb11_setup_oc_fail;
+	}
+
+	ret = da8xx_register_usb11(&da850_usb11_pdata);
+	if (ret) {
+		pr_warn("%s: USB 1.1 registration failed: %d\n", __func__, ret);
+		goto usb11_setup_fail;
+	}
+
+	return;
+
+usb11_setup_fail:
+	gpio_free(DA850_USB1_OC_PIN);
+usb11_setup_oc_fail:
+	gpio_free(DA850_USB1_VBUS_PIN);
+}
+
+#else /* CONFIG_USB */
+
+static __init void da850_usb_init(void)
+{
+	return 0;
+}
+
+#endif /* CONFIG_USB */
+
 #define DA850EVM_SATA_REFCLKPN_RATE	(100 * 1000 * 1000)
 
 static __init void da850_evm_init(void)
@@ -1453,6 +1587,7 @@ static __init void da850_evm_init(void)
 	if (ret)
 		pr_warn("%s: I2C0 registration failed: %d\n", __func__, ret);
 
+	da850_usb_init();
 
 	ret = da8xx_register_watchdog();
 	if (ret)
-- 
1.7.12.1

