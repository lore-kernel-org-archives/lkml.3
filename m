Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaHKDJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 23:09:41 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:42686
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751779AbaHKDJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 23:09:40 -0400
Date: Mon, 11 Aug 2014 11:09:36 +0800
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: Shawn Guo <shawn.guo@freescale.com>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <Guangyu.Chen@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 3/3] ARM: clk-imx6q: Add missing lvds and anaclk clock
 to the clock tree
Message-ID: <20140811030935.GB13158@audiosh1>
References: <cover.1407481023.git.shengjiu.wang@freescale.com>
 <9ecf6480464cffb3b4347ad3fd8ec5f07462a0fc.1407481023.git.shengjiu.wang@freescale.com>
 <20140809135841.GB8849@dragon>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140809135841.GB8849@dragon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(51704005)(199002)(189002)(97736001)(80022001)(47776003)(87936001)(21056001)(50466002)(31966008)(79102001)(54356999)(76176999)(97756001)(77982001)(74502001)(74662001)(64706001)(76482001)(20776003)(106466001)(83072002)(105606002)(50986999)(81342001)(95666004)(81542001)(92566001)(85852003)(99396002)(86362001)(92726001)(4396001)(68736004)(85306004)(23726002)(33716001)(84676001)(83506001)(107046002)(33656002)(46406003)(44976005)(83322001)(102836001)(110136001)(6806004)(104016003)(46102001)(26826002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB340;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03008837BD
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2014 at 09:58:42PM +0800, Shawn Guo wrote:
> On Fri, Aug 08, 2014 at 03:02:49PM +0800, Shengjiu Wang wrote:
> > @@ -176,8 +182,12 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
> >  	 * the "output_enable" bit as a gate, even though it's really just
> >  	 * enabling clock output.
> >  	 */
> > -	clk[IMX6QDL_CLK_LVDS1_GATE] = imx_clk_gate("lvds1_gate", "lvds1_sel", base + 0x160, 10);
> > -	clk[IMX6QDL_CLK_LVDS2_GATE] = imx_clk_gate("lvds2_gate", "lvds2_sel", base + 0x160, 11);
> > +	clk[IMX6QDL_CLK_LVDS1_GATE] = imx_clk_gate2("lvds1_gate", "lvds1_sel", base + 0x160, 10);
> > +	clk[IMX6QDL_CLK_LVDS2_GATE] = imx_clk_gate2("lvds2_gate", "lvds2_sel", base + 0x160, 11);
> 
> I do not think you can simply change to use imx_clk_gate2() here.  It's
> designed for those CCGR gate clocks, each of which is controlled by two
> bits.
> 
> Shawn
>
As Lucas Stach's suggestion, we need to do add some method for mutually exclusive clock, 
lvds1_gate with lvds1_in, lvds2_gate with lvds2_in. I add imx_clk_gate2_exclusive() function in clk-gate2.c.
So I change imx_clk_gate() to imx_clk_gate2() here.
As you said, this is not good solution. So I need your suggestion, how can I do?
First, is it allowable that to add imx_clk_gate2_exclusive() function, is there a more better way?
second, or should I change the clk-gate.c to add exclusive control?

Thanks
wang shengjiu

> > +	clk[IMX6QDL_CLK_LVDS1_IN] = imx_clk_gate2("lvds1_in", "anaclk1", base + 0x160, 12);
> > +	clk[IMX6QDL_CLK_LVDS2_IN] = imx_clk_gate2("lvds2_in", "anaclk2", base + 0x160, 13);
> > +	imx_clk_gate2_exclusive(clk[IMX6QDL_CLK_LVDS1_GATE], clk[IMX6QDL_CLK_LVDS1_IN]);
> > +	imx_clk_gate2_exclusive(clk[IMX6QDL_CLK_LVDS2_GATE], clk[IMX6QDL_CLK_LVDS2_IN]);
> >  
> >  	/*                                            name              parent_name        reg       idx */
> >  	clk[IMX6QDL_CLK_PLL2_PFD0_352M] = imx_clk_pfd("pll2_pfd0_352m", "pll2_bus",     base + 0x100, 0);
