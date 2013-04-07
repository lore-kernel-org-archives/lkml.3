Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836Ab3DGOdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 10:33:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56817 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933815Ab3DGOdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 10:33:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Tang <dt.tangr@gmail.com>
Subject: Re: [RFC PATCH arm: initial TI-Nspire support]
Date: Sun, 7 Apr 2013 16:32:55 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        fabian@ritter-vogt.de, Lionel Debroux <lionel_debroux@yahoo.fr>,
        linux-kernel@vger.kernel.org
References: <6FE4B33E-A503-4A75-AEED-831CB2C06D83@gmail.com> <201304061524.56502.arnd@arndb.de> <4B3FD561-84FC-40CD-B747-13851692D673@gmail.com>
In-Reply-To: <4B3FD561-84FC-40CD-B747-13851692D673@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304071632.55922.arnd@arndb.de>
X-Provags-ID: V02:K0:nSUcmxELzARPe/X5xj+UQVjGmBGoug8ZWfyipjnp/wH
 wLlw78Oe85vL7UfFB7hCNJysmgB03NPYzP0aUgy1bc4pmFaDER
 wTbcOM9XopEb8eg8aebKGSD/m4LHdhDMOq5brY31aKvKoFelAl
 WEoYOQlyeuI7p8k9rp4SH/fYDJNgqve0kcneHopuhhJqejSdOq
 C/VjHxFRYi2EECGZCaaPwU93znB2/GdVShd9JGd1/xHZa1EYlu
 mz7UFQNGCeZ7oNPcHKF9wGrfwrD7ETMnLUstrKH5peMAMzzXkk
 ApP4ZAUC5finBEmRmwzvFT14nrEBDrZs/i29FewGWieZUiFuff
 MycZDY4cZBVMe6bC1QUw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 April 2013, Daniel Tang wrote:
> On 07/04/2013, at 12:24 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > 
> >> @@ -313,7 +314,7 @@ define archhelp
> >>   echo  '  Image         - Uncompressed kernel image (arch/$(ARCH)/boot/Image)'
> >>   echo  '* xipImage      - XIP kernel image, if configured (arch/$(ARCH)/boot/xipImage)'
> >>   echo  '  uImage        - U-Boot wrapped zImage'
> >> -  echo  '  bootpImage    - Combined zImage and initial RAM disk' 
> >> +  echo  '  bootpImage    - Combined zImage and initial RAM disk'
> >>   echo  '                  (supply initrd image via make variable INITRD=<path>)'
> >>   echo  '* dtbs          - Build device tree blobs for enabled boards'
> >>   echo  '  install       - Install uncompressed kernel'
> > 
> > This looks like it wasn't meant to be in the patch.
> 
> It probably isn't. I think there was trailing whitespace on that and my editor happened to remove it automatically.
> 
> Should this be a separate patch to fix up formatting or should I leave it in as a drive-by fix?

Any cleanups like this should be separate patches, and ideally even
part of a different patch series.

> > 
> >> +			uart: uart@90020000 {
> >> +				reg = <0x90020000 0x1000>;
> >> +				interrupts = <1>;
> >> +
> >> +				clocks = <&uart_clk>;
> >> +				clock-names = "uart_clk";
> >> +			};
> > 
> > The name for a uart should be "serial". Since this is a pl01x, please add
> > the required properties for the device, e.g. 
> > 
> > 	compatible = "arm,pl011", "arm,primecell";
> > 
> > You will need the "arm,primecell" bit to make the device appear on the
> > amba bus rather than the platform bus.
> 
> That was actually deliberate because different models of the TI-NSPIRE have different
> serial hardware. On the newer CX models, it is a PL01x and on the older models, it has
> a 8250-like interface. They all reside at the same address with the same IRQ though.
> 
> I thought it might be cleaner to specify the interrupts and registers in the common file
> and leave it to the board specific ones to implement the "compatible" property.

I see. It seems a little confusing to the reader though. I don't have a good answer,
but there are two other options how this can be handled:

* Put both devices in the devicetree and mark them as status="disabled" in the main file,
but enable one of them in the version specific files.

* leave them out of the .dtsi file and only define them in the specific .dts files.
> >> +	err = of_property_read_string(of_aliases, "timer0", &path);
> >> +	if (WARN_ON(err))
> >> +		return;
> >> +
> >> +	timer = of_find_node_by_path(path);
> >> +	base = of_iomap(timer, 0);
> >> +	if (WARN_ON(!base))
> >> +		return;
> >> +
> >> +	clk = of_clk_get_by_name(timer, NULL);
> >> +	clk_register_clkdev(clk, timer->name, "sp804");
> >> +
> >> +	sp804_clocksource_init(base, timer->name);
> >> +
> >> +	err = of_property_read_string(of_aliases, "timer1", &path);
> >> +	if (WARN_ON(err))
> >> +		return;
> > 
> > In particular, I think the method of using aliases to pick the right sp804
> > instance is being deprecated now. If both timers are identical, the kernel
> > will now just pick one of them.
> 
> Sorry, I don't quite understand. 
> 
> Out of the timers, I want to add one as a clocksource and one as a clockevent.
> If they're identical (i.e. without using aliases), how should I tell the kernel,
> "Take the first timer you see and make it a clocksource, take the next one you
> see and make it a clockevent"?

The modified sp804 driver will have logic to do that. I think in the end we
decided that the driver should first look for any device that can be used as
a clocksource and use it that way. If it finds a second device, that can be
used as clockevent.

	Arnd
