Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab3HWSVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:21:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:51758 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab3HWSVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:21:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,943,1367996400"; 
   d="scan'208";a="350783229"
Date: Fri, 23 Aug 2013 21:21:17 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH] i915: Update VGA arbiter support for newer
 devices
Message-ID: <20130823182117.GA11428@intel.com>
References: <20130815223917.27890.28003.stgit@bling.home>
 <CAPM=9twr6Ho7PCFdL9GubzDNPedO9tBvC1YPofpkJ01Avx=8_g@mail.gmail.com>
 <1376607255.13642.155.camel@ul30vt.home>
 <20130816102017.GK7159@intel.com>
 <1376677334.28796.8.camel@ul30vt.home>
 <20130820194645.GZ7159@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130820194645.GZ7159@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 10:46:45PM +0300, Ville Syrjälä wrote:
> On Fri, Aug 16, 2013 at 12:22:14PM -0600, Alex Williamson wrote:
> > On Fri, 2013-08-16 at 13:20 +0300, Ville Syrjälä wrote:
> > > On Thu, Aug 15, 2013 at 04:54:15PM -0600, Alex Williamson wrote:
> > > > On Fri, 2013-08-16 at 08:49 +1000, Dave Airlie wrote:
> > > > > On Fri, Aug 16, 2013 at 8:43 AM, Alex Williamson
> > > > > <alex.williamson@redhat.com> wrote:
> > > > > > This is intended to add VGA arbiter support for Intel HD graphics on
> > > > > > Core processors.  The old GMCH registers no longer exist, so even
> > > > > > though it appears that i915 participates in VGA arbitration, it doesn't
> > > > > > work.  On Intel HD graphics we already attempt to disable VGA regions
> > > > > > of the device.  This makes registering as a VGA client unnecessary since
> > > > > > we don't intend to operate differently depending on how many VGA devices
> > > > > > are present.  We can disable VGA memory regions by clearing a memory
> > > > > > enable bit in the VGA MSR.  That only leaves VGA IO, which we update
> > > > > > the VGA arbiter to know that we don't participate in VGA memory
> > > > > > arbitration.  We also add a hook on unload to re-enable memory and
> > > > > > reinstate VGA memory arbitration.
> > > > > 
> > > > > I would think there is still a VGA disable bit on the Intel device
> > > > > somewhere, we'd just need
> > > > > Intel to look in the docs and find it. A bit that can nuke both i/o
> > > > > and cmd regs.
> > > > 
> > > > The only bit available is in the GGC and is a keyed/locked register that
> > > > not only disables VGA memory and I/O, but also modifies the class code
> > > > of the device.  Early Core processors didn't lock this, but it's
> > > > untouchable in newer ones AFAICT.  Thanks,
> > > 
> > > I've not found anything else in the docs. And also we _need_ VGA I/O
> > > access to make i915_disable_vga() work. It's not 100% clear whether
> > > we really need to poke at the sequencer register in modern hardware,
> > > but the docs do still list it as a mandatory step. So even if we were
> > > to have a global "disable VGA I/O and mem bit" we'd need to make sure
> > > we already disabled VGA eg. after resume when the BIOS had a chance to
> > > turn the VGA display back on. I think there were also some BIOSen that
> > > turned VGA display back on when closing/opening the laptop lid. Not
> > > sure what would even happen with those if totally disabled VGA I/O
> > > access. I'm not sure they actually frob with the VGA regs though.
> > > Could be they just turn on the VGA display bit in the VGA_CONTROL
> > > register.
> > 
> > Hmm, it appears the MSR write isn't fully disabling VGA memory space.
> > When the VBIOS for the PEG graphics is run in the guest, I get some
> > corruption of the IGD frame buffer.  If I manually disable PCI memory in
> > the command register, this doesn't happen.  I also get some strange
> > artifacts on the PEG display that don't happen when PCI memory is
> > disabled.  Should that MSR bit give us the whole a_0000-b_ffff range?
> 
> Perhaps. It does that on some old graphics cards I've played with, but
> frankly I have no idea what it does on our hardware.
> 
> I'm trying to find out though. If and when I get an answer I'll let you
> know.

So the answer I basically got is that MSR is the only option here when
the GMCH register can't be used. Supposedly it should work too, but
I felt that I didn't get a 100% definite answer on that subject.

I tried it a bit on an IVB machine and PCI and PCIe Matrox G550 cards,
and for me it does seem to work. In the G550 PCIe case there's an extra
PCIe-PCI bridge on the card, and and in the G550 PCI case there's a
PCI-PCI bridge on the card and a PCIe-PCI bridge on the motherboard.
I don't have any native PCIe graphics cards on me to test the no
extra bridges case.

Based on a bit of manual register/memory banging it looks like the IGD
will decode the access when MSR[1]=1, and won't when MSR[1]=0. Same was
true for PCI_COMMAND[0] in case of VGA I/O. If those bits are disabled
for IGD, the accesses get to the external card. If neither claims it,
I just get 0xff back and writes are ignored.

Curiously I didn't see any problems when I configured both graphics
devices and bridges to decode/forward VGA resources. The IGD was
always the one to answer and the data didn't seem corrupted. Not sure
why that is. Maybe I just got lucky or something.

My tests weren't very thorough however, so I may have missed something.

-- 
Ville Syrjälä
Intel OTC
