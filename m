Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaIYIR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:17:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58794 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbaIYIRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:17:52 -0400
Date: Thu, 25 Sep 2014 10:17:48 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [RFC] pinctrl driver for Zynq
Message-ID: <20140925081748.GB26991@pengutronix.de>
References: <c2b9a1c1-d3b9-48c5-9c14-a4c3a95965fa@BN1AFFO11FD046.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c2b9a1c1-d3b9-48c5-9c14-a4c3a95965fa@BN1AFFO11FD046.protection.gbl>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:05:26 up 15 days, 52 min, 77 users,  load average: 0,08, 0,09,
 0,13
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Wed, Sep 24, 2014 at 02:09:14PM -0700, Sören Brinkmann wrote:
> Hi,
> 
> I think I have pinctrl driver that is covering the pinmux options of
> Zynq and I also figured out how the DT bindings work.
> 
> But there are a couple of things that probably could be done better.
> 
> One thing making the DT bindings explode, seems to be all those single
> pin functions that can be muxed to every pin.
> Next to GPIO, this applies to SD card and write protect - which are even
> present twice since Zynq has two SDIO cores. Just these functions
> account for a couple of hundred nodes in the DT and a bunch of lines in
> the driver. Is there a better way to do this?
> 
> In particular for GPIO there seemed to be a better solution with
> implementing gpio_request_enable(), but that seemed to allow GPIO in
> parallel to request and mux the pin which does not work on Zynq. IOW: I
> expected the core would reject a call of gpio_request_enable for a pin
> that is already muxed to some other function, but that was not the case
> in my testing. Am I missing something here?
> 
> And finally, for SD card detect and write protect, we actually have to
> disable the muxing. The problem with those functions is, that they have
> a dedicated mux for that function which is in parallel to the "normal"
> pinmuxes. So, muxing a "normal" function to a pin would not void the
> muxing of the SD signals. I thought this would be easily resolved by
> implementing the 'disable' op, but after I did that, I noticed that
> there is only a stale documentation comment of this member of struct
> pinmux_ops left, the actual function pointer is gone.
> 
> 	Thanks,
> 	Sören
> 
> ------------8<-----------------8<-------------------8<--------------8<----------
> Date: Mon, 15 Sep 2014 17:24:35 -0700
> Subject: [PATCH RFC] pinctrl: Add driver for Zynq
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/boot/dts/zynq-7000.dtsi | 3039 +++++++++++++++++++++++++++++++++++++-
>  arch/arm/boot/dts/zynq-zc706.dts |   13 +
>  arch/arm/mach-zynq/Kconfig       |    1 +
>  drivers/pinctrl/Kconfig          |    8 +
>  drivers/pinctrl/Makefile         |    1 +
>  drivers/pinctrl/pinctrl-zynq.c   |  927 ++++++++++++
>  6 files changed, 3988 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/pinctrl/pinctrl-zynq.c
> 
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index 6cc83d4c6c76..814873da0392 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -229,7 +229,7 @@
>  		slcr: slcr@f8000000 {
>  			#address-cells = <1>;
>  			#size-cells = <1>;
> -			compatible = "xlnx,zynq-slcr", "syscon";
> +			compatible = "xlnx,zynq-slcr", "syscon", "simple-bus";
>  			reg = <0xF8000000 0x1000>;
>  			ranges;
>  			clkc: clkc@100 {
> @@ -250,6 +250,3043 @@
>  						"dbg_trc", "dbg_apb";
>  				reg = <0x100 0x100>;
>  			};
> +
> +			pinctrl0: pinctrl@700 {
> +				compatible = "xlnx,pinctrl-zynq";
> +				reg = <0x700 0x200>;
> +
> +				pinctrl_i2c0_0: pinctrl-i2c0@0 {
> +					i2c0-mux {
> +						function = "i2c0";
> +						pins = "i2c0_0_grp";
> +					};
> +				};
> +

(...)

> +				pinctrl_sdio1_cd_54: pinctrl-sdio1_cd@54 {
> +					sdio1_cd-mux {
> +						function = "sdio1_cd";
> +						pins = "sdio1_emio_cd_grp";
> +					};
> +				};
> +			};
>  		};
>  

Wouldn't this reaaally bloat the dtb?
I know that imx decided to remove all the pinctrls from the dtsis, because
the dtbs got to big.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
