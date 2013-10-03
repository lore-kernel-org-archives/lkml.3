Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3JCPPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:15:37 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:57306 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab3JCPPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:15:34 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Andrew Lunn <andrew@lunn.ch>
CC: Jason Cooper <jason@lakedaemon.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 03 Oct 2013 17:15:05 +0200
Message-ID: <1417ee2ae58.2784.107cef0f820c2f5d7b7f41463071c310@gmail.com>
In-Reply-To: <20131003134724.GD20056@lunn.ch>
References: <1380804294-13726-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20131003134724.GD20056@lunn.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1 AquaMail/1.2.5.5 (build: 2100355)
Subject: Re: [PATCH 1/2] ARM: kirkwood: retain MAC address for DT ethernet
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On October 3, 2013 3:47:24 PM Andrew Lunn <andrew@lunn.ch> wrote:
> On Thu, Oct 03, 2013 at 02:44:53PM +0200, Sebastian Hesselbarth wrote:
> > Ethernet IP on Kirkwood SoCs loose their MAC address register content
> > if clock gated. To allow modular ethernet driver setups and gated clocks
> > also on non-DT capable bootloaders, we fixup port device nodes with no
> > valid MAC address property. This patch copies MAC address register
> > contents set up by bootloaders early, notably before ethernet clocks
> > are gated. While at it, also reorder call sequence in _dt_init.
> > Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> > ---
> > - Added Benjamin and Grant who where part of the discussion last time
> >   and gave valuable input on DT fixups.
> > - Patches are based on v3.12-rc1 and depend on latest mv643xx_eth
> >   fixes applied yesterday by David Miller [1].
> > [1] 
> https://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=569943d0639c85a451ea853087cbd5f738247dd9
> > Cc: Jason Cooper <jason@lakedaemon.net>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Cc: Grant Likely <grant.likely@linaro.org>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> > Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  arch/arm/mach-kirkwood/board-dt.c |   72 
> +++++++++++++++++++++++++++++++++++--
> >  1 file changed, 69 insertions(+), 3 deletions(-)
> > diff --git a/arch/arm/mach-kirkwood/board-dt.c 
> b/arch/arm/mach-kirkwood/board-dt.c
> > index 82d3ad8..a2974ad 100644
> > --- a/arch/arm/mach-kirkwood/board-dt.c
> > +++ b/arch/arm/mach-kirkwood/board-dt.c
> > @@ -13,6 +13,8 @@
> >  #include <linux/kernel.h>
> >  #include <linux/init.h>
> >  #include <linux/of.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_net.h>
> >  #include <linux/of_platform.h>
> >  #include <linux/clk-provider.h>
> >  #include <linux/clocksource.h>
> > @@ -66,6 +68,71 @@ static void __init kirkwood_legacy_clk_init(void)
> >  	clk_prepare_enable(clk);
> >  }
> > +#define MV643XX_ETH_MAC_ADDR_LOW	0x0414
> > +#define MV643XX_ETH_MAC_ADDR_HIGH	0x0418
> > +
> > +static void __init kirkwood_dt_eth_fixup(void)
> > +{
> > +	struct device_node *np;
> > +
> > +	/*
> > +	 * The ethernet interfaces forget the MAC address assigned by u-boot
> > +	 * if the clocks are turned off. Usually, u-boot on kirkwood boards
> > +	 * has no DT support to properly set local-mac-address property.
> > +	 * As a workaround, we get the MAC address from mv643xx_eth registers
> > +	 * and update the port device node if no valid MAC address is set.
> > +	 */
> > +	for_each_compatible_node(np, NULL, "marvell,kirkwood-eth-port") {
> > +		struct device_node *pnp = of_get_parent(np);
> > +		struct property *pmac;
> > +		void __iomem *io;
> > +		u8 *macaddr;
> > +		u32 reg;
> > +
> > +		if (!pnp || !of_device_is_available(pnp))
> > +			continue;
> > +
> > +		if (of_get_mac_address(np))
> > +			continue;
> > +
> > +		pr_err(FW_BUG "%s: local-mac-address is not set\n",
> > +		       np->full_name);
> > +
> > +		io = of_iomap(pnp, 0);
> > +		if (!io)
> > +			continue;
> > +
> > +		pmac = kzalloc(sizeof(*pmac) + 6, GFP_KERNEL);
> > +		if (!pmac) {
> > +			iounmap(io);
> > +			continue;
> > +		}
> > +
> > +		pmac->value = pmac + 1;
> > +		pmac->length = 6;
> > +		pmac->name = kstrdup("local-mac-address", GFP_KERNEL);
> > +		if (!pmac->name) {
> > +			kfree(pmac);
> > +			iounmap(io);
> > +			continue;
> > +		}
> > +
> > +		macaddr = pmac->value;
> > +		reg = readl(io + MV643XX_ETH_MAC_ADDR_HIGH);
> > +		macaddr[0] = (reg >> 24) & 0xff;
> > +		macaddr[1] = (reg >> 16) & 0xff;
> > +		macaddr[2] = (reg >> 8) & 0xff;
> > +		macaddr[3] = reg & 0xff;
>
> Hi Sebastian
>
> What happens if at this point, the ethernet clock is gated off?  I
> assume the CPU locks solid, requiring a power cycle.
>
> It would be a bit of an odd situation, u-boot has disabled the clock,
> yet we have a DT node for the device and no valid local-mac-address.
> We do however know that Jason Gunthorpe u-boot does gate the second
> ethernet for his board, so it is not completely impossible to hit this
> situation, particularly when bringing up a new board.
>
> Are we too early in the boot to actually use the clock information in
> the node to find it, and clk_prepare_enable() it before making the
> access?

Ccframework is up when calling this. I suggest to call clk_is_enabled and 
also skip the fixup if it isn't. Clk_prepare_enable ist quite useless, as 
register contents will suffer what this workaround is about. I send an 
updated v2 later but someone will have to test as I don't have kirkwood 
around till next week.

> 	Andrew



