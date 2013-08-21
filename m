Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab3HUPa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:30:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49694 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab3HUPa4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:30:56 -0400
Subject: Re: [PATCH v2 2/5] devicetree: serial: Document msm_serial bindings
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1377067686-31957-3-git-send-email-sboyd@codeaurora.org>
Date: Wed, 21 Aug 2013 10:30:58 -0500
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        David Brown <davidb@codeaurora.org>, <devicetree@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <6E3C7111-D337-4DDF-9EF9-F8DC75A1C0B4@codeaurora.org>
References: <1377067686-31957-1-git-send-email-sboyd@codeaurora.org> <1377067686-31957-3-git-send-email-sboyd@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 21, 2013, at 1:48 AM, Stephen Boyd wrote:

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
> .../devicetree/bindings/serial/qcom,msm-uart.txt   | 25 +++++++++++
> .../devicetree/bindings/serial/qcom,msm-uartdm.txt | 52 ++++++++++++++++++++++
> 2 files changed, 77 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/serial/qcom,msm-uart.txt
> create mode 100644 Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt

Should we remove bindings/tty/serial/msm_serial.txt ?

> diff --git a/Documentation/devicetree/bindings/serial/qcom,msm-uart.txt b/Documentation/devicetree/bindings/serial/qcom,msm-uart.txt
> new file mode 100644
> index 0000000..ce8c901
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serial/qcom,msm-uart.txt
> @@ -0,0 +1,25 @@
> +* MSM Serial UART
> +
> +The MSM serial UART hardware is designed for low-speed use cases where a
> +dma-engine isn't needed. From a software perspective it's mostly compatible
> +with the MSM serial UARTDM except that it only supports reading and writing one
> +character at a time.
> +
> +Required properties:
> +- compatible: Should contain "qcom,msm-uart"
> +- reg: Should contain UART register location and length.
> +- interrupts: Should contain UART interrupt.
> +- clocks: Should contain the core clock.
> +- clock-names: Should be "core".
> +
> +Example:
> +
> +A uart device at 0xa9c00000 with interrupt 11.
> +
> +serial@a9c00000 {
> +	compatible = "qcom,msm-uart";
> +	reg = <0xa9c00000 0x1000>;
> +	interrupts = <11>;
> +	clocks = <&uart_cxc>;
> +	clock-names = "core";
> +};
> diff --git a/Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt b/Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt
> new file mode 100644
> index 0000000..1a4d681
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serial/qcom,msm-uartdm.txt
> @@ -0,0 +1,52 @@
> +* MSM Serial UARTDM
> +
> +The MSM serial UARTDM hardware is designed for high-speed use cases where the
> +transmit and/or receive channels can be offloaded to a dma-engine. From a
> +software perspective it's mostly compatible with the MSM serial UART except
> +that it supports reading and writing multiple characters at a time.
> +
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

Can we add something like:

"qcom,msm-uartdm-v1.3" is the only compatible that might optionally need the GSBI control region.

> +- interrupts: Should contain UART interrupt.
> +- clocks: Should contain the core clock and the AHB clock.
> +- clock-names: Should be "core" for the core clock and "iface" for the
> +	       AHB clock.
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
> +	clock-names = "core", "iface";
> +	dmas = <&dma0 0>, <&dma0 1>;
> +	dma-names = "tx", "rx";
> +};
> +
> +A uartdm v1.3 device without dma capabilities and part of a GSBI complex. Note
> +that not all v1.3 hardware is part of a GSBI.
> +
> +serial@19c40000 {
> +	compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
> +	reg = <0x19c40000 0x1000>,
> +	      <0x19c00000 0x1000>;
> +	interrupts = <0 195 0x0>;
> +	clocks = <&gsbi5_uart_cxc>, <&gsbi5_ahb_cxc>;
> +	clock-names = "core", "iface";
> +};
> -- 

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

