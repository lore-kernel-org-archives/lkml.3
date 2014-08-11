Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaHKC4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 22:56:48 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:2658
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751763AbaHKC4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 22:56:47 -0400
Date: Mon, 11 Aug 2014 10:56:42 +0800
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: Shawn Guo <shawn.guo@freescale.com>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <Guangyu.Chen@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 2/3] ARM: clk-gate2: Add API imx_clk_gate2_exclusive
 for clk_gate2
Message-ID: <20140811025640.GA13158@audiosh1>
References: <cover.1407481023.git.shengjiu.wang@freescale.com>
 <e1a314548b2e00fccccb4ece8200da97cf89c6bb.1407481023.git.shengjiu.wang@freescale.com>
 <20140809133314.GA8849@dragon>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140809133314.GA8849@dragon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(51704005)(199002)(189002)(97756001)(68736004)(110136001)(69596002)(81542001)(6806004)(81342001)(31966008)(104016003)(97736001)(23726002)(74502001)(44976005)(83072002)(74662001)(50466002)(85852003)(107046002)(21056001)(86362001)(26826002)(87936001)(106466001)(77982001)(102836001)(80022001)(92566001)(92726001)(33716001)(79102001)(33656002)(85306004)(50986999)(99396002)(81156004)(84676001)(95666004)(4396001)(105606002)(46406003)(83506001)(19580405001)(76176999)(83322001)(19580395003)(64706001)(46102001)(76482001)(47776003)(54356999)(20776003);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB338;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03008837BD
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2014 at 09:33:17PM +0800, Shawn Guo wrote:
> On Fri, Aug 08, 2014 at 03:02:48PM +0800, Shengjiu Wang wrote:
> > As some clocks are mutually exlcusive, they can't be enabled simultaneously,
> > So add this new API for registering exclusive clock, the enable function will
> > check if there is exclusive clock and it is not enabled, then this clock can
> > be enabled, otherwise, it will return error.
> > 
> > Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
> > ---
> >  arch/arm/mach-imx/clk-gate2.c |   18 +++++++++++++++++-
> >  arch/arm/mach-imx/clk.h       |    2 ++
> >  2 files changed, 19 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/mach-imx/clk-gate2.c b/arch/arm/mach-imx/clk-gate2.c
> > index 84acdfd..df64c4d 100644
> > --- a/arch/arm/mach-imx/clk-gate2.c
> > +++ b/arch/arm/mach-imx/clk-gate2.c
> > @@ -8,7 +8,7 @@
> >   *
> >   * Gated clock implementation
> >   */
> > -
> > +#include <linux/clk-private.h>
> 
> I do not see why this header is needed.
> 
> Shawn
> 
I add new function imx_clk_gate2_exclusive(), which need to access "struct clk_hw"
in "struct clk", So here need include clk-private.h

> >  #include <linux/clk-provider.h>
> >  #include <linux/module.h>
> >  #include <linux/slab.h>
> > @@ -34,6 +34,7 @@ struct clk_gate2 {
> >  	u8		flags;
> >  	spinlock_t	*lock;
> >  	unsigned int	*share_count;
> > +	struct clk	*clk_exclusive;
> >  };
> >  
> >  #define to_clk_gate2(_hw) container_of(_hw, struct clk_gate2, hw)
> > @@ -46,6 +47,11 @@ static int clk_gate2_enable(struct clk_hw *hw)
> >  
> >  	spin_lock_irqsave(gate->lock, flags);
> >  
> > +	if (gate->clk_exclusive && __clk_is_enabled(gate->clk_exclusive)) {
> > +		spin_unlock_irqrestore(gate->lock, flags);
> > +		return -EBUSY;
> > +	}
> > +
> >  	if (gate->share_count && (*gate->share_count)++ > 0)
> >  		goto out;
> >  
> > @@ -147,3 +153,13 @@ struct clk *clk_register_gate2(struct device *dev, const char *name,
> >  
> >  	return clk;
> >  }
> > +
> > +int imx_clk_gate2_exclusive(struct clk *clk1, struct clk *clk2)
> > +{
> > +	struct clk_gate2 *gate1 = to_clk_gate2(clk1->hw);
> > +	struct clk_gate2 *gate2 = to_clk_gate2(clk2->hw);
> > +
> > +	gate1->clk_exclusive = clk2;
> > +	gate2->clk_exclusive = clk1;
> > +	return 0;
> > +}
> > diff --git a/arch/arm/mach-imx/clk.h b/arch/arm/mach-imx/clk.h
> > index d5ba76f..2b07376 100644
> > --- a/arch/arm/mach-imx/clk.h
> > +++ b/arch/arm/mach-imx/clk.h
> > @@ -36,6 +36,8 @@ struct clk *clk_register_gate2(struct device *dev, const char *name,
> >  struct clk * imx_obtain_fixed_clock(
> >  			const char *name, unsigned long rate);
> >  
> > +int imx_clk_gate2_exclusive(struct clk *clk1, struct clk *clk2);
> > +
> >  static inline struct clk *imx_clk_gate2(const char *name, const char *parent,
> >  		void __iomem *reg, u8 shift)
> >  {
> > -- 
> > 1.7.9.5
> > 
