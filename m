Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbaIYQDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:03:34 -0400
Received: from mail-by2on0064.outbound.protection.outlook.com ([207.46.100.64]:63952
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753735AbaIYQDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:03:32 -0400
Date: Thu, 25 Sep 2014 09:02:17 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [RFC] pinctrl driver for Zynq
References: <c2b9a1c1-d3b9-48c5-9c14-a4c3a95965fa@BN1AFFO11FD046.protection.gbl>
 <20140925081748.GB26991@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140925081748.GB26991@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20974.007
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <85851374-20d5-400b-b773-ea6ba2acdaf7@BY2FFO11FD045.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(164054003)(51704005)(189002)(24454002)(377424004)(86362001)(83506001)(53416004)(47776003)(92566001)(1496007)(92726001)(85852003)(23676002)(20776003)(83072002)(95666004)(21056001)(50986999)(87936001)(31696002)(64706001)(19580395003)(54356999)(76176999)(70736001)(102836001)(81542003)(74662003)(81342003)(46102003)(50466002)(79102003)(106466001)(85202003)(6806004)(85182001)(77096002)(85306004)(44976005)(19580405001)(110136001)(83322001)(31966008)(10300001)(107046002)(4396001)(74316001)(77982003)(99396003)(76482002)(104016003)(80022003)(74502003)(120916001)(90102001)(107986001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB019;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0345CFD558
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-25 at 10:17AM +0200, Steffen Trumtrar wrote:
> Hi!
> 
> On Wed, Sep 24, 2014 at 02:09:14PM -0700, Sören Brinkmann wrote:
> > Hi,
> > 
> > I think I have pinctrl driver that is covering the pinmux options of
> > Zynq and I also figured out how the DT bindings work.
> > 
> > But there are a couple of things that probably could be done better.
> > 
> > One thing making the DT bindings explode, seems to be all those single
> > pin functions that can be muxed to every pin.
> > Next to GPIO, this applies to SD card and write protect - which are even
> > present twice since Zynq has two SDIO cores. Just these functions
> > account for a couple of hundred nodes in the DT and a bunch of lines in
> > the driver. Is there a better way to do this?
> > 
> > In particular for GPIO there seemed to be a better solution with
> > implementing gpio_request_enable(), but that seemed to allow GPIO in
> > parallel to request and mux the pin which does not work on Zynq. IOW: I
> > expected the core would reject a call of gpio_request_enable for a pin
> > that is already muxed to some other function, but that was not the case
> > in my testing. Am I missing something here?
> > 
> > And finally, for SD card detect and write protect, we actually have to
> > disable the muxing. The problem with those functions is, that they have
> > a dedicated mux for that function which is in parallel to the "normal"
> > pinmuxes. So, muxing a "normal" function to a pin would not void the
> > muxing of the SD signals. I thought this would be easily resolved by
> > implementing the 'disable' op, but after I did that, I noticed that
> > there is only a stale documentation comment of this member of struct
> > pinmux_ops left, the actual function pointer is gone.
> > 
> > 	Thanks,
> > 	Sören
> > 
> > ------------8<-----------------8<-------------------8<--------------8<----------
> > Date: Mon, 15 Sep 2014 17:24:35 -0700
> > Subject: [PATCH RFC] pinctrl: Add driver for Zynq
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> >  arch/arm/boot/dts/zynq-7000.dtsi | 3039 +++++++++++++++++++++++++++++++++++++-
> >  arch/arm/boot/dts/zynq-zc706.dts |   13 +
> >  arch/arm/mach-zynq/Kconfig       |    1 +
> >  drivers/pinctrl/Kconfig          |    8 +
> >  drivers/pinctrl/Makefile         |    1 +
> >  drivers/pinctrl/pinctrl-zynq.c   |  927 ++++++++++++
> >  6 files changed, 3988 insertions(+), 1 deletion(-)
> >  create mode 100644 drivers/pinctrl/pinctrl-zynq.c
> > 
> > diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> > index 6cc83d4c6c76..814873da0392 100644
> > --- a/arch/arm/boot/dts/zynq-7000.dtsi
> > +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> > @@ -229,7 +229,7 @@
> >  		slcr: slcr@f8000000 {
> >  			#address-cells = <1>;
> >  			#size-cells = <1>;
> > -			compatible = "xlnx,zynq-slcr", "syscon";
> > +			compatible = "xlnx,zynq-slcr", "syscon", "simple-bus";
> >  			reg = <0xF8000000 0x1000>;
> >  			ranges;
> >  			clkc: clkc@100 {
> > @@ -250,6 +250,3043 @@
> >  						"dbg_trc", "dbg_apb";
> >  				reg = <0x100 0x100>;
> >  			};
> > +
> > +			pinctrl0: pinctrl@700 {
> > +				compatible = "xlnx,pinctrl-zynq";
> > +				reg = <0x700 0x200>;
> > +
> > +				pinctrl_i2c0_0: pinctrl-i2c0@0 {
> > +					i2c0-mux {
> > +						function = "i2c0";
> > +						pins = "i2c0_0_grp";
> > +					};
> > +				};
> > +
> 
> (...)
> 
> > +				pinctrl_sdio1_cd_54: pinctrl-sdio1_cd@54 {
> > +					sdio1_cd-mux {
> > +						function = "sdio1_cd";
> > +						pins = "sdio1_emio_cd_grp";
> > +					};
> > +				};
> > +			};
> >  		};
> >  
> 
> Wouldn't this reaaally bloat the dtb?
> I know that imx decided to remove all the pinctrls from the dtsis, because
> the dtbs got to big.

Yep, it absolutely does and I don't really know what to do about it.
Listing them all is a lot. Not listing them all would force board DTs to
potentially duplicate such nodes. This is definitely one of the things
I'm seeking input on.
Is there any good solution or best practice?

	Sören
