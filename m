Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350Ab3GZPvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:51:49 -0400
Received: from oproxy14-pub.unifiedlayer.com ([67.222.51.224]:53910 "HELO
	oproxy14-pub.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756785Ab3GZPvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:51:47 -0400
Date: Fri, 26 Jul 2013 08:51:58 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Ugly patches for stolen reservation
Message-ID: <20130726085158.56724801@jbarnes-desktop>
In-Reply-To: <CA+55aFyDXkvc7mK2trfHA2Wj9vRu2FkCeZuZVfRvmbak1TqUmA@mail.gmail.com>
References: <1374770269-3223-1-git-send-email-jbarnes@virtuousgeek.org>
	<20130725200551.GA16719@gmail.com>
	<5304d042-6f8f-4754-9d19-df62662d19f4@email.android.com>
	<CA+55aFyDXkvc7mK2trfHA2Wj9vRu2FkCeZuZVfRvmbak1TqUmA@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jul 2013 17:31:29 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Jul 25, 2013 at 3:42 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > So the bootloader is just as likely to step on things... what happens when/if it does?
> 
> This isn't a new problem. We've had this "firmware tables don't show
> all devices" issue before.
> 
> The only odd thing about this one is how the quirk in question uses
> "e820_add_region()" instead of just adding things to the MMIO list.
> And I think that's actually likely a mistake.
> 
> So Jesse, why don't you do what the other quirks do, and claim an
> actual MMIO resource? If you make it a real resource, you'll get to
> use fancy things like REAL NAMES, and actually document it. With
> human-readable strings.
> 
> See quirk_io_region() in drivers/pci/quirks.c for example. The same
> code except for IORESOURCE_MEM should do a lovely job..
> 
> And even *if* it's already marked reserved in the e820 table, it just
> looks nice in /proc/iomem.
> 
> Hmm?

I should have mentioned yesterday that we *do* try to reserve the
resource in our driver init, with pretty name and everything.

The issue here is making sure we are actually *able* to reserve it
without conflicts at driver init time.

If the PCI layer has put something there (misc MMIO or the "RAM
buffer" intended to prevent stuff like this) because it's not listed in
the E820 map, we'll fail to get at this memory in our driver init.

Thus the early reservation in early-quirks, followed by a real
request_mem_region later on.

Doing the request_mem_region before the PCI layer gets its hands on it
isn't really possible, because __request_region depends on the memory
allocator being initialized.  So rather than add a new hook elsewhere in
setup_arch or start_kernel I figured I'd use an early quirk.

Reasonable?  Note iomem in both cases.

Before (RAM buffer prevents our allocation):
cafff000-caffffff : System RAM
cb000000-cbffffff : RAM buffer
cfa00000-feafffff : PCI Bus 0000:00
  d0000000-dfffffff : 0000:00:02.0

After (yay):
cb000000-cb9fffff : RAM buffer
cba00000-cf9fffff : reserved
  cba00000-cf9fffff : Graphics Stolen Memory
cfa00000-feafffff : PCI Bus 0000:00

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
