Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738Ab3CZJYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:24:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60061 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3CZJYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:24:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Axel Lin <axel.lin@ingics.com>
Subject: Re: [PATCH] clocksource: Fix build error when !CONFIG_CLKSRC_OF
Date: Tue, 26 Mar 2013 09:24:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <rob.herring@calxeda.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>
References: <1364272469.18836.1.camel@phoenix>
In-Reply-To: <1364272469.18836.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303260924.24549.arnd@arndb.de>
X-Provags-ID: V02:K0:QBMX9sel3jn1UOWvlK5n8zlczkko4QmWtyp1O+8GML8
 YmhYrs3PyUEj26CJgHNDtoeN2zA0Ldd7thBjHg40cDMf+xtP20
 zTCOYQlvfceG6nVvm/zRv5BeUTXzLQ8e3DV3TtctYVsxr3ROuU
 hHsi1ZvvGHyuWf0G7RMSHKqg7h092ltgzaXF1CKBJbCxYgBFHi
 +zcISLJgK33IRtGnqkPW1uXks8r+/Ca6wJu46WJ31pdb9IWL6A
 XgnEfmSAEeXpX+JH7miQvizomgCIMamrPCKzSkrF9Iq7i5wMML
 jNCaxmLlEShGd1lDqEMzxxzqdDpJBgeCQ0ebyY5hIHXOlSS9sB
 ApSFdAZw/z+0QPwiQCS4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 March 2013, Axel Lin wrote:
> Fix below build error:
> 
>   CC      drivers/clocksource/exynos_mct.o
> drivers/clocksource/exynos_mct.c:557:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__unused'
> drivers/clocksource/exynos_mct.c:558:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '__unused'
> make[2]: *** [drivers/clocksource/exynos_mct.o] Error 1
> make[1]: *** [drivers/clocksource] Error 2
> make: *** [drivers] Error 2
> 
> This build error is introduced by commit 4d10f054
> "clocksource: make CLOCKSOURCE_OF_DECLARE type safe".

Hi Axel,

Thanks for the bug report. It seems that the __unused does not exist in
the kernel, so I'll have to use __attribute__((unused)) instead.
I definitely want to keep the feature of checking the function prototype
even for CONFIG_OF=n though, so I won't remove the macro definition.

I'll apply this patch unless there are further concerns with it.

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index ac33184..818be77 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -346,7 +346,7 @@ extern void clocksource_of_init(void);
 static inline void clocksource_of_init(void) {}
 #define CLOCKSOURCE_OF_DECLARE(name, compat, fn)			\
 	static const struct of_device_id __clksrc_of_table_##name	\
-		__unused __section(__clksrc_of_table)			\
+		__attribute__((__unused__))				\
 		 = { .compatible = compat,				\
 		     .data = (fn == (clocksource_of_init_fn)NULL) ? fn : fn }
 #endif


Since Rob's earlier patches changed the interface for CLOCKSOURCE_OF_DECLARE,
we will also need to have a patch like the one below for the exynos_mct
driver.

diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 203ac05..fc95114 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -511,48 +511,37 @@ static void __init exynos4_timer_resources(struct device_node *np)
 #endif /* CONFIG_LOCAL_TIMERS */
 }
 
-static const struct of_device_id exynos_mct_ids[] = {
-	{ .compatible = "samsung,exynos4210-mct", .data = (void *)MCT_INT_SPI },
-	{ .compatible = "samsung,exynos4412-mct", .data = (void *)MCT_INT_PPI },
-};
-
-void __init mct_init(void)
+static void __init mct_init(struct device_node *np)
 {
-	struct device_node *np = NULL;
-	const struct of_device_id *match;
 	u32 nr_irqs, i;
 
-#ifdef CONFIG_OF
-	np = of_find_matching_node_and_match(NULL, exynos_mct_ids, &match);
-#endif
-	if (np) {
-		mct_int_type = (u32)(match->data);
-
-		/* This driver uses only one global timer interrupt */
-		mct_irqs[MCT_G0_IRQ] = irq_of_parse_and_map(np, MCT_G0_IRQ);
-
-		/*
-		 * Find out the number of local irqs specified. The local
-		 * timer irqs are specified after the four global timer
-		 * irqs are specified.
-		 */
-#ifdef CONFIG_OF
-		nr_irqs = of_irq_count(np);
-#endif
-		for (i = MCT_L0_IRQ; i < nr_irqs; i++)
-			mct_irqs[i] = irq_of_parse_and_map(np, i);
-	} else if (soc_is_exynos4210()) {
-		mct_irqs[MCT_G0_IRQ] = EXYNOS4_IRQ_MCT_G0;
-		mct_irqs[MCT_L0_IRQ] = EXYNOS4_IRQ_MCT_L0;
-		mct_irqs[MCT_L1_IRQ] = EXYNOS4_IRQ_MCT_L1;
-		mct_int_type = MCT_INT_SPI;
-	} else {
-		panic("unable to determine mct controller type\n");
-	}
+	/* This driver uses only one global timer interrupt */
+	mct_irqs[MCT_G0_IRQ] = irq_of_parse_and_map(np, MCT_G0_IRQ);
+
+	/*
+	 * Find out the number of local irqs specified. The local
+	 * timer irqs are specified after the four global timer
+	 * irqs are specified.
+	 */
+	nr_irqs = of_irq_count(np);
+	for (i = MCT_L0_IRQ; i < nr_irqs; i++)
+		mct_irqs[i] = irq_of_parse_and_map(np, i);
 
 	exynos4_timer_resources(np);
 	exynos4_clocksource_init();
 	exynos4_clockevent_init();
 }
-CLOCKSOURCE_OF_DECLARE(exynos4210, "samsung,exynos4210-mct", mct_init)
-CLOCKSOURCE_OF_DECLARE(exynos4412, "samsung,exynos4412-mct", mct_init)
+
+static void __init exynos4210_mct_init(struct device_node *np)
+{
+	mct_int_type = MCT_INT_SPI;
+	mct_init(np);
+}
+CLOCKSOURCE_OF_DECLARE(exynos4210, "samsung,exynos4210-mct", exynos4210_mct_init);
+
+static void __init exynos4412_mct_init(struct device_node *np)
+{
+	mct_int_type = MCT_INT_PPI;
+	mct_init(np);
+}
+CLOCKSOURCE_OF_DECLARE(exynos4412, "samsung,exynos4412-mct", exynos4412_mct_init);

diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index 535cecf..5cac5ce 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -88,6 +88,12 @@ static inline void *of_irq_find_parent(struct device_node *child)
 {
 	return NULL;
 }
+
+static inline int of_irq_count(struct device_node *dev)
+{
+	return 0;
+}
+
 #endif /* !CONFIG_OF */
 
 #endif /* __OF_IRQ_H */
