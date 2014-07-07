Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaGGXwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:52:30 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:43212 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaGGXw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:52:27 -0400
Date: Mon, 7 Jul 2014 16:52:22 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Lee Jones <lee.jones@linaro.org>, devicetree@vger.kernel.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>, kernel@stlinux.com,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        "Gupta, Pekon\"" <pekon@ti.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] mtd: nand: stm_nand_bch: add new driver
Message-ID: <20140707235222.GC7537@ld-irv-0074>
References: <1401268805-26043-1-git-send-email-lee.jones@linaro.org>
 <20140703002237.GM3599@ld-irv-0074>
 <20140703100522.756f9715@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140703100522.756f9715@bbrezillon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Thu, Jul 03, 2014 at 10:05:22AM +0200, Boris BREZILLON wrote:
> On Wed, 2 Jul 2014 17:22:37 -0700 Brian Norris <computersforpeace@gmail.com> wrote:
> > On Wed, May 28, 2014 at 10:20:05AM +0100, Lee Jones wrote:
> > > +
> > > +	nand_timing0: nand-timing {
> > > +		sig-setup	= <10>;
> > > +		sig-hold	= <10>;
> > > +		CE-deassert	= <0>;
> > > +		WE-to-RBn	= <100>;
> > > +		wr-on		= <10>;
> > > +		wr-off		= <30>;
> > > +		rd-on		= <10>;
> > > +		rd-off		= <30>;
> > > +		chip-delay	= <30>;		/* delay in us */
> > > +	};
> > 
> > You didn't document any of this node. And I don't think we want to
> > specify every single timing parameter in DT; it may make sense to use
> > Boris Brezillon's approach (I note this further down, in the driver
> > code) for mapping non-ONFI NAND timings into a compatible ONFI timing
> > mode. This will greatly simplify the bindings needed, since it's
> > standardized and auto-detectable in many cases.
> 
> 
> AFAIR, the NAND timing representation for non-ONFI chips question was
> left unanswered:
> 
> https://lkml.org/lkml/2014/5/20/581
> 
> I can definitely respin my NAND timings series, but I'd like to be sure
> this is how you want it done before doing so.

Can we start by supporting ONFI-only (or ONFI-only, plus entries in
nand_flash_ids[]), and have nand_base provide the translation so drivers
can retrieve the info? Then we can begin supporting new drivers like
Lee's, and worry about the DT question separately.

BTW, Lee: you're completely missing the definitions for
'struct nand_sdr_timings' in this patch, so it doesn't compile.

> Just as a reminder, you and Jason thought NAND timings for non-ONFI
> chips could be auto detected thanks to READID informations (by storing
> some sort of "NANDID <-> timings" association table).

Yes, thanks for the reminder. I knew there was more than one reason I
was wary of Lee's patch (first, that it was duplication of another patch
set; and second, than I'm not sure it belongs in DT at all).

I think we should attempt to solve this without any need for DT
bindings, as most other parameters are auto-detectable in some sense
(even if we have to store some NANDID <-> timings tables). I think going
forward, we can expect that new NAND will use a JEDEC or ONFI spec, and
that we shouldn't have to scale nand_flash_ids[] to include too many
flash chip timings.

Brian
