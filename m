Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab3GEPvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 11:51:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50949 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360Ab3GEPvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 11:51:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: pxa: propagate errors from regulator_enable() to pxamci
Date: Fri, 5 Jul 2013 17:51:20 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-mmc@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307051751.20729.arnd@arndb.de>
X-Provags-ID: V02:K0:CPo5FIW6un8vi2/70KwrJrIS3HnfFHu82tXJRTm9Fos
 1WU5IQ39/+9mM+sNpStoo2mFcNbucQhzAn2VOVywbJMsrPe5Ik
 D1h+Ekwh50Nl1a9o15RVYgE7MpIdOgARnJsLBfeEajStdM03FI
 8Y+8mFmn/lPMsPRndqYg4lYBS9xVbIAnzXo1dR/1uYOGaGSugx
 lg6xlwaW80ok61UpMYjfrt+9PF/mwBvUujAhevcmbXLQvndBak
 XHqEYSNZK9R6xPJcPY89zJaJQXVP/Vyo3XPZD/LFUVIxcFwnMw
 xQaT9q4mSOdO48sW8g//3buocxsl6nuqMb6Vk1fo7LOeNrs0gK
 JcIW/vIoCSmK+VhHNUtY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The em_x270_mci_setpower() and em_x270_usb_hub_init() functions
call regulator_enable(), which may return an error that must
be checked.

This changes the em_x270_usb_hub_init() function to bail out
if it fails, and changes the pxamci_platform_data->setpower
callback so that the a failed em_x270_mci_setpower call
can be propagated by the pxamci driver into the mmc core.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Rapoport <mike@compulab.co.il>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Chris Ball <cjb@laptop.org>

diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
index f6726bb..f8062e4 100644
--- a/arch/arm/mach-pxa/em-x270.c
+++ b/arch/arm/mach-pxa/em-x270.c
@@ -477,16 +477,24 @@ static int em_x270_usb_hub_init(void)
 	/* USB Hub power-on and reset */
 	gpio_direction_output(usb_hub_reset, 1);
 	gpio_direction_output(GPIO9_USB_VBUS_EN, 0);
-	regulator_enable(em_x270_usb_ldo);
+	err = regulator_enable(em_x270_usb_ldo);
+	if (err)
+		goto err_free_rst_gpio;
+
 	gpio_set_value(usb_hub_reset, 0);
 	gpio_set_value(usb_hub_reset, 1);
 	regulator_disable(em_x270_usb_ldo);
-	regulator_enable(em_x270_usb_ldo);
+	if (err)
+		goto err_free_rst_gpio;
+
+	err = regulator_enable(em_x270_usb_ldo);
 	gpio_set_value(usb_hub_reset, 0);
 	gpio_set_value(GPIO9_USB_VBUS_EN, 1);
 
 	return 0;
 
+err_free_rst_gpio:
+	gpio_free(usb_hub_reset);
 err_free_vbus_gpio:
 	gpio_free(GPIO9_USB_VBUS_EN);
 err_free_usb_ldo:
@@ -592,7 +600,7 @@ err_irq:
 	return err;
 }
 
-static void em_x270_mci_setpower(struct device *dev, unsigned int vdd)
+static int em_x270_mci_setpower(struct device *dev, unsigned int vdd)
 {
 	struct pxamci_platform_data* p_d = dev->platform_data;
 
@@ -600,10 +608,11 @@ static void em_x270_mci_setpower(struct device *dev, unsigned int vdd)
 		int vdd_uV = (2000 + (vdd - __ffs(MMC_VDD_20_21)) * 100) * 1000;
 
 		regulator_set_voltage(em_x270_sdio_ldo, vdd_uV, vdd_uV);
-		regulator_enable(em_x270_sdio_ldo);
+		return regulator_enable(em_x270_sdio_ldo);
 	} else {
 		regulator_disable(em_x270_sdio_ldo);
 	}
+	return 0;
 }
 
 static void em_x270_mci_exit(struct device *dev, void *data)
diff --git a/arch/arm/mach-pxa/mainstone.c b/arch/arm/mach-pxa/mainstone.c
index d2c6523..dd70343 100644
--- a/arch/arm/mach-pxa/mainstone.c
+++ b/arch/arm/mach-pxa/mainstone.c
@@ -408,7 +408,7 @@ static int mainstone_mci_init(struct device *dev, irq_handler_t mstone_detect_in
 	return err;
 }
 
-static void mainstone_mci_setpower(struct device *dev, unsigned int vdd)
+static int mainstone_mci_setpower(struct device *dev, unsigned int vdd)
 {
 	struct pxamci_platform_data* p_d = dev->platform_data;
 
@@ -420,6 +420,7 @@ static void mainstone_mci_setpower(struct device *dev, unsigned int vdd)
 		printk(KERN_DEBUG "%s: off\n", __func__);
 		MST_MSCWR1 &= ~MST_MSCWR1_MMC_ON;
 	}
+	return 0;
 }
 
 static void mainstone_mci_exit(struct device *dev, void *data)
