Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047AbaGVVqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 17:46:46 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:14816 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757011AbaGVVqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 17:46:43 -0400
Date: Tue, 22 Jul 2014 14:46:44 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH RESEND v2 1/4] pinctrl: Update Qualcomm pm8xxx GPIO
 parameters definitions
Message-ID: <20140722214643.GH19700@sonymobile.com>
References: <1405610748-7583-5-git-send-email-iivanov@mm-sol.com>
 <1405626085-14069-1-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1405626085-14069-1-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 12:41 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>

Hi Ivan,

Sorry for the slow response, I wanted to respin my pm8xxx-gpio driver to figure
out some resonable answers to you.

> Available 'power-source' labels differ between chips.
> Use just VIN0-VIN14 in the input source names.
>

The documentation uses VIN0-VIN7 to define the actual register value 0-7. As
with most other things in DT we don't want to encode the actual bits that
should go in the register, but rather give them some human readable name. This
is why I have the mapping tables in my proposal.

Inventing some magic mapping where you're supposed to know that you should type
VIN14 when you mean VPH on pm8921 but VIN0 on pm8941 doesn't make sense.

So, either we put the actual register values in the binding, or we use the enum
(as I proposed) to encode human readable names.

For pm8941 the valid power supply values are:
 GPIO 1-14
   0: VPH
   2: SMPS3
   3: LDO6

 GPIO 15-18
  2: SMPS3
  3: LDO6

 GPIO 19-36
  0: VPH
  1: VDD_TORCH
  2: SPMS3
  3: LDO6

 MPP 1-8
  0: VPH
  1: LDO1
  2: SPMS3
  3: LDO6

For pma8084 the valid power supply values are:
 GPIO 1-22
  0: VPH
  2: SPMS4
  3: LDO6

 MPP 1-8
  0: VPH
  1: LDO1
  2: SMPS4
  3: LDO6

Please add these constants to the table of valid power-source values and use
something like I did to translate them to register values - it makes the DT
much more readable.

> PM8018, PM8038, PM8058, PM8917, PM8921 pin controller hardware
> support only one function 'gpio'. Currently GPIO's will
> support only 'normal' mode. Rest of the modes will be added
> later, if needed.
>

This is not true.

As I said before, there is no such thing as "pin controller hardware"; both on
pm8xxx and qpnp-pin there are two different HW blocks, one for GPIO and one for
MPP. And if you look in your pinconf_set function you will see that they are
very different.

I'm still trying to figure out the correct pinmux mapping for the various
pmics, but the current indication is a list that looks like this:
  "gpio"
  "paired"
  "ext_reg_en"
  "ext_smps_en"
  "fclk"
  "kypd_drv"
  "kypd_sns"
  "lpa"
  "lpg"
  "mp3_clk"
  "sleep_clk"
  "uart"
  "uim"
  "upl"

I haven't looked through the dts files for 8974 and 8084, but it's not possible
to describe the previous Qualcomm reference formfactor devices (MTP) with only
"gpio".

> We can not use generic drive-strength because Qualcomm hardware
> define those values as low, medium and high. Use qcom,strength
> for this.
>
> We can not use generic bias-pull-up because Qualcomm hardware
> define those values in uA's. Use qcom,pull-up for this.
>

I'm not to fond of the lack of symetry we introduce by having "bias-disable",
"bias-pull-down" and "qcom,pull-up". Furhter more, at least for 8x60, 8960 and
8064 almost all pins are configured with 30uA.

So my suggestion is that we keep the symmetry by continue to select the pull up
mode by the use of "bias-pull-up" and then we introduce a property named
"qcom,pull-up-strength" that optionally can be used to select a different
strength than the 30uA.

[...]
>  - function:
> -       Usage: optional
> +       Usage: mandatory

Usage: required

