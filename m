Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbaFWPn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 11:43:26 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:49870 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785AbaFWPnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:43:23 -0400
MIME-Version: 1.0
In-Reply-To: <1403532837.3804.29.camel@hornet>
References: <1403018494-10264-1-git-send-email-pawel.moll@arm.com>
 <20140620170901.GA12059@leverpostej> <1403532837.3804.29.camel@hornet>
From: Rob Herring <robherring2@gmail.com>
Date: Mon, 23 Jun 2014 10:43:02 -0500
Message-ID: <CAL_Jsq+6SveWhzWPrtziTJ-tDOFaJV4sXO+r_CEhAZf=tQE6FA@mail.gmail.com>
Subject: Re: [PATCH v7 1/2] video: ARM CLCD: Add DT support
To: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 9:13 AM, Pawel Moll <pawel.moll@arm.com> wrote:
> On Fri, 2014-06-20 at 18:09 +0100, Mark Rutland wrote:
>> > +- clocks-names: should contain "clcdclk" and "apb_pclk"
>>
>> s/clocks-names/clock-names/
>
> Haha - it took quite a few patch revisions to spot this one, thanks!

Was this tested?

>> > +- clocks: contains phandle and clock specifier pairs for the entries
>> > +   in the clock-names property. See
>> > +   Documentation/devicetree/binding/clock/clock-bindings.txt
>> > +
>> > +Optional properties:
>> > +
>> > +- arm,pl11x,framebuffer-base: a pair of two 32-bit values, address and size,
>> > +   defining the framebuffer that must be used; if not present, the
>> > +   framebuffer may be located anywhere in the memory
>>
>> The name is confusing: this is a base _and_ size.
>
> True. Can split it into two -base and -size or rename it into
> framebuffer or video-memory.
>
>> When should this be used, and what is valid to point it at?
>
> When the hardware design determines the address the memory transactions
> must be issued at. This is aimed at a situation (allegedly not
> impossible) when the memory map from the CLCD's point of view is
> different from the CPU's one (eg. the video memory is mapped at xxx for
> the CPU and yyy for the CLCD).

Humm, that sounds like what dma-ranges is for.

>
>> How does this play with memory carveouts (CMA, reserved-memory)?
>
> It doesn't, and wasn't intended to (the original version of the binding
> was trying to do something like reserved-memory before it was defined),
> but someone managed to convince me not to do this, if it's a "low level"
> feature.
>
> I guess I can be re-convinced (again).

NAK on this property. Convinced?

If this is only theoretical, then just drop it for now.

>> > +- max-memory-bandwidth: maximum bandwidth in bytes per second that the
>> > +   cell's memory interface can handle
>>
>> When should I set this, given it is optional?
>
> When there is a (significant) limitation of the bandwidth available for
> the cell's memory interface. One will either be told by the soc guys or
> will figure it out in the hard way, as we did :-(

What are you going to do with this information? b/w is a function of
screen size and pixel depth. Are you going to refuse certain configs
based on that? Seems like someone doing their own modes should know
what they are doing and the limitations.

Again, drop it until there is a defined need for this.

>
>> > +
>> > +Required sub-nodes:
>> > +
>> > +- port: describes LCD panel signals, following the common binding
>> > +   for video transmitter interfaces; see
>> > +   Documentation/devicetree/bindings/media/video-interfaces.txt;
>> > +   when it is a TFT panel, the port's endpoint must define the
>> > +   following property:
>> > +
>> > +   - arm,pl11x,tft-r0g0b0-pads: an array of three 32-bit values,
>> > +           defining the way CLD pads are wired up; this implicitly
>> > +           defines available color modes, for example:
>> > +           - PL111 TFT 4:4:4 panel:
>> > +                   arm,pl11x,tft-r0g0b0-pads = <4 15 20>;
>> > +           - PL110 TFT (1:)5:5:5 panel:
>> > +                   arm,pl11x,tft-r0g0b0-pads = <1 7 13>;
>> > +           - PL111 TFT (1:)5:5:5 panel:
>> > +                   arm,pl11x,tft-r0g0b0-pads = <3 11 19>;
>> > +           - PL111 TFT 5:6:5 panel:
>> > +                   arm,pl11x,tft-r0g0b0-pads = <3 10 19>;
>> > +           - PL110 and PL111 TFT 8:8:8 panel:
>> > +                   arm,pl11x,tft-r0g0b0-pads = <0 8 16>;
>> > +           - PL110 and PL111 TFT 8:8:8 panel, R & B components swapped:
>> > +                   arm,pl11x,tft-r0g0b0-pads = <16 8 0>;
>>
>> I'm somewhat lost trying to figure out this mapping. Am I not looking at
>> this in the right way, or is there any documentation which makes this
>> clearer?
>
> Yeah, looking at this now, it definitely needs some more explanation.
> Something like this?
>
>         First value contains index of the "CLD" external pin (pad)
>         used as R0 (first bit of the red component), second value
>         index of the pad used as G0, third value index of the pad
>         used as B0, see also "LCD panel signal multiplexing details"
>         paragraph in the PL11x Technical Reference Manuals.
>
> Pawel
>
