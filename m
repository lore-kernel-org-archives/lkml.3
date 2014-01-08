Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbaAHQkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 11:40:52 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:16862 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096AbaAHQkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 11:40:49 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+RpXlIJ6fwWlfxrtGClxkQ
Date: Wed, 8 Jan 2014 08:40:41 -0800
From: Tony Lindgren <tony@atomide.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Paul Walmsley <paul@pwsan.com>, Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] driver-core: platform: Resolve DT interrupt references
 late
Message-ID: <20140108164040.GA31686@atomide.com>
References: <20140108011957.GK5074@atomide.com>
 <1389185477-507-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389185477-507-1-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thierry Reding <thierry.reding@gmail.com> [140108 04:55]:
> When devices are probed from the device tree, any interrupts that they
> reference are resolved at device creation time. This causes problems if
> the interrupt provider hasn't been registered yet at that time, which
> results in the interrupt being set to 0.
> 
> This is especially bad for platform devices because they are created at
> a very early stage during boot when the majority of interrupt providers
> haven't had a chance to be probed yet. One of the platform where this
> causes major issues is OMAP.
> 
> Note that this patch is the easy way out to fix a large part of the
> problems for now. A more proper solution for the long term would be to
> transition drivers to an API that always resolves resources of any kind
> (not only interrupts) at probe time.
> 
> For some background and discussion on possible solutions, see:
> 
> 	https://lkml.org/lkml/2013/11/22/520
> 
> Acked-by: Rob Herring <robherring2@gmail.com>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Note that this is somewhat urgent and should if at all possible go into
> v3.13 before the release.
> 
>  drivers/base/platform.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 3a94b799f166..c894d1af3a5e 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -13,6 +13,7 @@
>  #include <linux/string.h>
>  #include <linux/platform_device.h>
>  #include <linux/of_device.h>
> +#include <linux/of_irq.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/dma-mapping.h>
> @@ -87,7 +88,12 @@ int platform_get_irq(struct platform_device *dev, unsigned int num)
>  		return -ENXIO;
>  	return dev->archdata.irqs[num];
>  #else
> -	struct resource *r = platform_get_resource(dev, IORESOURCE_IRQ, num);
> +	struct resource *r;
> +
> +	if (IS_ENABLED(CONFIG_OF) && dev->dev.of_node)
> +		return irq_of_parse_and_map(dev->dev.of_node, num);
> +
> +	r = platform_get_resource(dev, IORESOURCE_IRQ, num);
>  
>  	return r ? r->start : -ENXIO;
>  #endif

