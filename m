Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbaDWPeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:34:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:9174 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbaDWPef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:34:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,912,1389772800"; 
   d="scan'208";a="498124397"
Message-ID: <1398267228.11914.253.camel@smile.fi.intel.com>
Subject: Re: [PATCH] pinctrl-baytrail: workaround for irq descriptor
 conflict on ASUS T100TA
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "Jin, Yao" <yao.jin@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Krogerus, Heikki" <heikki.krogerus@intel.com>
Date: Wed, 23 Apr 2014 18:33:48 +0300
In-Reply-To: <5357A594.6050404@linux.intel.com>
References: <1397443272-31467-1-git-send-email-yao.jin@linux.intel.com>
	 <534B4C6D.5070003@linux.intel.com>
	 <CACRpkdYXD-Fd0tFJtir8ifsTqdBvA0Rznc4Hmzoq_ByBjTahdw@mail.gmail.com>
	 <5357A594.6050404@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-23 at 14:35 +0300, Mathias Nyman wrote:
> >
> > Urgent fix and the maintainers did not react in a week? Well maybe they need
> > to be on the To: line...
> >
> > Mathias: can you send a patch adding yourself as maintainer of this
> > driver in the MAINTAINERS file so stuff like this does not fall to the
> > floor (me)?
> >
> 
> Hi,
> 
> Sorry about the delay. I'm taking over Sarah's role as usb3 xhci 
> maintainer and got my hands full over there. I can look at these
> patches now and then but you might need to kick me.
> 
> In general, I'd agree with Mika, Andy and Heikki (and Rafael obviously) 
> opinion regarding baytrail gpio / acpi related matters.

This patch and discussion reminds me an old one where I was trying to
solve quite similar issue on Medfield [1], in particular [2, and 3]. For
my opinion irq mapping framework should be redesigned to solve the issue
regarding to devices which require fixed interrupt lines.

[1] https://lkml.org/lkml/2012/7/5/152
[2] https://lkml.org/lkml/2012/7/5/155
[3] https://lkml.org/lkml/2012/7/16/173
> 
> > Second: this fix is ugly like hell, is it really the best we can think
> > of, plus in the commit message I'd very much like to know the
> > real issue behind this as people in the x86 camp seem to be
> > using some strange static IRQ line assignments that I cannot
> > really understand so I don't know what the proper fix for this is :-(
> >
> 
> This patch went out a bit early, a new version (which is not mangled) 
> can be found at:
> 
> http://marc.info/?l=linux-kernel&m=139765010717522&w=2
> 
> But that one still produces some compiler warning which should be fixed.
> 
> There might be some touchscreen related issues recently found related to 
> this patch that need to be investigated ( see bug link in commit message)
> 
> This is a hack to get T100TA working. This is one of many bad ways to 
> workaround the real issue instead of fixing it, and I hope it can be 
> reverted later, but this is the best we can do with our (my) limited 
> io-apic and interrupt knowledge. But in the end, with this the Asus 
> T100TA gpio works somehow, without it, it doesn't.
> 
> The real issue to my understanding is that the x86 io-apic code is not 
> really capable of living together with other interrupt controllers at 
> the same time. There are some assumptions that interrupts 0-15 belong to 
> the legacy ISA world, from there on we got io-apic PCI interrupts
> ( I think io-apic interrupt controller handles something like 24 - 48 
> interrupts?) we want to be outside that range until this is fixed.
> 
> The x86 io-apic code does nasty things, for example the function
> that allocates the irq and the private chip data assumes that if the irq 
> descriptor is taken, (returns -EEXISTS) then io-apic just must have 
> reserved it earlier and can anyway use it, and access the chip data in a 
> format only io-apic (struct irq_cfg) uses. This is of course not the 
> case if a gpio interrupt controller like pinctrl-baytrail reserved the 
> interrupt descriptor earler.  -> oops
> 
> here's the io_apic.c function:
> 
> static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
> {
>   	int res = irq_alloc_desc_at(at, node);
>          struct irq_cfg *cfg;
> 
>          if (res < 0) {
>                  if (res != -EEXIST)
>                          return NULL;
>                  cfg = irq_get_chip_data(at);
>                  if (cfg)
>                          return cfg;
>          }
> 
>          cfg = alloc_irq_cfg(at, node);
> 	if (cfg)
>                  irq_set_chip_data(at, cfg);
>          else
>              	irq_free_desc(at);
>          return cfg;
> }
> 
> We tried to fix this particular issue (make sure the interrupt belongs 
> to a io_apic controller before letting io_apic touch it), but we just 
> opened a can of worms of other issues I don't know how to deal with.
> 
> -Mathias
> 


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

