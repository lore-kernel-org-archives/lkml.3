Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbaIEIOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 04:14:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58513 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751641AbaIEIOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 04:14:17 -0400
Date: Fri, 5 Sep 2014 10:14:09 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, "'Alexander Shiyan'" <shc_work@mail.ru>,
        naushad@samsung.com, "'Tomasz Figa'" <t.figa@samsung.com>,
        linux-kernel@vger.kernel.org, joshi@samsung.com,
        linux-samsung-soc@vger.kernel.org, thomas.ab@samsung.com,
        tomasz.figa@gmail.com, vikas.sajjan@samsung.com, chow.kim@samsung.com,
        lee.jones@linaro.org, "'Michal Simek'" <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org,
        "'Mark Brown'" <broonie@kernel.org>
Subject: Re: [PATCH v2] mfd: syscon: Decouple syscon interface from platform
 devices
Message-ID: <20140905101409.68b14cc3@bbrezillon>
In-Reply-To: <002701cfc7fb$110a7350$331f59f0$@samsung.com>
References: <1409668935-10667-1-git-send-email-pankaj.dubey@samsung.com>
	<6034841.GFrG3XCMdb@wuerfel>
	<20140903151611.260a7218@bbrezillon>
	<4224773.hl3QDeILqz@wuerfel>
	<20140903161528.05f566e1@bbrezillon>
	<002701cfc7fb$110a7350$331f59f0$@samsung.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep 2014 10:15:27 +0530
Pankaj Dubey <pankaj.dubey@samsung.com> wrote:

> Hi Boris,
> 
> On Wednesday, September 03, 2014 Boris BREZILLON wrote,
> > To: Arnd Bergmann
> > Cc: Pankaj Dubey; kgene.kim@samsung.com; linux@arm.linux.org.uk; Alexander
> > Shiyan; naushad@samsung.com; Tomasz Figa; linux-kernel@vger.kernel.org;
> > joshi@samsung.com; linux-samsung-soc@vger.kernel.org;
> thomas.ab@samsung.com;
> > tomasz.figa@gmail.com; vikas.sajjan@samsung.com; chow.kim@samsung.com;
> > lee.jones@linaro.org; Michal Simek; linux-arm-kernel@lists.infradead.org;
> Mark
> > Brown
> > Subject: Re: [PATCH v2] mfd: syscon: Decouple syscon interface from
> platform
> > devices
> > 
> > On Wed, 03 Sep 2014 15:49:04 +0200
> > Arnd Bergmann <arnd@arndb.de> wrote:
> > 
> > > On Wednesday 03 September 2014 15:16:11 Boris BREZILLON wrote:
> > > > I checked that part, and it appears most of the code is already
> > > > there (see usage of regmap_attach_dev function here [1]).
> > > >
> > > > The only problem I see is that errors are still printed with
> > > > dev_err, which, AFAIK, will trigger a kernel panic if dev is NULL.
> > >
> > > Actually not:
> > >
> > > static int __dev_printk(const char *level, const struct device *dev,
> > >                         struct va_format *vaf) {
> > >         if (!dev)
> > >                 return printk("%s(NULL device *): %pV", level, vaf);
> > >
> > >         return dev_printk_emit(level[1] - '0', dev,
> > >                                "%s %s: %pV",
> > >                                dev_driver_string(dev), dev_name(dev),
> > > vaf); }
> > >
> > 
> > My bad then (I don't know where I looked at to think NULL dev was not
> gracefully
> > handled :-)). Thanks for pointing this out.
> > Given that, I think it should work fine even with a NULL dev.
> > I'll give it a try on at91 ;-).
> > 
> 
> We have tested this patch, on Exynos board and found working well.
> In our use case DT based drivers such as USB Phy, SATA Phy, Watchdog are
> calling 
> syscon_regmap_lookup_by APIs to get regmap handle to Exynos PMU and it
> worked 
> well for these drivers. 
> 
> It would be great if after testing you share result here or give a
> Tested-By.
> 

I eventually tested it (just required minor modifications to my PMC
code: see below).
Still, this patch is not achieving my final goal which is to remove the
global at91_pmc_base variable and make use of the syscon regmap to
implement at91 cpu idle and platform suspend.
Moreover, I'd like to remove the lock in at91_pmc struct as regmap is
already taking care of locking the resources when accessing a
register, but this requires a lot more changes.

Anyway, here is my

Tested-by: Boris Brezillon <boris.brezillon@free-electrons.com>



diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index dd28e1f..7df2c9b 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -23,6 +23,7 @@ config COMMON_CLK_AT91
 	bool
 	default AT91_PMC_UNIT && USE_OF && !AT91_USE_OLD_CLK
 	select COMMON_CLK
