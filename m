Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaHSCmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 22:42:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59152 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaHSCmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 22:42:51 -0400
Date: Mon, 18 Aug 2014 19:42:44 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, "Gupta, Pekon\"" <pekon@ti.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: Re: [PATCH] mtd: nand: stm_nand_bch: add new driver
Message-ID: <20140819024244.GS18411@ld-irv-0074>
References: <1401268805-26043-1-git-send-email-lee.jones@linaro.org>
 <20140703002237.GM3599@ld-irv-0074>
 <20140731164709.GK9030@lee--X1>
 <20140731175427.GO3711@ld-irv-0074>
 <20140801092725.GN9030@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801092725.GN9030@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 10:27:25AM +0100, Lee Jones wrote:
> On Thu, 31 Jul 2014, Brian Norris wrote:
> > On Thu, Jul 31, 2014 at 05:47:09PM +0100, Lee Jones wrote:
> > > > >  arch/arm/boot/dts/stih41x-b2020.dtsi               |   40 +
> > > > 
> > > > This will need refreshed and sent as a separate patch, to go through the
> > > > appropriate ARM tree.
> > > 
> > > As above.
> > 
> > OK, if you're really planning to send a final git pull request, you'll
> > need to have this in a separate branch for them to take, then.
> 
> Of course.  Same goes with the DTS(I) changes.

PSA: make sure your patches will bisect if you're going to send so many.
I don't want to have to copy-and-paste my build results again.

> > > > (Related: Coverity caught a whole bunch of these type of bugs in the MTD
> > > > test modules. I have fixes queued up that I meant to test and submit
> > > > soon.)
> > > 
> > > I will attempt to play around with Coverity.
> > 
> > Good luck :) Coverity isn't always the easiest to get running
> > individually. You might have better luck (once your stuff is merged)
> 
> Sorry merged where?

To Linus's tree. Presumably that's what you're sending your patches to
me for? :)

Dave Jones runs a Coverity instance against mainline.

> > checking out the free service offered for open source projects through
> > github. There's a project instance set up for mainline:
> > 
> >   https://scan.coverity.com/projects/128?tab=overview
> 
> Thanks.  I'll have a play.
> 
> > > > > +/*
> > > > > + * Detect an erased page, tolerating and correcting up to a specified number of
> > > > > + * bits at '0'.  (For many devices, it is now deemed within spec for an erased
> > > > > + * page to include a number of bits at '0', either as a result of read-disturb
> > > > > + * behaviour or 'stuck-at-zero' failures.)  Returns the number of corrected
> > > > > + * bits, or a '-1' if we have exceeded the maximum number of bits at '0' (likely
> > > > > + * to be a genuine uncorrectable ECC error).  In the latter case, the data must
> > > > > + * be returned unmodified, in accordance with the MTD API.
> > > > > + */
> > > > > +static int check_erased_page(uint8_t *data, uint32_t page_size, int max_zeros)
> > > > 
> > > > Another "check erased page" implementation? Sigh... it would be nice if
> > > > we could agree on a common implementation to share. My last attempt was
> > > > unsuccessful, since some drivers have some very odd requirements.
> > > > 
> > > > > +{
> > > > > +	uint8_t *b = data;
> > > > > +	int zeros = 0;
> > > > > +	int i;
> > > > > +
> > > > > +	for (i = 0; i < page_size; i++) {
> > > > > +		zeros += hweight8(~*b++);
> > > > > +		if (zeros > max_zeros)
> > > > > +			return -1;
> > > > > +	}
> > > > > +
> > > > > +	if (zeros)
> > > > > +		memset(data, 0xff, page_size);
> > > > 
> > > > It seems like you're not considering the spare area at all. What if this
> > > > is a mostly-blank page, with ECC data, but most of the bitflips are in
> > > > the spare area? Then you will "correct" this page to all 0xFF, not
> > > > noticing that this was really not a blank page at all.
> > > 
> > > I could really use Angus' advice on this one.  Although, I fear he may
> > > have disappeared into the cosmos.  If I remember correctly (I'm
> > > getting rusty on this now), this controller doesn't allow access to
> > > the spare area easily.  I think it's all handled automatically
> > > i.e. without intervention.
> > 
> > That's tough. It's pretty hard to support NAND without *any* access to
> > spare area.
> 
> I think we _can_ do it, via the second (Flex) interface, but it appears
> to be readonly and we only do so when initially scanning/building the
> BBTs.

Does your driver pass the MTD tests? (drivers/mtd/tests/)

> I'm not sure I follow your example precisely.  When you say that most
> of the bitflips are in the spare area, do you mean that there's usable
> data in there?

What I mean is that because ALL [*] data (in- and out-of-band) is used
by the error correction algorithm, then you need to use all of that data
when determining that a page is erased, not just the data that you see
in-band.

Consider this: you program a page with all 0xFF data, except for a
single byte of data. Then suppose your page experiences too many
bitflips in the spare area. When you try to read this page back, you
will experience an ECC error, and fall back to "checking for an erased
page." But if this algorithm only looks at the in-band data, it may see
mostly-0xFF, with fewer than 8 bits that are low. Because it ignored all
of the ECC parity data stored OOB, then your algorithm might falsely
declare your page "erased," when in fact it held data and is instead
truly uncorrectable.

This kind of subtle error might lead to silent corruption.

I haven't exactly seen this in practice, since most MTD users will
be programming significant amounts of non-0xFF data to pages, but it's
really not a guarantee. And power cuts, for instance, provide a big
source of uncertainty, where you can't expect that an unsound algorithm
like this will work properly.

Note on [*]: some ECC algorithms may ignore parts of the spare area, in
order to provide ability to program special markers independently from
the rest of the spare area.

Brian
