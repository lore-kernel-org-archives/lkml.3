Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbaIRV2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 17:28:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33824 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756518AbaIRV2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 17:28:40 -0400
Date: Thu, 18 Sep 2014 23:28:37 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wenyou Yang <wenyou.yang@atmel.com>
Subject: Re: [PATCH] ARM: at91: sama5: configure L2 cache
Message-ID: <20140918212836.GD29620@piout.net>
References: <1411072716-20769-1-git-send-email-alexandre.belloni@free-electrons.com>
 <20140918210212.GD5182@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140918210212.GD5182@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/09/2014 at 22:02:12 +0100, Russell King - ARM Linux wrote :
> On Thu, Sep 18, 2014 at 10:38:36PM +0200, Alexandre Belloni wrote:
> > From: Wenyou Yang <wenyou.yang@atmel.com>
> > 
> > Ensure that the L2 cache configuration is optimal to avoid depending on the
> > bootloader to set it correctly.
> > 
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > ---
> >  arch/arm/mach-at91/board-dt-sama5.c | 47 ++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 46 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
> > index 548de4ad6937..7cbe0d9daf2b 100644
> > --- a/arch/arm/mach-at91/board-dt-sama5.c
> > +++ b/arch/arm/mach-at91/board-dt-sama5.c
> > @@ -13,12 +13,14 @@
> >  #include <linux/gpio.h>
> >  #include <linux/micrel_phy.h>
> >  #include <linux/of.h>
> > +#include <linux/of_address.h>
> >  #include <linux/of_irq.h>
> >  #include <linux/of_platform.h>
> >  #include <linux/phy.h>
> >  #include <linux/clk-provider.h>
> >  
> >  #include <asm/setup.h>
> > +#include <asm/hardware/cache-l2x0.h>
> >  #include <asm/irq.h>
> >  #include <asm/mach/arch.h>
> >  #include <asm/mach/map.h>
> > @@ -35,8 +37,52 @@ static void __init sama5_dt_timer_init(void)
> >  	at91sam926x_pit_init();
> >  }
> >  
> > +static void __init at91_l2x0_init(void)
> > +{
> > +	struct device_node *np;
> > +	void __iomem *l2cc_base;
> > +	u32 reg;
> > +
> > +	np = of_find_compatible_node(NULL, NULL, "arm,pl310-cache");
> > +	if (!np)
> > +		return;
> > +
> > +	l2cc_base = of_iomap(np, 0);
> > +	of_node_put(np);
> > +
> > +	if (!l2cc_base) {
> > +		pr_err("L2C-310 unable to map registers\n");
> > +		return;
> > +	}
> > +
> > +	/* Prefetch Control */
> > +	reg = readl_relaxed(l2cc_base + L310_PREFETCH_CTRL);
> > +	reg &= ~L310_PREFETCH_CTRL_OFFSET_MASK;
> > +	reg |= 0x01 & L310_PREFETCH_CTRL_OFFSET_MASK;
> > +	reg |= L310_PREFETCH_CTRL_DBL_LINEFILL_INCR;
> > +	reg |= L310_PREFETCH_CTRL_PREFETCH_DROP;
> > +	reg |= L310_PREFETCH_CTRL_DATA_PREFETCH;
> > +	reg |= L310_PREFETCH_CTRL_INSTR_PREFETCH;
> > +	reg |= L310_PREFETCH_CTRL_DBL_LINEFILL;
> > +	writel_relaxed(reg, l2cc_base + L310_PREFETCH_CTRL);
> > +
> > +	/* Power Control */
> > +	reg = readl_relaxed(l2cc_base + L310_POWER_CTRL);
> > +	reg |= L310_STNDBY_MODE_EN;
> > +	reg |= L310_DYNAMIC_CLK_GATING_EN;
> > +	writel_relaxed(reg, l2cc_base + L310_POWER_CTRL);
> > +
> > +	/* Disable interrupts */
> > +	writel_relaxed(0x00, l2cc_base + L2X0_INTR_MASK);
> > +	writel_relaxed(0x01ff, l2cc_base + L2X0_INTR_CLEAR);
> > +
> > +	l2x0_of_init(0, ~0UL);
> 
> NAK.  Really, nak.  Stop this mentality of working around shortcomings
> of generic code by adding yet more platform junk.  Such approaches are
> not acceptable.
> 

Thank you for that confirmation, that was the main reason to Cc you.

> The power control is already done by generic code.  I know that you've
> developed the above code against the exact copy of generic code which
> has this, because you're using the new symbols.
> 

Yeah I actually forgot to remove that part when "porting" from vendor
code to use your defines.

> You shouldn't need to disable interrupts; the interrupts should already
> be disabled unless your bootloaders are doing something weird with them.
> 
> There have been DT bindings proposed for prefetch control register.  I
> suggest that you search this mailing list for that patch, and check
> whether it is acceptable for your platform.
> 

I'm really wondering whether we should really put that in the device
tree... We will soon end up with a property for each bit of each
registers and the binding will end up being huge. Also, that is
configuration, not HW description.

I actually tried multiple things, without any satisfaction:
 - using DT, with the main issue that we will definitely end up with one
   property per bit of configuration

 - adding an .l2c_prefetch_val to the machine start but that is kind of
   ugly.

 - adding a new parameter to l2x0_of_init()

So I ended up choosing to do it in the platform code. But if everybody
is fine with adding more properties to DT, I can go that way.

> Taking all that together, you should need /zero/ code in your platform
> for L2 caches, which is *the way it should be*.
> 

I would also prefer it that way.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
