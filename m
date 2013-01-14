Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3ANA00 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 19:26:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45749 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab3ANA0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 19:26:25 -0500
Date: Mon, 14 Jan 2013 00:26:08 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Chanho Min <chanho.min@lge.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, chanho0207@gmail.com
Subject: Re: [PATCH] ARM: PL011: Add support for Rx DMA buffer polling
Message-ID: <20130114002608.GV23505@n2100.arm.linux.org.uk>
References: <50efad8d.84fc440a.589e.ffff9546SMTPIN_ADDED_BROKEN@mx.google.com> <CACRpkdYSaFsastx-WWC7sBu8NteAc2hCDZMz4-yMc8+=2dyBVw@mail.gmail.com> <50f107aa.894e420a.596a.ffffe3f6SMTPIN_ADDED_BROKEN@mx.google.com> <CACRpkdaJd48WOzP_iURATb=c+V6==2-AB2Y9oFyh=E3oe1eT0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaJd48WOzP_iURATb=c+V6==2-AB2Y9oFyh=E3oe1eT0Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 01:04:58AM +0100, Linus Walleij wrote:
> At some point we reasoned that we may actually be saved
> by the reverse phenomena - if single request is *NOT*
> connected, there will very often be some characters in the
> FIFO, and that's enough to trigger the RTIM IRQ, and we get
> a nice flow. So maybe the platforms that actually work, work
> because they have bursts only.
> 
> But that would pose a problem when an even burst of
> characters arrive. Say 16 characters, this will be transferred
> in two bursts and leave the FIFO empty, but no DMA TC
> IRQ since the buffer is not full, and we'd get your
> phenomena.
> 
> But I could never reproduce the latter theoretical problem,
> so I think the hardware actually has a fix for this, around
> the burst signal logic.
> 
> But it may very well be that the single request can not be
> enabled for the PL011 for it to work properly.

What you describe above is exactly the problem I see on the Versatile
platform with it's PL080 and PL011.  I made the comment that this setup
can't work properly as it stands.  And I don't think that setting a
timer which fires every jiffy count is really a solution to the problem.
That's an expensive way of having a per-jiffy callback for something
that's probably going to remain idle most of the time.

Not only that, but a 1 jiffy timeout even for slower baud rates is
just utterly silly.

The point of using DMA is to move the workload off the CPU onto hardware,
so that the CPU can go off and do other stuff.  If it's having to poll
it once every jiffy, then...

> You may not be able to turn this off, and in that case this
> kind of code is the only way forward indeed.

Unless there's something inbetween the PL080 and PL011 to do that.
The peripherals themselves don't have any means of controlling this.

The solution I came up with on Versatile was to just not enable
receive DMA - at all.
