Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaCZAao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 20:30:44 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61685 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaCZAam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 20:30:42 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/wX5hHG1x9K3uQSYXcOoGt4VFzqoeyhl0=
X-DKIM: OpenDKIM Filter v2.0.1 titan 5975A54C0DB
Date: Tue, 25 Mar 2014 20:30:27 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 07/14] ARM: mvebu: Extend the pmsu registers
Message-ID: <20140326003027.GJ28304@titan.lakedaemon.net>
References: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com>
 <1395787705-31061-8-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395787705-31061-8-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 11:48:18PM +0100, Gregory CLEMENT wrote:
> The initial binding for PMSU were wrong. It didn't take into account
> all the registers from the PMSU and moreover it referred to registers
> which are not part of PMSU.
> 
> The Power Management Unit Service block also controls the Coherency
> Fabric subsystem. These registers are needed for the CPU idle
> implementation for the Armada 370/XP, it allows to enter a deep CPU
> idle state where the Coherency Fabric and the L2 cache are powered
> down.
> 
> This commit add support for a new compatible for the PMSU node
> including the block related to the coherency fabric. It also keeps
> compatibility with the old binding
> 
> This patch also adds warnings if one of the base registers set can't
> be ioremapped.
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  arch/arm/mach-mvebu/pmsu.c | 47 +++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 42 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-mvebu/pmsu.c b/arch/arm/mach-mvebu/pmsu.c
> index d71ef53107c4..865bcb651e01 100644
> --- a/arch/arm/mach-mvebu/pmsu.c
> +++ b/arch/arm/mach-mvebu/pmsu.c
> @@ -27,11 +27,21 @@
>  static void __iomem *pmsu_mp_base;
>  static void __iomem *pmsu_reset_base;
>  
> -#define PMSU_BOOT_ADDR_REDIRECT_OFFSET(cpu)	((cpu * 0x100) + 0x24)
> +#define PMSU_BASE_OFFSET    0x100
> +#define PMSU_REG_SIZE	    0x1000
> +
> +#define PMSU_BOOT_ADDR_REDIRECT_OFFSET(cpu)	((cpu * 0x100) + 0x124)
>  #define PMSU_RESET_CTL_OFFSET(cpu)		(cpu * 0x8)
>  
>  static struct of_device_id of_pmsu_table[] = {
> -	{.compatible = "marvell,armada-370-xp-pmsu"},
> +	{
> +		.compatible = "marvell,armada-370-pmsu",
> +		.data = (void *) false,

This looks sketchy to me.

> +	},
> +	{
> +		.compatible = "marvell,armada-370-xp-pmsu",
> +		.data = (void *) true, /* legacy */

Same.

> +	},
>  	{ /* end of list */ },
>  };
>  
> @@ -59,15 +69,42 @@ int armada_xp_boot_cpu(unsigned int cpu_id, void *boot_addr)
>  }
>  #endif
>  
> +static void __init armada_370_xp_pmsu_legacy_init(struct device_node *np)
> +{
> +	u32 addr;
> +	pr_warn("*** Warning ***  Using an old binding which will be deprecated\n");

This should be noted in the binding docs...

> +	/* We just need the adress, we already know the size */

nit. s/adress/address/

> +	addr = be32_to_cpu(*of_get_address(np, 0, NULL, NULL));
> +	addr -= PMSU_BASE_OFFSET;
> +	pmsu_mp_base = ioremap(addr, PMSU_REG_SIZE);
> +	of_node_put(np);
> +}
> +
>  static int __init armada_370_xp_pmsu_init(void)
>  {
>  	struct device_node *np;
> -

Please leave this empty line.

>  	np = of_find_matching_node(NULL, of_pmsu_table);
>  	if (np) {
> +		const struct of_device_id *match =
> +			of_match_node(of_pmsu_table, np);
> +		BUG_ON(!match);
> +
>  		pr_info("Initializing Power Management Service Unit\n");
> -		pmsu_mp_base = of_iomap(np, 0);
> -		pmsu_reset_base = of_iomap(np, 1);
> +
> +		if (match->data) /* legacy */
> +			armada_370_xp_pmsu_legacy_init(np);

And if a new compatible string actually needs data passed?

> +		else
> +			pmsu_mp_base = of_iomap(np, 0);
> +		WARN_ON(!pmsu_mp_base);
> +		of_node_put(np);
> +
> +		/*
> +		 * This temporaty hack will be removed as soon as we

nit. s/temporaty/temporary/

thx,

Jason.

> +		 * get the proper reset controler support
> +		 */
> +		np = of_find_compatible_node(NULL, NULL, "marvell,armada-xp-cpu-reset");
> +		pmsu_reset_base = of_iomap(np, 0);
> +		WARN_ON(!pmsu_reset_base);
>  		of_node_put(np);
>  	}
>  
> -- 
> 1.8.1.2
> 
