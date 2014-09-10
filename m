Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaIJEm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:42:29 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:34220 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaIJEmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:42:13 -0400
MIME-Version: 1.0
In-Reply-To: <1408533593-32346-2-git-send-email-javier.martinez@collabora.co.uk>
References: <1408533593-32346-1-git-send-email-javier.martinez@collabora.co.uk>
	<1408533593-32346-2-git-send-email-javier.martinez@collabora.co.uk>
Date: Tue, 9 Sep 2014 21:42:12 -0700
X-Google-Sender-Auth: Fg8--tsAvwLWAaTulFBgT5CIFxI
Message-ID: <CAD=FV=VVLmnvZToewvsiJDUbapPj5BBA=RG4a7_N9wadRN7CTg@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] ARM: dts: Add Peach Pit and Pi dts entry for
 max77802 PMIC
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On Wed, Aug 20, 2014 at 4:19 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> Exynos5420 based Peach Pit and Exynos5800 based Peach Pi boards
> uses a Maxim 77802 power management IC to drive regulators and
> its Real Time Clock. This patch adds support for this chip.
>
> These are the device nodes and pinctrl configuration that
> are present on the Peach pit DeviceTree source file in the
> the Chrome OS kernel 3.8 tree.
>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Tested-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5420-peach-pit.dts | 372 +++++++++++++++++++++++++++++
>  arch/arm/boot/dts/exynos5800-peach-pi.dts  | 372 +++++++++++++++++++++++++++++
>  2 files changed, 744 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
> index ab06148..78cea4c 100644
> --- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
> +++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
> @@ -11,6 +11,7 @@
>  /dts-v1/;
>  #include <dt-bindings/input/input.h>
>  #include <dt-bindings/gpio/gpio.h>
> +#include <dt-bindings/interrupt-controller/irq.h>
>  #include "exynos5420.dtsi"
>
>  / {
> @@ -144,6 +145,339 @@
>         ddc = <&i2c_2>;
>  };
>
> +&hsi2c_4 {
> +       status = "okay";
> +       clock-frequency = <400000>;
> +
> +       max77802-pmic@9 {
> +               compatible = "maxim,max77802";
> +               interrupt-parent = <&gpx3>;
> +               interrupts = <1 IRQ_TYPE_NONE>;
> +               pinctrl-names = "default";
> +               pinctrl-0 = <&max77802_irq>, <&pmic_selb>,
> +                           <&pmic_dvs_1>, <&pmic_dvs_2>, <&pmic_dvs_3>;
> +               wakeup-source;
> +               reg = <0x9>;
> +               #clock-cells = <1>;

...you've actually got the 32k clock specified in a reasonable way now
(unlike our tree).

We don't have opmode or the DVFS stuff upstream yet, so makes sense
that's not here.


> +               inb1-supply = <&tps65090_dcdc2>;
> +               inb2-supply = <&tps65090_dcdc1>;
> +               inb3-supply = <&tps65090_dcdc2>;
> +               inb4-supply = <&tps65090_dcdc2>;
> +               inb5-supply = <&tps65090_dcdc1>;
> +               inb6-supply = <&tps65090_dcdc2>;
> +               inb7-supply = <&tps65090_dcdc1>;
> +               inb8-supply = <&tps65090_dcdc1>;
> +               inb9-supply = <&tps65090_dcdc1>;
> +               inb10-supply = <&tps65090_dcdc1>;
> +
> +               inl1-supply = <&buck5_reg>;
> +               inl2-supply = <&buck7_reg>;
> +               inl3-supply = <&buck9_reg>;
> +               inl4-supply = <&buck9_reg>;
> +               inl5-supply = <&buck9_reg>;
> +               inl6-supply = <&tps65090_dcdc2>;
> +               inl7-supply = <&buck9_reg>;
> +               inl9-supply = <&tps65090_dcdc2>;
> +               inl10-supply = <&buck7_reg>;

I double-checked your input supplies against schematics (since we
don't have them right in our tree).  They look right.

> +
> +               regulators {
> +                       buck1_reg: BUCK1 {
> +                               regulator-name = "vdd_mif";
> +                               regulator-min-microvolt = <800000>;
> +                               regulator-max-microvolt = <1300000>;
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               regulator-ramp-delay = <12500>;
> +                       };
> +
> +                       buck2_reg: BUCK2 {
> +                               regulator-name = "vdd_arm";
> +                               regulator-min-microvolt = <800000>;
> +                               regulator-max-microvolt = <1500000>;
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               regulator-ramp-delay = <12500>;
> +                       };
> +
> +                       buck3_reg: BUCK3 {
> +                               regulator-name = "vdd_int";
> +                               regulator-min-microvolt = <800000>;
> +                               regulator-max-microvolt = <1400000>;
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               regulator-ramp-delay = <12500>;
> +                       };
> +
> +                       buck4_reg: BUCK4 {
> +                               regulator-name = "vdd_g3d";
> +                               regulator-min-microvolt = <700000>;
> +                               regulator-max-microvolt = <1400000>;
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               regulator-ramp-delay = <12500>;
> +                       };
> +
> +                       buck5_reg: BUCK5 {
> +                               regulator-name = "vdd_1v2";
> +                               regulator-min-microvolt = <1200000>;
> +                               regulator-max-microvolt = <1200000>;
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                       };
> +
> +                       buck6_reg: BUCK6 {
> +                               regulator-name = "vdd_kfc";
> +                               regulator-min-microvolt = <800000>;
> +                               regulator-max-microvolt = <1500000>;
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                               regulator-ramp-delay = <12500>;
> +                       };
> +
> +                       buck7_reg: BUCK7 {
> +                               regulator-name = "vdd_1v35";
> +                               regulator-min-microvolt = <1350000>;
> +                               regulator-max-microvolt = <1350000>;
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                       };
> +
> +                       buck8_reg: BUCK8 {
> +                               regulator-name = "vdd_emmc";
> +                               regulator-min-microvolt = <2850000>;
> +                               regulator-max-microvolt = <2850000>;
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                       };
> +
> +                       buck9_reg: BUCK9 {
> +                               regulator-name = "vdd_2v";
> +                               regulator-min-microvolt = <2000000>;
> +                               regulator-max-microvolt = <2000000>;
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                       };
> +
> +                       buck10_reg: BUCK10 {
> +                               regulator-name = "vdd_1v8";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                               regulator-always-on;
> +                               regulator-boot-on;
> +                       };
> +
> +                       ldo1_reg: LDO1 {
> +                               regulator-name = "vdd_1v0";
> +                               regulator-min-microvolt = <1000000>;
> +                               regulator-max-microvolt = <1000000>;
> +                               regulator-always-on;
> +                       };
> +
> +                       ldo2_reg: LDO2 {
> +                               regulator-name = "vdd_1v2_2";
> +                               regulator-min-microvolt = <1200000>;
> +                               regulator-max-microvolt = <1200000>;
> +                       };
> +
> +                       ldo3_reg: LDO3 {
> +                               regulator-name = "vdd_1v8_3";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                               regulator-always-on;
> +                       };
> +
> +                       vqmmc_sdcard: ldo4_reg: LDO4 {
> +                               regulator-name = "vdd_sd";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <2800000>;
> +                               regulator-always-on;
> +                       };
> +
> +                       ldo5_reg: LDO5 {
> +                               regulator-name = "vdd_1v8_5";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                               regulator-always-on;
> +                       };
> +
> +                       ldo6_reg: LDO6 {
> +                               regulator-name = "vdd_1v8_6";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                               regulator-always-on;
> +                       };
> +
> +                       ldo7_reg: LDO7 {
> +                               regulator-name = "vdd_1v8_7";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                       };
> +
> +                       ldo8_reg: LDO8 {
> +                               regulator-name = "vdd_ldo8";
> +                               regulator-min-microvolt = <1000000>;
> +                               regulator-max-microvolt = <1000000>;
> +                               regulator-always-on;
> +                       };
> +
> +                       ldo9_reg: LDO9 {
> +                               regulator-name = "vdd_ldo9";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                               regulator-always-on;
> +                       };
> +
> +                       ldo10_reg: LDO10 {
> +                               regulator-name = "vdd_ldo10";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                               regulator-always-on;
> +                       };
> +
> +                       ldo11_reg: LDO11 {
> +                               regulator-name = "vdd_ldo11";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                               regulator-always-on;
> +                       };
> +
> +                       ldo12_reg: LDO12 {
> +                               regulator-name = "vdd_ldo12";
> +                               regulator-min-microvolt = <3000000>;
> +                               regulator-max-microvolt = <3000000>;
> +                               regulator-always-on;
> +                       };
> +
> +                       ldo13_reg: LDO13 {
> +                               regulator-name = "vdd_ldo13";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                               regulator-always-on;
> +                       };
> +
> +                       ldo14_reg: LDO14 {
> +                               regulator-name = "vdd_ldo14";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                               regulator-always-on;
> +                       };
> +
> +                       ldo15_reg: LDO15 {
> +                               regulator-name = "vdd_ldo15";
> +                               regulator-min-microvolt = <1000000>;
> +                               regulator-max-microvolt = <1000000>;
> +                               regulator-always-on;
> +                       };
> +
> +                       ldo17_reg: LDO17 {
> +                               regulator-name = "vdd_g3ds";
> +                               regulator-min-microvolt = <900000>;
> +                               regulator-max-microvolt = <1400000>;
> +                               regulator-always-on;
> +                       };
> +
> +                       ldo18_reg: LDO18 {
> +                               regulator-name = "ldo_18";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                       };
> +
> +                       ldo19_reg: LDO19 {
> +                               regulator-name = "ldo_19";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                       };
> +
> +                       ldo20_reg: LDO20 {
> +                               regulator-name = "ldo_20";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                               regulator-always-on;
> +                       };
> +
> +                       ldo21_reg: LDO21 {
> +                               regulator-name = "ldo_21";
> +                               regulator-min-microvolt = <2800000>;
> +                               regulator-max-microvolt = <2800000>;
> +                       };
> +
> +                       ldo23_reg: LDO23 {
> +                               regulator-name = "ldo_23";
> +                               regulator-min-microvolt = <3300000>;
> +                               regulator-max-microvolt = <3300000>;
> +                       };
> +                       ldo24_reg: LDO24 {
> +                               regulator-name = "ldo_24";
> +                               regulator-min-microvolt = <2800000>;
> +                               regulator-max-microvolt = <2800000>;
> +                       };
> +
> +                       ldo25_reg: LDO25 {
> +                               regulator-name = "ldo_25";
> +                               regulator-min-microvolt = <3300000>;
> +                               regulator-max-microvolt = <3300000>;
> +                       };
> +
> +                       ldo26_reg: LDO26 {
> +                               regulator-name = "ldo_26";
> +                               regulator-min-microvolt = <1200000>;
> +                               regulator-max-microvolt = <1200000>;
> +                       };
> +
> +                       ldo27_reg: LDO27 {
> +                               regulator-name = "ldo_27";
> +                               regulator-min-microvolt = <1200000>;
> +                               regulator-max-microvolt = <1200000>;
> +                       };
> +
> +                       ldo28_reg: LDO28 {
> +                               regulator-name = "ldo_28";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                       };
> +
> +                       ldo29_reg: LDO29 {
> +                               regulator-name = "ldo_29";
> +                               regulator-min-microvolt = <1800000>;
> +                               regulator-max-microvolt = <1800000>;
> +                       };
> +
> +                       ldo30_reg: LDO30 {
> +                               regulator-name = "vdd_mifs";
> +                               regulator-min-microvolt = <1000000>;
> +                               regulator-max-microvolt = <1000000>;
> +                               regulator-always-on;
> +                       };
> +
> +                       ldo32_reg: LDO32 {
> +                               regulator-name = "ldo_32";
> +                               regulator-min-microvolt = <3000000>;
> +                               regulator-max-microvolt = <3000000>;
> +                       };
> +
> +                       ldo33_reg: LDO33 {
> +                               regulator-name = "ldo_33";
> +                               regulator-min-microvolt = <2800000>;
> +                               regulator-max-microvolt = <2800000>;
> +                       };
> +
> +                       ldo34_reg: LDO34 {
> +                               regulator-name = "ldo_34";
> +                               regulator-min-microvolt = <3000000>;
> +                               regulator-max-microvolt = <3000000>;
> +                       };
> +
> +                       ldo35_reg: LDO35 {
> +                               regulator-name = "ldo_35";
> +                               regulator-min-microvolt = <1200000>;
> +                               regulator-max-microvolt = <1200000>;
> +                               inl2-supply = <&buck7_reg>;

Is this a typo?  Shouldn't supplies be specified at the top?


Other than that, you can add my Reviewed-by.
