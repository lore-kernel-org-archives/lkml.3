Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab3HPSWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:22:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595Ab3HPSW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:22:29 -0400
Message-ID: <1376677334.28796.8.camel@ul30vt.home>
Subject: Re: [PATCH] i915: Update VGA arbiter support for newer devices
From: Alex Williamson <alex.williamson@redhat.com>
To: Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc: Dave Airlie <airlied@gmail.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 16 Aug 2013 12:22:14 -0600
In-Reply-To: <20130816102017.GK7159@intel.com>
References: <20130815223917.27890.28003.stgit@bling.home>
	 <CAPM=9twr6Ho7PCFdL9GubzDNPedO9tBvC1YPofpkJ01Avx=8_g@mail.gmail.com>
	 <1376607255.13642.155.camel@ul30vt.home> <20130816102017.GK7159@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-16 at 13:20 +0300, Ville Syrjälä wrote:
> On Thu, Aug 15, 2013 at 04:54:15PM -0600, Alex Williamson wrote:
> > On Fri, 2013-08-16 at 08:49 +1000, Dave Airlie wrote:
> > > On Fri, Aug 16, 2013 at 8:43 AM, Alex Williamson
> > > <alex.williamson@redhat.com> wrote:
> > > > This is intended to add VGA arbiter support for Intel HD graphics on
> > > > Core processors.  The old GMCH registers no longer exist, so even
> > > > though it appears that i915 participates in VGA arbitration, it doesn't
> > > > work.  On Intel HD graphics we already attempt to disable VGA regions
> > > > of the device.  This makes registering as a VGA client unnecessary since
> > > > we don't intend to operate differently depending on how many VGA devices
> > > > are present.  We can disable VGA memory regions by clearing a memory
> > > > enable bit in the VGA MSR.  That only leaves VGA IO, which we update
> > > > the VGA arbiter to know that we don't participate in VGA memory
> > > > arbitration.  We also add a hook on unload to re-enable memory and
> > > > reinstate VGA memory arbitration.
> > > 
> > > I would think there is still a VGA disable bit on the Intel device
> > > somewhere, we'd just need
> > > Intel to look in the docs and find it. A bit that can nuke both i/o
> > > and cmd regs.
> > 
> > The only bit available is in the GGC and is a keyed/locked register that
> > not only disables VGA memory and I/O, but also modifies the class code
> > of the device.  Early Core processors didn't lock this, but it's
> > untouchable in newer ones AFAICT.  Thanks,
> 
> I've not found anything else in the docs. And also we _need_ VGA I/O
> access to make i915_disable_vga() work. It's not 100% clear whether
> we really need to poke at the sequencer register in modern hardware,
> but the docs do still list it as a mandatory step. So even if we were
> to have a global "disable VGA I/O and mem bit" we'd need to make sure
> we already disabled VGA eg. after resume when the BIOS had a chance to
> turn the VGA display back on. I think there were also some BIOSen that
> turned VGA display back on when closing/opening the laptop lid. Not
> sure what would even happen with those if totally disabled VGA I/O
> access. I'm not sure they actually frob with the VGA regs though.
> Could be they just turn on the VGA display bit in the VGA_CONTROL
> register.

Hmm, it appears the MSR write isn't fully disabling VGA memory space.
When the VBIOS for the PEG graphics is run in the guest, I get some
corruption of the IGD frame buffer.  If I manually disable PCI memory in
the command register, this doesn't happen.  I also get some strange
artifacts on the PEG display that don't happen when PCI memory is
disabled.  Should that MSR bit give us the whole a_0000-b_ffff range?
Thanks,

Alex

