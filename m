Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab3JGXbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 19:31:02 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:44111 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3JGXbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 19:31:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1381177511-1100-1-git-send-email-sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1380881842-24605-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1381177511-1100-1-git-send-email-sebastian.hesselbarth@gmail.com>
Message-ID: <20131007233052.7445.98714@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v4] ARM: kirkwood: retain MAC address for DT ethernet
Date: Mon, 07 Oct 2013 16:30:52 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sebastian Hesselbarth (2013-10-07 13:25:11)
> Ethernet IP on Kirkwood SoCs loose their MAC address register content
> if clock gated. To allow modular ethernet driver setups and gated clocks
> also on non-DT capable bootloaders, we fixup port device nodes with no
> valid MAC address property. This patch copies MAC address register
> contents set up by bootloaders early, notably before ethernet clocks
> are gated. While at it, also reorder call sequence in _dt_init.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Reviewed-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> Tested-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Mike Turquette <mturquette@linaro.org>

Regards,
Mike

> ---
> Just to make sure they don't get lost this time:
> Added Jason's and Ezequiel's Reviewed-by to honor their constant reviews,
> and Andrew's last Tested-by because I know he will be testing again.
> 
> Changelog:
> v3->v4:
> - drop clk_is_enabled (and dependency) due to possible abuse of the
>   new function; enable/disable clk instead, remove gated clock warning
>   (Suggested by Andrew Lunn, Uwe Kleine-Koenig, Mike Turquette)
> - reduce FW_BUG to FW_INFO (Suggested by Andrew Lunn)
> - proper cleanup of iomap, clk, nodes
> v2->v3:
> - make use of new public clk_is_enabled (adds dependency)
> - add warning about gated clock && missing MAC property
>   (Suggested by Jason Gunthorpe)
> v1->v2:
> - check for gated clock before accessing eth registers
>   (Suggested by Andrew Lunn)
> 
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-kirkwood/board-dt.c |   86 +++++++++++++++++++++++++++++++++++--
>  1 file changed, 83 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-kirkwood/board-dt.c b/arch/arm/mach-kirkwood/board-dt.c
> index 82d3ad8..3ddd194 100644
> --- a/arch/arm/mach-kirkwood/board-dt.c
> +++ b/arch/arm/mach-kirkwood/board-dt.c
> @@ -13,6 +13,8 @@
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_net.h>
>  #include <linux/of_platform.h>
>  #include <linux/clk-provider.h>
>  #include <linux/clocksource.h>
> @@ -66,6 +68,85 @@ static void __init kirkwood_legacy_clk_init(void)
>         clk_prepare_enable(clk);
>  }
>  
> +#define MV643XX_ETH_MAC_ADDR_LOW       0x0414
> +#define MV643XX_ETH_MAC_ADDR_HIGH      0x0418
> +
> +static void __init kirkwood_dt_eth_fixup(void)
> +{
> +       struct device_node *np;
> +
> +       /*
> +        * The ethernet interfaces forget the MAC address assigned by u-boot
> +        * if the clocks are turned off. Usually, u-boot on kirkwood boards
> +        * has no DT support to properly set local-mac-address property.
> +        * As a workaround, we get the MAC address from mv643xx_eth registers
> +        * and update the port device node if no valid MAC address is set.
> +        */
> +       for_each_compatible_node(np, NULL, "marvell,kirkwood-eth-port") {
> +               struct device_node *pnp = of_get_parent(np);
> +               struct clk *clk;
> +               struct property *pmac;
> +               void __iomem *io;
> +               u8 *macaddr;
> +               u32 reg;
> +
> +               if (!pnp)
> +                       continue;
> +
> +               /* skip disabled nodes or nodes with valid MAC address*/
> +               if (!of_device_is_available(pnp) || of_get_mac_address(np))
> +                       goto eth_fixup_skip;
> +
> +               clk = of_clk_get(pnp, 0);
> +               if (IS_ERR(clk))
> +                       goto eth_fixup_skip;
> +
> +               io = of_iomap(pnp, 0);
> +               if (!io)
> +                       goto eth_fixup_no_map;
> +
> +               /* ensure port clock is not gated to not hang CPU */
> +               clk_prepare_enable(clk);
> +
> +               /* store MAC address register contents in local-mac-address */
> +               pr_err(FW_INFO "%s: local-mac-address is not set\n",
> +                      np->full_name);
> +
> +               pmac = kzalloc(sizeof(*pmac) + 6, GFP_KERNEL);
> +               if (!pmac)
> +                       goto eth_fixup_no_mem;
> +
> +               pmac->value = pmac + 1;
> +               pmac->length = 6;
> +               pmac->name = kstrdup("local-mac-address", GFP_KERNEL);
> +               if (!pmac->name) {
> +                       kfree(pmac);
> +                       goto eth_fixup_no_mem;
> +               }
> +
> +               macaddr = pmac->value;
> +               reg = readl(io + MV643XX_ETH_MAC_ADDR_HIGH);
> +               macaddr[0] = (reg >> 24) & 0xff;
> +               macaddr[1] = (reg >> 16) & 0xff;
> +               macaddr[2] = (reg >> 8) & 0xff;
> +               macaddr[3] = reg & 0xff;
> +
> +               reg = readl(io + MV643XX_ETH_MAC_ADDR_LOW);
> +               macaddr[4] = (reg >> 8) & 0xff;
> +               macaddr[5] = reg & 0xff;
> +
> +               of_update_property(np, pmac);
> +
> +eth_fixup_no_mem:
> +               iounmap(io);
> +               clk_disable_unprepare(clk);
> +eth_fixup_no_map:
> +               clk_put(clk);
> +eth_fixup_skip:
> +               of_node_put(pnp);
> +       }
> +}
> +
>  static void __init kirkwood_dt_time_init(void)
>  {
>         of_clk_init(NULL);
> @@ -97,11 +178,10 @@ static void __init kirkwood_dt_init(void)
>         kirkwood_l2_init();
>  
>         kirkwood_cpufreq_init();
> -
> +       kirkwood_cpuidle_init();
>         /* Setup clocks for legacy devices */
>         kirkwood_legacy_clk_init();
> -
> -       kirkwood_cpuidle_init();
> +       kirkwood_dt_eth_fixup();
>  
>  #ifdef CONFIG_KEXEC
>         kexec_reinit = kirkwood_enable_pcie;
> -- 
> 1.7.10.4
