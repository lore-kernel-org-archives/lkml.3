Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab3F0SwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 14:52:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57557 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809Ab3F0SwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:52:08 -0400
Message-ID: <1372359090.21065.12.camel@cumari.coelho.fi>
Subject: Re: [PATCH] Documentation: dt: bindings: TI WiLink modules
From: Luciano Coelho <coelho@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        "Tony Lindgren" <tony@atomide.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 27 Jun 2013 21:51:30 +0300
In-Reply-To: <CAGo_u6pWZX9gbHgBae=gcWk8i6-TnhxH1TdM9QdEDLTow6Pn5A@mail.gmail.com>
References: <1372149330-24335-1-git-send-email-coelho@ti.com>
	 <51CBC1C8.1040301@gmail.com> <1372322851.18889.53.camel@cumari.coelho.fi>
	 <20130627125131.GA27285@kahuna> <1372337887.8383.12.camel@cumari.coelho.fi>
	 <CAGo_u6qbt9dANgKq49xR=1qsCpUBhmVaPL4EK04XvTw+=4Z23g@mail.gmail.com>
	 <1372339148.8383.17.camel@cumari.coelho.fi> <51CC3CEE.3050004@ti.com>
	 <1372339810.8383.20.camel@cumari.coelho.fi>
	 <CAGo_u6pWZX9gbHgBae=gcWk8i6-TnhxH1TdM9QdEDLTow6Pn5A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 08:39 -0500, Nishanth Menon wrote:
> On Thu, Jun 27, 2013 at 8:30 AM, Luciano Coelho <coelho@ti.com> wrote:
> > On Thu, 2013-06-27 at 08:23 -0500, Nishanth Menon wrote:
> >> On 06/27/2013 08:19 AM, Luciano Coelho wrote:
> >> > On Thu, 2013-06-27 at 08:15 -0500, Nishanth Menon wrote:
> >> >> On Thu, Jun 27, 2013 at 7:58 AM, Luciano Coelho <coelho@ti.com> wrote:
> >> >>> For the actual DTS files, I could add a wilink.dtsi with enumerations
> >> >>> for these values so they could be used in the node definitions.  But I'm
> >> >>> not sure it's going to be that valuable in the end.
> >> >> The  way GPIO HIGH was defined might help to provide guidance I think :)
> >> >
> >> > Where? As far as I can see, the GPIO flags are defined in a bitmap.
> >>
> >> include/dt-bindings/gpio/gpio.h
> >
> > Thanks! I don't see these macros used anywhere, though.
> umm... I'd think you have'nt looked deep enough / lists :)

If you mean mailing lists, you're right, I didn't.  I just did a git
grep for the macros and didn't find any users.


> >> And corresponding kernel header:
> >> include/linux/of_gpio.h
> >
> > This seems to be a completely different thing.  This is the header that
> > contains the helper functions to get GPIO-related device tree nodes,
> > isn't it?
> That is true, but it also contains the flag for level which needs to
> be in sync with the gpio.h dts header.
> >> just a hint. not saying frequencies were defined in header. for systems
> >> that define frequencies - example cpufreq OPPs, clock node usage, we do
> >> not use indexing to frequency, instead, that is the responsibility of
> >> driver to convert frequency back to required index.
> >> git grep frequency Documentation/devicetree/bindings gives you how the
> >> precedence looks like.
> >>
> >> Personally, if given a choice, I'd go with actual frequencies rather
> >> than indexes.
> >
> > If I do that, I need to add also a separate flag to define whether the
> > XTAL clock is used or not.  For instance, we have 26MHz and 26MHz
> > crystal; and 38.4MHz and 38.4MHz crystal...
> Yes, you would have to. at the same time, it is easy for module maker
> to provide dtsi corresponding to exact h/w representation on his
> module using wilink chip without being worried about weird index value
> whose meaning is hidden in binding

The module makers need to know about the bindings and read the document
before they specify the node in DTS.  I think for clarity, a comment in
the DTS file stating the actual frequency is good enough.  Simpler and
more efficient (in terms of DT binary size and module code size) than
adding the actual frequencies.


> On the flip side, It also allows driver to reject frequencies /
> configurations that are not supported by the corresponding chip.

It's actually much easier to reject frequencies that are not valid with
the enumeration.  "if (refclock > 5) { bail_out(); }".  If I need to
check every frequency, I need to add an array of valid frequencies and
so on.  Waste of code, IMHO.


> As I said, just my 2 cents. Personally, I'd like dts files to be as
> readable as c files without having to dig through bindings document.

As I said before, for readability, adding a comment with the frequency
is good enough.  This is what I did for PandaES's DTS (not sent out
yet):

	wlan {
	     compatible = "ti,wilink6";
	     interrupt-parent = <&gpio2>;
	     interrupts = <21 0x4>;	/* gpio line 53, high level triggered */
	     refclock = <2>;		/* 38.4 MHz */
	 };

Looks more readable to me than:

	wlan {
	     compatible = "ti,wilink6";
	     interrupt-parent = <&gpio2>;
	     interrupts = <21 0x4>;	/* gpio line 53, high level triggered */
	     refclock = <38400>;
	     refclock_xtal = <0>;
	 };

The macro idea sounds better to me, but in this case this code is so
simple that I don't think it's really worth it.

And, from another point of view, I see this as only a specification of
the module's details.  The frequency value is not really used anywhere
outside the module, so we don't see it.  I don't think there's a good
reason to expose the actual frequency to the kernel (and parse it back
to the values the firmware needs), since nothing else inside the kernel
will care about it.

--
Luca.

