Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaA3Tcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:32:39 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43620 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbaA3Tci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:32:38 -0500
Date: Thu, 30 Jan 2014 13:29:25 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC] Remove ARM-specific set_irq_flags usage from irqdomain
 implementations
Message-ID: <20140130192925.GG20228@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all-

Looking through a bunch of irqdomain implementations (and in some other
places), it appears that the following pattern is distressingly common:

	static int foo_map(struct irq_domain *d, unsigned int irq,
			   irq_hw_number_t hw)
	{
		/*...*/
	#ifdef CONFIG_ARM
		set_irq_flags(irq, IRQF_VALID);
	#else
		irq_set_noprobe(irq);
	#endif
		return 0;
	}

Which, to someone unfamiliar with how ARM's set_irq_flags() (and ARM's
ARCH_IRQ_INIT_FLAGS), is just confusing and ugly[1].

I think there is an opportunity for some simplification here, based on
the following assumptions[2]:

  1. The irqdomain core already manages the IRQ_NOREQUEST bit, clearing
     it after creating a association, and setting it on disassociation
  2. No existing irqdomain implementations are relying on
     set_irq_flags() to clear the IRQ_NOAUTOEN bit

If these two assumptions hold, then the following simplification can
take place[3]:

-#if CONFIG_ARM
-	set_irq_flags(irq, IRQF_VALID);
-#else
 	irq_set_noprobe(irq);
-#endif

The first assumption fairly clearly holds, looking at the irqdomain
core.  I'm confident that the fact that IRQF_NOAUTOEN is not in
ARCH_IRQ_INIT_FLAGS and that no existing IRQF_NOAUTOEN users appear to
muck with irqdomains that it's a safe bet.  And...any code relying
AUTOEN to be cleared would currently be broken on non-ARM platforms.

Thoughts?  If this is a worthwhile simplification and my analysis is
sane, I'll cook up the proper patches.

Thanks,
  Josh

[1]: git grep 'kill me now'
[2]: For reference, here's a truth table establishing the mapping between
     ARM's IRQF_{VALID,PROBE,NOAUTOEN} flags and the generic flags:

                      V P NA | NR NP NA
                      0 0 0  |  1 1  0
   ARM-specific       0 0 1  |  1 1  1    genirq irqflag
    irqflags          0 1 0  |  1 0  0      definitions
  V  - IRQF_VALID     0 1 1  |  1 0  1    NR - IRQ_NOREQUEST
  P  - IRQF_PROBE     1 0 0  |  0 1  0    NP - IRQ_NOPROBE
  NA - IRQF_NOAUTOEN  1 0 1  |  0 1  1    NA - IRQ_NOAUTOEN
                      1 1 0  |  0 0  0
                      1 1 1  |  0 0  1

[3]: With the same justifications, on unmap:
-#if CONFIG_ARM
-	set_irq_flags(irq, 0);
-#endif

 ---
 drivers/base/regmap/regmap-irq.c |  8 --------
 drivers/gpio/gpio-adnp.c         |  6 ------
 drivers/gpio/gpio-bcm-kona.c     |  5 -----
 drivers/gpio/gpio-grgpio.c       |  8 --------
 drivers/gpio/gpio-pca953x.c      |  5 -----
 drivers/gpio/gpio-pcf857x.c      |  4 ----
 drivers/gpio/gpio-stmpe.c        |  8 --------
 drivers/gpio/gpio-tc3589x.c      |  8 --------
 drivers/mfd/88pm860x-core.c      |  4 ----
 drivers/mfd/ab8500-core.c        |  5 -----
 drivers/mfd/arizona-irq.c        |  8 --------
 drivers/mfd/lp8788-irq.c         |  6 ------
 drivers/mfd/max77686-irq.c       |  4 ----
 drivers/mfd/max77693-irq.c       |  4 ----
 drivers/mfd/max8925-core.c       |  4 ----
 drivers/mfd/max8997-irq.c        |  4 ----
 drivers/mfd/max8998-irq.c        |  4 ----
 drivers/mfd/stmpe.c              |  8 --------
 drivers/mfd/tc3589x.c            |  8 --------
 drivers/mfd/tps6586x.c           |  8 --------
 drivers/mfd/twl6030-irq.c        | 14 --------------
 drivers/mfd/wm831x-irq.c         |  8 --------
 drivers/mfd/wm8994-irq.c         |  8 --------
 drivers/pinctrl/pinctrl-single.c |  4 ----
 24 files changed, 153 deletions(-)
diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 763c60d..cd3add8 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -306,15 +306,7 @@ static int regmap_irq_map(struct irq_domain *h, unsigned int virq,
 	irq_set_chip_data(virq, data);
 	irq_set_chip(virq, &data->irq_chip);
 	irq_set_nested_thread(virq, 1);
-
-	/* ARM needs us to explicitly flag the IRQ as valid
-	 * and will set them noprobe when we do so. */
-#ifdef CONFIG_ARM
-	set_irq_flags(virq, IRQF_VALID);
-#else
 	irq_set_noprobe(virq);
-#endif
-
 	return 0;
 }
 
diff --git a/drivers/gpio/gpio-adnp.c b/drivers/gpio/gpio-adnp.c
index b204033..d34f41d 100644
--- a/drivers/gpio/gpio-adnp.c
+++ b/drivers/gpio/gpio-adnp.c
@@ -423,13 +423,7 @@ static int adnp_irq_map(struct irq_domain *domain, unsigned int irq,
 	irq_set_chip_data(irq, domain->host_data);
 	irq_set_chip(irq, &adnp_irq_chip);
 	irq_set_nested_thread(irq, true);
-
-#ifdef CONFIG_ARM
-	set_irq_flags(irq, IRQF_VALID);
-#else
 	irq_set_noprobe(irq);
-#endif
-
 	return 0;
 }
 
diff --git a/drivers/gpio/gpio-bcm-kona.c b/drivers/gpio/gpio-bcm-kona.c
index 54c18c2..61dff06 100644
--- a/drivers/gpio/gpio-bcm-kona.c
+++ b/drivers/gpio/gpio-bcm-kona.c
@@ -480,12 +480,7 @@ static int bcm_kona_gpio_irq_map(struct irq_domain *d, unsigned int irq,
 		return ret;
 	irq_set_lockdep_class(irq, &gpio_lock_class);
 	irq_set_chip_and_handler(irq, &bcm_gpio_irq_chip, handle_simple_irq);
-#ifdef CONFIG_ARM
-	set_irq_flags(irq, IRQF_VALID);
-#else
 	irq_set_noprobe(irq);
-#endif
-
 	return 0;
 }
 
diff --git a/drivers/gpio/gpio-grgpio.c b/drivers/gpio/gpio-grgpio.c
index 84d2478..3f5496e 100644
--- a/drivers/gpio/gpio-grgpio.c
+++ b/drivers/gpio/gpio-grgpio.c
@@ -282,12 +282,7 @@ static int grgpio_irq_map(struct irq_domain *d, unsigned int irq,
 	irq_set_chip_and_handler(irq, &grgpio_irq_chip,
 				 handle_simple_irq);
 	irq_clear_status_flags(irq, IRQ_NOREQUEST);
-#ifdef CONFIG_ARM
-	set_irq_flags(irq, IRQF_VALID);
-#else
 	irq_set_noprobe(irq);
-#endif
-
 	return ret;
 }
 
@@ -301,9 +296,6 @@ static void grgpio_irq_unmap(struct irq_domain *d, unsigned int irq)
 	int ngpio = priv->bgc.gc.ngpio;
 	int i;
 
-#ifdef CONFIG_ARM
-	set_irq_flags(irq, 0);
-#endif
 	irq_set_chip_and_handler(irq, NULL, NULL);
 	irq_set_chip_data(irq, NULL);
 
diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 6e48c07..05cbfa2 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -525,12 +525,7 @@ static int pca953x_gpio_irq_map(struct irq_domain *d, unsigned int irq,
 	irq_set_chip_data(irq, d->host_data);
 	irq_set_chip(irq, &pca953x_irq_chip);
 	irq_set_nested_thread(irq, true);
-#ifdef CONFIG_ARM
-	set_irq_flags(irq, IRQF_VALID);
-#else
 	irq_set_noprobe(irq);
-#endif
-
 	return 0;
 }
 
diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
index 1535686..5b3ab60 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -226,11 +226,7 @@ static int pcf857x_irq_domain_map(struct irq_domain *domain, unsigned int irq,
 	irq_set_chip_and_handler(irq,
 				 &dummy_irq_chip,
 				 handle_level_irq);
-#ifdef CONFIG_ARM
-	set_irq_flags(irq, IRQF_VALID);
-#else
 	irq_set_noprobe(irq);
-#endif
 	gpio->irq_mapped |= (1 << hw);
 
 	return 0;
diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
index 2647e24..dd661a99 100644
--- a/drivers/gpio/gpio-stmpe.c
+++ b/drivers/gpio/gpio-stmpe.c
@@ -284,20 +284,12 @@ static int stmpe_gpio_irq_map(struct irq_domain *d, unsigned int irq,
 	irq_set_chip_and_handler(irq, &stmpe_gpio_irq_chip,
 				 handle_simple_irq);
 	irq_set_nested_thread(irq, 1);
-#ifdef CONFIG_ARM
-	set_irq_flags(irq, IRQF_VALID);
-#else
 	irq_set_noprobe(irq);
-#endif
-
 	return 0;
 }
 
 static void stmpe_gpio_irq_unmap(struct irq_domain *d, unsigned int irq)
 {
-#ifdef CONFIG_ARM
-	set_irq_flags(irq, 0);
-#endif
 	irq_set_chip_and_handler(irq, NULL, NULL);
 	irq_set_chip_data(irq, NULL);
 }
diff --git a/drivers/gpio/gpio-tc3589x.c b/drivers/gpio/gpio-tc3589x.c
index ddb5fef..e5402f7 100644
--- a/drivers/gpio/gpio-tc3589x.c
+++ b/drivers/gpio/gpio-tc3589x.c
@@ -263,20 +263,12 @@ static int tc3589x_gpio_irq_map(struct irq_domain *d, unsigned int irq,
 	irq_set_chip_and_handler(irq, &tc3589x_gpio_irq_chip,
 				handle_simple_irq);
 	irq_set_nested_thread(irq, 1);
-#ifdef CONFIG_ARM
-	set_irq_flags(irq, IRQF_VALID);
-#else
 	irq_set_noprobe(irq);
-#endif
-
 	return 0;
 }
 
 static void tc3589x_gpio_irq_unmap(struct irq_domain *d, unsigned int irq)
 {
-#ifdef CONFIG_ARM
-	set_irq_flags(irq, 0);
-#endif
 	irq_set_chip_and_handler(irq, NULL, NULL);
 	irq_set_chip_data(irq, NULL);
 }
diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index c9b1f64..49d29ab 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -552,11 +552,7 @@ static int pm860x_irq_domain_map(struct irq_domain *d, unsigned int virq,
 	irq_set_chip_data(virq, d->host_data);
 	irq_set_chip_and_handler(virq, &pm860x_irq_chip, handle_edge_irq);
 	irq_set_nested_thread(virq, 1);
-#ifdef CONFIG_ARM
-	set_irq_flags(virq, IRQF_VALID);
-#else
 	irq_set_noprobe(virq);
-#endif
 	return 0;
 }
 
diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index b6c2cdc..f6b2b1e 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -563,12 +563,7 @@ static int ab8500_irq_map(struct irq_domain *d, unsigned int virq,
 	irq_set_chip_and_handler(virq, &ab8500_irq_chip,
 				handle_simple_irq);
 	irq_set_nested_thread(virq, 1);
-#ifdef CONFIG_ARM
-	set_irq_flags(virq, IRQF_VALID);
-#else
 	irq_set_noprobe(virq);
-#endif
-
 	return 0;
 }
 
diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index 88758ab..31e9c20 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -166,15 +166,7 @@ static int arizona_irq_map(struct irq_domain *h, unsigned int virq,
 	irq_set_chip_data(virq, data);
 	irq_set_chip_and_handler(virq, &arizona_irq_chip, handle_edge_irq);
 	irq_set_nested_thread(virq, 1);
-
-	/* ARM needs us to explicitly flag the IRQ as valid
-	 * and will set them noprobe when we do so. */
-#ifdef CONFIG_ARM
-	set_irq_flags(virq, IRQF_VALID);
-#else
 	irq_set_noprobe(virq);
-#endif
-
 	return 0;
 }
 
diff --git a/drivers/mfd/lp8788-irq.c b/drivers/mfd/lp8788-irq.c
index c84ded5..26b25ec 100644
--- a/drivers/mfd/lp8788-irq.c
+++ b/drivers/mfd/lp8788-irq.c
@@ -139,13 +139,7 @@ static int lp8788_irq_map(struct irq_domain *d, unsigned int virq,
 	irq_set_chip_data(virq, irqd);
 	irq_set_chip_and_handler(virq, chip, handle_edge_irq);
 	irq_set_nested_thread(virq, 1);
-
-#ifdef CONFIG_ARM
-	set_irq_flags(virq, IRQF_VALID);
-#else
 	irq_set_noprobe(virq);
-#endif
-
 	return 0;
 }
 
diff --git a/drivers/mfd/max77686-irq.c b/drivers/mfd/max77686-irq.c
index cdc3280..12fbbcb 100644
--- a/drivers/mfd/max77686-irq.c
+++ b/drivers/mfd/max77686-irq.c
@@ -230,11 +230,7 @@ static int max77686_irq_domain_map(struct irq_domain *d, unsigned int irq,
 	irq_set_chip_data(irq, max77686);
 	irq_set_chip_and_handler(irq, &max77686_irq_chip, handle_edge_irq);
 	irq_set_nested_thread(irq, 1);
-#ifdef CONFIG_ARM
-	set_irq_flags(irq, IRQF_VALID);
-#else
 	irq_set_noprobe(irq);
-#endif
 	return 0;
 }
 
diff --git a/drivers/mfd/max77693-irq.c b/drivers/mfd/max77693-irq.c
index 66b58fe..8c9c9e8 100644
--- a/drivers/mfd/max77693-irq.c
+++ b/drivers/mfd/max77693-irq.c
@@ -246,11 +246,7 @@ static int max77693_irq_domain_map(struct irq_domain *d, unsigned int irq,
 	irq_set_chip_data(irq, max77693);
 	irq_set_chip_and_handler(irq, &max77693_irq_chip, handle_edge_irq);
 	irq_set_nested_thread(irq, 1);
-#ifdef CONFIG_ARM
-	set_irq_flags(irq, IRQF_VALID);
-#else
 	irq_set_noprobe(irq);
-#endif
 	return 0;
 }
 
diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
index f0cc402..f1d9b1e 100644
--- a/drivers/mfd/max8925-core.c
+++ b/drivers/mfd/max8925-core.c
@@ -648,11 +648,7 @@ static int max8925_irq_domain_map(struct irq_domain *d, unsigned int virq,
 	irq_set_chip_data(virq, d->host_data);
 	irq_set_chip_and_handler(virq, &max8925_irq_chip, handle_edge_irq);
 	irq_set_nested_thread(virq, 1);
-#ifdef CONFIG_ARM
-	set_irq_flags(virq, IRQF_VALID);
-#else
 	irq_set_noprobe(virq);
-#endif
 	return 0;
 }
 
diff --git a/drivers/mfd/max8997-irq.c b/drivers/mfd/max8997-irq.c
index 43fa614..9425f80 100644
--- a/drivers/mfd/max8997-irq.c
+++ b/drivers/mfd/max8997-irq.c
@@ -295,11 +295,7 @@ static int max8997_irq_domain_map(struct irq_domain *d, unsigned int irq,
 	irq_set_chip_data(irq, max8997);
 	irq_set_chip_and_handler(irq, &max8997_irq_chip, handle_edge_irq);
 	irq_set_nested_thread(irq, 1);
-#ifdef CONFIG_ARM
-	set_irq_flags(irq, IRQF_VALID);
-#else
 	irq_set_noprobe(irq);
-#endif
 	return 0;
 }
 
diff --git a/drivers/mfd/max8998-irq.c b/drivers/mfd/max8998-irq.c
index c469477..ef74d2a 100644
--- a/drivers/mfd/max8998-irq.c
+++ b/drivers/mfd/max8998-irq.c
@@ -206,11 +206,7 @@ static int max8998_irq_domain_map(struct irq_domain *d, unsigned int irq,
 	irq_set_chip_data(irq, max8998);
 	irq_set_chip_and_handler(irq, &max8998_irq_chip, handle_edge_irq);
 	irq_set_nested_thread(irq, 1);
-#ifdef CONFIG_ARM
-	set_irq_flags(irq, IRQF_VALID);
-#else
 	irq_set_noprobe(irq);
-#endif
 	return 0;
 }
 
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index fff63a4..e65d36e 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -957,20 +957,12 @@ static int stmpe_irq_map(struct irq_domain *d, unsigned int virq,
 	irq_set_chip_data(virq, stmpe);
 	irq_set_chip_and_handler(virq, chip, handle_edge_irq);
 	irq_set_nested_thread(virq, 1);
-#ifdef CONFIG_ARM
-	set_irq_flags(virq, IRQF_VALID);
-#else
 	irq_set_noprobe(virq);
-#endif
-
 	return 0;
 }
 
 static void stmpe_irq_unmap(struct irq_domain *d, unsigned int virq)
 {
-#ifdef CONFIG_ARM
-		set_irq_flags(virq, 0);
-#endif
 		irq_set_chip_and_handler(virq, NULL, NULL);
 		irq_set_chip_data(virq, NULL);
 }
diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index 87ea51d..a1e8d7b 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -213,20 +213,12 @@ static int tc3589x_irq_map(struct irq_domain *d, unsigned int virq,
 	irq_set_chip_and_handler(virq, &dummy_irq_chip,
 				handle_edge_irq);
 	irq_set_nested_thread(virq, 1);
-#ifdef CONFIG_ARM
-	set_irq_flags(virq, IRQF_VALID);
-#else
 	irq_set_noprobe(virq);
-#endif
-
 	return 0;
 }
 
 static void tc3589x_irq_unmap(struct irq_domain *d, unsigned int virq)
 {
-#ifdef CONFIG_ARM
-	set_irq_flags(virq, 0);
-#endif
 	irq_set_chip_and_handler(virq, NULL, NULL);
 	irq_set_chip_data(virq, NULL);
 }
diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index ee61fd7..5d46fea 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -290,15 +290,7 @@ static int tps6586x_irq_map(struct irq_domain *h, unsigned int virq,
 	irq_set_chip_data(virq, tps6586x);
 	irq_set_chip_and_handler(virq, &tps6586x_irq_chip, handle_simple_irq);
 	irq_set_nested_thread(virq, 1);
-
-	/* ARM needs us to explicitly flag the IRQ as valid
-	 * and will set them noprobe when we do so. */
-#ifdef CONFIG_ARM
-	set_irq_flags(virq, IRQF_VALID);
-#else
 	irq_set_noprobe(virq);
-#endif
-
 	return 0;
 }
 
diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
index 517eda8..b355c20 100644
--- a/drivers/mfd/twl6030-irq.c
+++ b/drivers/mfd/twl6030-irq.c
@@ -349,26 +349,12 @@ static int twl6030_irq_map(struct irq_domain *d, unsigned int virq,
 	irq_set_chip_and_handler(virq,  &pdata->irq_chip, handle_simple_irq);
 	irq_set_nested_thread(virq, true);
 	irq_set_parent(virq, pdata->twl_irq);
-
-#ifdef CONFIG_ARM
-	/*
-	 * ARM requires an extra step to clear IRQ_NOREQUEST, which it
-	 * sets on behalf of every irq_chip.  Also sets IRQ_NOPROBE.
-	 */
-	set_irq_flags(virq, IRQF_VALID);
-#else
-	/* same effect on other architectures */
 	irq_set_noprobe(virq);
-#endif
-
 	return 0;
 }
 
 static void twl6030_irq_unmap(struct irq_domain *d, unsigned int virq)
 {
-#ifdef CONFIG_ARM
-	set_irq_flags(virq, 0);
-#endif
 	irq_set_chip_and_handler(virq, NULL, NULL);
 	irq_set_chip_data(virq, NULL);
 }
diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index 64e512e..bd7635e 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -552,15 +552,7 @@ static int wm831x_irq_map(struct irq_domain *h, unsigned int virq,
 	irq_set_chip_data(virq, h->host_data);
 	irq_set_chip_and_handler(virq, &wm831x_irq_chip, handle_edge_irq);
 	irq_set_nested_thread(virq, 1);
-
-	/* ARM needs us to explicitly flag the IRQ as valid
-	 * and will set them noprobe when we do so. */
-#ifdef CONFIG_ARM
-	set_irq_flags(virq, IRQF_VALID);
-#else
 	irq_set_noprobe(virq);
-#endif
-
 	return 0;
 }
 
diff --git a/drivers/mfd/wm8994-irq.c b/drivers/mfd/wm8994-irq.c
index e74dedd..3d81759 100644
--- a/drivers/mfd/wm8994-irq.c
+++ b/drivers/mfd/wm8994-irq.c
@@ -172,15 +172,7 @@ static int wm8994_edge_irq_map(struct irq_domain *h, unsigned int virq,
 	irq_set_chip_data(virq, wm8994);
 	irq_set_chip_and_handler(virq, &wm8994_edge_irq_chip, handle_edge_irq);
 	irq_set_nested_thread(virq, 1);
-
-	/* ARM needs us to explicitly flag the IRQ as valid
-	 * and will set them noprobe when we do so. */
-#ifdef CONFIG_ARM
-	set_irq_flags(virq, IRQF_VALID);
-#else
 	irq_set_noprobe(virq);
-#endif
-
 	return 0;
 }
 
diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 829b98c..9755e01 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1744,11 +1744,7 @@ static int pcs_irqdomain_map(struct irq_domain *d, unsigned int irq,
 	irq_set_chip_and_handler(irq, &pcs->chip,
 				 handle_level_irq);
 
-#ifdef CONFIG_ARM
-	set_irq_flags(irq, IRQF_VALID);
-#else
 	irq_set_noprobe(irq);
-#endif
 
 	return 0;
 }
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
