Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112AbaGRGzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 02:55:32 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:42662 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbaGRGz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 02:55:26 -0400
MIME-Version: 1.0
In-Reply-To: <0C2AB07A-C515-4D5E-A823-DDF7C871515A@goldelico.com>
References: <1405369228-27197-1-git-send-email-marek@goldelico.com>
	<1405369228-27197-2-git-send-email-marek@goldelico.com>
	<CAGhQ9Vx1gm9=vda9dUVYR25JK4VSUe9Qk5_xc_bo9ZPLFCtExA@mail.gmail.com>
	<0C2AB07A-C515-4D5E-A823-DDF7C871515A@goldelico.com>
Date: Fri, 18 Jul 2014 08:55:24 +0200
Message-ID: <CAGhQ9VwTXdCHe693PBtaVsv28-heEHY3=qbnn+mdgk3ea3u7qQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] arm: dts: omap3-gta04: Add missing nodes to fully
 describe gta04 board
From: Joachim Eastwood <manabian@gmail.com>
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Marek Belisko <marek@goldelico.com>, robh+dt@kernel.org,
        Pawel Moll <pawel.moll@arm.com>, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, devicetree@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 July 2014 09:17, Dr. H. Nikolaus Schaller <hns@goldelico.com> wrote:
> Am 15.07.2014 um 14:45 schrieb Joachim Eastwood:
>
>> Hi Marek,
>>
>> You seem to add some DT nodes for hw that doesn't have drivers in
>> mainline. I think you should leave those out until the driver itself
>> is upstream and the bindings for it is documented.
> is there some policy for only having nodes for existing drivers in DT files?

I am not sure about that, better ask the DT maintainers.

There is however a policy that says new bindings should be reviewed
and documented.

> If I understand the device tree concept correctly, it should not describe drivers
> (and hence nothing about the state of them being mainlined), but it should statically
> describe the given hardware in a way that kernel and drivers can read it (or ignore).
> And even other kernels can use it (because they run on the same hardware).
>
> So unless there is an important reason not to have "currently unused" nodes
> in the DT source/binary (loading time is IMHO neglectable), I would ask that we
> can keep with the complete DT instead of splitting it up artificially and getting back
> to the same status (because the hardware does not change over time).

The problem with the nodes is that the bindings may change when the
drivers/bindings are submitted to mainline and reviewed. I don't see
why you want nodes for hardware that right now obviously don't work
with mainline and if the bindings change it will churn and confusion
for the users.

One example is the omap-pwm driver. It should really have #pwm-cells
set to 3 and not 2. This driver is not upstream yet, because it
requires some files to move out of arch/arm. See
http://marc.info/?l=linux-omap&m=139903867022779&w=2 for the suggested
new bindings.

The normal case for new DT boards is to first submit nodes for the
hardware that is working in mainline and then update the DT with more
nodes for hardware as bindings are decided upon and drivers go
upstream.

Please don't top post.

regards,
Joachim Eastwood

