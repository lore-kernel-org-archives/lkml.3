Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaENUI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 16:08:56 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58875 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbaENUIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 16:08:52 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Anders Berg <anders.berg@avagotech.com>, "Arnd Bergmann" <arnd@arndb.de>,
        "Olof Johansson" <olof@lixom.net>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <a83c5e1272d7a3242701504f238789592c2ec80f.1400072260.git.anders.berg@avagotech.com>
Cc: "Linus Walleij" <linus.walleij@linaro.org>,
        "Russell King" <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Anders Berg" <anders.berg@lsi.com>,
        "Mark Rutland" <mark.rutland@arm.com>
References: <cover.1400072260.git.anders.berg@avagotech.com>
 <a83c5e1272d7a3242701504f238789592c2ec80f.1400072260.git.anders.berg@avagotech.com>
Message-ID: <20140514200845.19795.80794@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v3 2/6] clk: Add clock driver for AXM55xx SoC
Date: Wed, 14 May 2014 13:08:45 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Anders Berg (2014-05-14 11:37:57)
> +Example:
> +
> +       clk_ref0: clk_ref0 {
> +               compatible = "fixed-clock";
> +               #clock-cells = <0>;
> +               clock-frequency = <125000000>;
> +       };

Hi Anders,

The driver looks good. As for the DT binding, I am starting to request
that bindings for new hardware move away from the one-clock-per-node
method. I am not forcing anyone with stable bindings to migrate that
way, but it tends to make maintenance easier in the long run (e.g.
setting per-clock flags, etc).

Your clk_ref0 example looks good, assuming that it is an off-chip clock
that feeds into the rest of the clock generator.

> +
> +       clk_cpu_pll: clk_cpu_pll@2010022000 {
> +               compatible = "lsi,axxia-pll-clock";
> +               #clock-cells = <0>;
> +               clocks = <&clk_ref0>;
> +               clock-output-names = "clk_cpu_pll";
> +               reg = <0x20 0x10022000 0 0x2c>;
> +       };

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



>From include/dt-bindings/clock/qcom,gcc-msm8974.h:

#define GCC_BLSP1_UART2_APPS_CLK                                103



Using this type of binding you only need to declare your clock generator
IP node in dts, and then define a mapping in the DT include chroot. Then
you can define your per-clock data inside of your clock driver instead
of putting all of the details inside of DT.

If you have a strong reason to do it the way that you originally posted
then let me know.

Regards,
Mike
