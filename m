Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab3KWAnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 19:43:42 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61821 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab3KWAnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 19:43:41 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+l4BSk2qImFwSaY3ZmYyB8
Date: Fri, 22 Nov 2013 16:43:35 -0800
From: Tony Lindgren <tony@atomide.com>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] of/platform: Fix no irq domain found errors when
 populating interrupts
Message-ID: <20131123004334.GJ10023@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we get the following kind of errors if we try to use
interrupt phandles to irqchips that have not yet initialized:

irq: no irq domain found for /ocp/pinmux@48002030 !
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
...

This is because we're wrongly trying to populate resources that are not
yet available. It's perfectly valid to create irqchips dynamically,
so let's fix up the issue by populating the interrupt resources based
on a notifier call instead.

Signed-off-by: Tony Lindgren <tony@atomide.com>

---

Rob & Grant, care to merge this for the -rc if this looks OK to you?

These happen for example when using interrupts-extended for omap
wake-up interrupts where the irq domain is created by pinctrl-single.c
at module_init time.

--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -130,6 +130,56 @@ void of_device_make_bus_id(struct device *dev)
 	dev_set_name(dev, "%s.%d", node->name, magic - 1);
 }
 
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
+	struct resource *res = pdev->resource;
+	struct resource *irqr = NULL;
+	int num_irq, i, found = 0;
+
+	if (event != BUS_NOTIFY_BIND_DRIVER)
+		return 0;
+
+	if (!np)
+		goto out;
+
+	num_irq = of_irq_count(np);
+	if (!num_irq)
+		goto out;
+
+	for (i = 0; i < pdev->num_resources; i++, res++) {
+		if (res->flags != IORESOURCE_IRQ ||
+		    res->start != -EPROBE_DEFER ||
+		    res->end != -EPROBE_DEFER)
+			continue;
+
+		if (!irqr)
+			irqr = res;
+		found++;
+	}
+
+	if (!found)
+		goto out;
+
+	if (found != num_irq) {
+		dev_WARN(dev, "error populating irq resources: %i != %i\n",
+			 found, num_irq);
+		goto out;
+	}
+
+	WARN_ON(of_irq_to_resource_table(np, irqr, num_irq) != num_irq);
+
+out:
+	return NOTIFY_DONE;
+}
+
 /**
  * of_device_alloc - Allocate and initialize an of_device
  * @np: device node to assign to device
@@ -168,7 +218,13 @@ struct platform_device *of_device_alloc(struct device_node *np,
 			rc = of_address_to_resource(np, i, res);
 			WARN_ON(rc);
 		}
-		WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
+
+		/* See of_device_resource_notify for populating interrupts */
+		for (i = 0; i < num_irq; i++, res++) {
+			res->flags = IORESOURCE_IRQ;
+			res->start = -EPROBE_DEFER;
+			res->end = -EPROBE_DEFER;
+		}
 	}
 
 	dev->dev.of_node = of_node_get(np);
@@ -447,6 +503,8 @@ int of_platform_bus_probe(struct device_node *root,
 }
 EXPORT_SYMBOL(of_platform_bus_probe);
 
+static struct notifier_block resource_nb;
+
 /**
  * of_platform_populate() - Populate platform_devices from device tree data
  * @root: parent of the first level to probe or NULL for the root of the tree
@@ -478,6 +536,11 @@ int of_platform_populate(struct device_node *root,
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
