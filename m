Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbaEPJG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:06:58 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:49856 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbaEPJGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:06:55 -0400
Date: Fri, 16 May 2014 11:06:49 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH] i915: Add module option to support VGA arbiter on HD
 devices
Message-ID: <20140516090649.GD8790@phenom.ffwll.local>
Mail-Followup-To: Alex Williamson <alex.williamson@redhat.com>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
	Dave Airlie <airlied@redhat.com>
References: <20140509201655.2849.97478.stgit@bling.home>
 <20140512190812.GH25056@phenom.ffwll.local>
 <1399923039.6734.97.camel@bling.home>
 <20140512193825.GI25056@phenom.ffwll.local>
 <1400190194.3289.143.camel@ul30vt.home>
 <CAKMK7uGRCQSUNjBiegkYncUiYmFfoLAqxj6UPYJNeOf2S2x-7w@mail.gmail.com>
 <1400215610.3289.174.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400215610.3289.174.camel@ul30vt.home>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 10:46:50PM -0600, Alex Williamson wrote:
> On Fri, 2014-05-16 at 00:50 +0200, Daniel Vetter wrote:
> > On Thu, May 15, 2014 at 11:43 PM, Alex Williamson
> > <alex.williamson@redhat.com> wrote:
> > > I don't know what to do with this.  It seems like a lot of wishful
> > > thinking that in the best case would drag on for years.  Even if we get
> > > VGA arbitration out of Xorg, the bit about making the userspace VGA
> > > arbiter interface lie depending on current->comm sounds tricky and
> > > horrible.  If we can lie to Xorg there, why don't we do that now?  If we
> > > can't lie to Xorg now, then what deprecation event or detection of the
> > > caller is going to allow us to do so in the future?
> > 
> > Well we wouldn't necessarily need to lie to X, but could instead look
> > whether all the vga devices in a system are claimed by kms drivers. If
> > that's the case the userspace doesn't have an awful lot of business
> > touching the VGA registers and we could simply not obey a vga arb
> > request from userspace.
> > 
> > More advanced would be if we still obey it for those devices not
> > claimed by kms drivers. So not really a need to key on current->comm.
> 
> This is a requirement for me, I don't really care about KMS or Xorg, the
> use case I want to enable is binding a VGA device to vfio-pci so that it
> can be assigned to a guest virtual machine.  This works on an unmodified
> kernel today so long as you don't have an Intel IGD in your system.  If
> you do, we try to switch the VGA device, but it doesn't actually get
> switched because i915 opts-out of arbitration yet still claims VGA
> accesses.

I get that its a requirement for you.

I've also just detailed the solution for you above, but I'm not going to
write the patch itself (since I can't test it really).

We have two users of the vga-arb crap relevant here:
- pci/pci-sysfs.c, used by X through libpciaccess
- vfio/pci/vfio_pci_rdwr.c, for vfio-pci vga forwarding

Make the former lie if all vga devices have kms drivers and the latter
still work correctly. That will prevent X from going nasty if there are
kms drivers, while still keeping vfio going.

Then we re-re-revert the i915 to have proper vga-arb.

Afaics no need for hacks, module options, special casing or breaking old
userspace. And really, if there is a kms driver userspace has zero
business touching the vga registers, so imo we don't lose an real
functionality. You can always opt to not load kms drivers if you want
userspace access.

What am I missing?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