>> On 14 July 2014 22:20, Marek Belisko <marek@goldelico.com> wrote:
>>> Signed-off-by: Marek Belisko <marek@goldelico.com>
>>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>>> ---
>>> arch/arm/boot/dts/omap3-gta04.dts | 443 +++++++++++++++++++++++++++++++++++---
>>> 1 file changed, 412 insertions(+), 31 deletions(-)
>>>
>>> diff --git a/arch/arm/boot/dts/omap3-gta04.dts b/arch/arm/boot/dts/omap3-gta04.dts
>>> index 215513b..bd6a71d 100644
>>> --- a/arch/arm/boot/dts/omap3-gta04.dts
>>> +++ b/arch/arm/boot/dts/omap3-gta04.dts
>>> @@ -12,7 +12,7 @@
>>> #include "omap36xx.dtsi"
>>>
>>> / {
>>> -       model = "OMAP3 GTA04";
>>> +       model = "Goldelico GTA04";
>>>        compatible = "ti,omap3-gta04", "ti,omap36xx", "ti,omap3";
>>>
>>>        cpus {
>>> @@ -26,6 +26,11 @@
>>>                reg = <0x80000000 0x20000000>; /* 512 MB */
>>>        };
>>>
>>> +       aliases {
>>> +               display0 = &lcd;
>>> +               display1 = &tv0;
>>> +       };
>>> +
>>>        gpio-keys {
>>>                compatible = "gpio-keys";
>>>
>>> @@ -37,15 +42,78 @@
>>>                };
>>>        };
>>>
>>> +       gpio-keys-wwan-wakeup {
>>> +               compatible = "gpio-keys";
>>> +
>>> +               wwan_wakeup_button: wwan-wakeup-button {
>>> +                       label = "3G_WOE";
>>> +                       linux,code = <240>;
>>> +                       gpios = <&gpio1 10 GPIO_ACTIVE_HIGH>;
>>> +                       gpio-key,wakeup;
>>> +               };
>>> +       };
>>> +
>>> +       hsusb2_phy: hsusb2_phy {
>>> +               compatible = "usb-nop-xceiv";
>>> +               reset-gpios = <&gpio6 14 GPIO_ACTIVE_LOW>; /* gpio_174 = reset for USB3322 */
>>> +       };
>>> +
>>> +       antenna-detect {
>>> +               compatible = "linux,extcon-gpio";
>>> +               label = "gps_antenna";
>>> +               gpios = <&gpio5 16 0>; /* gpio_144 */
>>> +               debounce-delay-ms = <10>;
>>> +               irq-flags = <IRQ_TYPE_EDGE_BOTH>;
>>> +               state-on = "external";
>>> +               state-off = "internal";
>>> +       };
>>> +
>>>        sound {
>>>                compatible = "ti,omap-twl4030";
>>>                ti,model = "gta04";
>>>
>>>                ti,mcbsp = <&mcbsp2>;
>>>                ti,codec = <&twl_audio>;
>>> +
>>> +               ti,mcbsp-voice = <&mcbsp4>;
>>> +       };
>>> +
>>> +       sound_card {
>>> +               compatible = "goldelico,gta04-audio";
>>> +               gta04,cpu-dai = <&mcbsp2>;
>>> +       };
>>> +
>>> +       gtm601_codec: voice_codec {
>>> +               compatible = "gtm601-codec";
>>> +       };
>>> +
>>> +       sound_voice {
>>> +               compatible = "goldelico,gta04-voice";
>>> +               gta04,cpu-dai = <&mcbsp4>;
>>> +               gta04,codec = <&gtm601_codec>;
>>>        };
>>>
>>> -       spi_lcd {
>>> +       w2cbw003_codec: headset_codec {
>>> +               compatible = "w2cbw003-codec";
>>> +       };
>>> +
>>> +       sound_headset {
>>> +               compatible = "goldelico,gta04-headset";
>>> +               gta04,cpu-dai = <&mcbsp3>;
>>> +               gta04,codec = <&w2cbw003_codec>;
>>> +       };
>>> +
>>> +       sound_fm {
>>> +               compatible = "goldelico,gta04-fm";
>>> +               gta04,cpu-dai = <&mcbsp1>;
>>> +               gta04,codec = <&si4721_codec>;
>>> +       };
>>> +
>>> +       madc-hwmon {
>>> +               compatible = "ti,twl4030-madc-hwmon";
>>> +       };
>>> +
>>> +       spi_lcd: spi_lcd {
>>>                compatible = "spi-gpio";
>>>                #address-cells = <0x1>;
>>>                #size-cells = <0x0>;
>>> @@ -75,7 +143,7 @@
>>>                };
>>>        };
>>>
>>> -       battery {
>>> +       madc_battery: battery {
>>>                compatible = "ti,twl4030-madc-battery";
>>>                capacity = <1200000>;
>>>                charging-calibration-data = <4200 100
>>> @@ -100,6 +168,83 @@
>>>                                   "ichg",
>>>                                   "vbat";
>>>        };
>>> +
>>> +       backlight {
>>> +               compatible = "pwm-backlight";
>>> +               pwms = <&pwm 0 2000000>;
>>> +               brightness-levels = <0 11 20 30 40 50 60 70 80 90 100>;
>>> +               default-brightness-level = <10>;
>>> +               pinctrl-names = "default";
>>> +               pintcrl-0 = <&backlight_pins>;
>>> +               power-supply = <&power>;
>>> +       };
>>> +
>>> +       pwm: omap_pwm {
>>> +               compatible = "ti,omap-pwm";
>>> +               timers = <&timer11>;
>>> +               #pwm-cells = <2>;
>>> +       };
>>
>> The omap-pwm driver is not yet upstream and thus the bindings are not final.
>>
>>> +       /* should be a PWM */
>>> +       power: fixed_regulator@0 {
>>> +              compatible = "regulator-fixed";
>>> +              regulator-name = "bl-enable";
>>> +              regulator-boot-on;
>>> +              regulator-always-on;
>>> +              regulator-min-microvolt = "1000000";
>>> +              regulator-max-microvolt = "1000000";
>>> +              gpio = <&gpio2 25 0>;    /* GPT11/PWM */
>>> +              enable-active-high;
>>> +       };
>>> +
>>> +       tv0: connector@1 {
>>> +               compatible = "svideo-connector";
>>> +               label = "tv";
>>> +
>>> +               port {
>>> +                       tv_connector_in: endpoint {
>>> +                               remote-endpoint = <&venc_out>;
>>> +                       };
>>> +               };
>>> +       };
>>> +
>>> +       tv_amp: opa362 {
>>> +               compatible = "ti,opa362";
>>> +               gpio = <&gpio1 23 0>;   /* GPIO to enable video out amplifier */
>>> +       };
>>
>> Driver for a OPAMP?
>>
>>> +       /* presents a single gpio to be plumbed to uart1 dts */
>>> +       bt_en: w2cbw003 {
>>> +               compatible = "wi2wi,w2cbw003";
>>> +               gpio-controller;
>>> +               #gpio-cells = <2>;
>>> +
>>> +               vdd-supply = <&vaux4>;
>>> +       };
>>> +
>>> +       /* presents a single gpio to be plumbed to uart2 dts */
>>> +       gps_en: w2sg0004 {
>>> +               compatible = "wi2wi,w2sg0004";
>>> +               gpio-controller;
>>> +               #gpio-cells = <2>;
>>> +
>>> +               lna-supply = <&vsim>;   /* LNA regulator */
>>> +               on-off-gpio = <&gpio5 17 0>;    /* gpio_145: trigger for turning on/off w2sg0004 */
>>> +               rx-gpio = <&gpio5 19 0>;        /* gpio_147: RX */
>>> +               rx-on-mux = < (PIN_INPUT_PULLUP | MUX_MODE0) >;
>>> +               rx-off-mux = < (PIN_INPUT_PULLUP | MUX_MODE4) >;
>>> +       };
>>> +
>>> +       /* control modem power through rfkill */
>>> +       modem_en: modem {
>>> +               compatible = "option,gtm601";
>>> +               gpio-controller;
>>> +               #gpio-cells = <2>;
>>> +
>>> +               usb-port = <&hsusb2_phy>;
>>> +               on-off-gpio = <&gpio6 26 0>;    /* gpio_186: trigger to power on modem */
>>> +               on-indicator-gpio = <0>;
>>> +       };
>>> };
>>
>> I don't think any of the above devices have documented bindings so I
>> don't think it is a good idea to add the nodes now.
>>
>>> &omap3_pmx_core {
>>> @@ -168,11 +313,72 @@
>>>> ;
>>>        };
>>>
>>> +       backlight_pins: backlight_pins_pimnux {
>>> +               pinctrl-single,pins = <0x8a MUX_MODE4>;
>>> +       };
>>> +
>>> +       hsusb2_pins: pinmux_hsusb2_pins {
>>> +               pinctrl-single,pins = <
>>> +                       OMAP3_CORE1_IOPAD(0x21d4, PIN_INPUT_PULLDOWN | MUX_MODE3)       /* mcspi1_cs3.hsusb2_data2 */
>>> +                       OMAP3_CORE1_IOPAD(0x21d6, PIN_INPUT_PULLDOWN | MUX_MODE3)       /* mcspi2_clk.hsusb2_data7 */
>>> +                       OMAP3_CORE1_IOPAD(0x21d8, PIN_INPUT_PULLDOWN | MUX_MODE3)       /* mcspi2_simo.hsusb2_data4 */
>>> +                       OMAP3_CORE1_IOPAD(0x21da, PIN_INPUT_PULLDOWN | MUX_MODE3)       /* mcspi2_somi.hsusb2_data5 */
>>> +                       OMAP3_CORE1_IOPAD(0x21dc, PIN_INPUT_PULLDOWN | MUX_MODE3)       /* mcspi2_cs0.hsusb2_data6 */
>>> +                       OMAP3_CORE1_IOPAD(0x21de, PIN_INPUT_PULLDOWN | MUX_MODE3)       /* mcspi2_cs1.hsusb2_data3 */
>>> +               >;
>>> +       };
>>> +
>>> +       i2c1_pins: pinmux_i2c1_pins {
>>> +               pinctrl-single,pins = <
>>> +                       0x18a (PIN_INPUT_PULLUP | MUX_MODE0)   /* i2c1_scl.i2c1_scl */
>>> +                       0x18c (PIN_INPUT_PULLUP | MUX_MODE0)   /* i2c1_sda.i2c1_sda */
>>> +               >;
>>> +       };
>>> +
>>> +       i2c2_pins: pinmux_i2c2_pins {
>>> +               pinctrl-single,pins = <
>>> +                       0x18e (PIN_INPUT_PULLUP | MUX_MODE0)   /* i2c2_scl.i2c2_scl */
>>> +                       0x190 (PIN_INPUT_PULLUP | MUX_MODE0)   /* i2c2_sda.i2c2_sda */
>>> +               >;
>>> +       };
>>> +
>>> +       i2c3_pins: pinmux_i2c3_pins {
>>> +               pinctrl-single,pins = <
>>> +                       0x192 (PIN_INPUT_PULLUP | MUX_MODE0)   /* i2c3_scl.i2c3_scl */
>>> +                       0x194 (PIN_INPUT_PULLUP | MUX_MODE0)   /* i2c3_sda.i2c3_sda */
>>> +               >;
>>> +       };
>>
>> Any reason why you don't use OMAP_IOPAD macro for the I2C pins?
>>
>>> +
>>> +       bma180_pins: pinmux_bma180_pins {
>>> +               pinctrl-single,pins = <
>>> +                       OMAP3_CORE1_IOPAD(0x213a, PIN_INPUT_PULLUP | MUX_MODE4)   /* gpio_115 */
>>> +               >;
>>> +       };
>>> +};
>>> +
>>> +&omap3_pmx_core2 {
>>> +       pinctrl-names = "default";
>>> +       pinctrl-0 = <
>>> +                       &hsusb2_2_pins
>>> +       >;
>>> +
>>> +       hsusb2_2_pins: pinmux_hsusb2_2_pins {
>>> +               pinctrl-single,pins = <
>>> +                       OMAP3630_CORE2_IOPAD(0x25f0, PIN_OUTPUT | MUX_MODE3)            /* etk_d10.hsusb2_clk */
>>> +                       OMAP3630_CORE2_IOPAD(0x25f2, PIN_OUTPUT | MUX_MODE3)            /* etk_d11.hsusb2_stp */
>>> +                       OMAP3630_CORE2_IOPAD(0x25f4, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d12.hsusb2_dir */
>>> +                       OMAP3630_CORE2_IOPAD(0x25f6, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d13.hsusb2_nxt */
>>> +                       OMAP3630_CORE2_IOPAD(0x25f8, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d14.hsusb2_data0 */
>>> +                       OMAP3630_CORE2_IOPAD(0x25fa, PIN_INPUT_PULLDOWN | MUX_MODE3)    /* etk_d15.hsusb2_data1 */
>>> +               >;
>>> +       };
>>> +
>>>        spi_gpio_pins: spi_gpio_pinmux {
>>> -               pinctrl-single,pins = <0x5a8 (PIN_OUTPUT | MUX_MODE4) /* clk */
>>> -                       0x5b6 (PIN_OUTPUT | MUX_MODE4) /* cs */
>>> -                       0x5b8 (PIN_OUTPUT | MUX_MODE4) /* tx */
>>> -                       0x5b4 (PIN_INPUT | MUX_MODE4) /* rx */
>>> +               pinctrl-single,pins = <
>>> +                       OMAP3630_CORE2_IOPAD(0x25d8, PIN_OUTPUT | MUX_MODE4) /* clk */
>>> +                       OMAP3630_CORE2_IOPAD(0x25e6, PIN_OUTPUT | MUX_MODE4) /* cs */
>>> +                       OMAP3630_CORE2_IOPAD(0x25e8, PIN_OUTPUT | MUX_MODE4) /* tx */
>>> +                       OMAP3630_CORE2_IOPAD(0x25e4, PIN_INPUT | MUX_MODE4) /* rx */
>>>> ;
>>>        };
>>> };
>>
>> regards,
>> Joachim Eastwood
>
