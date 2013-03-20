Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3CTRXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:23:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51610 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750902Ab3CTRXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:23:14 -0400
Date: Wed, 20 Mar 2013 13:23:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Kosina <jkosina@suse.cz>
cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>, Greg KH <greg@kroah.com>,
        Harald Arnesen <skogtun.linux@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Meyer <thomas@m3y3r.de>, Shawn Starr <shawn.starr@rogers.com>,
        USB list <linux-usb@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Imre Deak <imre.deak@intel.com>,
        Daniel Kurtz <djkurtz@chromium.org>, <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        <x86@kernel.org>, Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: gm45 intel gfx can generate non-MSI irq# in MSI mode (was Re:
 [PATCH] drm/i915: stop using GMBUS IRQs on Gen4 chips (was Re: [3.9-rc1]
 irq 16: nobody cared (was [3.9-rc1] very poor interrupt respo
In-Reply-To: <alpine.LNX.2.00.1303201728070.17295@pobox.suse.cz>
Message-ID: <Pine.LNX.4.44L0.1303201319190.1208-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Mar 2013, Jiri Kosina wrote:

> > I don't know of any way.  In fact, I have been thinking of writing a 
> > test driver module, with a module parameter telling it which IRQ number 
> > to register for.  It seems like the sort of thing that would be useful 
> > to have, from time to time.
> 
> Ok, so how about this?
> Daniel, is it enough to make the problem appear on your system (by 
> building this into the kernel and booting with dummy-irq.irq=16)?
> 
> Thanks.
> 
> 
> 
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] dummy-irq: introduce a dummy IRQ handler driver
> 
> This module accepts a single 'irq' parameter, which it should register for.
> 
> Its sole purpose is to help with debugging of IRQ sharing problems, by
> force-enabling IRQ that would otherwise be disabled.
> 
> Suggested-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

This is just what I was thinking of.  Three extremely minor 
suggestions...

> +static irqreturn_t dummy_interrupt(int irq, void *dev_id)
> +{
> +	static int count = 0;
> +
> +	if (count == 0) {
> +		printk("dummy-irq: interrupt occured on IRQ %d\n", irq);

You probably should put a severity level here.  KERN_INFO?

> +		count++;
> +	}
> +
> +	return IRQ_NONE;
> +}
> +
> +static int __init dummy_irq_init(void)
> +{
> +	if (request_irq(irq, &dummy_interrupt, IRQF_SHARED, "dummy_irq", &irq)) {
> +		printk(KERN_ERR "dummy-irq: cannot register IRQ %d\n", irq);
> +		return -EIO;
> +	}
> +	printk(KERN_INFO "dummy-irq: registered for IRQ %d\n", irq);
> +	return 0;
> +}
> +
> +static void __exit dummy_irq_exit(void)
> +{
> +	printk(KERN_INFO "dummy-irq unloaded\n");
> +	free_irq(irq, &irq);
> +	return;

A return statement isn't needed here.

> +}
> +
> +module_init(dummy_irq_init);
> +module_exit(dummy_irq_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Jiri Kosina");
> +module_param_named(irq, irq, uint, 0444);

module_param is good enough when the parameter's name is the same as 
the variable's name.

> +MODULE_PARM_DESC(irq, "The IRQ to register for");

Alan Stern

