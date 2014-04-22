Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaDVE5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 00:57:43 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:21053 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaDVE5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 00:57:40 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19F0v5L8K2tjIA4O+vlcT24
Date: Mon, 21 Apr 2014 21:57:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robh+dt@kernel.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 2/2] dt: platform driver: Fill the resources before
 probe and defer if needed
Message-ID: <20140422045730.GC26554@atomide.com>
References: <20140418205213.GA21823@atomide.com>
 <CAL_JsqJvVvo6R-qNXxur7wiZERKbi52xyKoWnmzJTfKS2iKK7A@mail.gmail.com>
 <20140418215848.GD21823@atomide.com>
 <20140418230335.GI24070@n2100.arm.linux.org.uk>
 <20140418232407.GQ21823@atomide.com>
 <CAL_JsqLvLTJwgsB-m0W72WxSUoTV4ubMdvM_a784J4k2eiK9AQ@mail.gmail.com>
 <20140421155424.GD23945@atomide.com>
 <53556AF1.2030608@gmail.com>
 <20140421202546.GA26554@atomide.com>
 <20140422030528.GB26554@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422030528.GB26554@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [140421 20:06]:
> * Tony Lindgren <tony@atomide.com> [140421 13:26]:
> > * Rob Herring <robherring2@gmail.com> [140421 12:01]:
> > > Something like this is what you had in mind?
... 
> > > --- a/drivers/of/irq.c
> > > +++ b/drivers/of/irq.c
> > > @@ -400,6 +400,26 @@ int of_irq_to_resource(struct device_node *dev, int
> > > index, struct resource *r)
> > >  EXPORT_SYMBOL_GPL(of_irq_to_resource);
> > > 
> > >  /**
> > > + * of_irq_get - Decode a node's IRQ and return it as a Linux irq number
> > > + * @dev: pointer to device tree node
> > > + * @index: zero-based index of the irq
> > > + *
> > > + * Returns Linux irq number on success, or -EPROBE_DEFER if the irq domain
> > > + * is not yet created.
> > > + *
> > > + */
> > > +int of_irq_get(struct device_node *dev, int index)
> > > +{
> > > +	int irq = irq_of_parse_and_map(dev, index);
> > > +
> > > +	if (!irq && of_find_irq_domain(dev, index) == NULL)
> > > +		return -EPROBE_DEFER;
> > > +
> > > +	return irq;
> > > +}
> > 
> > Yeah something like that. That might also work as a pretty
> > minimal fix as long as we fix the known broken drivers to use
> > platform_get_irq().
> 
> Actually, the above code for of_irq_get() won't help as we're still
> calling irq_of_parse_and_map() before we should. So the nasty warnings
> are still there if the irqdomain is not yet found.

OK so to fix the warning part of the problem we first need to not
try to map uninitialized irqdomains and then downgrade the current
warning to a dev_dbg.

So looks like the current minimal fix to my original problem the
first patch from Jean-Jacques in this series, and the following patch.

This works for drivers that currently do of_irq_parse_and_map(),
then your patch is also needed to make things work properly with
platform_get_irq().

8< ------------------
From: Tony Lindgren <tony@atomide.com>
Date: Mon, 21 Apr 2014 19:33:43 -0700
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

This is because we're wrongly trying to populate resources that are not
yet available. It's perfectly valid to create irqchips dynamically, so
let's fix up the issue by populating the interrupt resources at the
driver probe time instead.

Let's fix the problem by using of_find_irq_domain() recently introduced
by Jean-Jacques Hiblot <jjhiblot@traphandler.com>. This way we can
avoid calling irq_of_parse_and_map() unnecesssarily with incomplete
data.

And then we also need to accept the fact that some irqdomains do not
exist that early on, and only get initialized later on. So we can
make the current WARN_ON into just into a pr_debug().

Note that this patch only solves the problem for drivers that are
currently doing of_irq_parse_and_map(). A follow-up patch is needed
to make platform_get_irq() to work without relying on the populated
resources.

Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -425,13 +425,17 @@ int of_irq_count(struct device_node *dev)
 int of_irq_to_resource_table(struct device_node *dev, struct resource *res,
 		int nr_irqs)
 {
-	int i;
+	int i, found = 0;
 
-	for (i = 0; i < nr_irqs; i++, res++)
+	for (i = 0; i < nr_irqs; i++, res++) {
+		if (!of_find_irq_domain(dev, i))
+			continue;
 		if (!of_irq_to_resource(dev, i, res))
 			break;
+		found++;
+	}
 
-	return i;
+	return found;
 }
 EXPORT_SYMBOL_GPL(of_irq_to_resource_table);
 
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -168,7 +168,9 @@ struct platform_device *of_device_alloc(struct device_node *np,
 			rc = of_address_to_resource(np, i, res);
 			WARN_ON(rc);
 		}
-		WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
+		if (of_irq_to_resource_table(np, res, num_irq) != num_irq)
+			pr_debug("not all legacy IRQ resources mapped for %s\n",
+				 np->name);
 	}
 
 	dev->dev.of_node = of_node_get(np);
