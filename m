Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaJMTvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 15:51:48 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:52121 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaJMTvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 15:51:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "Joe.C" <yingjoe.chen@mediatek.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "arm@kernel.org" <arm@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        "yingjoe.chen@gmail.com" <yingjoe.chen@gmail.com>,
        "hc.yen@mediatek.com" <hc.yen@mediatek.com>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        "nathan.chung@mediatek.com" <nathan.chung@mediatek.com>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        Pawel Moll <Pawel.Moll@arm.com>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Matt Porter <mporter@linaro.org>, Marc Carino <marc.ceeeee@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sricharan R <r.sricharan@ti.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/7] irqchip: gic: Support hierarchy irq domain.
Date: Mon, 13 Oct 2014 21:51:18 +0200
Message-ID: <4904191.xcTM1nFGH7@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <543BC138.3010109@arm.com>
References: <1412864980-20273-1-git-send-email-yingjoe.chen@mediatek.com> <1413196996.23455.9.camel@mtksdaap41> <543BC138.3010109@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:jAzGNtAHrm6/GpV/A74LccG4E77avsFkZ+FXkESKGnx
 XK4hchTxjiOK+vbAQqZz0yty3y1AJK8K0qIPspvxzSPuv9dIhT
 JDe843a2YqvuQfU+iuSen5PPy368B4bVrjw6Ez0yDOsLDB4Hcs
 wiE5eM3Vu44x1P9Zu00mMlc8M3Hds4EvATld6d+ngEMIAHyG99
 zQEV1X7oUdBQt57cr3ixGtH6NZfjy/sFwZ+amH5Wdkx5IF+m1w
 TLGRvE3fWkWqHj6lp8avdNKBwaQ66EZiosJivfvGfSfSq7DhXN
 c7hnLM9L00rjQ7W3M5djA7OnBYIy7nAx4Xkj6XCFcxuz9g/z1p
 /j0/aUazxscrDrN/QL9w=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 October 2014 13:10:32 Marc Zyngier wrote:
> On 13/10/14 11:43, Joe.C wrote:
> > On Thu, 2014-10-09 at 17:59 +0100, Marc Zyngier wrote:
> >> On 09/10/14 15:29, Joe.C wrote
> >>> @@ -952,7 +988,11 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
> >>>  
> >>>     gic_irqs -= hwirq_base; /* calculate # of irqs to allocate */
> >>>  
> >>> -   if (of_property_read_u32(node, "arm,routable-irqs",
> >>> +   if (IS_ENABLED(CONFIG_IRQ_DOMAIN_HIERARCHY) &&
> >>> +           of_find_property(node, "arm,irq-domain-hierarchy", NULL))
> >>> +           gic->domain = irq_domain_add_linear(node, gic_irqs,
> >>> +                                   &gic_irq_domain_hierarchy_ops, gic);
> >>
> >> I really think that looking for a property is the wrong thing to do. If
> >> "node" is non-NULL, then we're pretty sure that we're initializing from
> >> DT, and that a pure linear domain should be the right thing, leaving the
> >> legacy stuff for the few non-DT platforms that are still around.
> >>
> >> Thanks,
> >>
> >>      M.
> > 
> > The only reason I introduce "arm,irq-domain-hierarchy" property is
> > trying to keep original behavior when hierarchy irq domain is not used.
> > Without this, when a board init GIC with DT, all driver will have to use
> > devicetree. I'm not sure we want to break things like this.
> 
> I don't think we want to support a "middle of the road" setup, where the
> GIC is probed by DT, but some devices have hardcoded interrupts.

Agreed. We should work on making GIC DT-only by converting the few remaining
users instead, and certainly should not add any new board files that
might use the domain hierarchy code.

	Arnd
