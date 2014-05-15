Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbaEOVnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:43:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbaEOVnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:43:18 -0400
Message-ID: <1400190194.3289.143.camel@ul30vt.home>
Subject: Re: [PATCH] i915: Add module option to support VGA arbiter on HD
 devices
From: Alex Williamson <alex.williamson@redhat.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org,
        Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        Dave Airlie <airlied@redhat.com>
Date: Thu, 15 May 2014 15:43:14 -0600
In-Reply-To: <20140512193825.GI25056@phenom.ffwll.local>
References: <20140509201655.2849.97478.stgit@bling.home>
	 <20140512190812.GH25056@phenom.ffwll.local>
	 <1399923039.6734.97.camel@bling.home>
	 <20140512193825.GI25056@phenom.ffwll.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-12 at 21:38 +0200, Daniel Vetter wrote:
> On Mon, May 12, 2014 at 01:30:39PM -0600, Alex Williamson wrote:
> > On Mon, 2014-05-12 at 21:08 +0200, Daniel Vetter wrote:
> > > On Fri, May 09, 2014 at 02:20:41PM -0600, Alex Williamson wrote:
> > > > Commit 81b5c7bc found that the current VGA arbiter support in i915
> > > > only works for ancient GMCH-based IGD devices and attempted to update
> > > > support for newer HD devices.  Unfortunately newer devices cannot
> > > > completely opt-out of VGA arbitration like the old devices could.
> > > > The VGA I/O space cannot be disabled internally.  The only way to
> > > > route VGA I/O elsewhere is by disabling I/O at the device PCI command
> > > > register.  This means that with commit 81b5c7bc and multiple VGA
> > > > adapters, the VGA arbiter will report that multiple VGA devices are
> > > > participating in arbitration, Xorg will notice this and disable DRI.
> > > > Therefore, 81b5c7bc was reverted because DRI is more important than
> > > > being correct.
> > > > 
> > > > There is however an actual need for i915 to correctly participate in
> > > > VGA arbitration; VGA device assignment.  If we want to use VFIO to
> > > > assign a VGA device to a virtual machine, we need to be able to
> > > > access the VGA resources of that device.  By adding an i915 module
> > > > option we can allow i915 to continue with its charade by default, but
> > > > also allow an easy path for users who require working VGA arbitration.
> > > > Hopefully Xorg can someday be taught to behave better with multiple
> > > > VGA devices.
> > > > 
> > > > This also rolls in reverted commit 6e1b4fda, which corrected an
> > > > ordering issue with 81b5c7bc by delaying the disabling of VGA memory
> > > > until after vgacon->fbcon handoff.
> > > > 
> > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > > Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > > > Cc: Dave Airlie <airlied@redhat.com>
> > > > ---
> > > > 
> > > > This should be a nop with the default module setting, so if there's
> > > > any opportunity to get this into v3.15, it would be appreciated.
> > > 
> > > I really don't like module options to work around bugs elsewhere. It means
> > > the 5 users who know about a given bug are now happen, and the 3
> > > bazillion without enough clue/savy/time still suffer from problems.
> > > 
> > > My goal is to actually add a bit of support to the core kernel's module
> > > option parsing code so that most of the options we have can spit warnings
> > > into dmesg and taint the kernel.
> > > 
> > > Can't we fix this in any other way?
> > 
> > Do you have any suggestions?  I proposed creating a new VGA arbiter
> > interface that would allow Xorg to mmap the legacy VGA MMIO space
> > regardless of the number of VGA arbitration participants, but didn't get
> > any nibbles on supporting that through the rest of the stack.  Dave
> > suggested maybe he could rip out the VGA arbiter support from Xorg and
> > nobody would notice.  In either case, at what point do we get to flip
> > i915 to behave correctly with arbitration?  It seems like anything we do
> > has a compatibility period where we must leave i915 in it's current
> > broken state, which means that anyone wanting VGA arbitration needs to
> > patch their kernel.  In the best case, that compatibility window could
> > extend for years.  Since we don't seem to be making progress on any of
> > the other fronts, it seemed time to propose a module switch.  It's not a
> > good solution, but it's better than leaving it broken.  Thanks,
> 
> Ripping out the vga arbiter stuff from X (or at least disabling it if
> there's only kms drivers) seems like a good start - we want that in any
> case I think.
> 
> Then we could also look into disabling the userspace interface on the
> kernel side if we have modeset drivers for everything, and X is the
> requesting process. I.e. lie to Xorg. Ugly, but might work.
> 
> Then once we've fixed userspace to no longer be stupid and have some way
> to work around old stupid userspace, we can fix i915.

I don't know what to do with this.  It seems like a lot of wishful
thinking that in the best case would drag on for years.  Even if we get
VGA arbitration out of Xorg, the bit about making the userspace VGA
arbiter interface lie depending on current->comm sounds tricky and
horrible.  If we can lie to Xorg there, why don't we do that now?  If we
can't lie to Xorg now, then what deprecation event or detection of the
caller is going to allow us to do so in the future?

Meanwhile anyone that wants i915 to participate in arbitration like it
should have from the start needs to patch their kernel with forward
ports of the reverted commits.

I just don't see this moving forward, which is why I thought a module
option at least gives us a workaround.  Thanks,

Alex

