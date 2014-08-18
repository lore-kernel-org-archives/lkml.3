Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaHRGGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 02:06:40 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:57885
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751142AbaHRGGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 02:06:39 -0400
Date: Mon, 18 Aug 2014 14:06:07 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 3/3] ARM: clk-imx6q: Add missing lvds and anaclk clock
 to the clock tree
Message-ID: <20140818060521.GA2114@dragon>
References: <cover.1407481023.git.shengjiu.wang@freescale.com>
 <9ecf6480464cffb3b4347ad3fd8ec5f07462a0fc.1407481023.git.shengjiu.wang@freescale.com>
 <20140809135841.GB8849@dragon> <20140811030935.GB13158@audiosh1>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140811030935.GB13158@audiosh1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019005)(6009001)(24454002)(199003)(51704005)(189002)(83322001)(57986006)(44976005)(83072002)(107046002)(104016003)(6806004)(105606002)(87936001)(76482001)(95666004)(106466001)(76176999)(92566001)(74662001)(97736001)(85852003)(97756001)(46102001)(86362001)(54356999)(50986999)(31966008)(74502001)(21056001)(85306004)(93886004)(84676001)(77982001)(92726001)(68736004)(99396002)(50466002)(83506001)(33716001)(81342001)(23726002)(102836001)(33656002)(26826002)(4396001)(46406003)(79102001)(80022001)(47776003)(64706001)(110136001)(20776003)(81542001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB321;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03077579FF
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 11:09:36AM +0800, Shengjiu Wang wrote:
> On Sat, Aug 09, 2014 at 09:58:42PM +0800, Shawn Guo wrote:
> > On Fri, Aug 08, 2014 at 03:02:49PM +0800, Shengjiu Wang wrote:
> > > @@ -176,8 +182,12 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
> > >  	 * the "output_enable" bit as a gate, even though it's really just
> > >  	 * enabling clock output.
> > >  	 */
> > > -	clk[IMX6QDL_CLK_LVDS1_GATE] = imx_clk_gate("lvds1_gate", "lvds1_sel", base + 0x160, 10);
> > > -	clk[IMX6QDL_CLK_LVDS2_GATE] = imx_clk_gate("lvds2_gate", "lvds2_sel", base + 0x160, 11);
> > > +	clk[IMX6QDL_CLK_LVDS1_GATE] = imx_clk_gate2("lvds1_gate", "lvds1_sel", base + 0x160, 10);
> > > +	clk[IMX6QDL_CLK_LVDS2_GATE] = imx_clk_gate2("lvds2_gate", "lvds2_sel", base + 0x160, 11);
> > 
> > I do not think you can simply change to use imx_clk_gate2() here.  It's
> > designed for those CCGR gate clocks, each of which is controlled by two
> > bits.
> > 
> > Shawn
> >
> As Lucas Stach's suggestion, we need to do add some method for mutually exclusive clock, 
> lvds1_gate with lvds1_in, lvds2_gate with lvds2_in. I add imx_clk_gate2_exclusive() function in clk-gate2.c.
> So I change imx_clk_gate() to imx_clk_gate2() here.
> As you said, this is not good solution.

It's not just a "not good" solution but wrong and broken one.  The net
result of that is if you call clk_enable() on lvds1_gate, both bit 10
and 11 will be set.

> So I need your suggestion, how can I do?

I guess we will need a new clock type to handle such mutually exclusive
clocks, rather than patching clk-gate2.

> First, is it allowable that to add imx_clk_gate2_exclusive() function, is there a more better way?

Again, this is completely wrong.

> second, or should I change the clk-gate.c to add exclusive control?

If such mutually exclusive clocks are somehow common across different
clock controllers, we can propose to change clk-gate.c for handling
them.  But I'm not sure this is a common case.

Shawn
