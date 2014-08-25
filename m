Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbaHYLWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 07:22:30 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:27592
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755155AbaHYLW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 07:22:29 -0400
Date: Mon, 25 Aug 2014 19:21:52 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 3/3] ARM: clk-imx6q: Add missing lvds and anaclk clock
 to the clock tree
Message-ID: <20140825112151.GD6928@dragon>
References: <cover.1407481023.git.shengjiu.wang@freescale.com>
 <9ecf6480464cffb3b4347ad3fd8ec5f07462a0fc.1407481023.git.shengjiu.wang@freescale.com>
 <20140809135841.GB8849@dragon> <20140811030935.GB13158@audiosh1>
 <20140818060521.GA2114@dragon> <20140825073957.GA7740@audiosh1>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140825073957.GA7740@audiosh1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(35774003)(199003)(24454002)(51704005)(83506001)(26826002)(76482001)(110136001)(99396002)(83322001)(95666004)(57986006)(74662001)(81156004)(46102001)(31966008)(105606002)(21056001)(81542001)(92726001)(74502001)(4396001)(47776003)(44976005)(20776003)(104016003)(68736004)(77982001)(50986999)(97736001)(76176999)(92566001)(85852003)(97756001)(84676001)(69596002)(85306004)(86362001)(33656002)(33716001)(106466001)(50466002)(90102001)(107046002)(64706001)(102836001)(83072002)(80022001)(6806004)(23726002)(46406003)(81342001)(93886004)(54356999)(79102001)(87936001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB334;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03142412E2
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 03:40:20PM +0800, Shengjiu Wang wrote:
> On Mon, Aug 18, 2014 at 02:06:07PM +0800, Shawn Guo wrote:
> > On Mon, Aug 11, 2014 at 11:09:36AM +0800, Shengjiu Wang wrote:
> > > On Sat, Aug 09, 2014 at 09:58:42PM +0800, Shawn Guo wrote:
> > > > On Fri, Aug 08, 2014 at 03:02:49PM +0800, Shengjiu Wang wrote:
> > > > > @@ -176,8 +182,12 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
> > > > >  	 * the "output_enable" bit as a gate, even though it's really just
> > > > >  	 * enabling clock output.
> > > > >  	 */
> > > > > -	clk[IMX6QDL_CLK_LVDS1_GATE] = imx_clk_gate("lvds1_gate", "lvds1_sel", base + 0x160, 10);
> > > > > -	clk[IMX6QDL_CLK_LVDS2_GATE] = imx_clk_gate("lvds2_gate", "lvds2_sel", base + 0x160, 11);
> > > > > +	clk[IMX6QDL_CLK_LVDS1_GATE] = imx_clk_gate2("lvds1_gate", "lvds1_sel", base + 0x160, 10);
> > > > > +	clk[IMX6QDL_CLK_LVDS2_GATE] = imx_clk_gate2("lvds2_gate", "lvds2_sel", base + 0x160, 11);
> > > > 
> > > > I do not think you can simply change to use imx_clk_gate2() here.  It's
> > > > designed for those CCGR gate clocks, each of which is controlled by two
> > > > bits.
> > > > 
> > > > Shawn
> > > >
> > > As Lucas Stach's suggestion, we need to do add some method for mutually exclusive clock, 
> > > lvds1_gate with lvds1_in, lvds2_gate with lvds2_in. I add imx_clk_gate2_exclusive() function in clk-gate2.c.
> > > So I change imx_clk_gate() to imx_clk_gate2() here.
> > > As you said, this is not good solution.
> > 
> > It's not just a "not good" solution but wrong and broken one.  The net
> > result of that is if you call clk_enable() on lvds1_gate, both bit 10
> > and 11 will be set.
> > 
> > > So I need your suggestion, how can I do?
> > 
> > I guess we will need a new clock type to handle such mutually exclusive
> > clocks, rather than patching clk-gate2.
> > 
> Could you please help to implement this feature?

Okay, I will give it a try soon.

> 
> Furthermore, I'd like to drop patch 2 and patch 3, wait the implementation from
> you.
> 
> Could you please review the patch 1?  do you have any comments?

Just applied #1.

Shawn
