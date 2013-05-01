Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190Ab3EAWYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:24:08 -0400
Received: from lvps176-28-13-145.dedicated.hosteurope.de ([176.28.13.145]:41711
	"EHLO lvps176-28-13-145.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756218Ab3EAWYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:24:07 -0400
From: Tim Sander <tim@krieglstein.org>
Organization: Sander & Lightning
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: Re: Pinmuxing with devicetree (beaglebone)
Date: Thu, 2 May 2013 00:24:46 +0200
User-Agent: KMail/1.13.7 (Linux/3.8.0-rc6-00008-g8b31849; KDE/4.8.4; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201304211143.50961.tim@krieglstein.org> <CAN1soZzz=GRMrmj3rtBkxE74e0JZ4xewR=yVMUeMvp=6Yp34nQ@mail.gmail.com>
In-Reply-To: <CAN1soZzz=GRMrmj3rtBkxE74e0JZ4xewR=yVMUeMvp=6Yp34nQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305020024.46922.tim@krieglstein.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian and Linux-Folks

Thanks for your reply. This is just a short followup how i got it working. But
as the 3.8.4 kernel on the beaglebone is having no ethernet connectivity i 
went back to the 3.2 kernel without device tree support for the time beeing.
So i didn't spent to much time on the device tree stuff.
> > I am currently trying to get pinmuxing working on a beaglebone board with
> > an offtree driver. This is for a custom handbuild hardware so i guess
> > there is no point in bringing this mainline.
> > 
> > While this is havyly patched 3.8.4 version running over here i think the
> > pinmux infrastructure is the new standard way. At least there is a
> > pinctrl/44e10800.pinmux directory in debugfs?
> > 
> > My last aproach was using the devicetree but beeing new to this
> > devicetree stuff i just got stuck:
> > http://comments.gmane.org/gmane.linux.ports.arm.kernel/231204
> > 
> > Now i tried use the way it is described in Documentation/pinctrl.txt but
> > still there are the includes missing: #include
> > <linux/pinctrl/consumer.h>.
> > 
> > Also while there is a /sys/kernel/debug/pinctrl/44e10800.pinmux in
> > debugfs i found that not so intuitive as the omap_mux which disappeared.
> > Also i didn't find any documentation for this debugfs stuff.
> > 
> > So what is the recommended way to get this stupid pinmuxing going. In pre
> > devicetree days one would just pick the mux.h include of the platform and
> > initialized the muxers which was pretty straight forward. Now with device
> > tree its much more complicated. No proper syntax checking as with the c
> > definitions and no documentation how to get this magic stuff working
> > :-(.
> > 
> > The whole stuff is build by a ptxdist (a embedded buildsystem) and can be
> > found over here:
> > https://gitorious.org/ptxdist-beaglebone/ptxdist-beaglebone
> 
> "pins" node could dump the register configuration if it's pinctrl-single
> driver.
> 
> You can dump this to check whether the right pinmux is set.
> 
> I checked your patch in the link.  It seems that you only write the pinmux
> configuration without using them.
> 
> Don't forget to append this in your DTS file.
>      pinctrl-names = "default";
>        pinctrl-0 = <&wind_pins>;
Thanks for the pointers, but somehow these fragments didn't work. What worked 
was writing it directly into the included dtb at the proper place eg.:

   am33xx_pinmux: pinmux@44e10800 {
      pinctrl-names = "default";
      pinctrl-0 = <&userleds_pins>;

      userled_pins: pinmux_userled_pins {
         pinctrl-single,pins = <
            /* Tims wind pins */
            0x000  0x27      /* gpmc_ad0 = ad0 = P8-25 = gpio1_0|input, no pullup, gpio mux  */
            0x004  0x27      /* gpmc_ad1 = ad1 = P8-24 = gpio1_1|input, no pullup, gpio mux  */
            0x008  0x27      /* gpmc_ad2 = ad2 = P8-5 = gpio1_2|input, no pullup, gpio mux  */
            0x00c  0x27      /* gpmc_ad3 = ad3 = P8-6 = gpio1_3|input, no pullup, gpio mux  */
            0x038  0x26      /* gpmc_ad14  = pru_gpio_in14 = P8_16 = gpio1.14|input, no pullup, pru0 gpio 14 */

            0x54 0x7 /* gpmc_a5.gpio1_21, OUTPUT | MODE7 */
            0x58 0x17   /* gpmc_a6.gpio1_22, OUTPUT_PULLUP | MODE7 */
            0x5c 0x7 /* gpmc_a7.gpio1_23, OUTPUT | MODE7 */
            0x60 0x17   /* gpmc_a8.gpio1_24, OUTPUT_PULLUP | MODE7 */
         >;
      };
      i2c0_pins: pinmux_i2c0_pins {
         pinctrl-single,pins = <
            0x188 0x70  /* i2c0_sda, SLEWCTRL_SLOW | INPUT_PULLUP | MODE0 */
            0x18c 0x70  /* i2c0_scl, SLEWCTRL_SLOW | INPUT_PULLUP | MODE0 */
         >;
      };
      i2c2_pins: pinmux_i2c2_pins {
         pinctrl-single,pins = <
            0x178 0x73  /* uart1_ctsn.i2c2_sda, SLEWCTRL_SLOW | INPUT_PULLUP | MODE3 */
            0x17c 0x73  /* uart1_rtsn.i2c2_scl, SLEWCTRL_SLOW | INPUT_PULLUP | MODE3 */
         >;
      };
   };

Also one thing i didn't know is that the dtb can also reverse compile so that the result can be seen.
This is especially handy with these fragment and include stuff.

Best regards
Tim
