Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaFBKAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:00:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38379 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752990AbaFBKAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:00:52 -0400
Date: Mon, 2 Jun 2014 12:00:48 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] ARM: berlin: add SMP support
Message-ID: <20140602100048.GA12162@kwain>
References: <1401700866-24804-1-git-send-email-antoine.tenart@free-electrons.com>
 <1401700866-24804-2-git-send-email-antoine.tenart@free-electrons.com>
 <20140602094715.GG28090@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140602094715.GG28090@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Mon, Jun 02, 2014 at 11:47:15AM +0200, Andrew Lunn wrote:
> On Mon, Jun 02, 2014 at 11:21:02AM +0200, Antoine Ténart wrote:
> > +
> > +static inline void berlin_reset_cpu(unsigned int cpu)
> > +{
> > +	u32 val;
> > +
> > +	val = readl(cpu_ctrl + CPU_RESET);
> > +	val |= BIT(cpu_logical_map(cpu));
> > +	writel(val, cpu_ctrl + CPU_RESET);
> > +}
> 
> Is this performing a reset on the CPU, or is it taking it out of reset?
> 
> If you are going to implement CPU hotplug at some point, you are going
> to want to be able to put the CPU into reset, i.e. power it off, and
> take it out of reset, i.e. power it on and getting it running. So it
> might help if we get these function names clear now.

It is performing a reset on the CPU. berlin_perform_reset_cpu() then?

> > +
> > +static void __init berlin_smp_prepare_cpus(unsigned int max_cpus)
> > +{
> > +	struct device_node *np;
> > +	void __iomem *scu_base;
> > +	void __iomem *vectors_base;
> > +
> > +	np = of_find_compatible_node(NULL, NULL, "arm,cortex-a9-scu");
> > +	scu_base = of_iomap(np, 0);
> > +	of_node_put(np);
> > +	if (!scu_base)
> > +		return;
> > +
> > +	np = of_find_compatible_node(NULL, NULL, "marvell,berlin-cpu-ctrl");
> > +	cpu_ctrl = of_iomap(np, 0);
> > +	of_node_put(np);
> > +	if (!cpu_ctrl)
> > +		goto unmap_scu;
> > +
> > +	vectors_base = ioremap(CONFIG_VECTORS_BASE, SZ_32K);
> > +	if (!vectors_base)
> > +		goto unmap_scu;
> > +
> > +	scu_enable(scu_base);
> > +	flush_cache_all();
> > +
> > +	/*
> > +	 * Write the first instruction the CPU will execute after being reseted
> > +	 * in the reset exception register.
> > +	 */
> > +	writel(boot_inst, vectors_base + RESET_VECT);
> > +
> > +	/*
> > +	 * Write the secondary startup address into the SW reset address
> > +	 * register. This is used by boot_inst.
> 
> Maybe it would be better to call this the reset address vector instead
> of address register. It is in the vector space after all.

I don't have a strong opinion on this. I can update the 'reset exception
register' as well then.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
