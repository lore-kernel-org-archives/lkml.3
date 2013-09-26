Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab3IZK70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:59:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48779 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756042Ab3IZK7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:59:24 -0400
Date: Thu, 26 Sep 2013 11:59:19 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2] MTD: Onenand: Add device tree support for samsung
 onenand
Message-ID: <20130926105919.GG2411@e106331-lin.cambridge.arm.com>
References: <1379941608-5068-1-git-send-email-m.krawczuk@partner.samsung.com>
 <20130923140823.GC16069@e106331-lin.cambridge.arm.com>
 <2086340.RrXQX9ib0T@amdc1227>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2086340.RrXQX9ib0T@amdc1227>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 02:00:01PM +0100, Tomasz Figa wrote:
> Hi Mateusz, Mark,

Hi,

> 
> On Monday 23 of September 2013 15:08:23 Mark Rutland wrote:
> > On Mon, Sep 23, 2013 at 02:06:48PM +0100, Mateusz Krawczuk wrote:
> > > +
> > > +Required properties:
> > > +  - compatible: value should be either of the following.
> > > +      (a) "samsung,s3c6400-onenand",
> > > +		for onenand controller compatible with s3c6400.
> > > +      (b) "samsung,s3c6410-onenand",
> > > +		for onenand controller compatible with s3c6410.
> > > +      (c) "samsung,s5pc100-onenand",
> > > +		for onenand controller compatible with s5pc100.
> > > +      (d) "samsung,s5pc110-onenand",
> > > +      for s5pc100-like onenand controller used on s5pc110 which supports DMA.
> > > +
> > 
> > As I asked on the last posting, what are the differences between these
> > implementations?
> 
> (d) is a completely different controller than (a), (b) and (c). They
> have completely different register layouts. Also see below.

Ok.

> 
> > > +Required properties for s5pc110:
> > > +
> > > + - reg: the offset and length of the control registers. First region describes
> > > +	OneNAND interface, second control registers.
> > 
> > Also, the complete reg description is a bit confusing. How about
> > something like:
> > 
> >  - reg: two register specifiers:
> >         [0] - The OneNAND interface
> > 	[1] - The control registers
> 
> This looks much better, although I wouldn't be afraid of using words
> instead of symbols to write this as follows instead:
> 
>   - reg: two memory mapped register regions:
>     - first entry: memory mapped OneNAND chip,
>     - second entry: control registers.

I'm also happy with that.

> 
> But... The controller in theory supports more than one OneNAND chip, each
> mapped at different, so I'd suggest reordering the entries:
> 
>   - reg: memory mapped register regions:
>     - first entry: control registers.
>     - second entry: memory mapped OneNAND chip 0,
>     - ...
>     - Nth entry: memory mapped OneNAND chip (N-2).

I agree on the reordering, hence the questions I had below.

> 
> > Do we expect future OneNAND devices which may require more reg entries
> > to describe?
> 
> Nope. In age of eMMC I wouldn't even expect any new OneNAND controller
> to be handled by these bindings.

Ok.

> 
> > > + - interrupt-parent, interrupts		Onenand memory interrupts
> > 
> > As it's a common property, I don't think interrupt-parent needs to
> > be described.
> > 
> > Is there more than one interrupt? What's it called on the manual?
> 
> There is one interrupt per OneNAND chip, so this is what should be
> represented in the binding.

Ah. That should be mentioned explicitly, with the required ordering.

> 
> > > +
> > > +Required properties for others:
> > > +
> > > + - reg: the offset and length of the control registers. First region describes
> > > +	control registers, second OneNAND interface.
> > 
> > Why does the s5pc110 OneNAND binding take its registers in the opposite
> > order to the rest of these? Can we not fix up the driver first to make
> > it consistent? Then we only need to describe this once and it's going to
> > be far less of a headache to support.
> 
> Both areas in both "major" hardware variants have completely different
> meaning:
>  - in case of SoCs earlier or equal to S5PC100, first entry represents
>    controller registers that are used to control various operating
>    parameters, while second entry is a command/data interface, which is
>    used to trigger read/write/etc. operations in the controller and
>    push/pull data through it. In this variant there is no direct mapping
>    of OneNAND chip in CPU address space. This variant supports only
>    one memory chip per controller instance,
>  - in case of S5PC110, each OneNAND chip is directly mapped into CPU
>    address space. In addition there is a block of control registers that
>    are used to configure the interface and control internal DMA engine
>    (which is not present in <= S5PC100 variants). This variant supports
>    multiple memory chips per controller instance (2 in case of S5PV210,
>    but current driver handles only one AFAIK).

Ok. Even with that, I think the suggestion to reorder the reg entries
above still makes this more consistent, with the controller registers
first, then an entry per-chip (which is either the chip itself or the
related command/data interface depending on the particular controller).

> 
> > > +
> > > +Clocks:
> > > + - gate - clock which output is supplied to external OneNAND flash memory.
> > 
> > How about the following (without the Clocks header):
> > 
> > - clocks: clock-specifiers for the clocks named in clock-names, per the
> >           common clock bindings.
> > 
> > - clock-names: should contain "gate" for the clock to the OneNAND flash
> >                memory.
> > 
> > Is this the only clock that might be necessary on all platforms?
> 
> S3C64xx SoCs have only one OneNAND gate clock per controller.
> S5PC100 SoC has one IP gate clock and one memory chip gate clock.
> S5PC110 SoC has one gate that gates both IP and all memory chips.

Good to know. Thanks for the thorough description.

Cheers,
Mark.
