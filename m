Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaENWck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:32:40 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:37343 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaENWch convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:32:37 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "Sebastian Hesselbarth" <sebastian.hesselbarth@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1399839881-29895-3-git-send-email-sebastian.hesselbarth@gmail.com>
Cc: "Rob Herring" <robh+dt@kernel.org>, "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        "Randy Dunlap" <rdunlap@infradead.org>,
        "Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
        "Antoine Tenart" <antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1399839881-29895-3-git-send-email-sebastian.hesselbarth@gmail.com>
Message-ID: <20140514223230.19795.63328@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 2/8] clk: berlin: add clock binding docs for Marvell Berlin2 SoCs
Date: Wed, 14 May 2014 15:32:30 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sebastian Hesselbarth (2014-05-11 13:24:35)
> This adds mandatory device tree binding documentation for the clock related
> IP found on Marvell Berlin2 (BG2, BG2CD, and BG2Q) SoCs.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Cc: Antoine Tenart <antoine.tenart@free-electrons.com>
> Cc: devicetree@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  .../devicetree/bindings/clock/berlin2-clock.txt    | 169 +++++++++++++++++++++
>  1 file changed, 169 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/berlin2-clock.txt
> 
> diff --git a/Documentation/devicetree/bindings/clock/berlin2-clock.txt b/Documentation/devicetree/bindings/clock/berlin2-clock.txt
> new file mode 100644
> index 000000000000..3da87a488402
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/berlin2-clock.txt
> @@ -0,0 +1,169 @@
> +* Marvell Berlin2 clock bindings
> +
> +Marvell Berlin2 (BG2, BG2CD, BG2Q) share the same IP for PLLs and clocks,
> +with some minor differences in features and register layout. The below
> +describes the individual clock related IP:
> +
> +* Audio/Video PLL
> +
> +The Audio/Video PLL (AVPLL) is a dual-VCO PLL with 8 channels each. Each
> +of the VCOs can sythesize a single VCO frequency based on a single input
> +reference clock. Each of the 8 channels then, can derive an output clock
> +from that VCO frequency by various dividers/multipliers.
> +
> +Required properties:
> +- compatible: shall be "marvell,berlin2-avpll"
> +- reg: address and length of the corresponding AVPLL registers
> +- #clock-cells: shall be set to 2
> +- clocks: single clock specifier referencing the AVPLL input clock
> +
> +To ease match-up with the desired AVPLL output clock, clock specifiers
> +referencing AVPLL clocks shall contain two cells. The first refers to
> +the VCO (0=AVPLL_A, 1=AVPLL_B) while the second refers to the corresponding
> +channel starting with 1. For example, to reference AVPLL_B3 the clock
> +specifier shall be: <&avpll 1 3>.
> +
> +Example:
> +
> +avpll: pll@ea0040 {
> +       compatible = "marvell,berlin2-avpll";
> +       #clock-cells = <2>;
> +       reg = <0xea0050 0x100>;
> +       clocks = <&refclk>;
> +};

Hi Sebastian,

Thanks for submitting the series. It looks good. I do have some comments
about the DT bindings though. I'm encouraging new bindings (and
especially new platforms or existing platforms that are only now
converting over to CCF) to not put their per-clock data into DTS. This
has scalability problems, is unpopular with the DT crowd and sometimes
makes it hard to do things like set CLK_SET_RATE_PARENT flags for
individual clocks.

The following is a copy/paste from an email I sent earlier today[1]. Of
course per-clock data makes great sense if you have an off-SoC clock
such as a fixed-rate oscillator (e.g. the fixed-clock binding). Let me
know what you think:

I assume the rest of your clocks are part of a clock generator IP block
inside of your chip. Have you looked at the QCOM binding? It is my
favorite binding these days. Here are some highlights:

See Documentation/devicetree/bindings/clock/qcom,gcc.txt.



>From arch/arm/boot/dts/qcom-msm8974.dtsi:

gcc: clock-controller@fc400000 {
        compatible = "qcom,gcc-msm8974";
        #clock-cells = <1>;
        #reset-cells = <1>;
        reg = <0xfc400000 0x4000>;
};

...

serial@f991e000 {
        compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
        reg = <0xf991e000 0x1000>;
        interrupts = <0 108 0x0>;
        clocks = <&gcc GCC_BLSP1_UART2_APPS_CLK>, <&gcc GCC_BLSP1_AHB_CLK>;
        clock-names = "core", "iface";
};



>From drivers/clk/qcom/gcc-msm8974.c:

static struct clk_branch gcc_blsp1_uart2_apps_clk = {
        .halt_reg = 0x0704,
        .clkr = {
                .enable_reg = 0x0704,
                .enable_mask = BIT(0),
                .hw.init = &(struct clk_init_data){
                        .name = "gcc_blsp1_uart2_apps_clk",
                        .parent_names = (const char *[]){
                                "blsp1_uart2_apps_clk_src",
                        },
                        .num_parents = 1,
                        .flags = CLK_SET_RATE_PARENT,
                        .ops = &clk_branch2_ops,
                },
        },
};

Using this type of binding you only need to declare your clock generator
IP node in dts, and then define a mapping in the DT include chroot. Then
you can define your per-clock data inside of your clock driver instead
of putting all of the details inside of DT.

If you have a strong reason to do it the way that you originally posted
then let me know.

Regards,
Mike

[1] https://lkml.org/lkml/2014/5/14/598
