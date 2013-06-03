Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908Ab3FCWXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:23:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34344 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758856Ab3FCWXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:23:34 -0400
Date: Mon, 3 Jun 2013 23:23:22 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] ARM: avoid mis-detecting some V7 cores in the
	decompressor
Message-ID: <20130603222321.GP18614@n2100.arm.linux.org.uk>
References: <1368049671-22879-1-git-send-email-sboyd@codeaurora.org> <5193E424.9090605@codeaurora.org> <519E57D2.3050000@codeaurora.org> <20130523231531.GT18614@n2100.arm.linux.org.uk> <20130524220539.GB599@codeaurora.org> <51AD0703.6050408@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AD0703.6050408@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 02:13:39PM -0700, Stephen Boyd wrote:
> Resending due to rmk's vacation.
> 
> On 05/24/13 15:05, Stephen Boyd wrote:
> > I've noticed another problem now that our caches are used. On MSM
> > we have TEXT_OFFSET set to at least 0x208000 if we've built-in
> > support for MSM8x60/8960. If I boot a kernel with the MSM code
> > built-in that requires the higher text offset, but I load my
> > compressed kernel below that address (such as 0x0) the
> > decompression fails.
> >
> > This happens because the page tables are written into the
> > compressed data region before we relocate ourself to a higher
> > location.

We've always required kernel images to be loaded above RAM+32K for
exactly this issue.

> > This is bad because we just wrote our page tables into the
> > compressed data. Nobody notices though and we finish relocating
> > ourselves and then we call decompress_kernel() which fails
> > randomly. (BTW, why does error() sit in a while loop forever?

It loops forever because there is _nothing_ else to be done.  It's
already printed a message explaining why stuff has failed:

void error(char *x)
{
        arch_error(x);

        putstr("\n\n");
        putstr(x);
        putstr("\n\n -- System halted");

        while(1);       /* Halt */
}

and the while loop is to prevent us trying to do something stupid
after failure.  Basically, error() never returns.

I've no idea why you say the following:

> > We
> > can't get any information about why the decompression failed if
> > we have debug_ll enabled. I had to patch the error() routine to
> > not while loop forever to get that print after do_decompress to
> > be useful.)

Maybe your implementation of puts() for the decompressor is faulty then?
Because it works for me - when something goes wrong with the decompression,
I get a message such as:

Decompressing kernel...

CRC error

 -- System halted

> > I see a few solutions.
> >
> >  1) Relocate with caches off and then turn on caches after we're
> >     running in a location where we won't overwrite ourselves.
> >
> >  2) Have temporary page tables for the relocation phase that live
> >     just below the location we're going to relocate to.
> >
> >  3) Force bootloaders loading these types of images to load the
> >     zImage at least as high as the TEXT_OFFSET is compiled to.
> >
> > I don't think we can convince everyone that #3 is ok to do. I'm
> > leaning towards #2 since we get all the benefits of the cache
> > during the relocation phase but #1 is the obviously simple fix.

(3) is what we've always required in the past.  We already have code
to relocate the compressed image, so we _might_ be able to do (1).

The easy solution is to continue saying "minimum of RAM start + 32K"
as we've always had in the past though.
