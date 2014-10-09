Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaJIRXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:23:36 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:61028 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaJIRX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:23:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, "Joe.C" <yingjoe.chen@mediatek.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sricharan R <r.sricharan@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "yingjoe.chen@gmail.com" <yingjoe.chen@gmail.com>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>,
        "arm@kernel.org" <arm@kernel.org>,
        "nathan.chung@mediatek.com" <nathan.chung@mediatek.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <Pawel.Moll@arm.com>,
        Matt Porter <mporter@linaro.org>, Marc Carino <marc.ceeeee@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        "hc.yen@mediatek.com" <hc.yen@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [PATCH v3 3/7] irqchip: gic: Support hierarchy irq domain.
Date: Thu, 09 Oct 2014 19:22:29 +0200
Message-ID: <3400038.iFbzPVHU3g@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5436BF0C.1030508@arm.com>
References: <1412864980-20273-1-git-send-email-yingjoe.chen@mediatek.com> <1412864980-20273-4-git-send-email-yingjoe.chen@mediatek.com> <5436BF0C.1030508@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:IyZYmvckYbRgE4M/6qKRmdts65ro+sk9g9L9SC/TfbP
 w0eCQxH1diRAW6Gr9FAtJQA2CGJMWOYZZ8kJqgc9kToYG1p6+a
 EnlqK5W6jsTETOJtdlBTHEzrH3t6DehVDOYLO29n1DJSGpZb8n
 t0eRdn2zgTVfV4JWXvD3hD4AVJtebmDuQOo6pL4E98M0ELTYmA
 wj2OGdRmAitcRwWtVrrxi8KXJvp5M7qoZZq7F7HXn/QDuMFOeM
 f9zmLLVBit0TdFCmUO6R+yQAWFd34MDMGBTFNCLJ9qjivCB3MA
 afKhuDtElE/eLdVSGbeFwjYDUHNWyZjse2T396BOKx298XzMxd
 EDYxqXRqYG1sJVsqnEhw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 October 2014 17:59:56 Marc Zyngier wrote:
> > @@ -952,7 +988,11 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
> >  
> >       gic_irqs -= hwirq_base; /* calculate # of irqs to allocate */
> >  
> > -     if (of_property_read_u32(node, "arm,routable-irqs",
> > +     if (IS_ENABLED(CONFIG_IRQ_DOMAIN_HIERARCHY) &&
> > +             of_find_property(node, "arm,irq-domain-hierarchy", NULL))
> > +             gic->domain = irq_domain_add_linear(node, gic_irqs,
> > +                                     &gic_irq_domain_hierarchy_ops, gic);
> 
> I really think that looking for a property is the wrong thing to do. If
> "node" is non-NULL, then we're pretty sure that we're initializing from
> DT, and that a pure linear domain should be the right thing, leaving the
> legacy stuff for the few non-DT platforms that are still around.

FWIW, these are the remaining ones that use gic:

arch/arm/mach-cns3xxx/core.c:   gic_init(0, 29, IOMEM(CNS3XXX_TC11MP_GIC_DIST_BASE_VIRT),
arch/arm/mach-realview/realview_eb.c:           gic_init(0, 29, __io_address(REALVIEW_EB11MP_GIC_DIST_BASE),
arch/arm/mach-realview/realview_eb.c:           gic_init(1, 96, __io_address(REALVIEW_EB_GIC_DIST_BASE),
arch/arm/mach-realview/realview_eb.c:           gic_init(0, 29, __io_address(REALVIEW_EB_GIC_DIST_BASE),
arch/arm/mach-realview/realview_pb1176.c:       gic_init(0, IRQ_DC1176_GIC_START,
arch/arm/mach-realview/realview_pb1176.c:       gic_init(1, IRQ_PB1176_GIC_START,
arch/arm/mach-realview/realview_pb11mp.c:       gic_init(0, 29, __io_address(REALVIEW_TC11MP_GIC_DIST_BASE),
arch/arm/mach-realview/realview_pb11mp.c:       gic_init(1, IRQ_PB11MP_GIC_START,
arch/arm/mach-realview/realview_pba8.c: gic_init(0, IRQ_PBA8_GIC_START,
arch/arm/mach-realview/realview_pbx.c:          gic_init(0, 29, __io_address(REALVIEW_PBX_TILE_GIC_DIST_BASE),
arch/arm/mach-realview/realview_pbx.c:          gic_init(0, IRQ_PBX_GIC_START,
arch/arm/mach-shmobile/intc-sh73a0.c:   gic_init(0, 29, gic_dist_base, gic_cpu_base);
arch/arm/mach-tegra/irq.c:              gic_init(0, 29, distbase,
arch/arm/mach-vexpress/ct-ca9x4.c:      gic_init(0, 29, ioremap(A9_MPCORE_GIC_DIST, SZ_4K),

Linus Walleij is working on realview, Pawel already has a patch for vexpress, the tegra one
can just be removed and the Renesas team will deal with shmobile.

This basically leaves cns3xxx, which now has a new maintainer but I suspect we won't
have DT-only support for it too soon anyway.

	Arnd
