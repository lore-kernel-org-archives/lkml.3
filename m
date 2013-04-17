Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab3DQKn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 06:43:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab3DQKn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 06:43:57 -0400
Date: Wed, 17 Apr 2013 07:43:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>,
        Takashi Iwai <tiwai@suse.de>, LMML <linux-media@vger.kernel.org>
Subject: Re: Device driver memory 'mmap()' function helper cleanup
Message-ID: <20130417074300.33d05475@redhat.com>
In-Reply-To: <CA+55aFyK2EEPuBPrqu3AGRbW+8TdP=kLLz4opvynNRcrSWC2ww@mail.gmail.com>
References: <CA+55aFyK2EEPuBPrqu3AGRbW+8TdP=kLLz4opvynNRcrSWC2ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 16 Apr 2013 20:12:32 -0700
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> Guys, I just pushed out a new helper function intended for cleaning up
> various device driver mmap functions, because they are rather messy,
> and at least part of the problem was the bad impedance between what a
> driver author would want to have, and the VM interfaces to map a
> memory range into user space with mmap.
> 
> Some drivers would end up doing extensive checks on the length of the
> mappings and the page offset within the mapping, while other drivers
> would end up doing no checks at all.
> 
> The new helper is in commit b4cbb197c7e7 ("vm: add vm_iomap_memory()
> helper function"), but I didn't actually commit any *users* of it,
> because I just have this untested patch-collection for a few random
> drivers (picked across a few different driver subsystems, just to make
> it interesting).  I did that largely just to check the different use
> cases, but I don't actually tend to *use* all that many fancy drivers,
> so I don't have much of a way of testing it.
> 
> The media layer has a few users of [io_]remap_pfn_range() that look
> like they could do with some tender loving too, but they don't match
> this particular pattern of "allow users to map a part of a fixed range
> of memory". In fact, the media pattern seems to be single-page
> mappings, which probably should use "vm_insert_page()" instead, but
> that's a whole separate thing. But I didn't check all the media cases
> (and there's a lot of remap_pfn_range use outside of media drivers I
> didn't check either), so there might be code that could use the new
> helper.

I think that [io_]remap_pfn_range() calls are used by the oldest drivers
and a few newer ones that based on some old cut-and-paste code.

Let me see what drivers use it on media...

	$ git grep -l remap_pfn_range drivers/media/
	drivers/media/pci/meye/meye.c
	drivers/media/pci/zoran/zoran_driver.c
	drivers/media/platform/omap/omap_vout.c
	drivers/media/platform/omap24xxcam.c
	drivers/media/platform/vino.c
	drivers/media/usb/cpia2/cpia2_core.c
	drivers/media/v4l2-core/videobuf-dma-contig.c

Yes, meye, vino, cpia2 and zoran are very old drivers. I only have
here somewhere zoran cards. I'll see if they still work, and write
a patch for it.

The platform drivers that use remap_pfn_range() are omap2 and vino.
Vino is for SGI Indy machines. I dunno anyone with those hardware
and a camera anymore. The OMAP2 were used on some Nokia phones.
They used to maintain that code, but now that they moved to the dark
side of the moon, they lost their interests on it. So, it may not 
be easily find testers for patches there.

The videobuf-dma-contig code actually uses two implementations there: 
one using vm_insert_page() for cached memory, and another one using 
remap_pfn_range() for uncached memory.

All places where cached memory is used got already moved to 
videobuf2-dma-contig. We can simply drop that unused code from it, 
and remap_pfn_range() by vm_iomap_memory(). 

I can write the patches doing it, but I don't any hardware here
using videobuf-dma-contig for testing. So, I'll post it
asking people to test.

> 
> Anyway, I'm attaching the *untested* patch to several drivers. Guys,
> mind taking a look? The point here is to simplify the interface,
> avoiding bugs, but also:
> 
>  5 files changed, 21 insertions(+), 87 deletions(-)
> 
> it needs current -git for the new helper function.
> 
> NOTE! The driver subsystem .mmap functions seem to almost universally do
> 
>     if (io_remap_pfn_range(..))
>         return -EAGAIN;
>     return 0;
> 
> and I didn't make the new helper function do that "turn all
> remap_pfn_range errors into EAGAIN". My *suspicion* is that this is
> just really old copy-pasta and makes no sense, but maybe there is some
> actual reasoning behind EAGAIN vs ENOMEM, for example. EAGAIN is
> documented to be about file/memory locking, which means that it really
> doesn't make any sense, but obviously there might be some binary that
> actally depends on this, so I'm perfectly willing to make the helper
> do that odd error case, I'd just like to know (and a add a comment)
> WHY.
> 
> My personal guess is that nobody actually cares (we return other error
> codes for other cases, notably EINVAL for various out-of-mapping-range
> issues), and the whole EAGAIN return value is just a completely
> historical oddity.
> 
> (And yes, I know the mtdchar code is actually disabled right now. But
> that was a good example of a driver that had a bug in this area and
> that I touched myself not too long ago, and recent stable noise
> reminded me of it, so I did that one despite it not being active).
> 
>                 Linus

Regards,
Mauro
