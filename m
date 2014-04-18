Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbaDRUzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 16:55:22 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51872 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbaDRUzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 16:55:18 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19c39t4wBYrbnMGTRN/Vw2j
Date: Fri, 18 Apr 2014 13:55:11 -0700
From: Tony Lindgren <tony@atomide.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Paul Walmsley <paul@pwsan.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when
 populating interrupts
Message-ID: <20140418205510.GB21823@atomide.com>
References: <20140410213808.GA5990@atomide.com>
 <CAL_JsqL4-gnMWaR_G_Bpk8Yiyopnx0x6gkJtpNkF3+TTkC-nYg@mail.gmail.com>
 <20140411184306.GC3673@mithrandir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140411184306.GC3673@mithrandir>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thierry Reding <thierry.reding@gmail.com> [140411 11:46]:
> On Thu, Apr 10, 2014 at 07:29:36PM -0500, Rob Herring wrote:
> > On Thu, Apr 10, 2014 at 4:38 PM, Tony Lindgren <tony@atomide.com> wrote:
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
> > 
> > There is a newer solution here which Grant seemed happier with:
> > 
> > http://lkml.iu.edu/hypermail/linux/kernel/1403.2/03666.html
> 
> I wonder why Grant seems to be happier with that solution than with my
> original proposal. That new solution does essentially the same thing.
> One of the main issues raised during review of my original proposal was
> that it had to modify the core, but this new solution does that as well.
> 
> Another thing that people weren't happy about was that my solution was
> more intrusive because it required a bunch of changes to the of_irq_*()
> helpers to make them propagate a proper error code. The new solution
> doesn't do that, but instead works around the lack of proper error
> propagation by trying to find an IRQ domain (which the of_irq_*()
> helpers will do anyway).

Yeah the problem I see with the patches above is that there's
nothing wrong with the irq subsystem. Replied along those lines to
the thread above.

Cheers,

Tony
