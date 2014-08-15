Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbaHOG7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 02:59:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57222 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaHOG7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 02:59:32 -0400
References: <1407770293-27190-1-git-send-email-tthayer@opensource.altera.com> <1407770293-27190-3-git-send-email-tthayer@opensource.altera.com>
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: tthayer@opensource.altera.com
Cc: robherring2@gmail.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, atull@opensource.altera.com,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        dougthompson@xmission.com, grant.likely@linaro.org, bp@alien8.de,
        sameo@linux.intel.com, lee.jones@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tthayer.linux@gmail.com
Subject: Re: [PATCHv10 2/2] arm: dts: Add Altera SDRAM EDAC bindings & devicetree entries.
Date: Fri, 15 Aug 2014 08:42:19 +0200
In-reply-to: <1407770293-27190-3-git-send-email-tthayer@opensource.altera.com>
Message-ID: <73vbputf04.fsf@dude.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:a236:9fff:fe00:814
X-SA-Exim-Mail-From: s.trumtrar@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

tthayer@opensource.altera.com writes:

> From: Thor Thayer <tthayer@opensource.altera.com>
>
> Add the Altera SDRAM EDAC bindings and device tree changes to the Altera SoC project.
>
> Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
> ---
> v2: Changes to SoC SDRAM EDAC code.
>
> v3: Implement code suggestions for SDRAM EDAC code.
>
> v4: Remove syscon from SDRAM controller bindings.
>
> v5: No Change, bump version for consistency.
>
> v6: Only map the ctrlcfg register as syscon.
>
> v7: No change. Bump for consistency.
>
> v8: No change. Bump for consistency.
>
> v9: Changes to support a MFD SDRAM controller with nested EDAC.
>
> v10: Revert to using syscon based on feedback.
> ---
>  .../bindings/arm/altera/socfpga-sdram-edac.txt     |   15 +++++++++++++++
>  arch/arm/boot/dts/socfpga.dtsi                     |   11 +++++++++++
>  2 files changed, 26 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
>
> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
> new file mode 100644
> index 0000000..d0ce01d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
> @@ -0,0 +1,15 @@
> +Altera SOCFPGA SDRAM Error Detection & Correction [EDAC]
> +The EDAC accesses a range of registers in the SDRAM controller.
> +
> +Required properties:
> +- compatible : should contain "altr,sdram-edac";
> +- altr,sdr-syscon : phandle of the sdr module
> +- interrupts : Should contain the SDRAM ECC IRQ in the
> +	appropriate format for the IRQ controller.
> +
> +Example:
> +	sdramedac {
> +		compatible = "altr,sdram-edac";
> +		altr,sdr-syscon = <&sdr>;
> +		interrupts = <0 39 4>;
> +	};
> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
> index 4676f25..45b361e 100644
> --- a/arch/arm/boot/dts/socfpga.dtsi
> +++ b/arch/arm/boot/dts/socfpga.dtsi
> @@ -603,6 +603,17 @@
>  			};
>  		};
>  
> +		sdr: sdr@ffc25000 {
> +			compatible = "syscon";
> +			reg = <0xffc25000 0x1000>;
> +		};
> +
> +		sdramedac {
> +			compatible = "altr,sdram-edac";
> +			altr,sdr-syscon = <&sdr>;
> +			interrupts = <0 39 4>;
> +		};
> +
>  		L2: l2-cache@fffef000 {
>  			compatible = "arm,pl310-cache";
>  			reg = <0xfffef000 0x1000>;

Sorry, but I personally still don't like this approach.

If we do it like this however, shouldn't the different regions of the
SDR (EDAC, FPGAPORTRST, ...) at least be child nodes of the syscon?
That seems to match the syscon binding and describes the actual hardware
better IMHO.
Oh, and "reg = <...>" for the sdram-edac, maybe ?
How would I know where the start address of the EDAC is, if I would use
this DT on another OS where I don't have the same driver?

Regards,
Steffen

-- 
Pengutronix e.K.                           | Steffen Trumtrar            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
