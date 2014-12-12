Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967559AbaLLMO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 07:14:58 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35917 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966281AbaLLMO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 07:14:56 -0500
Date: Fri, 12 Dec 2014 13:14:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, khilman@kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<ivo.g.dimitrov.75@gmail.com>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: Re: __hci_cmd_sync() not suitable for nokia h4p
Message-ID: <20141212121453.GA31659@amd>
References: <20141209190210.GA15641@amd>
 <304050AD-DB11-4A2B-A1F7-8B1BBB5F04F0@holtmann.org>
 <20141209201328.GA18003@amd>
 <7EFD3C33-E503-4FB6-BCCF-52836080ABD6@holtmann.org>
 <20141210131519.GA14748@amd>
 <EE1A4B9D-30D5-4BD9-9A43-532619494A0C@holtmann.org>
 <20141211221306.GA2905@amd>
 <20141212011504.GA16599@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141212011504.GA16599@earth.universe>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> > I have created provisional device tree binding, and the driver still
> > works.
> 
> I don't have time to look at the code now, but I have some comments
> regarding the binding.

> >  
> >  &uart2 {
> > +        compatible = "brcm,uart,bcm2048";
> 
> This does not look correct. The uart should not be overwritten. The
> current h4p driver indeed implements a driver for the serial port,
> but that's a) linux specific and does not belong in the DT and b)
> should probably be changed in the mainline kernel.

Yes, bettter solution is needed here. But see the code, I don't see
how b) would be implemented.

> >  	interrupts-extended = <&intc 73 &omap3_pmx_core OMAP3_UART2_RX>;
> >  	pinctrl-names = "default";
> >  	pinctrl-0 = <&uart2_pins>;
> > +	device {
> > +		  compatible = "brcm,bcm2048";
> > +		  uart = <&uart2>;
> 
> You don't need a phandle to the parent device.

Ok.

> > +		  reset-gpios = <&gpio3 27 GPIO_ACTIVE_HIGH>; /* want 91 */
> > +		  host-wakeup-gpios = <&gpio4 5 GPIO_ACTIVE_HIGH>; /* want 101 */
> 
> The host-wakeup should be mapped as irq, gpio2irq conversion
> will happen ;)

Why? It is accessed as gpio, too.

> > +		  chip-type = <3>;
> 
> This should be set in the driver based on the compatible
> value and not via DT data.

Ok

> > +		  clocks = <&uart2_fck>, <&uart2_ick>;
> > +		  clock-names = "fck", "ick";
> 
> These clocks you defined belong to the uart device and not to the
> uart slave (bluetooth) device.

Ok. Why are they only needed in the bluetooth case?

> > +		  bt-sysclk = <2>;
> 
> I think this should be mapped cleanly in DT by adding a new clock
> to the DTS file:
> 
> vctcxo_clock: clock  {
>     compatible = "fixed-clock";
>     #clock-cells = <0>;
>     clock-frequency = <38400000>;
> };

No. It seems that this selects baud rate during the chip init. I guess
I can just remove that one.

> Then the bluetooth device can reference its clock device:
> 
> clocks = <&vctcxo_clock>;
> 
> The same clock reference should be added to the wl1251 DT node :)

Feel free to do that, but I don't see how this one helps...?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
