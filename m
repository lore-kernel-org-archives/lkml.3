Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab3B0K2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 05:28:48 -0500
Received: from linux-sh.org ([111.68.239.195]:45511 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab3B0K2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 05:28:47 -0500
Date: Wed, 27 Feb 2013 19:28:30 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        benh@kernel.crashing.org, grant.likely@secretlab.ca,
        horms@verge.net.au, tglx@linutronix.de
Subject: Re: [PATCH] irqchip: Renesas INTC External IRQ pin driver
Message-ID: <20130227102829.GA17968@linux-sh.org>
References: <20130218142834.28739.39417.sendpatchset@w520>
 <20130227082335.GB30395@linux-sh.org>
 <CANqRtoSbiPhRbDsZppkJ+F48tEmuCdSfVRo3dTs9cEUxfvLopA@mail.gmail.com>
 <20130227085216.GC30395@linux-sh.org>
 <CANqRtoTFgHDKpb52HCRD=11ds_zKgLammcnymF719L9u4v3fvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANqRtoTFgHDKpb52HCRD=11ds_zKgLammcnymF719L9u4v3fvg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 06:52:51PM +0900, Magnus Damm wrote:
> As you know, the INTC code that you are referring to is a full
> interrupt controller designed to work directly with CPU cores like SH
> and ARM. Newer ARM cores like Cortex-A9 all include the GIC both for
> IPI purpose in case of SMP and they also implement SPI functionality
> for I/O device interrupts. So the need for vendor-specific interrupt
> controller IP is almost down to nothing these days.
> 
Yes, I'm aware of that.

> With that in mind I do really doubt that we end up reimplementing
> sh_intc. The upcoming designs that I am aware of do not change their
> external IRQ pin hardware to force us to update this driver. What
> happens after that I'm afraid I can't say. =)
> 
While I don't expect you would end up with a full reimplmentation, my
concern is more that it would just be reproducing stuff that's already in
place. IOW, perhaps it's less work to put sh_intc on a diet, and tie the
core functionality that you need for external IRQ pins in to an irqchip
there -- with the core of the old code adapted in to some sort of common
base library, rather than coming up with a new lightweight irqchip driver
and having to incrementally pile stuff on top of it later.

> I mainly wrote this driver to support the r8a7779 SoC which can't be
> driven by the existing INTC code base. During development I decided to
> try to share the driver between multiple GIC-based SoCs like r8a7779
> and sh73a0. The reason behind trying to share this driver between
> multiple SoCs is to remove SoC-specific hacks that can't be dealt with
> by the existing INTC code.
> 
Ok, fair enough.

> I don't really understand why you would want to use a generic table
> driven driver when you have the possibility of using a
> hardware-specific driver.

For the same reason sh_intc was written in the first place, every CPU
subtype more or less had a similar set of interrupt controllers with
minor deviations. Those deviations were sufficient enough to make the
code pretty hairy in places, and what we have now is really more of a
subsystem than an irqchip driver.

Having to reproduce 90% of the code when you're adding new CPUs at the
rate of 2 a month hardly makes an SoC-specific driver realistic,
especially as you just end up with identical features being broken in
subtly differnt ways on different SoCs. That being said, a lot of that is
legacy stuff and a result of no CPU team talking to any other CPU team
ever, and it seems like things have improved enough in that regard that
perhaps a hardware-specific driver won't be a complete throw-away
disaster like it was before. It's a risk either way, I just hope your
lightweight solution remains lightweight and consistent long enough that
we don't have multiple copies of slightly different drivers doing exactly
same thing spiralling out of control and turning in to a maintenance
nightmare.

If sh_intc doesn't deal with the needs of the new GIC-backed SoCs then
that's of course something that has to be addressed regardless (whether
that be hacking up sh_intc or adding new hardware-specific irqchips).

> I suppose you are wondering why no one seems to be working on INTC DT
> support at this point. The truth is that we got very little feedback
> and development support with interrupts in general last autumn and on
> top of that our developers went their own way instead of following
> advice.
> 
I assumed it was either being rewritten or had already been merged, so I
was simply surprised to hear otherwise. I will dig through the archives a
bit later and see about getting caught up.
