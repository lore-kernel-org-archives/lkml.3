Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbaIVWAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 18:00:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148AbaIVWAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 18:00:03 -0400
Message-ID: <1411422892.1199.173.camel@ul30vt.home>
Subject: Re: Stupid NVIDIA 3D vgaarb.c patch
From: Alex Williamson <alex.williamson@redhat.com>
To: C =?ISO-8859-1?Q?Bergstr=F6m?= <cbergstrom@pathscale.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Airlie <airlied@linux.ie>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 22 Sep 2014 15:54:52 -0600
In-Reply-To: <CAOnawYp4QLq+k9__BKcAapHQyShYa93B9S7rbt30Jv3z+Dm9XA@mail.gmail.com>
References: <CAOnawYp7kv7Zjn4j-j4-TUOshE9G1uXWEqXB_=RHePNwNLmwWA@mail.gmail.com>
	 <CA+55aFwX_nV9oUjh6u5WY=jpLxN-a5GFLmXQWDbHW0Yom9OOVA@mail.gmail.com>
	 <1411420555.1199.151.camel@ul30vt.home>
	 <CAOnawYp4QLq+k9__BKcAapHQyShYa93B9S7rbt30Jv3z+Dm9XA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-23 at 04:20 +0700, C Bergström wrote:
> For clarity - My testing and the patch is required when the Intel driver
> isn't being used at all. After I finish some other testing I can see if
> bumblebee and intel driver + this patch will play nicely.
> 
> How is a laptop with dual VGA controllers any different than if one
> identifies itself as a "3D controller"?

With dual VGA controllers, we can change VGA routing in the chipset so
that we can address one device or the other using the VGA address space.
This lets things like Xorg switch between cards to initialize a card via
the VGA BIOS or execute runtime VGA BIOS calls.  If one of those devices
reports itself as a 3D controller, then we have no reason to believe
that the device actually responds to VGA accesses or that the PCI ROM
payload includes a VGA BIOS.

Maybe that's how the arbiter device registration should work, if the
class code is VGA add it, if it's 3D controller, switch VGA routing and
see if it responds to VGA.  There are still a couple problems that I've
been beating my head against though.  First, i915 lies when it opts-out
of VGA arbitration, so you might think you've found a VGA device
elsewhere, but you're actually still talking to IGD.  Second is the Xorg
DRI problem where it's going to disable DRI support if suddenly a second
arbitration participant appears.  This is what happened when I tried to
fix the i915 problem and suddenly anybody with IGD + plugin graphics
lost DRI and the fix was reverted.  The whole thing is pretty broken.

In this case, if your laptop actually supports disabling and hiding the
IGD device, I'd expect the Nvidia device to switch to reporting itself
as VGA.  It seems like often the Optimus graphics aren't even directly
connected to an output device, which makes me curious that you can
actually pick one or the other.  Thanks,

Alex

> On Tue, Sep 23, 2014 at 4:15 AM, Alex Williamson <alex.williamson@redhat.com
> > wrote:
> 
> > On Mon, 2014-09-22 at 13:43 -0700, Linus Torvalds wrote:
> > > Adding proper people and mailing lists..
> > >
> > > The PCI_CLASS_DISPLAY_VGA test goes back to the very beginning by
> > > BenH, and I have no idea if adding PCI_CLASS_DISPLAY_3D is
> > > appropriate, but hopefully somebody does. The fact that it makes
> > > things work certainly argues fairly convincingly for it, but I want
> > > some backup here.
> > >
> > > Dave, BenH?
> >
> > TBH, it seems pretty dubious to me.  There's nothing in the spec that
> > would give us reason to believe that a device with a 3D controller class
> > code requires VGA arbitration.  Also, if this controller starts
> > participating in arbitration then this same laptop will likely disable
> > DRI when Intel is the primary graphics due to Xorg wanting to mmap VGA
> > MMIO space.  I'm not sure what the solution is, but unfortunately it's
> > likely to be much more complicated than this patch.  Thanks,
> >
> > Alex
> >
> > > Christopher(?), can you please also specify which laptop etc. And the
> > > patch itself seems to have come from somebody else, unless you're
> > > Lekensteyn. So we'd want to get the provenance of that too.
> > >
> > >                 Linus
> > >
> > > On Mon, Sep 22, 2014 at 1:28 PM, C Bergström <cbergstrom@pathscale.com>
> > wrote:
> > > > Hi Linus,
> > > >
> > > > I don't know who the original author is and I can have one of the
> > distro
> > > > graphics friends review it, but I need this patch below to get NVIDIA
> > > > drivers to work (without using any Intel graphics) on my laptop
> > > > http://pastebin.com/wpmFi38k
> > > >
> > > > Sorry - I know this is not the proper way to submit a patch, but it's
> > > > trivial and I'm not a kernel dev.
> > > >
> > > > Thanks
> > > >
> > > > ./C
> >
> >
> >
> >