>         Value type: <string>
>         Definition: Specify the alternative function to be configured for the
> -                   specified pins.  Valid values are:
> -                       "normal",
> -                       "paired",
> -                       "func1",
> -                       "func2",
> -                       "dtest1",
> -                       "dtest2",
> -                       "dtest3",
> -                       "dtest4"
> +                   specified pins.  Valid values is: "gpio"
>
>  - bias-disable:
>         Usage: optional
> @@ -99,18 +95,6 @@ to specify in a pin configuration subnode:
>         Value type: <none>
>         Definition: The specified pins should be configued as pull down.
>
> -- bias-pull-up:
> -       Usage: optional
> -       Value type: <u32> (optional)
> -       Definition: The specified pins should be configued as pull up. An
> -                   optional argument can be used to configure the strength.
> -                   Valid values are; as defined in
> -                   <dt-bindings/pinctrl/qcom,pm8xxx-gpio.h>:
> -                   1: 30uA                     (PM8XXX_GPIO_PULL_UP_30)
> -                   2: 1.5uA                    (PM8XXX_GPIO_PULL_UP_1P5)
> -                   3: 31.5uA                   (PM8XXX_GPIO_PULL_UP_31P5)
> -                   4: 1.5uA + 30uA boost       (PM8XXX_GPIO_PULL_UP_1P5_30)
> -

As described above, I belive we should make this:

- bias-pull-up:
	Usage: optional
	Value type: <empty>
	Definition: The specified pins should be configured as pull up.

- qcom,pull-up-strength:
	Usage: optional
	Value type: <u32>
	Definition: Specifies the strength to use for pull up, if selected.
                    Valid values are; as defined in
                    <dt-bindings/pinctrl/qcom,pm8xxx-gpio.h>:
                    1: 30uA                     (PM8XXX_GPIO_PULL_UP_30)
                    2: 1.5uA                    (PM8XXX_GPIO_PULL_UP_1P5)
                    3: 31.5uA                   (PM8XXX_GPIO_PULL_UP_31P5)
                    4: 1.5uA + 30uA boost       (PM8XXX_GPIO_PULL_UP_1P5_30)
		    If this property is ommited 30uA strength will be used if
		    pull up is selected.

>  - bias-high-impedance:
>         Usage: optional
>         Value type: <none>
> @@ -139,47 +123,37 @@ to specify in a pin configuration subnode:
>         Definition: Selects the power source for the specified pins. Valid
>                     power sources are, as defined in
>                     <dt-bindings/pinctrl/qcom,pm8xxx-gpio.h>:
> -                       0: bb (PM8XXX_GPIO_VIN_BB)
> +                       0: bb (PM8XXX_GPIO_VIN0)
>                                 valid for pm8038, pm8058, pm8917, pm8921
> -                       1: ldo2 (PM8XXX_GPIO_VIN_L2)
> +                       1: ldo2 (PM8XXX_GPIO_VIN1)
>                                 valid for pm8018, pm8038, pm8917,pm8921
> -                       2: ldo3 (PM8XXX_GPIO_VIN_L3)
> +                       2: ldo3 (PM8XXX_GPIO_VIN2)
>                                 valid for pm8038, pm8058, pm8917, pm8921
> -                       3: ldo4 (PM8XXX_GPIO_VIN_L4)
> +                       3: ldo4 (PM8XXX_GPIO_VIN3)
>                                 valid for pm8018, pm8917, pm8921
> -                       4: ldo5 (PM8XXX_GPIO_VIN_L5)
> +                       4: ldo5 (PM8XXX_GPIO_VIN4)
>                                 valid for pm8018, pm8058
> -                       5: ldo6 (PM8XXX_GPIO_VIN_L6)
> +                       5: ldo6 (PM8XXX_GPIO_VIN5)
>                                 valid for pm8018, pm8058
> -                       6: ldo7 (PM8XXX_GPIO_VIN_L7)
> +                       6: ldo7 (PM8XXX_GPIO_VIN6)
>                                 valid for pm8058
> -                       7: ldo8 (PM8XXX_GPIO_VIN_L8)
> +                       7: ldo8 (PM8XXX_GPIO_VIN7)
>                                 valid for pm8018
> -                       8: ldo11 (PM8XXX_GPIO_VIN_L11)
> +                       8: ldo11 (PM8XXX_GPIO_VIN8)
>                                 valid for pm8038
> -                       9: ldo14 (PM8XXX_GPIO_VIN_L14)
> +                       9: ldo14 (PM8XXX_GPIO_VIN9)
>                                 valid for pm8018
> -                       10: ldo15 (PM8XXX_GPIO_VIN_L15)
> +                       10: ldo15 (PM8XXX_GPIO_VIN10)
>                                 valid for pm8038, pm8917, pm8921
> -                       11: ldo17 (PM8XXX_GPIO_VIN_L17)
> +                       11: ldo17 (PM8XXX_GPIO_VIN11)
>                                 valid for pm8038, pm8917, pm8921
> -                       12: smps3 (PM8XXX_GPIO_VIN_S3)
> +                       12: smps3 (PM8XXX_GPIO_VIN12)
>                                 valid for pm8018, pm8058
> -                       13: smps4 (PM8XXX_GPIO_VIN_S4)
> +                       13: smps4 (PM8XXX_GPIO_VIN13)
>                                 valid for pm8921
> -                       14: vph (PM8XXX_GPIO_VIN_VPH)
> +                       14: vph (PM8XXX_GPIO_VIN14)
>                                 valid for pm8018, pm8038, pm8058, pm8917 pm8921

