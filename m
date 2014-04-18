Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbaDRViV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 17:38:21 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:10360 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbaDRViA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 17:38:00 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19aZ9kZEFmMBjDLzyFiakBb
Date: Fri, 18 Apr 2014 14:37:51 -0700
From: Tony Lindgren <tony@atomide.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>, Paul Walmsley <paul@pwsan.com>,
        Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when
 populating interrupts
Message-ID: <20140418213751.GC21823@atomide.com>
References: <20140410213808.GA5990@atomide.com>
 <20140411092028.GI16119@n2100.arm.linux.org.uk>
 <20140411183625.GB3673@mithrandir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140411183625.GB3673@mithrandir>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thierry Reding <thierry.reding@gmail.com> [140411 11:40]:
> On Fri, Apr 11, 2014 at 10:20:28AM +0100, Russell King - ARM Linux wrote:
> > On Thu, Apr 10, 2014 at 02:38:09PM -0700, Tony Lindgren wrote:
> > > Currently we get the following kind of errors if we try to use interrupt
> > > phandles to irqchips that have not yet initialized:
> > > 
> > > irq: no irq domain found for /ocp/pinmux@48002030 !
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 0 PID: 1 at drivers/of/platform.c:171 of_device_alloc+0x144/0x184()
> > > Modules linked in:
> > > CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-00038-g42a9708 #1012
> > > (show_stack+0x14/0x1c)
> > > (dump_stack+0x6c/0xa0)
> > > (warn_slowpath_common+0x64/0x84)
> > > (warn_slowpath_null+0x1c/0x24)
> > > (of_device_alloc+0x144/0x184)
> > > (of_platform_device_create_pdata+0x44/0x9c)
> > > (of_platform_bus_create+0xd0/0x170)
> > > (of_platform_bus_create+0x12c/0x170)
> > > (of_platform_populate+0x60/0x98)
> > > 
> > > This is because we're wrongly trying to populate resources that are not yet
> > > available. It's perfectly valid to create irqchips dynamically, so let's
> > > fix up the issue by populating the interrupt resources at the driver probe
> > > time instead.
> > > 
> > > Note that at least currently we cannot dynamically allocate the resources as bus
> > > specific code may add legacy resources with platform_device_add_resources()
> > > before the driver probe. At least omap_device_alloc() currently relies on
> > > num_resources to determine if legacy resources should be added. Some of these
> > > will clear automatically when mach-omap2 boots with DT only, but there are
> > > probably other places too where platform_device_add_resources() modifies
> > > things before driver probe.
> > > 
> > > This patch was discussed quite a bit earlier, but so far it seems we don't
> > > have any better options to fix the problem. For the earlier discussion,
> > > please see:
> > > 
> > > https://lkml.org/lkml/2013/11/22/520
> > > 
> > > The addition of of_platform_probe() is based on patches posted earlier by
> > > Thierry Reding <thierry.reding@gmail.com>.
> > > 
> > > Signed-off-by: Tony Lindgren <tony@atomide.com>
> > 
> > So what happens if a device driver probe function:
> > 
> > - creates a new platform device
> > - copies the resources from the original to the new device
> > - copies the of_node from the original to the new device
> > - registers the new device
> > 
> > Yes, it's broken (because it can result in the same driver being re-probed
> > by the new device) but we *do* have stuff in the kernel tree which does
> > this.

Grr. Care to list some examples? See also if what I'm suggesting below
if that might work for the cases you're describing.
 
> From what I can tell the only clean solution would be to allow the OF
> functions to properly propagate errors. My earlier attempt was exactly
> that, but was deemed too invasive.

Frankly, I think sprinkling new of_* functions all over the subsystems
is going to be a never ending task to try to fix this and other similar
issues. For a long term solution it makes sense to not probe the driver
at all until all it's resources are in place.
 
> But that doesn't really solve the case you describe above either. So I
> think the only good generic solution would be for all resources to be
> resolved by the driver's .probe() function so that resources aren't
> "cached" in the device node.

For the other resources than interrupts I think what Russell describes
can be worked around by keeping the initial populating of the resources
except for the interrupts. Then we can just overwrite the resources in
of_device_resource_populate().

No idea which drivers Russell refers to above on the copied devices.
But presumably the copied device does not need interrupts without a
driver probe?

Regards,

Tony


8< ----------------------
From: Tony Lindgren <tony@atomide.com>
Date: Fri, 11 Apr 2014 07:52:00 -0700
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
num_resources to determine if legacy resources should be added. Some of these
will clear automatically when mach-omap2 boots with DT only, but there are
probably other places too where platform_device_add_resources() modifies
things before driver probe.

This patch was discussed quite a bit earlier, but so far it seems we don't
have any better options to fix the problem. For the earlier discussion,
please see:

https://lkml.org/lkml/2013/11/22/520

The addition of of_platform_probe() is based on patches posted earlier by
Thierry Reding <thierry.reding@gmail.com>.

Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -484,6 +484,10 @@ static int platform_drv_probe(struct device *_dev)
 	if (ACPI_HANDLE(_dev))
 		acpi_dev_pm_attach(_dev, true);
 
+	ret = of_platform_probe(dev);
+	if (ret)
+		return ret;
+
 	ret = drv->probe(dev);
 	if (ret && ACPI_HANDLE(_dev))
 		acpi_dev_pm_detach(_dev, true);
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -154,7 +154,7 @@ struct platform_device *of_device_alloc(struct device_node *np,
 			num_reg++;
 	num_irq = of_irq_count(np);
 
-	/* Populate the resource table */
+	/* Populate the resource table except for interrupts as they can change  */
 	if (num_irq || num_reg) {
 		res = kzalloc(sizeof(*res) * (num_irq + num_reg), GFP_KERNEL);
 		if (!res) {
@@ -168,7 +168,7 @@ struct platform_device *of_device_alloc(struct device_node *np,
 			rc = of_address_to_resource(np, i, res);
 			WARN_ON(rc);
 		}
-		WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
+		/* See of_device_resource_populate for populating interrupts */
 	}
 
 	dev->dev.of_node = of_node_get(np);
@@ -187,6 +187,50 @@ struct platform_device *of_device_alloc(struct device_node *np,
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
@@ -485,4 +529,35 @@ int of_platform_populate(struct device_node *root,
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
