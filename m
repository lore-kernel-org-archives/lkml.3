Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbaEKVgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 17:36:19 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:36588 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbaEKVgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 17:36:15 -0400
MIME-Version: 1.0
Date: Sun, 11 May 2014 17:36:14 -0400
Message-ID: <CA+3xLx4JYntsBZ-fnMqwLd4fjGqGpZWymfWqsj20swLx85w+OQ@mail.gmail.com>
Subject: [PATCH] pinctrl-baytrail, mmc/sdhci-acpi: Fix for Intel Baytrail-T
 mmc_pwr pin
From: Jon Pry <jonpry@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of this patch was probably written by Doug Johnson. He never
submitted it and I have removed spurious dependencies on moving
certain gpio chips to ACPI control.

----


Baytrail_T has errata regarding a non-functioning mmc_pwr pin. This
patch reconfigures
said pin as a GPIO and adds SDHCI quirks to support such functionality

Signed-off-by: Jon Pry <jonpry <at> gmail.com>
---
 drivers/mmc/host/sdhci-acpi.c      |    2 +-
 drivers/mmc/host/sdhci.c           |   30 ++++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci.h           |   11 ++++++-----
 drivers/pinctrl/pinctrl-baytrail.c |    9 ++++++---
 include/linux/mmc/sdhci.h          |    3 +++
 5 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/host/sdhci-acpi.c b/drivers/mmc/host/sdhci-acpi.c
index ebb3f39..ebed2a0 100644
--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -123,7 +123,7 @@ static const struct sdhci_acpi_slot
sdhci_acpi_slot_int_emmc = {

 static const struct sdhci_acpi_slot sdhci_acpi_slot_int_sdio = {
     .quirks  = SDHCI_QUIRK_BROKEN_CARD_DETECTION,
-    .quirks2 = SDHCI_QUIRK2_HOST_OFF_CARD_ON,
+    .quirks2 = SDHCI_QUIRK2_HOST_OFF_CARD_ON |
SDHCI_QUIRK2_BROKEN_POWER_ENABLE,
     .caps    = MMC_CAP_NONREMOVABLE | MMC_CAP_POWER_OFF_CARD,
     .flags   = SDHCI_ACPI_RUNTIME_PM,
     .pm_caps = MMC_PM_KEEP_POWER,
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 9a79fc4..7a06008 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -22,6 +22,7 @@
 #include <linux/scatterlist.h>
 #include <linux/regulator/consumer.h>
 #include <linux/pm_runtime.h>
+#include <linux/gpio.h>

 #include <linux/leds.h>

@@ -1261,6 +1262,10 @@ static inline void sdhci_update_clock(struct
sdhci_host *host)
     sdhci_set_clock(host, clock);
 }

+static inline void sdhci_set_power_quirk(unsigned short power) {
+    gpio_set_value(SDHCI_POWER_QUIRK_GPIO, power);
+}
+
 static int sdhci_set_power(struct sdhci_host *host, unsigned short power)
 {
     u8 pwr = 0;
@@ -1292,6 +1297,9 @@ static int sdhci_set_power(struct sdhci_host
*host, unsigned short power)
         sdhci_writeb(host, 0, SDHCI_POWER_CONTROL);
         if (host->quirks2 & SDHCI_QUIRK2_CARD_ON_NEEDS_BUS_ON)
             sdhci_runtime_pm_bus_off(host);
+        /* The intel Bay Trail SoCs need to assert a GPIO as a work around */
+        if (host->quirks2 & SDHCI_QUIRK2_BROKEN_POWER_ENABLE)
+            sdhci_set_power_quirk(0);
         return 0;
     }

@@ -1311,8 +1319,14 @@ static int sdhci_set_power(struct sdhci_host
*host, unsigned short power)

     pwr |= SDHCI_POWER_ON;

+
     sdhci_writeb(host, pwr, SDHCI_POWER_CONTROL);

+    /* The intel Bay Trail SoCs need to assert a GPIO as a work around */
+    if (host->quirks2 & SDHCI_QUIRK2_BROKEN_POWER_ENABLE)
+        sdhci_set_power_quirk(1);
+
+
     if (host->quirks2 & SDHCI_QUIRK2_CARD_ON_NEEDS_BUS_ON)
         sdhci_runtime_pm_bus_on(host);

@@ -2820,6 +2834,18 @@ int sdhci_add_host(struct sdhci_host *host)
         host->flags &= ~SDHCI_USE_SDMA;
     }