As described this doesn't make sense, please add the necessary enumeration for
your pins or make an argument for just using register values directly here.

If we choose to go with register values directly in the dt binding we should
document the valid values and their mapping/meaning here.

>
> -- drive-strength:
> -       Usage: optional
> -       Value type: <u32>
> -       Definition: Selects the drive strength for the specified pins. Value
> -                   drive strengths are:
> -                       0: no   (PM8XXX_GPIO_STRENGTH_NO)
> -                       1: high (PM8XXX_GPIO_STRENGTH_HIGH)
> -                       2: medium       (PM8XXX_GPIO_STRENGTH_MED)
> -                       3: low  (PM8XXX_GPIO_STRENGTH_LOW)
> -
>  - drive-push-pull:
>         Usage: optional
>         Value type: <none>
> @@ -190,6 +164,28 @@ to specify in a pin configuration subnode:
>         Value type: <none>
>         Definition: The specified pins are configured in open-drain mode.
>
> +- qcom,pull-up:
> +       Usage: optional
> +       Value type: <u32>
> +       Definition: The specified pins should be configued as pull up. An
> +                   optional argument can be used to configure the strength.
> +                   Valid values are as defined in
> +                   <dt-bindings/pinctrl/qcom,pm8xxx-gpio.h>:
> +                   1: 30uA                     (PM8XXX_GPIO_PULL_UP_30)
> +                   2: 1.5uA                    (PM8XXX_GPIO_PULL_UP_1P5)
> +                   3: 31.5uA                   (PM8XXX_GPIO_PULL_UP_31P5)
> +                   4: 1.5uA + 30uA boost       (PM8XXX_GPIO_PULL_UP_1P5_30)
> +
> +- qcom,strength:

Better follow the standard naming and use "qcom,drive-strength" to actually
specify what strength we're talking about.

> +       Usage: optional
> +       Value type: <u32>
> +       Definition: Selects the drive strength for the specified pins.
> +                   Valid values are as defined in
> +                   <dt-bindings/pinctrl/qcom,pm8xxx-gpio.h>:
> +                       0: no   (PM8XXX_GPIO_STRENGTH_NO)
> +                       1: high (PM8XXX_GPIO_STRENGTH_HIGH)
To be clearer what these actually means we could probably add the following:
				0.9mA @ 1.8V - 1.9mA @ 2.6V
> +                       2: medium       (PM8XXX_GPIO_STRENGTH_MED)
				0.6mA @ 1.8V - 1.25mA @ 2.6V
> +                       3: low  (PM8XXX_GPIO_STRENGTH_LOW)
				0.15mA @ 1.8V - 0.3mA @ 2.6V
>
>  Example:
>
> @@ -218,13 +214,14 @@ Example:
>                 pm8921_gpio_keys: gpio-keys {
>                         volume-keys {
>                                 pins = "gpio20", "gpio21";
> -                               function = "normal";
> +                               function = "gpio";

Sounds reasonable.

>
>                                 input-enable;
>                                 bias-pull-up;
>                                 drive-push-pull;
> -                               drive-strength = <PM8XXX_GPIO_STRENGTH_NO>;
> -                               power-source = <PM8XXX_GPIO_VIN_S4>;
> +
> +                               power-source = <PM8XXX_GPIO_VIN13>;

Here you can see why VIN13 doesn't make any sense; anyone writing a dts for
this would expect this to either be <VIN_S4> or <2>.

> +                               qcom,strength = <PM8XXX_GPIO_STRENGTH_NO>;
>                         };
>                 };
>         };

Please let me know what you think and I can send out an updated version of my
binding documentation.

Regards,
Bjorn
