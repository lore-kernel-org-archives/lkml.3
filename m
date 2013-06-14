Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab3FNF4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:56:37 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:11392 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751401Ab3FNF4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:56:35 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18A9lNaPMa0VsTRH11aeCsz
Date: Thu, 13 Jun 2013 22:56:29 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, pali.rohar@gmail.com,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Subject: Re: N900 device tree conversion: how to do first step
Message-ID: <20130614055629.GM8164@atomide.com>
References: <20130609015944.GA23559@amd.pavel.ucw.cz>
 <20130609201119.GA3190@blackmetal.musicnaut.iki.fi>
 <20130613132624.GA3464@amd.pavel.ucw.cz>
 <20130613141001.GF8164@atomide.com>
 <20130613142809.GA3775@amd.pavel.ucw.cz>
 <20130613145724.GH8164@atomide.com>
 <20130613155240.GB3775@amd.pavel.ucw.cz>
 <20130613161418.GJ8164@atomide.com>
 <20130613230808.GA14876@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613230808.GA14876@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek <pavel@ucw.cz> [130613 16:14]:
> Hi!
> 
> > > Now, by chance, any idea what is DT equivalent of 
> > > 
> > > omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
> > 
> > You can try the attached hack after calling the above to grep for
> > pins in /sys/kernel/debug/omap_mux/board/core and you get the pins
> > in DT suitable format. There's a bug where the the pins are not
> > correctly split between core and wkup domains in the legacy mux fwk,
> > but you probably won't need to mux many wkup domain pins.
> > 
> > Then you just need to add the pinctr-single entries for each device,
> > but AFAIK most of the pins are muxed correctly in the bootloader
> > for the Nokia boards.
> 
> Thanks a lot for the help. So far, I'm not playing with
> suspend/resume, so wkup/core split should not be issue (right?).

Well if you have any wkup mux registers mapped for core mux,
pinctrl-single will complain about offset being out of range
and not set the values. You can see that in dmesg, or at least
with CONFIG_DEBUG_PINCTRL set.
 
> How does it work with the devices? AFAICT omap4 groups it logically,
> but that's just for easy reading, no?

No, there really are two instances of mux registers even on omap3,
but I missed that earlier while reading the docs, and with the legacy
mux framework it does not matter which mux domain it is. But it
matters for pinctrl-single as it ioremaps the ranges separately.
 
> I tried this, but no luck, mux is not initialized correctly, so code
> in board-rx51-video fails, and later fbcon crashes.
> 
> Any ideas?

You may have some wkup mux domain offsets in your .dts file, so
pinctrl-single will abort the muxing.

> --- a/arch/arm/boot/dts/omap3-n900.dts
> +++ b/arch/arm/boot/dts/omap3-n900.dts
> @@ -81,3 +81,218 @@
>  	power = <50>;
>  };
>  */
> +
> +
> +
> +&omap3_pmx_core {
> +		pinctrl-names = "default";
> +		pinctrl-0 = <
> +			&all_pins
> +		>;
> +
> +		all_pins: pinmux_all_pins {
> +		    pinctrl-single,pins = <
> +			0xe6 0x4104	/* cam_d0.gpio_99 gpio99 INPUT | OFF_WAKEUPENABLE | MODE4 */
> +			0xe8 0x11c	/* cam_d1.gpio_100 gpio100 INPUT_PULLUP | MODE4 */
> +			0xfa 0x7	/* cam_d10.safe_mode gpio109 OUTPUT | MODE7 */
...

This is not a good way of doing muxing, hogging all the pins under
omap3_pmx_core will make it impossible to unload pinctrl-single
as a module, which is not nice for distros and developers.

Further, if some pins need dynamic remuxing, we can't do it in
the device driver for the device. For n900, dynamic remuxing needs
to be done for eMMC at least, see rx51_mmc2_remux().

Also, see the recent patches that Benoit has queued to use the
preprocessor for the .dts files, we should modify the legacy mux
dump hack to output the mux mode defines instead.

Regards,

Tony
