Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbaIRI5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 04:57:34 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:55242 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754609AbaIRI5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 04:57:32 -0400
Message-ID: <1411030649.2017.7.camel@x220>
Subject: [PATCH] gpio: samsung: Remove remaining check for
 CONFIG_S5P_GPIO_DRVSTR
From: Paul Bolle <pebolle@tiscali.nl>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Tomasz Figa <tomasz.figa@gmail.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 18 Sep 2014 10:57:29 +0200
In-Reply-To: <201409041803.46098.arnd@arndb.de>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
	 <53C67783.4090407@samsung.com> <1409825317.5546.94.camel@x220>
	 <201409041803.46098.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Sep 2014 08:57:30.0566 (UTC) FILETIME=[942F9660:01CFD31E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-04 at 18:03 +0200, Arnd Bergmann wrote:
> On Thursday 04 September 2014, Paul Bolle wrote: 
> > That check for CONFIG_S5P_GPIO_DRVSTR is still present in v3.17-rc3 and
> > next-20140903. Should I submit the trivial patch to remove it (and the
> > dead code it hides)?
> 
> Yes, I think this one is an obvious candidate for removal.

Still there in v3.17-rc5 and next-20140918. So I submit yet another
trivial cleanup.

Done on top of next-20140918. Only tested by grepping the tree. Please
note that, obviously, nothing uses s5p_gpio_get_drvstr() or
s5p_gpio_set_drvstr().


Paul Bolle
-------->8--------
From: Paul Bolle <pebolle@tiscali.nl>

Commit d78c16ccde96 ("ARM: SAMSUNG: Remove remaining legacy code")
removed the Kconfig symbol S5P_GPIO_DRVSTR. It didn't remove one check
for the related macro. Remove that check and the dead code it hides.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/gpio/gpio-samsung.c | 50 ---------------------------------------------
 1 file changed, 50 deletions(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index 3810da47043f..7c288ba4dc87 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -1309,56 +1309,6 @@ samsung_gpio_pull_t s3c_gpio_getpull(unsigned int pin)
 }
 EXPORT_SYMBOL(s3c_gpio_getpull);
 
-#ifdef CONFIG_S5P_GPIO_DRVSTR
-s5p_gpio_drvstr_t s5p_gpio_get_drvstr(unsigned int pin)
-{
-	struct samsung_gpio_chip *chip = samsung_gpiolib_getchip(pin);
-	unsigned int off;
-	void __iomem *reg;
-	int shift;
-	u32 drvstr;
-
-	if (!chip)
-		return -EINVAL;
-
-	off = pin - chip->chip.base;
-	shift = off * 2;
-	reg = chip->base + 0x0C;
-
-	drvstr = __raw_readl(reg);
-	drvstr = drvstr >> shift;
-	drvstr &= 0x3;
-
-	return (__force s5p_gpio_drvstr_t)drvstr;
-}
-EXPORT_SYMBOL(s5p_gpio_get_drvstr);
-
-int s5p_gpio_set_drvstr(unsigned int pin, s5p_gpio_drvstr_t drvstr)
-{
-	struct samsung_gpio_chip *chip = samsung_gpiolib_getchip(pin);
-	unsigned int off;
-	void __iomem *reg;
-	int shift;
-	u32 tmp;
-
-	if (!chip)
-		return -EINVAL;
-
-	off = pin - chip->chip.base;
-	shift = off * 2;
-	reg = chip->base + 0x0C;
-
-	tmp = __raw_readl(reg);
-	tmp &= ~(0x3 << shift);
-	tmp |= drvstr << shift;
-
-	__raw_writel(tmp, reg);
-
-	return 0;
-}
-EXPORT_SYMBOL(s5p_gpio_set_drvstr);
-#endif	/* CONFIG_S5P_GPIO_DRVSTR */
-
 #ifdef CONFIG_PLAT_S3C24XX
 unsigned int s3c2410_modify_misccr(unsigned int clear, unsigned int change)
 {
-- 
1.9.3

