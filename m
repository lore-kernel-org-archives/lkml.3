Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaDWLYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:24:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:26527 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbaDWLYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:24:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,911,1389772800"; 
   d="scan'208";a="526060363"
Message-ID: <5357A594.6050404@linux.intel.com>
Date: Wed, 23 Apr 2014 14:35:48 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        "Jin, Yao" <yao.jin@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Krogerus, Heikki" <heikki.krogerus@intel.com>
Subject: Re: [PATCH] pinctrl-baytrail: workaround for irq descriptor conflict
 on ASUS T100TA
References: <1397443272-31467-1-git-send-email-yao.jin@linux.intel.com>	<534B4C6D.5070003@linux.intel.com> <CACRpkdYXD-Fd0tFJtir8ifsTqdBvA0Rznc4Hmzoq_ByBjTahdw@mail.gmail.com>
In-Reply-To: <CACRpkdYXD-Fd0tFJtir8ifsTqdBvA0Rznc4Hmzoq_ByBjTahdw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Urgent fix and the maintainers did not react in a week? Well maybe they need
> to be on the To: line...
>
> Mathias: can you send a patch adding yourself as maintainer of this
> driver in the MAINTAINERS file so stuff like this does not fall to the
> floor (me)?
>

Hi,

Sorry about the delay. I'm taking over Sarah's role as usb3 xhci 
maintainer and got my hands full over there. I can look at these
patches now and then but you might need to kick me.

In general, I'd agree with Mika, Andy and Heikki (and Rafael obviously) 
opinion regarding baytrail gpio / acpi related matters.

> Second: this fix is ugly like hell, is it really the best we can think
> of, plus in the commit message I'd very much like to know the
> real issue behind this as people in the x86 camp seem to be
> using some strange static IRQ line assignments that I cannot
> really understand so I don't know what the proper fix for this is :-(
>

This patch went out a bit early, a new version (which is not mangled) 
can be found at:

http://marc.info/?l=linux-kernel&m=139765010717522&w=2

But that one still produces some compiler warning which should be fixed.

There might be some touchscreen related issues recently found related to 
this patch that need to be investigated ( see bug link in commit message)

This is a hack to get T100TA working. This is one of many bad ways to 
workaround the real issue instead of fixing it, and I hope it can be 
reverted later, but this is the best we can do with our (my) limited 
io-apic and interrupt knowledge. But in the end, with this the Asus 
T100TA gpio works somehow, without it, it doesn't.

The real issue to my understanding is that the x86 io-apic code is not 
really capable of living together with other interrupt controllers at 
the same time. There are some assumptions that interrupts 0-15 belong to 
the legacy ISA world, from there on we got io-apic PCI interrupts
( I think io-apic interrupt controller handles something like 24 - 48 
interrupts?) we want to be outside that range until this is fixed.

The x86 io-apic code does nasty things, for example the function
that allocates the irq and the private chip data assumes that if the irq 
descriptor is taken, (returns -EEXISTS) then io-apic just must have 
reserved it earlier and can anyway use it, and access the chip data in a 
format only io-apic (struct irq_cfg) uses. This is of course not the 
case if a gpio interrupt controller like pinctrl-baytrail reserved the 
interrupt descriptor earler.  -> oops

here's the io_apic.c function:

static struct irq_cfg *alloc_irq_and_cfg_at(unsigned int at, int node)
{
  	int res = irq_alloc_desc_at(at, node);
         struct irq_cfg *cfg;

         if (res < 0) {
                 if (res != -EEXIST)
                         return NULL;
                 cfg = irq_get_chip_data(at);
                 if (cfg)
                         return cfg;
         }

         cfg = alloc_irq_cfg(at, node);
	if (cfg)
                 irq_set_chip_data(at, cfg);
         else
             	irq_free_desc(at);
         return cfg;
}

We tried to fix this particular issue (make sure the interrupt belongs 
to a io_apic controller before letting io_apic touch it), but we just 
opened a can of worms of other issues I don't know how to deal with.

-Mathias

