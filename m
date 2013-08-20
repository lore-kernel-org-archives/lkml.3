Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab3HTOlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:41:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38838 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab3HTOlS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:41:18 -0400
Subject: Re: [PATCH 2/4] devicetree: serial: Document msm_serial bindings
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1376948397-6882-3-git-send-email-sboyd@codeaurora.org>
Date: Tue, 20 Aug 2013 09:41:25 -0500
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        David Brown <davidb@codeaurora.org>, <devicetree@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <543F6671-8317-446A-B14A-147373BCA9B6@codeaurora.org>
References: <1376948397-6882-1-git-send-email-sboyd@codeaurora.org> <1376948397-6882-3-git-send-email-sboyd@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 19, 2013, at 4:39 PM, Stephen Boyd wrote:

> The msm serial device bindings were added to the DTS files but
> never documented. Let's document them now and also fix things up
> so that it's clearer what hardware is supported. Instead of using
> hsuart (for high speed uart), let's use uartdm because that
> matches the actual name of the hardware. Also, let's add the
> version information in case we need to differentiate between
> different versions of the hardware in the future.
> 
> Cc: David Brown <davidb@codeaurora.org>
> Cc: <devicetree@vger.kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> .../devicetree/bindings/serial/msm_serial.txt      | 82 ++++++++++++++++++++++
> 1 file changed, 82 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/serial/msm_serial.txt
> 
> diff --git a/Documentation/devicetree/bindings/serial/msm_serial.txt b/Documentation/devicetree/bindings/serial/msm_serial.txt
> new file mode 100644
> index 0000000..a6efac3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serial/msm_serial.txt
> @@ -0,0 +1,82 @@
> +* MSM Serial UART and UARTDM
> +
> +There are two MSM serial hardware designs. UARTDM is designed for use with a
> +dma engine in high-speed use cases and the non-DM design is for lower speed use
> +cases. The two designs are mostly compatible from a software perspective except
> +the non-DM design can only read and write one character at a time and so the
> +register layout differs slightly.

I think you split this into two binding spec docs, one for each type of uart.

> +
> +UART
> +----
> +Required properties:
> +- compatible: Should contain "qcom,msm-uart"
> +- reg: Should contain UART register location and length. The first

first? is there more than one reg region?

> +       register shall specify the main control registers
> +- interrupts: Should contain UART interrupt.
> +- clocks: Should contain the core clock.
> +- clock-names: Should be "core_clk".
> +
> +Optional properties:
> +- dmas: Should contain dma specifiers for transmit and receive
> +- dma-names: Should contain "tx" for transmit and "rx" for receive

confused, above you say the non-DM doesn't support DMA so, why the optional props?

> +
> +Example:
> +
> +A uart device with dma capabilities.
> +
> +serial@a9c00000 {
> +	compatible = "qcom,msm-uart";
> +	reg = <0xa9c00000 0x1000>;
> +	interrupts = <11>;
> +	clocks = <&uart_cxc>;
> +	clock-names = "core_clk";
> +	dmas = <&dma0 0>, <&dma0 1>;
> +	dma-names = "tx", "rx";
> +};
> +
> +UARTDM
> +------
> +Required properties:
> +- compatible: Should contain at least "qcom,msm-uartdm".
> +              A more specific property should be specified as follows depending
> +	      on the version:
> +		"qcom,msm-uartdm-v1.1"
> +		"qcom,msm-uartdm-v1.2"
> +		"qcom,msm-uartdm-v1.3"
> +		"qcom,msm-uartdm-v1.4"
> +- reg: Should contain UART register locations and lengths. The first
> +       register shall specify the main control registers. An optional second
> +       register location shall specify the GSBI control region.

Is GSBI region existing tied to particular versions (if so can we say that)

reg-names?

> +- interrupts: Should contain UART interrupt.
> +- clocks: Should contain the core clock and the ahb clock.

nit, ahb in caps?

> +- clock-names: Should be "core_clk" for the core clock and "iface_clk" for the
> +	       ahb clock.
> +
> +Optional properties:
> +- dmas: Should contain dma specifiers for transmit and receive channels
> +- dma-names: Should contain "tx" for transmit and "rx" for receive channels
> +
> +Examples:
> +
> +A uartdm v1.4 device with dma capabilities.
> +
> +serial@f991e000 {
> +	compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
> +	reg = <0xf991e000 0x1000>;
> +	interrupts = <0 108 0x0>;
> +	clocks = <&blsp1_uart2_apps_cxc>, <&blsp1_ahb_cxc>;
> +	clock-names = "core_clk", "iface_clk";
> +	dmas = <&dma0 0>, <&dma0 1>;
> +	dma-names = "tx", "rx";
> +};
> +
> +A uartdm v1.3 device without dma capabilities.
> +
> +serial@19c40000 {
> +	compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
> +	reg = <0x19c40000 0x1000>,
> +	      <0x19c00000 0x1000>;
> +	interrupts = <0 195 0x0>;
> +	clocks = <&gsbi5_uart_cxc>, <&gsbi5_ahb_cxc>;
> +	clock-names = "core_clk", "iface_clk";
> +};
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