diff --git a/arch/arm/mach-pxa/pcm990-baseboard.c b/arch/arm/mach-pxa/pcm990-baseboard.c
index fb7f1d1..13e5b00 100644
--- a/arch/arm/mach-pxa/pcm990-baseboard.c
+++ b/arch/arm/mach-pxa/pcm990-baseboard.c
@@ -335,7 +335,7 @@ static int pcm990_mci_init(struct device *dev, irq_handler_t mci_detect_int,
 	return err;
 }
 
-static void pcm990_mci_setpower(struct device *dev, unsigned int vdd)
+static int pcm990_mci_setpower(struct device *dev, unsigned int vdd)
 {
 	struct pxamci_platform_data *p_d = dev->platform_data;
 	u8 val;
@@ -348,6 +348,7 @@ static void pcm990_mci_setpower(struct device *dev, unsigned int vdd)
 		val &= ~PCM990_CTRL_MMC2PWR;
 
 	pcm990_cpld_writeb(PCM990_CTRL_MMC2PWR, PCM990_CTRL_REG5);
+	return 0;
 }
 
 static void pcm990_mci_exit(struct device *dev, void *data)
diff --git a/arch/arm/mach-pxa/poodle.c b/arch/arm/mach-pxa/poodle.c
index 50ccd5f..cb374c2 100644
--- a/arch/arm/mach-pxa/poodle.c
+++ b/arch/arm/mach-pxa/poodle.c
@@ -258,7 +258,7 @@ err_free_2:
 	return err;
 }
 
-static void poodle_mci_setpower(struct device *dev, unsigned int vdd)
+static int poodle_mci_setpower(struct device *dev, unsigned int vdd)
 {
 	struct pxamci_platform_data* p_d = dev->platform_data;
 
@@ -270,6 +270,8 @@ static void poodle_mci_setpower(struct device *dev, unsigned int vdd)
 		gpio_set_value(POODLE_GPIO_SD_PWR1, 0);
 		gpio_set_value(POODLE_GPIO_SD_PWR, 0);
 	}
+
+	return 0;
 }
 
 static void poodle_mci_exit(struct device *dev, void *data)
diff --git a/arch/arm/mach-pxa/spitz.c b/arch/arm/mach-pxa/spitz.c
index 362726c..49bfcd7 100644
--- a/arch/arm/mach-pxa/spitz.c
+++ b/arch/arm/mach-pxa/spitz.c
@@ -597,7 +597,7 @@ static inline void spitz_spi_init(void) {}
  * NOTE: The card detect interrupt isn't debounced so we delay it by 250ms to
  * give the card a chance to fully insert/eject.
  */
-static void spitz_mci_setpower(struct device *dev, unsigned int vdd)
+static int spitz_mci_setpower(struct device *dev, unsigned int vdd)
 {
 	struct pxamci_platform_data* p_d = dev->platform_data;
 
@@ -605,6 +605,8 @@ static void spitz_mci_setpower(struct device *dev, unsigned int vdd)
 		spitz_card_pwr_ctrl(SCOOP_CPR_SD_3V, SCOOP_CPR_SD_3V);
 	else
 		spitz_card_pwr_ctrl(SCOOP_CPR_SD_3V, 0x0);
+
+	return 0;
 }
 
 static struct pxamci_platform_data spitz_mci_platform_data = {
diff --git a/arch/arm/mach-pxa/stargate2.c b/arch/arm/mach-pxa/stargate2.c
index 88fde43..62aea3e 100644
--- a/arch/arm/mach-pxa/stargate2.c
+++ b/arch/arm/mach-pxa/stargate2.c
@@ -734,9 +734,10 @@ static int stargate2_mci_init(struct device *dev,
  *
  * Very simple control. Either it is on or off and is controlled by
  * a gpio pin */
-static void stargate2_mci_setpower(struct device *dev, unsigned int vdd)
+static int stargate2_mci_setpower(struct device *dev, unsigned int vdd)
 {
 	gpio_set_value(SG2_SD_POWER_ENABLE, !!vdd);
+	return 0;
 }
 
 static void stargate2_mci_exit(struct device *dev, void *data)
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 2b2f65a..ad65170 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -128,7 +128,7 @@ static inline int pxamci_set_power(struct pxamci_host *host,
 			       !!on ^ host->pdata->gpio_power_invert);
 	}
 	if (!host->vcc && host->pdata && host->pdata->setpower)
-		host->pdata->setpower(mmc_dev(host->mmc), vdd);
+		return host->pdata->setpower(mmc_dev(host->mmc), vdd);
 
 	return 0;
 }
diff --git a/include/linux/platform_data/mmc-pxamci.h b/include/linux/platform_data/mmc-pxamci.h
index 9eb515b..1706b35 100644
--- a/include/linux/platform_data/mmc-pxamci.h
+++ b/include/linux/platform_data/mmc-pxamci.h
@@ -12,7 +12,7 @@ struct pxamci_platform_data {
 	unsigned long detect_delay_ms;		/* delay in millisecond before detecting cards after interrupt */
 	int (*init)(struct device *, irq_handler_t , void *);
 	int (*get_ro)(struct device *);
-	void (*setpower)(struct device *, unsigned int);
+	int (*setpower)(struct device *, unsigned int);
 	void (*exit)(struct device *, void *);
 	int gpio_card_detect;			/* gpio detecting card insertion */
 	int gpio_card_ro;			/* gpio detecting read only toggle */