Hmm actually testing this patch, it does not fix fix the $Subject bug :(

irq: no irq domain found for /ocp/pinmux@48002030 !
[    0.301361] ------------[ cut here ]------------
[    0.301391] WARNING: CPU: 0 PID: 1 at drivers/of/platform.c:171 of_device_alloc+0x144/0x184()
[    0.301422] Modules linked in:
[    0.301452] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc7-00002-g4d998a6 #17
[    0.301513] [<c0015c04>] (unwind_backtrace+0x0/0xf4) from [<c00127b0>] (show_stack+0x14/0x1c)
[    0.301544] [<c00127b0>] (show_stack+0x14/0x1c) from [<c05685a4>] (dump_stack+0x6c/0xa0)
[    0.301574] [<c05685a4>] (dump_stack+0x6c/0xa0) from [<c00425b4>] (warn_slowpath_common+0x64/0x84)
[    0.301605] [<c00425b4>] (warn_slowpath_common+0x64/0x84) from [<c00425f0>] (warn_slowpath_null+0x1c/0x24)
[    0.301635] [<c00425f0>] (warn_slowpath_null+0x1c/0x24) from [<c0485210>] (of_device_alloc+0x144/0x184)
[    0.301635] [<c0485210>] (of_device_alloc+0x144/0x184) from [<c0485294>] (of_platform_device_create_pdata+0x44/0x9c)
[    0.301666] [<c0485294>] (of_platform_device_create_pdata+0x44/0x9c) from [<c04853bc>] (of_platform_bus_create+0xd0/0x170)
[    0.301696] [<c04853bc>] (of_platform_bus_create+0xd0/0x170) from [<c0485418>] (of_platform_bus_create+0x12c/0x170)
[    0.301727] [<c0485418>] (of_platform_bus_create+0x12c/0x170) from [<c04854bc>] (of_platform_populate+0x60/0x98)
[    0.301757] [<c04854bc>] (of_platform_populate+0x60/0x98) from [<c07ca53c>] (pdata_quirks_init+0x28/0x78)
[    0.301788] [<c07ca53c>] (pdata_quirks_init+0x28/0x78) from [<c07bab20>] (customize_machine+0x20/0x48)
[    0.301818] [<c07bab20>] (customize_machine+0x20/0x48) from [<c000882c>] (do_one_initcall+0x2c/0x150)
[    0.301849] [<c000882c>] (do_one_initcall+0x2c/0x150) from [<c07b75d8>] (do_basic_setup+0x94/0xd4)
[    0.301879] [<c07b75d8>] (do_basic_setup+0x94/0xd4) from [<c07b7694>] (kernel_init_freeable+0x7c/0x120)
[    0.301910] [<c07b7694>] (kernel_init_freeable+0x7c/0x120) from [<c05667ec>] (kernel_init+0x8/0x120)
[    0.301940] [<c05667ec>] (kernel_init+0x8/0x120) from [<c000e908>] (ret_from_fork+0x14/0x2c)
[    0.302124] ---[ end trace 2b87f5de2f86f809 ]---
...

There's nothing wrong with the interrupt related code paths, we're just
trying to call the functions at a wrong time when thing are not yet
initialized.

Below is a repost of what works for me without using notifiers. Anybody
got any better ideas for a minimal fix?

Regards,

Tony

8< -------------------------------
From: Tony Lindgren <tony@atomide.com>
Date: Tue, 7 Jan 2014 17:07:18 -0800
Subject: [PATCH] of/platform: Fix no irq domain found errors when populating interrupts

Currently we get the following kind of errors if we try to use interrupt
phandles to irqchips that have not yet initialized:

irq: no irq domain found for /ocp/pinmux@48002030 !
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at drivers/of/platform.c:171 of_device_alloc+0x144/0x184()
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-00038-g42a9708 #1012
(show_stack+0x14/0x1c)
(dump_stack+0x6c/0xa0)
(warn_slowpath_common+0x64/0x84)
(warn_slowpath_null+0x1c/0x24)
(of_device_alloc+0x144/0x184)
(of_platform_device_create_pdata+0x44/0x9c)
(of_platform_bus_create+0xd0/0x170)
(of_platform_bus_create+0x12c/0x170)
(of_platform_populate+0x60/0x98)

This is because we're wrongly trying to populate resources that are not yet
available. It's perfectly valid to create irqchips dynamically, so let's
fix up the issue by populating the interrupt resources at the driver probe
time instead.

Note that at least currently we cannot dynamically allocate the resources as bus
specific code may add legacy resources with platform_device_add_resources()
before the driver probe. At least omap_device_alloc() currently relies on
num_resources to determine if legacy resources should be added. This issue
will get fixed automatically when mach-omap2 boots with DT only, but there
are probably other places too where platform_device_add_resources() modifies
things before driver probe.

The addition of of_platform_probe() is based on patches posted earlier by
Thierry Reding <thierry.reding@gmail.com>.

Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -481,6 +481,10 @@ static int platform_drv_probe(struct device *_dev)
 	struct platform_device *dev = to_platform_device(_dev);
 	int ret;
 
+	ret = of_platform_probe(dev);
+	if (ret)
+		return ret;
+
 	if (ACPI_HANDLE(_dev))
 		acpi_dev_pm_attach(_dev, true);
 
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -141,7 +141,7 @@ struct platform_device *of_device_alloc(struct device_node *np,
 				  struct device *parent)
 {
 	struct platform_device *dev;
-	int rc, i, num_reg = 0, num_irq;
+	int num_reg = 0, num_irq;
 	struct resource *res, temp_res;
 
 	dev = platform_device_alloc("", -1);
@@ -154,7 +154,14 @@ struct platform_device *of_device_alloc(struct device_node *np,
 			num_reg++;
 	num_irq = of_irq_count(np);
 
-	/* Populate the resource table */
+	/*
+	 * Only allocate the resources for us to use later on. Note that bus
+	 * specific code may also add in additional legacy resources using
+	 * platform_device_add_resources(), and may even rely on us allocating
+	 * the basic resources here to do so. So we cannot allocate the
+	 * resources lazily until the legacy code has been fixed to not rely
+	 * on allocating resources here.
+	 */
 	if (num_irq || num_reg) {
 		res = kzalloc(sizeof(*res) * (num_irq + num_reg), GFP_KERNEL);
 		if (!res) {
@@ -164,11 +171,7 @@ struct platform_device *of_device_alloc(struct device_node *np,
 
 		dev->num_resources = num_reg + num_irq;
 		dev->resource = res;
-		for (i = 0; i < num_reg; i++, res++) {
-			rc = of_address_to_resource(np, i, res);
-			WARN_ON(rc);
-		}
-		WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
+		/* See of_device_resource_populate for populating the data */
 	}
 
 	dev->dev.of_node = of_node_get(np);
@@ -187,6 +190,50 @@ struct platform_device *of_device_alloc(struct device_node *np,
 EXPORT_SYMBOL(of_device_alloc);
 
 /**
+ * of_device_resource_populate - Populate device resources from device tree
+ * @dev: pointer to platform device
+ *
+ * The device interrupts are not necessarily available for all
+ * irqdomains initially so we need to populate them lazily at
+ * device probe time from of_platform_populate.
+ */
+static int of_device_resource_populate(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	int rc, i, num_reg = 0, num_irq;
+	struct resource *res, temp_res;
+
+	res = pdev->resource;
+
+	/*
+	 * Count the io and irq resources again. Currently we cannot rely on
+	 * pdev->num_resources as bus specific code may have changed that
+	 * with platform_device_add_resources(). But the resources we allocated
+	 * earlier are still there and available for us to populate.
+	 */
+	if (of_can_translate_address(np))
+		while (of_address_to_resource(np, num_reg, &temp_res) == 0)
+			num_reg++;
+	num_irq = of_irq_count(np);
+
+	if (pdev->num_resources < num_reg + num_irq) {
+		dev_WARN(&pdev->dev, "not enough resources %i < %i\n",
+			 pdev->num_resources, num_reg + num_irq);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < num_reg; i++, res++) {
+		rc = of_address_to_resource(np, i, res);
+		WARN_ON(rc);
+	}
+
+	if (num_irq)
+		WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
+
+	return 0;
+}
+
+/**
  * of_platform_device_create_pdata - Alloc, initialize and register an of_device
  * @np: pointer to node to create device for
  * @bus_id: name to assign device
@@ -485,4 +532,35 @@ int of_platform_populate(struct device_node *root,
 	return rc;
 }
 EXPORT_SYMBOL_GPL(of_platform_populate);
+
+/**
+ * of_platform_probe() - OF specific initialization at probe time
+ * @pdev: pointer to a platform device
+ *
+ * This function is called by the driver core to perform devicetree-specific
+ * setup for a given platform device at probe time. If a device's resources
+ * as specified in the device tree are not available yet, this function can
+ * return -EPROBE_DEFER and cause the device to be probed again later, when
+ * other drivers that potentially provide the missing resources have been
+ * probed in turn.
+ *
+ * Note that because of the above, all code executed by this function must
+ * be prepared to be run multiple times on the same device (i.e. it must be
+ * idempotent).
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+int of_platform_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	if (!pdev->dev.of_node)
+		return 0;
+
+	ret = of_device_resource_populate(pdev);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
 #endif /* CONFIG_OF_ADDRESS */
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -72,6 +72,8 @@ extern int of_platform_populate(struct device_node *root,
 				const struct of_device_id *matches,
 				const struct of_dev_auxdata *lookup,
 				struct device *parent);
+
+extern int of_platform_probe(struct platform_device *pdev);
 #else
 static inline int of_platform_populate(struct device_node *root,
 					const struct of_device_id *matches,
@@ -80,6 +82,11 @@ static inline int of_platform_populate(struct device_node *root,
 {
 	return -ENODEV;
 }
+
+static inline int of_platform_probe(struct platform_device *pdev)
+{
+	return 0;
+}
 #endif
 
 #endif	/* _LINUX_OF_PLATFORM_H */
