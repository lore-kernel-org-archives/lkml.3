Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbaEPOiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:38:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbaEPOiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:38:17 -0400
Message-ID: <1400251093.3289.193.camel@ul30vt.home>
Subject: Re: [PATCH] i915: Add module option to support VGA arbiter on HD
 devices
From: Alex Williamson <alex.williamson@redhat.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        Dave Airlie <airlied@redhat.com>
Date: Fri, 16 May 2014 08:38:13 -0600
In-Reply-To: <20140516090649.GD8790@phenom.ffwll.local>
References: <20140509201655.2849.97478.stgit@bling.home>
	 <20140512190812.GH25056@phenom.ffwll.local>
	 <1399923039.6734.97.camel@bling.home>
	 <20140512193825.GI25056@phenom.ffwll.local>
	 <1400190194.3289.143.camel@ul30vt.home>
	 <CAKMK7uGRCQSUNjBiegkYncUiYmFfoLAqxj6UPYJNeOf2S2x-7w@mail.gmail.com>
	 <1400215610.3289.174.camel@ul30vt.home>
	 <20140516090649.GD8790@phenom.ffwll.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-16 at 11:06 +0200, Daniel Vetter wrote:
> On Thu, May 15, 2014 at 10:46:50PM -0600, Alex Williamson wrote:
> > On Fri, 2014-05-16 at 00:50 +0200, Daniel Vetter wrote:
> > > On Thu, May 15, 2014 at 11:43 PM, Alex Williamson
> > > <alex.williamson@redhat.com> wrote:
> > > > I don't know what to do with this.  It seems like a lot of wishful
> > > > thinking that in the best case would drag on for years.  Even if we get
> > > > VGA arbitration out of Xorg, the bit about making the userspace VGA
> > > > arbiter interface lie depending on current->comm sounds tricky and
> > > > horrible.  If we can lie to Xorg there, why don't we do that now?  If we
> > > > can't lie to Xorg now, then what deprecation event or detection of the
> > > > caller is going to allow us to do so in the future?
> > > 
> > > Well we wouldn't necessarily need to lie to X, but could instead look
> > > whether all the vga devices in a system are claimed by kms drivers. If
> > > that's the case the userspace doesn't have an awful lot of business
> > > touching the VGA registers and we could simply not obey a vga arb
> > > request from userspace.
> > > 
> > > More advanced would be if we still obey it for those devices not
> > > claimed by kms drivers. So not really a need to key on current->comm.
> > 
> > This is a requirement for me, I don't really care about KMS or Xorg, the
> > use case I want to enable is binding a VGA device to vfio-pci so that it
> > can be assigned to a guest virtual machine.  This works on an unmodified
> > kernel today so long as you don't have an Intel IGD in your system.  If
> > you do, we try to switch the VGA device, but it doesn't actually get
> > switched because i915 opts-out of arbitration yet still claims VGA
> > accesses.
> 
> I get that its a requirement for you.
> 
> I've also just detailed the solution for you above, but I'm not going to
> write the patch itself (since I can't test it really).

I repeat it because it seems incompatible with any plan that involves
modes of operation where the VGA arbiter says one thing if all VGA
devices are bound to KMS drivers and another if they're not.  That means
Xorg would have a different feature set depending on the driver state of
devices we might be using for entirely different purposes.

Users want to be able to run X on the host i915 at the same time that
they have other VGA devices assigned to guests.

> We have two users of the vga-arb crap relevant here:
> - pci/pci-sysfs.c, used by X through libpciaccess
> - vfio/pci/vfio_pci_rdwr.c, for vfio-pci vga forwarding

Do we really know that we only have these two users?

> Make the former lie if all vga devices have kms drivers and the latter

There's that "if all vga devices" again.  Is the user expected to start
Xorg with all devices attached to KMS drivers, then unbind the extra VGA
devices to be used for other purposes?  What happens if the user wants
to restart X, do they get a different feature set?  Does the output of
the VGA arbiter change while X is running when the other devices are
unbound from their KMS driver?  (unbinding a graphics card from it's
driver isn't a foolproof operation btw, so the driver may be blacklisted
or avoided through other means)

> still work correctly. That will prevent X from going nasty if there are
> kms drivers, while still keeping vfio going.

But by lying to Xorg, I think we're saying that it's ok to go mmap VGA
MMIO space through /dev/mem and poke VGA I/O through inb/outb, it's not
going to change... then at the same time we provide this other interface
that allows it to change.  Are we just masking i915's bug by breaking
the entire interface?

> Then we re-re-revert the i915 to have proper vga-arb.
> 
> Afaics no need for hacks, module options, special casing or breaking old
> userspace. 

But there is special casing isn't there?  Aren't we only able to make
the assumption that it's ok to lie through the VGA arbiter userspace
interface if only KMS drivers are in use?

> And really, if there is a kms driver userspace has zero
> business touching the vga registers, so imo we don't lose an real
> functionality. You can always opt to not load kms drivers if you want
> userspace access.
> 
> What am I missing?

I must be the one missing something because this still all sounds
terribly convoluted and fragile.  Thanks,

Alex

