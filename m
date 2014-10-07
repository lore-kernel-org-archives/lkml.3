Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbaJGLF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 07:05:57 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:41985 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbaJGLFz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 07:05:55 -0400
MIME-Version: 1.0
In-Reply-To: <c2b9a1c1-d3b9-48c5-9c14-a4c3a95965fa@BN1AFFO11FD046.protection.gbl>
References: <c2b9a1c1-d3b9-48c5-9c14-a4c3a95965fa@BN1AFFO11FD046.protection.gbl>
Date: Tue, 7 Oct 2014 13:05:54 +0200
Message-ID: <CACRpkdaZ2Yy7=CcOjnsQ0K7KYTN=wHaeZTDNxpvnf+axLLLJ_g@mail.gmail.com>
Subject: Re: [RFC] pinctrl driver for Zynq
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:09 PM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> I think I have pinctrl driver that is covering the pinmux options of
> Zynq and I also figured out how the DT bindings work.

OK let's look....

> One thing making the DT bindings explode, seems to be all those single
> pin functions that can be muxed to every pin.

The purpose of the device tree is to describe configuration of the
hardware, not to describe all possibilities the hardware has, just those
deployed on a specific system. I think this is the problem, will
look more into detail below...

> Next to GPIO, this applies to SD card and write protect - which are even
> present twice since Zynq has two SDIO cores. Just these functions
> account for a couple of hundred nodes in the DT and a bunch of lines in
> the driver. Is there a better way to do this?

Probably :-)

> In particular for GPIO there seemed to be a better solution with
> implementing gpio_request_enable(), but that seemed to allow GPIO in
> parallel to request and mux the pin which does not work on Zynq.

Just that it becomes possible to use GPIO and another function in
parallel doesn't mean you have to use this possibility. I think this
is the case with some drivers as of now.

I know it has this unfulfilledness about it...

> IOW: I
> expected the core would reject a call of gpio_request_enable for a pin
> that is already muxed to some other function, but that was not the case
> in my testing. Am I missing something here?

There are systems where a certain function and GPIO can be used
in parallel, so GPIO can "spy" on a pin used by another function.
I think there was something like a flag line from some hardware
that was used by the HW block, but sometimes other parts of
the system needed to know the state of that line and it was not
in the registers for that hardware, but it could be read by using this
dual-mode property of the GPIO.

> And finally, for SD card detect and write protect, we actually have to
> disable the muxing. The problem with those functions is, that they have
> a dedicated mux for that function which is in parallel to the "normal"
> pinmuxes. So, muxing a "normal" function to a pin would not void the
> muxing of the SD signals.

This should be solved internally in the pin control driver, as it should
handle hardware pecularities and abstract it to the framework.

Do not rely on the framework to provide convenient quirk hooks
for hardware oddities.

> I thought this would be easily resolved by
> implementing the 'disable' op, but after I did that, I noticed that
> there is only a stale documentation comment of this member of struct
> pinmux_ops left, the actual function pointer is gone.

This has been removed since it was bogus and is being cleaned
up and the vtable entry .enable() has been renamed .set_mux().

> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> index 6cc83d4c6c76..814873da0392 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -229,7 +229,7 @@
>                 slcr: slcr@f8000000 {
>                         #address-cells = <1>;
>                         #size-cells = <1>;
> -                       compatible = "xlnx,zynq-slcr", "syscon";
> +                       compatible = "xlnx,zynq-slcr", "syscon", "simple-bus";
>                         reg = <0xF8000000 0x1000>;
>                         ranges;
>                         clkc: clkc@100 {
> @@ -250,6 +250,3043 @@
>                                                 "dbg_trc", "dbg_apb";
>                                 reg = <0x100 0x100>;
>                         };
> +
> +                       pinctrl0: pinctrl@700 {
> +                               compatible = "xlnx,pinctrl-zynq";
> +                               reg = <0x700 0x200>;
> +
> +                               pinctrl_i2c0_0: pinctrl-i2c0@0 {

So is this a state?

> +                                       i2c0-mux {
> +                                               function = "i2c0";
> +                                               pins = "i2c0_0_grp";

This I know we discussed in person. I have renamed the latter
string from "pins" to "groups" which is as you can see way more
appropriate. See this patch which is queued for v3.18:

http://marc.info/?l=devicetree&m=141223584006648&w=2

I'm also working on converting the Nomadik driver to this and
provide central DT parsing in the pin control core.

> +                               pinctrl_i2c0_1: pinctrl-i2c0@1 {
> +                                       i2c0-mux {
> +                                               function = "i2c0";
> +                                               pins = "i2c0_1_grp";
> +                                       };
> +                               };
> +
> +                               pinctrl_i2c0_2: pinctrl-i2c0@2 {
> +                                       i2c0-mux {
> +                                               function = "i2c0";
> +                                               pins = "i2c0_2_grp";
> +                                       };
> +                               };

My main concern here is whether all these states are really
in use, or if you're busy outlining everything the controller
can do. Just include the bits you actually need for the
specific system this device tree is for.

> +                               pinctrl_i2c1_10: pinctrl-i2c1@10 {
> +                                       i2c1-mux {
> +                                               function = "i2c1";
> +                                               pins = "i2c1_10_grp";
> +                                       };
> +                               };
> +
> +                               pinctrl_gem0_0: pinctrl-gem0@0 {
> +                                       gem0-mux {
> +                                               function = "ethernet0";
> +                                               pins = "ethernet0_0_grp";
> +                                       };
> +                               };

This doesn't add up. You opened up
pinctrl_i2c0_0: pinctrl-i2c0@0 { ... a bit up.

Now you're putting gem0 and what not into a i2c0's node?

Something is seriously wrong here and I don't know where
it's gone wrong.

> +                               pinctrl_gpio0_0: pinctrl-gpio0@0 {
> +                                       gpio0-mux {
> +                                               function = "gpio0";
> +                                               pins = "gpio0_0_grp";
> +                                       };
> +                               };

Yeah that's sort of hairy to maintain isn't it?
Go for the quick helper function .gpio_request_enable() and
skip this. Live with the fact that pins may be used in
parallel or figure out a way to patch the framework to prevent
it.

I once considered add a bool no_dual_mode_gpio; to
pinctrl_desc and enforce isolation between the two things.

> diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zynq-zc706.dts
> index 4cc9913078cd..1ae9bcaee252 100644
> --- a/arch/arm/boot/dts/zynq-zc706.dts
> +++ b/arch/arm/boot/dts/zynq-zc706.dts
> @@ -33,11 +33,20 @@
>  &gem0 {

I'm not familiar with this syntax of putting an ampersand in front
of a node like that. What does that mean? To me ampersands
are phandles :-/

>         status = "okay";
>         phy-mode = "rgmii";
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&pinctrl_gem0_0>, <&pinctrl_mdio0_0>;

This looks right, and maybe you should put in only these
nodes that you actually use below the pin controller?

>  &i2c0 {
>         status = "okay";
>         clock-frequency = <400000>;
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&pinctrl_i2c0_10>;

So why do we need to defined pinctrl_i2c0_0 ...
pinctrl_i2c0_N?

> +++ b/arch/arm/mach-zynq/Kconfig
> @@ -9,6 +9,7 @@ config ARCH_ZYNQ
>         select HAVE_ARM_TWD if SMP
>         select ICST
>         select MFD_SYSCON
> +       select PINCTRL

select PINCTRL_ZYNQ?

Usually these things seem to be hard to live without.

> +++ b/drivers/pinctrl/Kconfig
> @@ -305,6 +305,14 @@ config PINCTRL_PALMAS
>           open drain configuration for the Palmas series devices like
>           TPS65913, TPS80036 etc.
>
> +config PINCTRL_ZYNQ
> +       bool "Pinctrl driver for Xilinx Zynq"
> +       depends on ARCH_ZYNQ
> +       select PINMUX
> +       select GENERIC_PINCONF

Thanks for using generic pinconf. But you haven't implemented
it yet?!

> +++ b/drivers/pinctrl/pinctrl-zynq.c
(...)
> +#define ZYNQ_PINMUX_MUX_SHIFT  1
> +#define ZYNQ_PINMUX_MUX_MASK   (0x7f << ZYNQ_PINMUX_MUX_SHIFT)

I would just like ...
#define ZYNQ_PINMUX_MUX_MASK 0xfe

> +/**
> + * struct zynq_pinmux_function - a pinmux function
> + * @name:    Name of the pinmux function.
> + * @groups:  List of pingroups for this function.
> + * @ngroups: Number of entries in @groups.
> + */
> +struct zynq_pinmux_function {
> +       const char *name;
> +       const char * const *groups;
> +       unsigned int ngroups;
> +       unsigned int mux_val;
> +       u32 mux;
> +       u32 mux_mask;
> +       u8 mux_shift;
> +};

I agree: it is a good thing to document. But kerneldoc all of
it!

> +enum zynq_pinmux_functions {
> +       ZYNQ_PMUX_ethernet0,
> +       ZYNQ_PMUX_ethernet1,
> +       ZYNQ_PMUX_mdio0,
> +       ZYNQ_PMUX_mdio1,
> +       ZYNQ_PMUX_qspi0,
> +       ZYNQ_PMUX_qspi1,
> +       ZYNQ_PMUX_qspi_fbclk,
> +       ZYNQ_PMUX_qspi_cs1,
> +       ZYNQ_PMUX_spi0,
> +       ZYNQ_PMUX_spi1,
> +       ZYNQ_PMUX_sdio0,
> +       ZYNQ_PMUX_sdio0_pc,
> +       ZYNQ_PMUX_sdio0_cd,
> +       ZYNQ_PMUX_sdio0_wp,
> +       ZYNQ_PMUX_sdio1,
> +       ZYNQ_PMUX_sdio1_pc,
> +       ZYNQ_PMUX_sdio1_cd,
> +       ZYNQ_PMUX_sdio1_wp,
> +       ZYNQ_PMUX_smc0_nor,
> +       ZYNQ_PMUX_smc0_nor_cs1,
> +       ZYNQ_PMUX_smc0_nor_addr25,
> +       ZYNQ_PMUX_smc0_nand,
> +       ZYNQ_PMUX_can0,
> +       ZYNQ_PMUX_can1,
> +       ZYNQ_PMUX_uart0,
> +       ZYNQ_PMUX_uart1,
> +       ZYNQ_PMUX_i2c0,
> +       ZYNQ_PMUX_i2c1,
> +       ZYNQ_PMUX_ttc0,
> +       ZYNQ_PMUX_ttc1,
> +       ZYNQ_PMUX_swdt0,
> +       ZYNQ_PMUX_gpio0,
> +       ZYNQ_PMUX_MAX_FUNC
> +};

This looks entirely reasonable. Those are the functions we
really need to control on this system.

> +const struct pinctrl_pin_desc zynq_pins[] = {
> +      PINCTRL_PIN(0,  "MIO0"),
(...)
> +      PINCTRL_PIN(53, "MIO53"),
> +      PINCTRL_PIN(54, "EMIO_SD0_WP"),
> +      PINCTRL_PIN(55, "EMIO_SD0_CD"),
> +      PINCTRL_PIN(56, "EMIO_SD1_WP"),
> +      PINCTRL_PIN(57, "EMIO_SD0_CD"),
> +};

Looks good.

> +/* pin groups */
> +static const unsigned int ethernet0_0_pins[] = {16, 17, 18, 19, 20, 21, 22, 23, 24,
> +                                           25, 26, 27};
> +static const unsigned int ethernet1_0_pins[] = {28, 29, 30, 31, 32, 33, 34, 35, 36,
> +                                               37, 38, 39};
(...)
> +static const unsigned int sdio1_3_pins[] = {46, 47, 48, 49, 40, 51};

Looks good.

> +static const unsigned int sdio0_emio_wp_pins[] = {54};
> +static const unsigned int sdio0_emio_cd_pins[] = {55};
> +static const unsigned int sdio1_emio_wp_pins[] = {56};
> +static const unsigned int sdio1_emio_cd_pins[] = {57};

So these are unique functions, not just a way to use GPIO?

(...)
> +static const unsigned int swdt0_4_pins[] = {52, 53};

Looks good until here.

> +static const unsigned int gpio0_0_pins[] = {0};
(...)
> +static const unsigned int gpio0_53_pins[] = {53};

Looks very tiresome to maintain. What about using the
shortcut?

(...)
> +struct zynq_pctrl_group zynq_pctrl_groups[] = {
> +       DEFINE_ZYNQ_PINCTRL_GRP(ethernet0_0),
> +       DEFINE_ZYNQ_PINCTRL_GRP(ethernet1_0),
(...)
> +       DEFINE_ZYNQ_PINCTRL_GRP(swdt0_4),

Generally looks good.

> +/* function groups */
> +static const char * const ethernet0_groups[] = {"ethernet0_0_grp"};
> +static const char * const ethernet1_groups[] = {"ethernet1_0_grp"};
> +static const char * const mdio0_groups[] = {"mdio0_0_grp"};
> +static const char * const mdio1_groups[] = {"mdio1_0_grp"};
> +static const char * const qspi0_groups[] = {"qspi0_0_grp"};
> +static const char * const qspi1_groups[] = {"qspi0_1_grp"};
> +static const char * const qspi_fbclk_groups[] = {"qspi_fbclk_grp"};
> +static const char * const qspi_cs1_groups[] = {"qspi_cs1_grp"};
> +static const char * const spi0_groups[] =
> +                               {"spi0_0_grp", "spi0_1_grp", "spi0_2_grp"};
> +static const char * const spi1_groups[] =
> +               {"spi1_0_grp", "spi1_1_grp", "spi1_2_grp", "spi1_3_grp"};

Looks good too, OK these functions can be muxed on these groups...

> +static const char * const sdio0_pc_groups[] = {"gpio0_0_grp",
> +               "gpio0_2_grp", "gpio0_4_grp", "gpio0_6_grp",
> +               "gpio0_8_grp", "gpio0_10_grp", "gpio0_12_grp",
> +               "gpio0_14_grp", "gpio0_16_grp", "gpio0_18_grp",
> +               "gpio0_20_grp", "gpio0_22_grp", "gpio0_24_grp",
> +               "gpio0_26_grp", "gpio0_28_grp", "gpio0_30_grp",
> +               "gpio0_32_grp", "gpio0_34_grp", "gpio0_36_grp",
> +               "gpio0_38_grp", "gpio0_40_grp", "gpio0_42_grp",
> +               "gpio0_44_grp", "gpio0_46_grp", "gpio0_48_grp",
> +               "gpio0_50_grp", "gpio0_52_grp"};
> +static const char * const sdio1_pc_groups[] = {"gpio0_1_grp",
> +               "gpio0_3_grp", "gpio0_5_grp", "gpio0_7_grp",
> +               "gpio0_9_grp", "gpio0_11_grp", "gpio0_13_grp",
> +               "gpio0_15_grp", "gpio0_17_grp", "gpio0_19_grp",
> +               "gpio0_21_grp", "gpio0_23_grp", "gpio0_25_grp",
> +               "gpio0_27_grp", "gpio0_29_grp", "gpio0_31_grp",
> +               "gpio0_33_grp", "gpio0_35_grp", "gpio0_37_grp",
> +               "gpio0_39_grp", "gpio0_41_grp", "gpio0_43_grp",
> +               "gpio0_45_grp", "gpio0_47_grp", "gpio0_49_grp",
> +               "gpio0_51_grp", "gpio0_53_grp"};
> +static const char * const sdio0_cd_groups[] = {"gpio0_0_grp",
> +               "gpio0_2_grp", "gpio0_4_grp", "gpio0_6_grp",
> +               "gpio0_10_grp", "gpio0_12_grp",
> +               "gpio0_14_grp", "gpio0_16_grp", "gpio0_18_grp",
> +               "gpio0_20_grp", "gpio0_22_grp", "gpio0_24_grp",
> +               "gpio0_26_grp", "gpio0_28_grp", "gpio0_30_grp",
> +               "gpio0_32_grp", "gpio0_34_grp", "gpio0_36_grp",
> +               "gpio0_38_grp", "gpio0_40_grp", "gpio0_42_grp",
> +               "gpio0_44_grp", "gpio0_46_grp", "gpio0_48_grp",
> +               "gpio0_50_grp", "gpio0_52_grp", "gpio0_1_grp",
> +               "gpio0_3_grp", "gpio0_5_grp",
> +               "gpio0_9_grp", "gpio0_11_grp", "gpio0_13_grp",
> +               "gpio0_15_grp", "gpio0_17_grp", "gpio0_19_grp",
> +               "gpio0_21_grp", "gpio0_23_grp", "gpio0_25_grp",
> +               "gpio0_27_grp", "gpio0_29_grp", "gpio0_31_grp",
> +               "gpio0_33_grp", "gpio0_35_grp", "gpio0_37_grp",
> +               "gpio0_39_grp", "gpio0_41_grp", "gpio0_43_grp",
> +               "gpio0_45_grp", "gpio0_47_grp", "gpio0_49_grp",
> +               "gpio0_51_grp", "gpio0_53_grp", "sdio0_emio_cd_grp"};
> +static const char * const sdio0_wp_groups[] = {"gpio0_0_grp",
> +               "gpio0_2_grp", "gpio0_4_grp", "gpio0_6_grp",
> +               "gpio0_10_grp", "gpio0_12_grp",
> +               "gpio0_14_grp", "gpio0_16_grp", "gpio0_18_grp",
> +               "gpio0_20_grp", "gpio0_22_grp", "gpio0_24_grp",
> +               "gpio0_26_grp", "gpio0_28_grp", "gpio0_30_grp",
> +               "gpio0_32_grp", "gpio0_34_grp", "gpio0_36_grp",
> +               "gpio0_38_grp", "gpio0_40_grp", "gpio0_42_grp",
> +               "gpio0_44_grp", "gpio0_46_grp", "gpio0_48_grp",
> +               "gpio0_50_grp", "gpio0_52_grp", "gpio0_1_grp",
> +               "gpio0_3_grp", "gpio0_5_grp",
> +               "gpio0_9_grp", "gpio0_11_grp", "gpio0_13_grp",
> +               "gpio0_15_grp", "gpio0_17_grp", "gpio0_19_grp",
> +               "gpio0_21_grp", "gpio0_23_grp", "gpio0_25_grp",
> +               "gpio0_27_grp", "gpio0_29_grp", "gpio0_31_grp",
> +               "gpio0_33_grp", "gpio0_35_grp", "gpio0_37_grp",
> +               "gpio0_39_grp", "gpio0_41_grp", "gpio0_43_grp",
> +               "gpio0_45_grp", "gpio0_47_grp", "gpio0_49_grp",
> +               "gpio0_51_grp", "gpio0_53_grp", "sdio0_emio_wp_grp"};
> +static const char * const sdio1_cd_groups[] = {"gpio0_0_grp",
> +               "gpio0_2_grp", "gpio0_4_grp", "gpio0_6_grp",
> +               "gpio0_10_grp", "gpio0_12_grp",
> +               "gpio0_14_grp", "gpio0_16_grp", "gpio0_18_grp",
> +               "gpio0_20_grp", "gpio0_22_grp", "gpio0_24_grp",
> +               "gpio0_26_grp", "gpio0_28_grp", "gpio0_30_grp",
> +               "gpio0_32_grp", "gpio0_34_grp", "gpio0_36_grp",
> +               "gpio0_38_grp", "gpio0_40_grp", "gpio0_42_grp",
> +               "gpio0_44_grp", "gpio0_46_grp", "gpio0_48_grp",
> +               "gpio0_50_grp", "gpio0_52_grp", "gpio0_1_grp",
> +               "gpio0_3_grp", "gpio0_5_grp",
> +               "gpio0_9_grp", "gpio0_11_grp", "gpio0_13_grp",
> +               "gpio0_15_grp", "gpio0_17_grp", "gpio0_19_grp",
> +               "gpio0_21_grp", "gpio0_23_grp", "gpio0_25_grp",
> +               "gpio0_27_grp", "gpio0_29_grp", "gpio0_31_grp",
> +               "gpio0_33_grp", "gpio0_35_grp", "gpio0_37_grp",
> +               "gpio0_39_grp", "gpio0_41_grp", "gpio0_43_grp",
> +               "gpio0_45_grp", "gpio0_47_grp", "gpio0_49_grp",
> +               "gpio0_51_grp", "gpio0_53_grp", "sdio1_emio_cd_grp"};
> +static const char * const sdio1_wp_groups[] = {"gpio0_0_grp",
> +               "gpio0_2_grp", "gpio0_4_grp", "gpio0_6_grp",
> +               "gpio0_10_grp", "gpio0_12_grp",
> +               "gpio0_14_grp", "gpio0_16_grp", "gpio0_18_grp",
> +               "gpio0_20_grp", "gpio0_22_grp", "gpio0_24_grp",
> +               "gpio0_26_grp", "gpio0_28_grp", "gpio0_30_grp",
> +               "gpio0_32_grp", "gpio0_34_grp", "gpio0_36_grp",
> +               "gpio0_38_grp", "gpio0_40_grp", "gpio0_42_grp",
> +               "gpio0_44_grp", "gpio0_46_grp", "gpio0_48_grp",
> +               "gpio0_50_grp", "gpio0_52_grp", "gpio0_1_grp",
> +               "gpio0_3_grp", "gpio0_5_grp",
> +               "gpio0_9_grp", "gpio0_11_grp", "gpio0_13_grp",
> +               "gpio0_15_grp", "gpio0_17_grp", "gpio0_19_grp",
> +               "gpio0_21_grp", "gpio0_23_grp", "gpio0_25_grp",
> +               "gpio0_27_grp", "gpio0_29_grp", "gpio0_31_grp",
> +               "gpio0_33_grp", "gpio0_35_grp", "gpio0_37_grp",
> +               "gpio0_39_grp", "gpio0_41_grp", "gpio0_43_grp",
> +               "gpio0_45_grp", "gpio0_47_grp", "gpio0_49_grp",
> +               "gpio0_51_grp", "gpio0_53_grp", "sdio1_emio_wp_grp"};

That's like, making your life hard. Use the shortcut.

> +#define DEFINE_ZYNQ_PINMUX_FUNCTION(fname, mval)       \
> +       [ZYNQ_PMUX_##fname] = {                         \
> +               .name = #fname,                         \
> +               .groups = fname##_groups,               \
> +               .ngroups = ARRAY_SIZE(fname##_groups),  \
> +               .mux_val = mval                         \
> +       }
> +
> +#define DEFINE_ZYNQ_PINMUX_FUNCTION_MUX(fname, mval, mux, mask, shift) \
> +       [ZYNQ_PMUX_##fname] = {                         \
> +               .name = #fname,                         \
> +               .groups = fname##_groups,               \
> +               .ngroups = ARRAY_SIZE(fname##_groups),  \
> +               .mux_val = mval,                        \
> +               .mux_mask = mask,                       \
> +               .mux_shift = shift                      \
> +       }
> +
> +#define ZYNQ_SDIO_WP_SHIFT     0
> +#define ZYNQ_SDIO_WP_MASK      (0x3f << ZYNQ_SDIO_WP_SHIFT)

Defining something and shifting it 0 positions seem a bit surplus.

> +#define ZYNQ_SDIO_CD_SHIFT     16
> +#define ZYNQ_SDIO_CD_MASK      (0x3f << ZYNQ_SDIO_CD_SHIFT)

This conveys something about the hardware though.

> +static const struct zynq_pinmux_function zynq_pmux_functions[] = {
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(ethernet0, 1),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(ethernet1, 1),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(mdio0, 0x40),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(mdio1, 0x50),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(qspi0, 1),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(qspi1, 1),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(qspi_fbclk, 1),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(qspi_cs1, 1),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(spi0, 0x50),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(spi1, 0x50),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(sdio0, 0x40),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(sdio0_pc, 0xc),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION_MUX(sdio0_wp, 0, 130, ZYNQ_SDIO_WP_MASK,
> +                                       ZYNQ_SDIO_WP_SHIFT),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION_MUX(sdio0_cd, 0, 130, ZYNQ_SDIO_CD_MASK,
> +                                       ZYNQ_SDIO_CD_SHIFT),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(sdio1, 0x40),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(sdio1_pc, 0xc),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION_MUX(sdio1_wp, 0, 134, ZYNQ_SDIO_WP_MASK,
> +                                       ZYNQ_SDIO_WP_SHIFT),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION_MUX(sdio1_cd, 0, 134, ZYNQ_SDIO_CD_MASK,
> +                                       ZYNQ_SDIO_CD_SHIFT),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(smc0_nor, 4),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(smc0_nor_cs1, 8),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(smc0_nor_addr25, 4),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(smc0_nand, 8),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(can0, 0x10),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(can1, 0x10),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(uart0, 0x70),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(uart1, 0x70),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(i2c0, 0x20),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(i2c1, 0x20),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(ttc0, 0x60),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(ttc1, 0x60),
> +       DEFINE_ZYNQ_PINMUX_FUNCTION(swdt0, 0x30),

Looks good.

> +static int zynq_pinmux_enable(struct pinctrl_dev *pctldev,
> +                             unsigned function,
> +                             unsigned group)

Rename zynq_pinmux_set() when rebasing to v3.18-rc1 (when
it is tagged, or use the pinctrl tree "devel" branch).

> +static const struct pinmux_ops zynq_pinmux_ops = {
> +       .get_functions_count = zynq_pmux_get_functions_count,
> +       .get_function_name = zynq_pmux_get_function_name,
> +       .get_function_groups = zynq_pmux_get_function_groups,
> +       .enable = zynq_pinmux_enable,

Renamed .set_mux() in the current codebase.

> +static struct pinctrl_desc zynq_desc = {
> +       .name = "zynq_pinctrl",
> +       .pins = zynq_pins,
> +       .npins = ARRAY_SIZE(zynq_pins),
> +       .pctlops = &zynq_pctrl_ops,
> +       .pmxops = &zynq_pinmux_ops,
> +       //const struct pinconf_ops *confops;

Delete it instead of commenting out. Patch it in later when
you patch in the pinconf support. It's fine to begin with only
muxing...

> +static int zynq_pinctrl_probe(struct platform_device *pdev)
> +
> +{
> +       struct resource *res;
> +       struct device_node *slcr;

Usually we just call this *np (node pointer) please rename the variable.

> +       struct zynq_pinctrl *pctrl;

Call it zpctrl or something more unique.

> +       pctrl = devm_kzalloc(&pdev->dev, sizeof(*pctrl), GFP_KERNEL);
> +       if (!pctrl)
> +               return -ENOMEM;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +
> +       slcr = of_get_parent(pdev->dev.of_node);
> +       if (slcr->data) {
> +               pctrl->regs = (__force void __iomem *)slcr->data + res->start;

This looks weird. Use DT parsing functions and accessors, no funny
business like this. The res-start to the device should be the real
physical address, not a relative base with offset, dunno what happened
here but it is wrong.

Yours,
Linus Walleij
