Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab3HLOOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:14:48 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46731 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755746Ab3HLOOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:14:44 -0400
Date: Mon, 12 Aug 2013 15:14:10 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "kevin.z.m.zh@gmail.com" <kevin.z.m.zh@gmail.com>,
        "sunny@allwinnertech.com" <sunny@allwinnertech.com>,
        "shuge@allwinnertech.com" <shuge@allwinnertech.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv3 3/4] clk: sunxi: Add A31 clocks support
Message-ID: <20130812141410.GB27165@e106331-lin.cambridge.arm.com>
References: <1375735381-18214-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375735381-18214-4-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375735381-18214-4-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding devicetree list to Cc]

Hi,

On Mon, Aug 05, 2013 at 09:43:00PM +0100, Maxime Ripard wrote:
> The A31 has a mostly different clock set compared to the other older
> SoCs currently supported in the Allwinner clock driver.
> 
> Add support for the basic useful clocks. The other ones will come in
> eventually.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  Documentation/devicetree/bindings/clock/sunxi.txt  |   6 +
>  .../bindings/clock/sunxi/sun6i-a31-gates.txt       |  83 ++++++++++++++
>  drivers/clk/sunxi/clk-sunxi.c                      | 124 +++++++++++++++++++++
>  3 files changed, 213 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/sunxi/sun6i-a31-gates.txt
> 
> diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Documentation/devicetree/bindings/clock/sunxi.txt
> index b24de10..c383d12 100644
> --- a/Documentation/devicetree/bindings/clock/sunxi.txt
> +++ b/Documentation/devicetree/bindings/clock/sunxi.txt
> @@ -8,6 +8,7 @@ Required properties:
>  - compatible : shall be one of the following:
>         "allwinner,sun4i-osc-clk" - for a gatable oscillator
>         "allwinner,sun4i-pll1-clk" - for the main PLL clock
> +       "allwinner,sun6i-a31-pll1-clk" - for the main PLL clock on A31
>         "allwinner,sun4i-cpu-clk" - for the CPU multiplexer clock
>         "allwinner,sun4i-axi-clk" - for the AXI clock
>         "allwinner,sun4i-axi-gates-clk" - for the AXI gates
> @@ -15,6 +16,8 @@ Required properties:
>         "allwinner,sun4i-ahb-gates-clk" - for the AHB gates on A10
>         "allwinner,sun5i-a13-ahb-gates-clk" - for the AHB gates on A13
>         "allwinner,sun5i-a10s-ahb-gates-clk" - for the AHB gates on A10s
> +       "allwinner,sun6i-a31-ahb1-mux-clk" - for the AHB1 multiplexer on A31
> +       "allwinner,sun6i-a31-ahb1-gates-clk" - for the AHB1 gates on A31
>         "allwinner,sun4i-apb0-clk" - for the APB0 clock
>         "allwinner,sun4i-apb0-gates-clk" - for the APB0 gates on A10
>         "allwinner,sun5i-a13-apb0-gates-clk" - for the APB0 gates on A13
> @@ -24,6 +27,9 @@ Required properties:
>         "allwinner,sun4i-apb1-gates-clk" - for the APB1 gates on A10
>         "allwinner,sun5i-a13-apb1-gates-clk" - for the APB1 gates on A13
>         "allwinner,sun5i-a10s-apb1-gates-clk" - for the APB1 gates on A10s
> +       "allwinner,sun6i-a31-apb1-gates-clk" - for the APB1 gates on A31
> +       "allwinner,sun6i-a31-apb2-div-clk" - for the APB2 gates on A31
> +       "allwinner,sun6i-a31-apb2-gates-clk" - for the APB2 gates on A31
> 
>  Required properties for all clocks:
>  - reg : shall be the control register address for the clock.

This looks sensible, but I have a couple of questions below:

> diff --git a/Documentation/devicetree/bindings/clock/sunxi/sun6i-a31-gates.txt b/Documentation/devicetree/bindings/clock/sunxi/sun6i-a31-gates.txt
> new file mode 100644
> index 0000000..fe44932
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/sunxi/sun6i-a31-gates.txt
> @@ -0,0 +1,83 @@
> +Gate clock outputs
> +------------------
> +
> +  * AHB1 gates ("allwinner,sun6i-a31-ahb1-gates-clk")
> +
> +    MIPI DSI                                   1
> +
> +    SS                                         5
> +    DMA                                                6
> +
> +    MMC0                                       8
> +    MMC1                                       9
> +    MMC2                                       10
> +    MMC3                                       11
> +
> +    NAND1                                      12
> +    NAND0                                      13
> +    SDRAM                                      14
> +
> +    GMAC                                       17
> +    TS                                         18
> +    HSTIMER                                    19
> +    SPI0                                       20
> +    SPI1                                       21
> +    SPI2                                       22
> +    SPI3                                       23
> +    USB_OTG                                    24
> +
> +    EHCI0                                      26
> +    EHCI1                                      27
> +
> +    OHCI0                                      29
> +    OHCI1                                      30
> +    OHCI2                                      31
> +    VE                                         32
> +
> +    LCD0                                       36
> +    LCD1                                       37
> +
> +    CSI                                                40
> +
> +    HDMI                                       43
> +    DE_BE0                                     44
> +    DE_BE1                                     45
> +    DE_FE1                                     46
> +    DE_FE1                                     47
> +
> +    MP                                         50
> +
> +    GPU                                                52
> +
> +    DEU0                                       55
> +    DEU1                                       56
> +    DRC0                                       57
> +    DRC1                                       58
> +
> +  * APB1 gates ("allwinner,sun6i-a31-apb1-gates-clk")
> +
> +    CODEC                                      0
> +
> +    DIGITAL MIC                                        4
> +    PIO                                                5
> +
> +    DAUDIO0                                    12
> +    DAUDIO1                                    13
> +
> +  * APB2 gates ("allwinner,sun6i-a31-apb2-gates-clk")
> +
> +    I2C0                                       0
> +    I2C1                                       1
> +    I2C2                                       2
> +    I2C3                                       3
> +
> +    UART0                                      16
> +    UART1                                      17
> +    UART2                                      18
> +    UART3                                      19
> +    UART4                                      20
> +    UART5                                      21
> +

Are those the specific names of the clock outputs, or just what they're
wired to on the A31? I noticed the a13 gate bindings mentioned a clock
called MALI400, which seemed awfully specific, but I don't have a
datasheet handy.

Does the binding cover all clocks (even if the driver doesn't yet
support them)? Is there any reason we can't document those clock names
and associated IDs in the binding now even if we can't yet drive them?

Thanks,
Mark.
