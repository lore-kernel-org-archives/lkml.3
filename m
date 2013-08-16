Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab3HPPwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:52:04 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34308 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3HPPwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:52:01 -0400
Date: Fri, 16 Aug 2013 08:51:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Michael Brunner <mibru@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chris Healy <chealy@imsco-us.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH] gpio: Fix bit masking in Kontron PLD GPIO driver
Message-ID: <20130816155156.GA6953@roeck-us.net>
References: <20130809173326.75aed3b6@mail.gmx.de>
 <CACRpkdYe9+Fb-YO4Mn885YtY_YiRWsG1U+sFXo-poThpDOL1dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYe9+Fb-YO4Mn885YtY_YiRWsG1U+sFXo-poThpDOL1dw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 05:09:04PM +0200, Linus Walleij wrote:
> On Fri, Aug 9, 2013 at 5:33 PM, Michael Brunner <mibru@gmx.de> wrote:
> 
> > This patch fixes the bit masking within the GPIO driver. The masking is
> > basically done twice which causes the wrong GPIOs to be addressed.
> >
> > Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
> 
> This looks good but just doesn't apply. Look:
> 
> git am --signoff brunner2.patch
> Tillämpar: gpio: Fix bit masking in Kontron PLD GPIO driver
> error: patch misslyckades: drivers/gpio/gpio-kempld.c:46
> error: drivers/gpio/gpio-kempld.c: patchen kan inte tillämpas
> 
> Then:
> patch -p1 < brunner2.patch
> patching file drivers/gpio/gpio-kempld.c
> Hunk #1 FAILED at 46.
> Hunk #2 FAILED at 60.
> Hunk #3 FAILED at 69.
> Hunk #4 FAILED at 80.
> Hunk #5 FAILED at 92.
> Hunk #6 FAILED at 107.
> Hunk #7 FAILED at 122.
> 7 out of 7 hunks FAILED -- saving rejects to file drivers/gpio/gpio-kempld.c.rej
> 
> I think there may be some whitespace mangling in your client
> or mail server or whatever.
> 
> I had the same problem with the previous patch but hand-coded it
> right since it was just a oneline.
> 
> Please try to figure out what is causing this.
> Consult:
> Documentation/email-clients.txt
> 
I think Michael just went on vacation.

Clean version is below. He must have sent it to me separately
because it worked for me.

Guenter

---
From: Brunner Michael <Michael.Brunner@kontron.com>
Date: Wed, 31 Jul 2013 20:55:39 +0200
Subject: [PATCH] gpio: Fix bit masking in Kontron PLD GPIO driver

This patch fixes the bit masking within the GPIO driver. The masking is
basically done twice which causes the wrong GPIOs to be addressed.

Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/gpio/gpio-kempld.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/gpio/gpio-kempld.c b/drivers/gpio/gpio-kempld.c
index d3ed563..6118b66 100644
--- a/drivers/gpio/gpio-kempld.c
+++ b/drivers/gpio/gpio-kempld.c
@@ -46,9 +46,9 @@ static void kempld_gpio_bitop(struct kempld_device_data *pld,
 
 	status = kempld_read8(pld, reg);
 	if (val)
-		status |= (1 << bit);
+		status |= KEMPLD_GPIO_MASK(bit);
 	else
-		status &= ~(1 << bit);
+		status &= ~KEMPLD_GPIO_MASK(bit);
 	kempld_write8(pld, reg, status);
 }
 
@@ -60,7 +60,7 @@ static int kempld_gpio_get_bit(struct kempld_device_data *pld, u8 reg, u8 bit)
 	status = kempld_read8(pld, reg);
 	kempld_release_mutex(pld);
 
-	return !!(status & (1 << bit));
+	return !!(status & KEMPLD_GPIO_MASK(bit));
 }
 
 static int kempld_gpio_get(struct gpio_chip *chip, unsigned offset)
@@ -69,8 +69,7 @@ static int kempld_gpio_get(struct gpio_chip *chip, unsigned offset)
 		= container_of(chip, struct kempld_gpio_data, chip);
 	struct kempld_device_data *pld = gpio->pld;
 
-	return kempld_gpio_get_bit(pld, KEMPLD_GPIO_LVL_NUM(offset),
-				   KEMPLD_GPIO_MASK(offset));
+	return kempld_gpio_get_bit(pld, KEMPLD_GPIO_LVL_NUM(offset), offset);
 }
 
 static void kempld_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
@@ -80,8 +79,7 @@ static void kempld_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 	struct kempld_device_data *pld = gpio->pld;
 
 	kempld_get_mutex(pld);
-	kempld_gpio_bitop(pld, KEMPLD_GPIO_LVL_NUM(offset),
-			  KEMPLD_GPIO_MASK(offset), value);
+	kempld_gpio_bitop(pld, KEMPLD_GPIO_LVL_NUM(offset), offset, value);
 	kempld_release_mutex(pld);
 }
 
@@ -92,8 +90,7 @@ static int kempld_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 	struct kempld_device_data *pld = gpio->pld;
 
 	kempld_get_mutex(pld);
-	kempld_gpio_bitop(pld, KEMPLD_GPIO_DIR_NUM(offset),
-			  KEMPLD_GPIO_MASK(offset), 0);
+	kempld_gpio_bitop(pld, KEMPLD_GPIO_DIR_NUM(offset), offset, 0);
 	kempld_release_mutex(pld);
 
 	return 0;
@@ -107,10 +104,8 @@ static int kempld_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
 	struct kempld_device_data *pld = gpio->pld;
 
 	kempld_get_mutex(pld);
-	kempld_gpio_bitop(pld, KEMPLD_GPIO_LVL_NUM(offset),
-			  KEMPLD_GPIO_MASK(offset), value);
-	kempld_gpio_bitop(pld, KEMPLD_GPIO_DIR_NUM(offset),
-			  KEMPLD_GPIO_MASK(offset), 1);
+	kempld_gpio_bitop(pld, KEMPLD_GPIO_LVL_NUM(offset), offset, value);
+	kempld_gpio_bitop(pld, KEMPLD_GPIO_DIR_NUM(offset), offset, 1);
 	kempld_release_mutex(pld);
 
 	return 0;
@@ -122,8 +117,7 @@ static int kempld_gpio_get_direction(struct gpio_chip *chip, unsigned offset)
 		= container_of(chip, struct kempld_gpio_data, chip);
 	struct kempld_device_data *pld = gpio->pld;
 
-	return kempld_gpio_get_bit(pld, KEMPLD_GPIO_DIR_NUM(offset),
-				   KEMPLD_GPIO_MASK(offset));
+	return kempld_gpio_get_bit(pld, KEMPLD_GPIO_DIR_NUM(offset), offset);
 }
 
 static int kempld_gpio_pincount(struct kempld_device_data *pld)
-- 
1.7.9.7

