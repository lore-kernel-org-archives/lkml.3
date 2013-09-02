Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab3IEFHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 01:07:05 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36659 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754622Ab3IEFHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 01:07:00 -0400
Date: Mon, 2 Sep 2013 12:40:16 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Kumar Gala <galak@codeaurora.org>
Cc: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>
Subject: Re: [PATCH 1/2] serial: fsl-imx-uart: Cleanup duplicate device
 tree binding
Message-ID: <20130902114016.GA13303@e106331-lin.cambridge.arm.com>
References: <1377716903-19699-1-git-send-email-galak@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377716903-19699-1-git-send-email-galak@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 08:08:22PM +0100, Kumar Gala wrote:
> We had two bindings for the same serial device, it looks like the one in
> tty/serial/fsl-imx-uart.txt is the more up to date one so go with it and
> merge a few things about the use/need for aliases in from
> serial/fsl-imx-uart.txt.

Oh my, that's a mess.

> 
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> ---
>  .../devicetree/bindings/serial/fsl-imx-uart.txt    | 35 ----------------------
>  .../bindings/tty/serial/fsl-imx-uart.txt           |  9 +++++-
>  2 files changed, 8 insertions(+), 36 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/serial/fsl-imx-uart.txt
> 
> diff --git a/Documentation/devicetree/bindings/serial/fsl-imx-uart.txt b/Documentation/devicetree/bindings/serial/fsl-imx-uart.txt
> deleted file mode 100644
> index c58573b..0000000
> --- a/Documentation/devicetree/bindings/serial/fsl-imx-uart.txt
> +++ /dev/null
> @@ -1,35 +0,0 @@
> -* Freescale i.MX UART controller
> -
> -Required properties:
> -- compatible : should be "fsl,imx21-uart"
> -- reg : Address and length of the register set for the device
> -- interrupts : Should contain UART interrupt number
> -
> -Optional properties:
> -- fsl,uart-has-rtscts: indicate that RTS/CTS signals are used
> -
> -Note: Each uart controller should have an alias correctly numbered
> -in "aliases" node.
> -
> -Example:
> -
> -- From imx51.dtsi:
> -aliases {
> -	serial0 = &uart1;
> -	serial1 = &uart2;
> -	serial2 = &uart3;
> -};
> -
> -uart1: serial@73fbc000 {
> -	compatible = "fsl,imx51-uart", "fsl,imx21-uart";
> -	reg = <0x73fbc000 0x4000>;
> -	interrupts = <31>;
> -	status = "disabled";
> -}
> -
> -- From imx51-babbage.dts:
> -uart1: serial@73fbc000 {
> -	fsl,uart-has-rtscts;
> -	status = "okay";
> -};
> -
> diff --git a/Documentation/devicetree/bindings/tty/serial/fsl-imx-uart.txt b/Documentation/devicetree/bindings/tty/serial/fsl-imx-uart.txt
> index c662eb3..35ae1fb 100644
> --- a/Documentation/devicetree/bindings/tty/serial/fsl-imx-uart.txt
> +++ b/Documentation/devicetree/bindings/tty/serial/fsl-imx-uart.txt
> @@ -11,9 +11,16 @@ Optional properties:

I note this binding doesn't actually define the set of compatible
strings, as it has:

	Compatible : Should be "fsl,<soc>-uart"

... the other binding had:

	compatible : should be "fsl,imx21-uart"

.. and the driver accepts "fsl,imx21-uart" and "fsl,imx1-uart".

Would it be possible to clarify this at the same time, something like:

	Compatible : Should contain one of:
		     * "fsl,imx21-uart" for UARTs compatible with that in
		       i.MX21 SoCs.
		     * "fsl,imx1-uart" for UARTs compatible with that in
		       i.MX1x SoCs·.

Otherwise, this seems sensible. With something like the above:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Cheers,
Mark.

>  - fsl,dte-mode : Indicate the uart works in DTE mode. The uart works
>                    is DCE mode by default.
>  
> +Note: Each uart controller should have an alias correctly numbered
> +in "aliases" node.
> +
>  Example:
>  
> -serial@73fbc000 {
> +aliases {
> +	serial0 = &uart1;
> +};
> +
> +uart1: serial@73fbc000 {
>  	compatible = "fsl,imx51-uart", "fsl,imx21-uart";
>  	reg = <0x73fbc000 0x4000>;
>  	interrupts = <31>;
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> 