+    if ((host->quirks2 & SDHCI_QUIRK2_BROKEN_POWER_ENABLE)) {
+        printk("Using GPIO for power enable as it is marked broken\n");
+        if (gpio_request(SDHCI_POWER_QUIRK_GPIO, "SDIO_PWR_EN") < 0) {
+            printk("Unable to request GPIO. SDIO may be broken.");
+            host->quirks2 = host->quirks2 & ~SDHCI_QUIRK2_BROKEN_POWER_ENABLE;
+        }
+        else if (gpio_direction_output(SDHCI_POWER_QUIRK_GPIO, 0) < 0) {
+            printk("Unable to set GPIO direction. SDIO may be broken.");
+            host->quirks2 = host->quirks2 & ~SDHCI_QUIRK2_BROKEN_POWER_ENABLE;
+        }
+    }
+
     if ((host->version >= SDHCI_SPEC_200) &&
         (caps[0] & SDHCI_CAN_DO_ADMA2))
         host->flags |= SDHCI_USE_ADMA;
@@ -3325,6 +3351,10 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
     tasklet_kill(&host->card_tasklet);
     tasklet_kill(&host->finish_tasklet);

+    if (host->quirks2 & SDHCI_QUIRK2_BROKEN_POWER_ENABLE) {
+        gpio_free(SDHCI_POWER_QUIRK_GPIO);
+    }
+
     if (host->vmmc) {
         regulator_disable(host->vmmc);
         regulator_put(host->vmmc);
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 0a3ed01..027fcd1 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -84,11 +84,12 @@
 #define   SDHCI_CTRL_ADMA64    0x18
 #define   SDHCI_CTRL_8BITBUS    0x20

-#define SDHCI_POWER_CONTROL    0x29
-#define  SDHCI_POWER_ON        0x01
-#define  SDHCI_POWER_180    0x0A
-#define  SDHCI_POWER_300    0x0C
-#define  SDHCI_POWER_330    0x0E
+#define SDHCI_POWER_CONTROL        0x29
+#define  SDHCI_POWER_ON            0x01
+#define  SDHCI_POWER_180        0x0A
+#define  SDHCI_POWER_300        0x0C
+#define  SDHCI_POWER_330        0x0E
+#define SDHCI_POWER_QUIRK_GPIO 195 /*GPIO offset 41 of SCORE device
is SD3_PWR_EN*/

 #define SDHCI_BLOCK_GAP_CONTROL    0x2A

diff --git a/drivers/pinctrl/pinctrl-baytrail.c
b/drivers/pinctrl/pinctrl-baytrail.c
index 6e8301f..78060f0 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -151,9 +151,9 @@ static void __iomem *byt_gpio_reg(struct gpio_chip
*chip, unsigned offset,

 static bool is_special_pin(struct byt_gpio *vg, unsigned offset)
 {
-    /* SCORE pin 92-93 */
+    /* SCORE pin 92-93; 41 for SDIO pwr_en bug  */
     if (!strcmp(vg->range->name, BYT_SCORE_ACPI_UID) &&
-        offset >= 92 && offset <= 93)
+       ((offset >= 92 && offset <= 93) || (offset == 41)))
         return true;

     /* SUS pin 11-21 */
@@ -176,6 +176,10 @@ static int byt_gpio_request(struct gpio_chip
*chip, unsigned offset)
      * But, some pins may have func pin mux 001 represents
      * GPIO function. Only allow user to export pin with
      * func pin mux preset as GPIO function by BIOS/FW.
+     *
+     * We do make an exception, however, for pin 41 which
+     * is needed in order to power up the SDIO bus (as per
+     * the intel erratum)
      */
     value = readl(reg) & BYT_PIN_MUX;
     special = is_special_pin(vg, offset);
@@ -184,7 +188,6 @@ static int byt_gpio_request(struct gpio_chip
*chip, unsigned offset)
             "pin %u cannot be used as GPIO.\n", offset);
         return -EINVAL;
     }
-
     pm_runtime_get(&vg->pdev->dev);

     return 0;
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index 7be12b8..92cec16 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -102,6 +102,9 @@ struct sdhci_host {
 #define SDHCI_QUIRK2_BROKEN_HS200            (1<<6)
 /* Controller does not support DDR50 */
 #define SDHCI_QUIRK2_BROKEN_DDR50            (1<<7)
+/* Controller cannot initialize power (must use GPIO instead) */
+#define SDHCI_QUIRK2_BROKEN_POWER_ENABLE        (1<<8)
+

     int irq;        /* Device IRQ */
     void __iomem *ioaddr;    /* Mapped address */
-- 
1.7.10.4
