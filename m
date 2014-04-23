Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbaDWWDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 18:03:10 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:44730 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaDWWDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 18:03:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140422045730.GC26554@atomide.com>
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
	<20140422045730.GC26554@atomide.com>
Date: Wed, 23 Apr 2014 17:03:05 -0500
Message-ID: <CAL_JsqJf42z3uooHrxdW1C0tDsOiacPnfQgF_X7dFvDy80p2dg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] dt: platform driver: Fill the resources before
 probe and defer if needed
From: Rob Herring <robherring2@gmail.com>
To: Tony Lindgren <tony@atomide.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 11:57 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Tony Lindgren <tony@atomide.com> [140421 20:06]:
>> * Tony Lindgren <tony@atomide.com> [140421 13:26]:
>> > * Rob Herring <robherring2@gmail.com> [140421 12:01]:

[...]

> 8< ------------------
> From: Tony Lindgren <tony@atomide.com>
> Date: Mon, 21 Apr 2014 19:33:43 -0700
> Subject: [PATCH] of/platform: Fix no irq domain found errors when populating interrupts
>
> Currently we get the following kind of errors if we try to use interrupt
> phandles to irqchips that have not yet initialized:
>
> irq: no irq domain found for /ocp/pinmux@48002030 !
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1 at drivers/of/platform.c:171 of_device_alloc+0x144/0x184()
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-00038-g42a9708 #1012
> (show_stack+0x14/0x1c)
> (dump_stack+0x6c/0xa0)
> (warn_slowpath_common+0x64/0x84)
> (warn_slowpath_null+0x1c/0x24)
> (of_device_alloc+0x144/0x184)
> (of_platform_device_create_pdata+0x44/0x9c)
> (of_platform_bus_create+0xd0/0x170)
> (of_platform_bus_create+0x12c/0x170)
> (of_platform_populate+0x60/0x98)
>
> This is because we're wrongly trying to populate resources that are not
> yet available. It's perfectly valid to create irqchips dynamically, so
> let's fix up the issue by populating the interrupt resources at the
> driver probe time instead.
>
> Let's fix the problem by using of_find_irq_domain() recently introduced
> by Jean-Jacques Hiblot <jjhiblot@traphandler.com>. This way we can
> avoid calling irq_of_parse_and_map() unnecesssarily with incomplete
> data.
>
> And then we also need to accept the fact that some irqdomains do not
> exist that early on, and only get initialized later on. So we can
> make the current WARN_ON into just into a pr_debug().
>
> Note that this patch only solves the problem for drivers that are
> currently doing of_irq_parse_and_map(). A follow-up patch is needed
> to make platform_get_irq() to work without relying on the populated
> resources.
>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
>
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -425,13 +425,17 @@ int of_irq_count(struct device_node *dev)
>  int of_irq_to_resource_table(struct device_node *dev, struct resource *res,
>                 int nr_irqs)
>  {
> -       int i;
> +       int i, found = 0;
>
> -       for (i = 0; i < nr_irqs; i++, res++)
> +       for (i = 0; i < nr_irqs; i++, res++) {
> +               if (!of_find_irq_domain(dev, i))
> +                       continue;

I don't think this is necessary. We either need to resolve all
interrupts or none. Having some of them resolved does not help us. The
following line will catch the latter case. I'll send out a full proper
series soon.

>                 if (!of_irq_to_resource(dev, i, res))
>                         break;
> +               found++;
> +       }
