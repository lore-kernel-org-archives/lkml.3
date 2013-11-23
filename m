Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3KWBuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 20:50:44 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14343 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab3KWBul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 20:50:41 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18SP4Fai/RxRHoiZNAJzp6V
Date: Fri, 22 Nov 2013 17:50:35 -0800
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when
 populating interrupts
Message-ID: <20131123015034.GP10023@atomide.com>
References: <20131123004334.GJ10023@atomide.com>
 <20131123005509.GJ16735@n2100.arm.linux.org.uk>
 <20131123010850.GN10023@atomide.com>
 <20131123011515.GO10023@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131123011515.GO10023@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [131122 17:16]:
> * Tony Lindgren <tony@atomide.com> [131122 17:09]:
> > * Russell King - ARM Linux <linux@arm.linux.org.uk> [131122 16:56]:
> > > On Fri, Nov 22, 2013 at 04:43:35PM -0800, Tony Lindgren wrote:
> > > > +		/* See of_device_resource_notify for populating interrupts */
> > > > +		for (i = 0; i < num_irq; i++, res++) {
> > > > +			res->flags = IORESOURCE_IRQ;
> > > > +			res->start = -EPROBE_DEFER;
> > > > +			res->end = -EPROBE_DEFER;
> > > 
> > > NAK.  Definitely a bad idea to start introducing magic values other into
> > > resources.  Please don't do this.
> > 
> > Do you have any better ideas on how to sort out this issue then?
> 
> I guess we could allocate all the resources lazily here, I'll take a look
> at that.

Here's a version that allocates the resources lazily with the notifier.
Seems to boot, need to play with it a bit more though to make sure we're
not overwriting resources for any legacy devices.

Regards,

Tony


--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -141,13 +141,47 @@ struct platform_device *of_device_alloc(struct device_node *np,
 				  struct device *parent)
 {
 	struct platform_device *dev;
-	int rc, i, num_reg = 0, num_irq;
-	struct resource *res, temp_res;
 
 	dev = platform_device_alloc("", -1);
 	if (!dev)
 		return NULL;
 
+	dev->dev.of_node = of_node_get(np);
+#if defined(CONFIG_MICROBLAZE)
+	dev->dev.dma_mask = &dev->archdata.dma_mask;
+#endif
+	dev->dev.parent = parent;
+
+	if (bus_id)
+		dev_set_name(&dev->dev, "%s", bus_id);
+	else
+		of_device_make_bus_id(&dev->dev);
+
+	/* See of_device_resource_notify for populating the resources */
+
+	return dev;
+}
+EXPORT_SYMBOL(of_device_alloc);
+
+/*
+ * The device interrupts are not necessarily available for all
+ * irqdomains initially so we need to populate them using a
+ * notifier.
+ */
+static int of_device_resource_notify(struct notifier_block *nb,
+				     unsigned long event, void *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct device_node *np = pdev->dev.of_node;
+	int rc, i, num_reg = 0, num_irq;
+	struct resource *res, temp_res;
+
+	if (event != BUS_NOTIFY_BIND_DRIVER)
+		return 0;
+
+	if (!np)
+		goto out;
+
 	/* count the io and irq resources */
 	if (of_can_translate_address(np))
 		while (of_address_to_resource(np, num_reg, &temp_res) == 0)
@@ -158,12 +192,12 @@ struct platform_device *of_device_alloc(struct device_node *np,
 	if (num_irq || num_reg) {
 		res = kzalloc(sizeof(*res) * (num_irq + num_reg), GFP_KERNEL);
 		if (!res) {
-			platform_device_put(dev);
-			return NULL;
+			platform_device_put(pdev);
+			goto out;
 		}
 
-		dev->num_resources = num_reg + num_irq;
-		dev->resource = res;
+		pdev->num_resources = num_reg + num_irq;
+		pdev->resource = res;
 		for (i = 0; i < num_reg; i++, res++) {
 			rc = of_address_to_resource(np, i, res);
 			WARN_ON(rc);
@@ -171,20 +205,9 @@ struct platform_device *of_device_alloc(struct device_node *np,
 		WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
 	}
 
-	dev->dev.of_node = of_node_get(np);
-#if defined(CONFIG_MICROBLAZE)
-	dev->dev.dma_mask = &dev->archdata.dma_mask;
-#endif
-	dev->dev.parent = parent;
-
-	if (bus_id)
-		dev_set_name(&dev->dev, "%s", bus_id);
-	else
-		of_device_make_bus_id(&dev->dev);
-
-	return dev;
+out:
+	return NOTIFY_DONE;
 }
-EXPORT_SYMBOL(of_device_alloc);
 
 /**
  * of_platform_device_create_pdata - Alloc, initialize and register an of_device
@@ -447,6 +470,8 @@ int of_platform_bus_probe(struct device_node *root,
 }
 EXPORT_SYMBOL(of_platform_bus_probe);
 
+static struct notifier_block resource_nb;
+
 /**
  * of_platform_populate() - Populate platform_devices from device tree data
  * @root: parent of the first level to probe or NULL for the root of the tree
@@ -478,6 +503,11 @@ int of_platform_populate(struct device_node *root,
 	if (!root)
 		return -EINVAL;
 
+	if (!resource_nb.notifier_call) {
+		resource_nb.notifier_call = of_device_resource_notify,
+			bus_register_notifier(&platform_bus_type, &resource_nb);
+	}
+
 	for_each_child_of_node(root, child) {
 		rc = of_platform_bus_create(child, matches, lookup, parent, true);
 		if (rc)
