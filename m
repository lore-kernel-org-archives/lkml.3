Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbaIYO1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:27:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:33860 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbaIYO1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:27:44 -0400
Date: Thu, 25 Sep 2014 16:27:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Joe.C" <srv_yingjoe.chen@mediatek.com>
cc: Jiang Liu <jiang.liu@linux.intel.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, srv_heupstream@mediatek.com,
        yingjoe.chen@gmail.com, hc.yen@mediatek.com, eddie.huang@mediatek.com,
        nathan.chung@mediatek.com, yh.chen@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH] [RFC] Using hierarchy irqdomian to implement MTK
 intpol.
In-Reply-To: <1411574696-1881-1-git-send-email-srv_yingjoe.chen@mediatek.com>
Message-ID: <alpine.DEB.2.10.1409251609500.4604@nanos>
References: <1411574696-1881-1-git-send-email-srv_yingjoe.chen@mediatek.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014, Joe.C wrote:
> From: "Joe.C" <yingjoe.chen@mediatek.com>
> 
> Here's the first draft of using hierarchy irqdomain to implement MTK intpol
> support. I have tested it and intpol works fine. Before continue, I'd like
> to get your comments. This is based on Jiang's hierarchy irqdomian [1] and
> my mediatek SoC basic support [2].
> 
> Simplified block diagram for interrupt:
> 
>     ---------      ---------
>  ---| CIRQ  |------|ARM GIC|
>  ---|       |------|       |
>  ---|       |------|       |
>  ---|       |------|       |
>  ---|       |------|       |
>     ---------      ---------
>  
> In device tree, interrupt-parent for other devices is cirq, child of gic.
> This describe HW better and allow device to specify polarity as it is sent
> by the device. I'm using interrupt-parent to specify irq domain parent in
> cirq now. Maybe adding another name like 'interrupt-domain-parent' will be
> better.

I leave that to the DT folks.
 
> Currently only set_type is implement in CIRQ, but I think this could extended
> to cover all function gic_arch_extn provided.

Right. Marc, can you have a look at this whether you can see how that
might replace the rest of the arch_extn hackery?

At least the avoidance of the set_type mess looks pretty reasonable.
 
> In order to use hierarchy irq domain, gic can't use legacy irq domain anymore.
> If arm,hierarchy-irq-domain property is specified, GIC will work in hierarchy
> way and all interrupt must be set by device tree.
> 
> One thing worth mention is arg in irq_domain_alloc_irqs. On x86, msi is using
> struct irq_alloc_info, to pass data between irq domain. In irq_create_of_mapping(),
> of_phandle_args is used. All allocs in irq_domain chain will need to use same
> interrupt-cells formats.

Right, but we leave that to the architecture implementation. It needs
to be consistent within an architecture, so we should change the "void
*arg" to a well defined type. For OF architectures this would be
of_phandle_args, other architectures can define their own struct type
which allows to transport data between the domains. That ensures
compile time type checking.

Thanks,

	tglx
