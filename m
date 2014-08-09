Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaHINdf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 09:33:35 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:55279
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750900AbaHINde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 09:33:34 -0400
Date: Sat, 9 Aug 2014 21:33:17 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <Guangyu.Chen@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 2/3] ARM: clk-gate2: Add API imx_clk_gate2_exclusive
 for clk_gate2
Message-ID: <20140809133314.GA8849@dragon>
References: <cover.1407481023.git.shengjiu.wang@freescale.com>
 <e1a314548b2e00fccccb4ece8200da97cf89c6bb.1407481023.git.shengjiu.wang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e1a314548b2e00fccccb4ece8200da97cf89c6bb.1407481023.git.shengjiu.wang@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(51704005)(24454002)(84676001)(97736001)(97756001)(85306004)(104016003)(92566001)(92726001)(23726002)(81342001)(31966008)(87936001)(46102001)(68736004)(6806004)(107046002)(21056001)(99396002)(85852003)(110136001)(50466002)(86362001)(83072002)(44976005)(81542001)(50986999)(76176999)(83506001)(20776003)(80022001)(47776003)(19580395003)(106466001)(19580405001)(83322001)(33656002)(79102001)(105606002)(76482001)(95666004)(33716001)(74502001)(54356999)(77982001)(102836001)(26826002)(74662001)(64706001)(57986006)(4396001)(46406003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB445;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02981BE340
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 03:02:48PM +0800, Shengjiu Wang wrote:
> As some clocks are mutually exlcusive, they can't be enabled simultaneously,
> So add this new API for registering exclusive clock, the enable function will
> check if there is exclusive clock and it is not enabled, then this clock can
> be enabled, otherwise, it will return error.
> 
> Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
> ---
>  arch/arm/mach-imx/clk-gate2.c |   18 +++++++++++++++++-
>  arch/arm/mach-imx/clk.h       |    2 ++
>  2 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-imx/clk-gate2.c b/arch/arm/mach-imx/clk-gate2.c
> index 84acdfd..df64c4d 100644
> --- a/arch/arm/mach-imx/clk-gate2.c
> +++ b/arch/arm/mach-imx/clk-gate2.c
> @@ -8,7 +8,7 @@
>   *
>   * Gated clock implementation
>   */
> -
> +#include <linux/clk-private.h>

I do not see why this header is needed.

Shawn

>  #include <linux/clk-provider.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> @@ -34,6 +34,7 @@ struct clk_gate2 {
>  	u8		flags;
>  	spinlock_t	*lock;
>  	unsigned int	*share_count;
> +	struct clk	*clk_exclusive;
>  };
>  
>  #define to_clk_gate2(_hw) container_of(_hw, struct clk_gate2, hw)
> @@ -46,6 +47,11 @@ static int clk_gate2_enable(struct clk_hw *hw)
>  
>  	spin_lock_irqsave(gate->lock, flags);
>  
> +	if (gate->clk_exclusive && __clk_is_enabled(gate->clk_exclusive)) {
> +		spin_unlock_irqrestore(gate->lock, flags);
> +		return -EBUSY;
> +	}
> +
>  	if (gate->share_count && (*gate->share_count)++ > 0)
>  		goto out;
>  
> @@ -147,3 +153,13 @@ struct clk *clk_register_gate2(struct device *dev, const char *name,
>  
>  	return clk;
>  }
> +
> +int imx_clk_gate2_exclusive(struct clk *clk1, struct clk *clk2)
> +{
> +	struct clk_gate2 *gate1 = to_clk_gate2(clk1->hw);
> +	struct clk_gate2 *gate2 = to_clk_gate2(clk2->hw);
> +
> +	gate1->clk_exclusive = clk2;
> +	gate2->clk_exclusive = clk1;
> +	return 0;
> +}
> diff --git a/arch/arm/mach-imx/clk.h b/arch/arm/mach-imx/clk.h
> index d5ba76f..2b07376 100644
> --- a/arch/arm/mach-imx/clk.h
> +++ b/arch/arm/mach-imx/clk.h
> @@ -36,6 +36,8 @@ struct clk *clk_register_gate2(struct device *dev, const char *name,
>  struct clk * imx_obtain_fixed_clock(
>  			const char *name, unsigned long rate);
>  
> +int imx_clk_gate2_exclusive(struct clk *clk1, struct clk *clk2);
> +
>  static inline struct clk *imx_clk_gate2(const char *name, const char *parent,
>  		void __iomem *reg, u8 shift)
>  {
> -- 
> 1.7.9.5
> 
