Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab3CLQju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 12:39:50 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:59137 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab3CLQjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 12:39:48 -0400
X-Greylist: delayed 72868 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Mar 2013 12:39:48 EDT
X-Originating-IP: 50.43.39.152
Date: Tue, 12 Mar 2013 09:39:42 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Konrad Vrba <konrad.vrba@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: very strange dependencies on CONFIG_EXPERT=n in kernel 3.8
Message-ID: <20130312163941.GA3991@leaf>
References: <CAF2Nc0zT5t_YeqzJWprUH7ma3_3LCWVXgbxLBODU7drgauDt=Q@mail.gmail.com>
 <20130311184916.GA6185@jtriplet-mobl1>
 <CAF2Nc0zSaXMkm-gkO9NqcAOubqSrZcBGeBeENo-jVZ+mo00ocQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF2Nc0zSaXMkm-gkO9NqcAOubqSrZcBGeBeENo-jVZ+mo00ocQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Please don't top-post.]

On Tue, Mar 12, 2013 at 03:52:24PM +0100, Konrad Vrba wrote:
> On 3/11/13, Josh Triplett <josh@joshtriplett.org> wrote:
> > On Sun, Mar 10, 2013 at 04:14:27PM +0100, Konrad Vrba wrote:
> >> I have noticed that CONFIG_EXPERT=n makes the following options in the
> >> kernel required (unremovable):
> >>
> >> CONFIG_FW_LOADER=y
> >> CONFIG_EXTRA_FIRMWARE=""
> >> CONFIG_MOUSE_PS2_ALPS=y
> >> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> >> CONFIG_MOUSE_PS2_SYNAPTICS=y
> >> CONFIG_MOUSE_PS2_LIFEBOOK=y
> >> CONFIG_MOUSE_PS2_TRACKPOINT=y
> >> CONFIG_VGA_ARB=y
> >> CONFIG_VGA_ARB_MAX_GPUS=16
> >> CONFIG_I8253_LOCK=y
> >> CONFIG_DEBUG_MEMORY_INIT=y
> >> CONFIG_PCSPKR_PLATFORM=y
> >>
> >> If I select CONFIG_EXPERT=y then I can remove those, but that creates
> >> a new problem by making CONFIG_DEBUG_KERNEL=y unremovable.
> >>
> >> To make a specific example, this makes it impossible to compile a kernel
> >> with
> >> CONFIG_FW_LOADER=n
> >> CONFIG_DEBUG_KERNEL=n
> >> at the same time
> >
> > CONFIG_DEBUG_KERNEL, like CONFIG_EXPERT, should not directly affect the
> > code included in the kernel; it should just avoid asking about a pile of
> > other debugging options.  In practice, a small amount of
> > architecture-specific code (for powerpc, parisc, and blackfin) did use
> > it as a generic debug option, but that needs fixing.  So, for now, turn
> > on CONFIG_EXPERT and live with having CONFIG_DEBUG_KERNEL turned on.
> >
> > That aside, several of the above options should not depend on EXPERT;
> > why would PCSPKR_PLATFORM or DEBUG_MEMORY_INIT need to depend on EXPERT?
> >
> > - Josh Triplett
> >
> Thanks Josh,
> unfortunately, I cannot live with CONFIG_DEBUG_KERNEL. I need a
> minimalistic kernel, and every unnecessary KB is expensive. Besides, I
> have ideological objections to having unneeded features compiled in my
> kernel.

What architecture will your kernel target?  If not powerpc, parisc, or
blackfin, CONFIG_DEBUG_KERNEL will not add a single byte to your kernel,
as long as you turn off all the other debugging options under it.

> Is there any way of editing it directly in the .config file manually?

No, you can't make the .config file violate the dependencies specified
in Kconfig.  However, you *could* write and submit a patch fixing the
underlying bug: add one or more new Kconfig symbols under
CONFIG_DEBUG_KERNEL, and change all the instances of CONFIG_DEBUG_KERNEL
in a .c, .h, or .S file to one of those.

> Nobody asked for my opinion, but I feel I have to say something:
> The linux kernel project is already a complicated endeavor as it is.
> Why does somebody complicate it needlessly, by creating these
> artificial problems.

CONFIG_EXPERT and CONFIG_DEBUG_KERNEL actually exist for the opposite
reason: to simplify kernel configuration for most people.  With
CONFIG_EXPERT=n, you don't get asked about a pile of kernel options that
almost everyone will want and that can unexpectedly break your kernel
when turned off.  Likewise, CONFIG_DEBUG_KERNEL=n lets you avoid
configuring a pile of individual debugging options.  (That matters more
if you use "make config" and have to answer questions one by one in
series, rather than "make menuconfig" where you can just ignore whole
sections of configuration that you don't care about.)

CONFIG_EXPERT=y means "I know what I'm doing and want to configure out
features that almost every kernel needs", and you usually only turn it
on when trying to make the smallest possible kernel.  In turn,
CONFIG_EXPERT enables CONFIG_DEBUG_KERNEL so that you can see and turn
*off* some of the debugging options that default to y, to make an even
smaller kernel.  So, in practice, if you want to make the smallest
possible kernel, you want CONFIG_EXPERT=y and CONFIG_DEBUG_KERNEL=y.
That CONFIG_DEBUG_KERNEL controls a bit of miscellaneous debugging on a
few architectures represents a bug, nothing more.

- Josh Triplett
