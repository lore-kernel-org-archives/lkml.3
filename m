Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab3KYTrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:47:08 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:25888 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab3KYTrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:47:03 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18BYw0Y+Apv1okJ2SKTZ2El
Date: Mon, 25 Nov 2013 11:46:57 -0800
From: Tony Lindgren <tony@atomide.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when
 populating interrupts
Message-ID: <20131125194657.GR10023@atomide.com>
References: <20131123004334.GJ10023@atomide.com>
 <20131123005509.GJ16735@n2100.arm.linux.org.uk>
 <20131123010850.GN10023@atomide.com>
 <20131123011515.GO10023@atomide.com>
 <20131123015034.GP10023@atomide.com>
 <CAL_JsqKV7K+QdLHS+3LtfcVx5Dpc7n6A8UwwNWKBP33Gs19c8g@mail.gmail.com>
 <20131123163240.GW5928@atomide.com>
 <20131125093434.GE22043@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125093434.GE22043@ulmo.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thierry Reding <thierry.reding@gmail.com> [131125 01:36]:
> On Sat, Nov 23, 2013 at 08:32:40AM -0800, Tony Lindgren wrote:
> > * Rob Herring <robherring2@gmail.com> [131123 07:43]:
> > > On Fri, Nov 22, 2013 at 7:50 PM, Tony Lindgren <tony@atomide.com> wrote:
> > > > * Tony Lindgren <tony@atomide.com> [131122 17:16]:
> > > >> * Tony Lindgren <tony@atomide.com> [131122 17:09]:
> > > >> > * Russell King - ARM Linux <linux@arm.linux.org.uk> [131122 16:56]:
> > > >> > > On Fri, Nov 22, 2013 at 04:43:35PM -0800, Tony Lindgren wrote:
> > > >> > > > +               /* See of_device_resource_notify for populating interrupts */
> > > >> > > > +               for (i = 0; i < num_irq; i++, res++) {
> > > >> > > > +                       res->flags = IORESOURCE_IRQ;
> > > >> > > > +                       res->start = -EPROBE_DEFER;
> > > >> > > > +                       res->end = -EPROBE_DEFER;
> > > >> > >
> > > >> > > NAK.  Definitely a bad idea to start introducing magic values other into
> > > >> > > resources.  Please don't do this.
> > > >> >
> > > >> > Do you have any better ideas on how to sort out this issue then?
> > > >>
> > > >> I guess we could allocate all the resources lazily here, I'll take a look
> > > >> at that.
> > > >
> > > > Here's a version that allocates the resources lazily with the notifier.
> > > > Seems to boot, need to play with it a bit more though to make sure we're
> > > > not overwriting resources for any legacy devices.
> > > 
> > > Have you seen Thierry's series[1]? While your approach is certainly
> > > more concise, it seems like a work-around for the problem. I don't
> > > think a notifier is the right long term solution.
> > 
> > OK cool. I think we can fix the $Subject bug first without making all
> > those changes, then do the rest of the reorg for v3.14.
> > 
> > The bug is that we try to populate IRQ resources at a wrong time
> > when they may not exist.
> > 
> > Based on a quick look it seems we could combine Thierry's addition
> > of the new function of_platform_probe(struct platform_device *pdev)
> > and use that to allocate all resources at driver probe time like my
> > patch is doing. And then there's no need for the notifier.
> 
> My series already does the allocation at probe time as well. That was
> the whole point. The reason why I added of_platform_probe() is because I
> think we'll be needing this for other types of resources in the future
> as well, so it could serve as a central place to do all of that.

Yeah, that's the way to go in the long run. However, we currently do have
some dependencies to that data being there and bus specific code may
add legacy resources to it with platform_device_add_resources(). At least
omap_device_alloc() depends on that until v3.14 when mach-omap2 is booting
in DT only mode.
 
> There was also a proposal[0] by Arnd a few weeks ago that solved this in
> a more generic way. I've said it before, and I'll say again that the
> idea scares me somewhat, but it does solve some interesting aspects and
> has the potential to get rid of a whole lot of boilerplate code. While
> the original purpose was to handle all things devm_*(), I suspect that
> same mechanism could be used to resolve DT references at probe time.

Yes devm_alloc() should work once the legacy dependencies are out of the
way. We would need to audit where pdev->num_resources or pdev->resource is
being relied on, and where platform_device_add_resources() is being called
before the device probe. So I doubt we can do that all as a fix for the
-rc cycle.

Below is what I think might be limited enough to fix the $Subject bug for
the -rc cycle. I took the of_platform_probe() from your patch 08/10 to
avoid the notifier. Also added Greg to Cc as it's now touching
drivers/base/platform.c too.

Seems to work for my test cases, does this work for you guys?

Regards,

Tony
 
> [0]: http://www.spinics.net/lists/devicetree/msg10684.html

8< ---------------------

From: Tony Lindgren <tony@atomide.com>
Date: Mon, 25 Nov 2013 11:12:52 -0800
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
@@ -488,4 +535,35 @@ int of_platform_populate(struct device_node *root,
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