+	select MFD_SYSCON
 
 config OLD_CLK_AT91
 	bool
diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
index 524196b..fb2c0af 100644
--- a/drivers/clk/at91/pmc.c
+++ b/drivers/clk/at91/pmc.c
@@ -19,6 +19,7 @@
 #include <linux/irqchip/chained_irq.h>
 #include <linux/irqdomain.h>
 #include <linux/of_irq.h>
+#include <linux/mfd/syscon.h>
 
 #include <asm/proc-fns.h>
 
@@ -190,6 +191,7 @@ static const struct at91_pmc_caps sama5d3_caps = {
 };
 
 static struct at91_pmc *__init at91_pmc_init(struct device_node *np,
+					     struct regmap *regmap,
 					     void __iomem *regbase,
int virq, const struct at91_pmc_caps *caps)
 {
@@ -205,7 +207,7 @@ static struct at91_pmc *__init at91_pmc_init(struct
device_node *np, return NULL;
 
 	spin_lock_init(&pmc->lock);
-	pmc->regbase = regbase;
+	pmc->regmap = regmap;
 	pmc->virq = virq;
 	pmc->caps = caps;
 
@@ -348,16 +350,46 @@ static void __init of_at91_pmc_setup(struct
device_node *np, void (*clk_setup)(struct device_node *, struct
at91_pmc *); const struct of_device_id *clk_id;
 	void __iomem *regbase = of_iomap(np, 0);
+	struct regmap *regmap;
 	int virq;
 
-	if (!regbase)
-		return;
+	/*
+	 * If the pmc compatible property does not contain the "syscon"
+	 * string, patch the property so that syscon_node_to_regmap can
+	 * consider it as a syscon device.
+	 */
+	if (!of_device_is_compatible(np, "syscon")) {
+		struct property *newprop, *oldprop;
+
+		oldprop = of_find_property(np, "compatible", NULL);
+		if (!oldprop)
+			panic("Could not find compatible property");
+
+		newprop = kzalloc(sizeof(*newprop), GFP_KERNEL);
+		if (!newprop)
+			panic("Could not allocate compatible
property"); +
+		newprop->name = "compatible";
+		newprop->length = oldprop->length + sizeof("syscon");
+		newprop->value = kmalloc(newprop->length, GFP_KERNEL);
+		if (!newprop->value) {
+			kfree(newprop->value);
+			panic("Could not allocate compatible string");
+		}
+		memcpy(newprop->value, oldprop->value,
oldprop->length);
+		memcpy(newprop->value + oldprop->length, "syscon",
sizeof("syscon"));
+		of_update_property(np, newprop);
+	}
+
+	regmap = syscon_node_to_regmap(np);
+	if (IS_ERR(regmap))
+		panic("Could not retrieve syscon regmap");
 
 	virq = irq_of_parse_and_map(np, 0);
 	if (!virq)
 		return;
 
-	pmc = at91_pmc_init(np, regbase, virq, caps);
+	pmc = at91_pmc_init(np, regmap, regbase, virq, caps);
 	if (!pmc)
 		return;
 	for_each_child_of_node(np, childnp) {
diff --git a/drivers/clk/at91/pmc.h b/drivers/clk/at91/pmc.h
index 6c76259..49589ea 100644
--- a/drivers/clk/at91/pmc.h
+++ b/drivers/clk/at91/pmc.h
@@ -14,6 +14,7 @@
 
 #include <linux/io.h>
 #include <linux/irqdomain.h>
+#include <linux/regmap.h>
 #include <linux/spinlock.h>
 
 struct clk_range {
@@ -28,7 +29,7 @@ struct at91_pmc_caps {
 };
 
 struct at91_pmc {
-	void __iomem *regbase;
+	struct regmap *regmap;
 	int virq;
 	spinlock_t lock;
 	const struct at91_pmc_caps *caps;
@@ -47,12 +48,16 @@ static inline void pmc_unlock(struct at91_pmc *pmc)
 
 static inline u32 pmc_read(struct at91_pmc *pmc, int offset)
 {
-	return readl(pmc->regbase + offset);
+	unsigned int ret = 0;
+
+	regmap_read(pmc->regmap, offset, &ret);
+
+	return ret;
 }
 
 static inline void pmc_write(struct at91_pmc *pmc, int offset, u32
value) {
-	writel(value, pmc->regbase + offset);
+	regmap_write(pmc->regmap, offset, value);
 }
 
 int of_at91_get_clk_range(struct device_node *np, const char *propname,
