Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab3AWK5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:57:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53227 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab3AWK5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:57:50 -0500
Date: Wed, 23 Jan 2013 10:57:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: Add axi-clkgen driver
Message-ID: <20130123105744.GQ23505@n2100.arm.linux.org.uk>
References: <1357755120-32735-1-git-send-email-lars@metafoo.de> <20130122175552.24671.27893@quantum> <50FFB4D8.5060801@metafoo.de> <20130123102755.GP23505@n2100.arm.linux.org.uk> <50FFC02C.9000109@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FFC02C.9000109@metafoo.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 11:49:16AM +0100, Lars-Peter Clausen wrote:
> On 01/23/2013 11:27 AM, Russell King - ARM Linux wrote:
> > On Wed, Jan 23, 2013 at 11:00:56AM +0100, Lars-Peter Clausen wrote:
> >> I think I read somewhere at some point that ioread{8,16,32} is preferred
> >> over write{b,h,l} in new code.
> > 
> > But... there's *no* point using ioread*() if you don't only use the
> > ioremap() interface.
> > 
> > ioread*() is there to allow PC IO and PC MMIO accesses through one
> > accessor depending on the cookie.  ioremap() only ever returns cookies
> > for MMIO accesses.
> 
> So your point is, if you know that it is MMIO memory only ever use readl and
> friends?

My point is... if you're going to stick with using ioremap(), then don't
bother with the potential overhead from ioread*() - you don't gain
anything but you have a few extra CPU cycles per access.  You might as
well just stick with read*() which aren't going anywhere anytime soon.

Sure, if you need stuff to work on both IO and MMIO accesses, then use
ioread*() but you'd also need the driver to:
- accept IORESOURCE_IO resource types.
- request these resources in the IO resource tree rather than the MMIO
  resource tree.
- use ioport_map() to "map" these resource types.

So, I don't mind seeing ioread*() in a driver _if_ it also uses IO resources
and handles them correctly, but it's pointless to use this accessor in any
driver which doesn't.
