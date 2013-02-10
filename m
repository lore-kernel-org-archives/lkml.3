Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab3BJPV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 10:21:59 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:46771 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab3BJPV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 10:21:58 -0500
MIME-Version: 1.0
Date: Sun, 10 Feb 2013 20:51:57 +0530
Message-ID: <CABYxbz5ECxoWZtkfL3UbZ=R4LVoNeMVxjYbPdZoarstCod-gQw@mail.gmail.com>
Subject: Sound record on Devkit8000 with DT boot issue
From: Anil Kumar <anilk4.v@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        alsa-devel@alsa-project.org
Cc: tony@atomide.com, thomas@tomweber.eu, perex@perex.cz, tiwai@suse.de,
        lrg@ti.com, Peter Ujfalusi <peter.ujfalusi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am working on Devkit8000 and adding DT support for that. I am trying
to add sound DT node support for this boards.
I have nearly done with this but facing issue on record. I do not have
much knowledge of twl4030 audio codec but with
small Hack[1] (as MainMic connected to the input jack)  i am able to
record sound on Devkit8000.
I do not know that MICBIAS1_EN can be enable by amixer commands.
Could you please help me to get out of this ?


1) Hack [1]

diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 63b280b..6780681 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -1473,7 +1473,7 @@ static const struct snd_soc_dapm_widget
twl4030_dapm_widgets[] = {
        SND_SOC_DAPM_SUPPLY("micbias2 select", TWL4030_REG_MICBIAS_CTL, 6, 0,
                            NULL, 0),

-       SND_SOC_DAPM_MICBIAS("Mic Bias 1", TWL4030_REG_MICBIAS_CTL, 0, 0),
+       SND_SOC_DAPM_MICBIAS("Mic Bias 1", TWL4030_REG_MICBIAS_CTL, 0, 1),
        SND_SOC_DAPM_MICBIAS("Mic Bias 2", TWL4030_REG_MICBIAS_CTL, 1, 0),
        SND_SOC_DAPM_MICBIAS("Headset Mic Bias", TWL4030_REG_MICBIAS_CTL, 2, 0),


2) Sound DT node patch for Devkit8000

diff --git a/arch/arm/boot/dts/omap3-
devkit8000.dts b/arch/arm/boot/dts/omap3-devkit8000.dts
index dc59272..5f3eec0 100644
--- a/arch/arm/boot/dts/omap3-devkit8000.dts
+++ b/arch/arm/boot/dts/omap3-devkit8000.dts
@@ -44,11 +44,22 @@
                 };

        };
+
+       sound {
+               compatible = "ti,omap-twl4030";
+               ti,model = "devkit8000";
+
+               ti,mcbsp = <&mcbsp2>;
+               ti,codec = <&twl_audio>;
+       };
 };

 &omap3_pmx_core {
        pinctrl-names = "default";
-       pinctrl-0 = <&i2c1_pins>;
+       pinctrl-0 = <
+                       &i2c1_pins
+                       &mcbsp2_pins
+               >;

        leds_pins: pinmux_led_pins {
                pinctrl-single,pins = <
@@ -65,6 +76,21 @@
                        0x18c 0x118     /* I2C1_SDA */
                 >;
        };
+
+       mcbsp2_pins: pinmux_mcbsp2_pins {
+                pinctrl-single,pins = <
+                       /*
+                        * MCBSP2_FSX, OMAP_MUX_MODE0 | OMAP_PIN_INPUT,
+                        * MCBSP2_CLKX, OMAP_MUX_MODE0 | OMAP_PIN_INPUT
+                        */
+                       0x10c 0x01000100
+                       /*
+                        * MCBSP2_DR, OMAP_MUX_MODE0 | OMAP_PIN_INPUT,
+                        * MCBSP2_DX, OMAP_MUX_MODE0 | OMAP_PIN_OUTPUT
+                        */
+                       0x110 0x00000100
+               >;
+       };
 };

 &i2c1 {
@@ -74,6 +100,14 @@
                reg = <0x48>;
                interrupts = <7>;       /* SYS_NIRQ cascaded to intc */
                interrupt-parent = <&intc>;
+
+               twl_audio: audio {
+                       compatible = "ti,twl4030-audio";
+                       codec {
+                               ti,ramp_delay_value = <3>;
+                               ti,offset_cncl_path = <0x31>;
+                       };
+               };
        };
 };

3) Playback amixer commands
   amixer set 'PredriveR Mixer AudioR2' on
   amixer set 'PredriveL Mixer AudioL2' on
   amixer set PreDriv 100 unmute
   amixer set 'DAC2 Digital Fine' 100

Thanks,
Anil
