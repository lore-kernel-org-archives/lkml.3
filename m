Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab3CONqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:46:48 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:32433 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755228Ab3CONp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:45:59 -0400
From: Andreas Larsson <andreas@gaisler.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        software@gaisler.com
Subject: [PATCH v5 1/3] gpio: gpio-generic: Add 16 and 32 bit big endian byte order support
Date: Fri, 15 Mar 2013 14:45:38 +0100
Message-Id: <1363355140-28216-2-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363355140-28216-1-git-send-email-andreas@gaisler.com>
References: <1363355140-28216-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no general support for 64-bit big endian accesses, so that is
left unsupported.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 drivers/gpio/gpio-generic.c     |   56 ++++++++++++++++++++++++++++++++-------
 include/linux/basic_mmio_gpio.h |    1 +
 2 files changed, 48 insertions(+), 9 deletions(-)

diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
index 05fcc0f..42d4706 100644
--- a/drivers/gpio/gpio-generic.c
+++ b/drivers/gpio/gpio-generic.c
@@ -104,6 +104,26 @@ static unsigned long bgpio_read64(void __iomem *reg)
 }
 #endif /* BITS_PER_LONG >= 64 */
 
+static void bgpio_write16be(void __iomem *reg, unsigned long data)
+{
+	iowrite16be(data, reg);
+}
+
+static unsigned long bgpio_read16be(void __iomem *reg)
+{
+	return ioread16be(reg);
+}
+
+static void bgpio_write32be(void __iomem *reg, unsigned long data)
+{
+	iowrite32be(data, reg);
+}
+
+static unsigned long bgpio_read32be(void __iomem *reg)
+{
+	return ioread32be(reg);
+}
+
 static unsigned long bgpio_pin2mask(struct bgpio_chip *bgc, unsigned int pin)
 {
 	return 1 << pin;
@@ -249,7 +269,8 @@ static int bgpio_dir_out_inv(struct gpio_chip *gc, unsigned int gpio, int val)
 
 static int bgpio_setup_accessors(struct device *dev,
 				 struct bgpio_chip *bgc,
-				 bool be)
+				 bool bit_be,
+				 bool byte_be)
 {
 
 	switch (bgc->bits) {
@@ -258,17 +279,33 @@ static int bgpio_setup_accessors(struct device *dev,
 		bgc->write_reg	= bgpio_write8;
 		break;
 	case 16:
-		bgc->read_reg	= bgpio_read16;
-		bgc->write_reg	= bgpio_write16;
+		if (byte_be) {
+			bgc->read_reg	= bgpio_read16be;
+			bgc->write_reg	= bgpio_write16be;
+		} else {
+			bgc->read_reg	= bgpio_read16;
+			bgc->write_reg	= bgpio_write16;
+		}
 		break;
 	case 32:
-		bgc->read_reg	= bgpio_read32;
-		bgc->write_reg	= bgpio_write32;
+		if (byte_be) {
+			bgc->read_reg	= bgpio_read32be;
+			bgc->write_reg	= bgpio_write32be;
+		} else {
+			bgc->read_reg	= bgpio_read32;
+			bgc->write_reg	= bgpio_write32;
+		}
 		break;
 #if BITS_PER_LONG >= 64
 	case 64:
-		bgc->read_reg	= bgpio_read64;
-		bgc->write_reg	= bgpio_write64;
+		if (byte_be) {
+			dev_err(dev,
+				"64 bit big endian byte order unsupported\n");
+			return -EINVAL;
+		} else {
+			bgc->read_reg	= bgpio_read64;
+			bgc->write_reg	= bgpio_write64;
+		}
 		break;
 #endif /* BITS_PER_LONG >= 64 */
 	default:
@@ -276,7 +313,7 @@ static int bgpio_setup_accessors(struct device *dev,
 		return -EINVAL;
 	}
 
-	bgc->pin2mask = be ? bgpio_pin2mask_be : bgpio_pin2mask;
+	bgc->pin2mask = bit_be ? bgpio_pin2mask_be : bgpio_pin2mask;
 
 	return 0;
 }
@@ -385,7 +422,8 @@ int bgpio_init(struct bgpio_chip *bgc, struct device *dev,
 	if (ret)
 		return ret;
 
-	ret = bgpio_setup_accessors(dev, bgc, flags & BGPIOF_BIG_ENDIAN);
+	ret = bgpio_setup_accessors(dev, bgc, flags & BGPIOF_BIG_ENDIAN,
+				    flags & BGPIOF_BIG_ENDIAN_BYTE_ORDER);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/basic_mmio_gpio.h b/include/linux/basic_mmio_gpio.h
index 1c504ca..d8a97ec 100644
--- a/include/linux/basic_mmio_gpio.h
+++ b/include/linux/basic_mmio_gpio.h
@@ -72,5 +72,6 @@ int bgpio_init(struct bgpio_chip *bgc, struct device *dev,
 #define BGPIOF_BIG_ENDIAN		BIT(0)
 #define BGPIOF_UNREADABLE_REG_SET	BIT(1) /* reg_set is unreadable */
 #define BGPIOF_UNREADABLE_REG_DIR	BIT(2) /* reg_dir is unreadable */
+#define BGPIOF_BIG_ENDIAN_BYTE_ORDER	BIT(3)
 
 #endif /* __BASIC_MMIO_GPIO_H */
-- 
1.7.10.4

