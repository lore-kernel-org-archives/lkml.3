Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002Ab3GZRw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 13:52:58 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:54767 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3GZRwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 13:52:55 -0400
Date: Fri, 26 Jul 2013 19:52:52 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Intel-gfx] Ugly patches for stolen reservation
Message-ID: <20130726175252.GG6084@phenom.ffwll.local>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>
References: <1374770269-3223-1-git-send-email-jbarnes@virtuousgeek.org>
 <20130725200551.GA16719@gmail.com>
 <5304d042-6f8f-4754-9d19-df62662d19f4@email.android.com>
 <CA+55aFyDXkvc7mK2trfHA2Wj9vRu2FkCeZuZVfRvmbak1TqUmA@mail.gmail.com>
 <51F1C76A.8020407@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F1C76A.8020407@zytor.com>
X-Operating-System: Linux phenom 3.11.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 05:48:42PM -0700, H. Peter Anvin wrote:
> On 07/25/2013 05:31 PM, Linus Torvalds wrote:
> > On Thu, Jul 25, 2013 at 3:42 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> >> So the bootloader is just as likely to step on things... what happens when/if it does?
> > 
> > This isn't a new problem. We've had this "firmware tables don't show
> > all devices" issue before.
> > 
> 
> Yes, I just want to know what happens.
> 
> > The only odd thing about this one is how the quirk in question uses
> > "e820_add_region()" instead of just adding things to the MMIO list.
> > And I think that's actually likely a mistake.
> > 
> > So Jesse, why don't you do what the other quirks do, and claim an
> > actual MMIO resource? If you make it a real resource, you'll get to
> > use fancy things like REAL NAMES, and actually document it. With
> > human-readable strings.
> > 
> > See quirk_io_region() in drivers/pci/quirks.c for example. The same
> > code except for IORESOURCE_MEM should do a lovely job..
> > 
> > And even *if* it's already marked reserved in the e820 table, it just
> > looks nice in /proc/iomem.
> 
> We should do both -- mark it reserved in early boot, and add it as an
> MMIO region later during boot.

We started to reserve this range in drm/i915 (and still do), that's why
we've noticed that something is amiss.
> 
> The problem here, if I'm reading this right, is that this memory region
> is marked as normal RAM in e820, which is much worse than just not
> marking it as reserved; we need to intercept this memory before we
> genuinely turn it into normal RAM.

I haven't seen a case where it's marked as ram, but many systems don't
mark it as reserved. Then the pci code can go around and put a bar into
the middle of that range. The other issue (benign but ugly) is that the
RAM buffer (used to protect stolen memory without knowing where exactly it
is because it's not properly reserved in the e820 map) sometimes ends up
in the graphics stolen range. With the new iomeme reserve code in drm/i915
we've stopped using stolen in such cases to avoid surprises, but that
kills  a few neat features.

Thus far we haven't tracked down any bugs to such overlaps yet, but otoh
we don't use stolen all that much yet. But we have plans to put it to real
use (and use the full range) and I'd like to get the reservation conflicts
sorted out before we do so.

> At the same time, we have no protection against the bootloader using
> this as memory or even placing the kernel there.  The BIOS needs to be
> fixed regardless of what workarounds we do in the kernel.

Like I've said we haven't seen it earmarked as ram anywhere yet, so I
don't think this is something we need to concern ousrselves with.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
