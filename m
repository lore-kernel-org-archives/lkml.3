Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbaIPDex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 23:34:53 -0400
Received: from mail-bn1bon0131.outbound.protection.outlook.com ([157.56.111.131]:63538
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753347AbaIPDew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 23:34:52 -0400
Date: Tue, 16 Sep 2014 11:41:24 +0800
From: Robin Gong <b38343@freescale.com>
To: Lucas Stach <l.stach@pengutronix.de>
CC: <shawn.guo@freescale.com>, <kernel@pengutronix.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: dts: imx6dl: disable dma support for spi on
 i.mx6dl
Message-ID: <20140916034123.GA20800@Robin-OptiPlex-780>
References: <1410327012-31185-1-git-send-email-b38343@freescale.com>
 <1410774073.3314.1.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410774073.3314.1.camel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51444003)(189002)(51704005)(199003)(83072002)(92566001)(104016003)(31966008)(85852003)(76176999)(84676001)(50986999)(54356999)(107046002)(81156004)(19580405001)(110136001)(26826002)(21056001)(95666004)(99396002)(46406003)(33716001)(69596002)(44976005)(15975445006)(76482001)(15202345003)(47776003)(90102001)(4396001)(68736004)(87936001)(33656002)(92726001)(83322001)(19580395003)(102836001)(105606002)(64706001)(50466002)(20776003)(23726002)(85306004)(6806004)(106466001)(97736003)(83506001)(97756001)(80022003)(46102003)(77982003)(74662003)(74502003)(79102003)(81542003)(81342003)(32563001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB348;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB348;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lucas,
  I understood your concern,but looks we have to break old DT. Our old DT
support SPI DMA on i.mx6q/dl(v2,b3810c3dc1bcbc6a), but the DMA support patch
for SPI driver is still in reviewing(v6). So the violation you mentioned comes
if someone use the DT during the time(from v2 to spi driver patch upstreamed).
  The different behaviors on different chips(only i.mxdl can't pass strength
test) are just found from last month, this is why I sent the patch for disable
SPI DMA support on i.mx6dl during I sent v6 patch for spi driver. I think that's
make sense, because DTs are also in development, new difference between different
chips maybe found in the future although they share the same IP....
  Yes, I can check cpu type by looking at DT in spi driver, but it's not nice.
So I'm afraid that we have to break the old DTs in the gap between the two
levels patch accepted cycle.

On Mon, Sep 15, 2014 at 11:41:13AM +0200, Lucas Stach wrote:
> Am Mittwoch, den 10.09.2014, 13:30 +0800 schrieb Robin Gong:
> > There is one weird data in rxfifo after one full rx/tx transfer
> > done sometimes. It looks a design issue and hard to workaround
> > totally, so disable dma functhion here. And will re-enable it
> > once the root cause found.
> > 
> Sorry, I'm late to this as Shawn seems to already have picked up this
> patch, but this isn't the right way to fix the problem.
> 
> We made it clear at kernel summit last year that we try to not break
> existing DTs as booting a new kernel with an old DT is a valid use case.
> While you don't strictly violate this rule what you do here is only
> fixing systems booting with a new DT while leaving others broken.
> 
> If you are working around a hardware problem please disable DMA support
> in the driver. This will also allow you to enable it again, if you find
> another workaround without touching the DT again.
> 
> So this patch gets a NAK from me.
> 
> > Signed-off-by: Robin Gong <b38343@freescale.com>
> > ---
> >  arch/arm/boot/dts/imx6q.dtsi   | 20 ++++++++++++++++++++
> >  arch/arm/boot/dts/imx6qdl.dtsi |  8 --------
> >  2 files changed, 20 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
> > index e9f3646..8d5d33b 100644
> > --- a/arch/arm/boot/dts/imx6q.dtsi
> > +++ b/arch/arm/boot/dts/imx6q.dtsi
> > @@ -291,6 +291,26 @@
> >  	};
> >  };
> >  
> > +&ecspi1 {
> > +	dmas = <&sdma 3 7 1>, <&sdma 4 7 2>;
> > +	dma-names = "rx", "tx";
> > +};
> > +
> > +&ecspi2 {
> > +	dmas = <&sdma 5 7 1>, <&sdma 6 7 2>;
> > +	dma-names = "rx", "tx";
> > +};
> > +
> > +&ecspi3 {
> > +	dmas = <&sdma 7 7 1>, <&sdma 8 7 2>;
> > +	dma-names = "rx", "tx";
> > +};
> > +
> > +&ecspi4 {
> > +	dmas = <&sdma 9 7 1>, <&sdma 10 7 2>;
> > +	dma-names = "rx", "tx";
> > +};
> > +
> >  &mipi_dsi {
> >  	port@2 {
> >  		reg = <2>;
> > diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
> > index 70d7207..f696546 100644
> > --- a/arch/arm/boot/dts/imx6qdl.dtsi
> > +++ b/arch/arm/boot/dts/imx6qdl.dtsi
> > @@ -210,8 +210,6 @@
> >  					clocks = <&clks IMX6QDL_CLK_ECSPI1>,
> >  						 <&clks IMX6QDL_CLK_ECSPI1>;
> >  					clock-names = "ipg", "per";
> > -					dmas = <&sdma 3 7 1>, <&sdma 4 7 2>;
> > -					dma-names = "rx", "tx";
> >  					status = "disabled";
> >  				};
> >  
> > @@ -224,8 +222,6 @@
> >  					clocks = <&clks IMX6QDL_CLK_ECSPI2>,
> >  						 <&clks IMX6QDL_CLK_ECSPI2>;
> >  					clock-names = "ipg", "per";
> > -					dmas = <&sdma 5 7 1>, <&sdma 6 7 2>;
> > -					dma-names = "rx", "tx";
> >  					status = "disabled";
> >  				};
> >  
> > @@ -238,8 +234,6 @@
> >  					clocks = <&clks IMX6QDL_CLK_ECSPI3>,
> >  						 <&clks IMX6QDL_CLK_ECSPI3>;
> >  					clock-names = "ipg", "per";
> > -					dmas = <&sdma 7 7 1>, <&sdma 8 7 2>;
> > -					dma-names = "rx", "tx";
> >  					status = "disabled";
> >  				};
> >  
> > @@ -252,8 +246,6 @@
> >  					clocks = <&clks IMX6QDL_CLK_ECSPI4>,
> >  						 <&clks IMX6QDL_CLK_ECSPI4>;
> >  					clock-names = "ipg", "per";
> > -					dmas = <&sdma 9 7 1>, <&sdma 10 7 2>;
> > -					dma-names = "rx", "tx";
> >  					status = "disabled";
> >  				};
> >  
> 
> -- 
> Pengutronix e.K.             | Lucas Stach                 |
> Industrial Linux Solutions   | http://www.pengutronix.de/  |
> 
