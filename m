Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbaKXRfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:35:23 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33125 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbaKXRfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:35:21 -0500
Date: Mon, 24 Nov 2014 18:35:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: guard against misaligned
 microcode data
Message-ID: <20141124173517.GE20296@pd.tnic>
References: <20141107234806.GG5180@pd.tnic>
 <20141108215749.GC32023@khazad-dum.debian.net>
 <20141111104700.GC31490@pd.tnic>
 <20141111165731.GA2584@khazad-dum.debian.net>
 <20141111171357.GK31490@pd.tnic>
 <20141111195400.GG2584@khazad-dum.debian.net>
 <20141112123115.GC16807@pd.tnic>
 <20141113001846.GB19734@khazad-dum.debian.net>
 <20141113115332.GB14070@pd.tnic>
 <20141115231044.GA8968@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141115231044.GA8968@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2014 at 09:10:44PM -0200, Henrique de Moraes Holschuh wrote:
> And since I have learned my lesson, I took your comment to mean "look
> deeper".  I took the time to both try to understand somewhat the mm/ code
> AND write a kernel module to do empiric testing before I wrote this reply,
> instead of trusting the documentation.

Good! Thanks. :-)

> Important detail: intel microcodes have 1KiB size granularity, are never
> smaller than 2048 bytes, and so far the largest ones are close to 64KiB.

Right, we should be able to manage 16 pages allocation on most systems.

> For SLUB:
> 
> kmalloc() will do kmalloc_large() for anything > 8192 bytes and that should
> return page-aligned data since it calls alloc_kmem_pages()/alloc_pages().

Yep.

> For 2048 bytes to 8192 bytes, we will get memory from one of the following
> slabs: kmalloc-2048, kmalloc-4096 or kmalloc-8192.
> 
> As far as I could understand (and here I could easily be wrong as the mm/
> slab cache code is not trivial to grok), those are going to be object-size
> aligned, because the allocation size will be rounded up to the slab's object
> size (i.e. 2048/4096/8192 bytes).  The objects are allocated from the start
> of the slab (which is page-aligned), back-to-back.
> 
> Thus SLUB would always return 16-byte aligned memory for the size range of
> Intel microcode.  In fact, it will return 2048-byte aligned memory in the
> worst case (2048-byte microcode).

I'm wondering if those slab objects would have some sort of
metadata after them so that the nice alignment of 2048, 4096 and 8192
gets b0rked. Because there are those members there in slub_def.h:

/*
 * Slab cache management.
 */
struct kmem_cache {
	...
        int size;               /* The size of an object including meta data */
        int object_size;        /* The size of an object without meta data */

but dumping the values from sysfs show me that there's no metadata:

/sys/kernel/slab/kmalloc-2048/object_size:2048
/sys/kernel/slab/kmalloc-2048/slab_size:2048
/sys/kernel/slab/kmalloc-4096/object_size:4096
/sys/kernel/slab/kmalloc-4096/slab_size:4096
/sys/kernel/slab/kmalloc-8192/object_size:8192
/sys/kernel/slab/kmalloc-8192/slab_size:8192

so we should be fine.

> For SLAB:
> 
> SLAB is nasty to grok with a first look due to the whole complexity re. its
> queues and cpu caches, and I don't think I understood the code properly.
>
> intel microcode sized allocations end up in slabs with large objects that
> are all of the same 2^n size (i.e. 2048 bytes, 4096 bytes, etc).  I could
> not grok the code enough to assert what real alignment I could expect for
> 2KiB to 64KiB objects.

Well, 2KiB alignment certainly satisfies 16 bytes alignment.

> Empiric testing in x86-64 SLAB, done by allocating 63 objects of the same
> size in a row, for all possible microcode sizes, did not result in a single
> kmalloc() that was not sufficiently aligned, and in fact all of them were
> object-size aligned, even for the smallest microcodes (2048 bytes).  I even
> tried it with CONFIG_DEBUG_SLAB turned on and off to see if it changed
> anything (it didn't).

Ok.

> So, while I didn't understand the code enough to prove that we'd mostly get
> good microcode alignment out of SLAB, I couldn't get it to return pointers
> that would require extra alignment either.  The worst case was 2048-byte
> alignment, for microcodes with 2048 bytes.

Well, looking at calculate_alignment() in mm/slab_common.c
and since we're being called with SLAB_HWCACHE_ALIGN, i.e.
create_kmalloc_caches(ARCH_KMALLOC_FLAGS) in kmem_cache_init(), then the
loop in calculate_alignment() will definitely give higher alignment than
16 for the larger caches. This is, of course AFAICT.

> For SLOB:
> 
> SLOB will call the page allocator for anything bigger than 4095 bytes, so
> all microcodes from 4096 bytes and above will be page-aligned.
> 
> Only 2048-byte and 3072-byte microcode wouldn't go directly to the page
> allocator.  This is microcode for ancient processors: Pentium M and earlier,
> and the first NetBurst processors.
> 
> I didn't bother to test, but from the code, I expect that 2048-byte and
> 3072-byte sized microcode would *not* be aligned to 16 bytes.  However, we
> have very few users of these ancient processors left.  Calling kmalloc(s);
> kfree(); kmalloc(s+15); for these rare processors doesn't look like too much
> of an issue IMHO.
> 
> SLOB was the only allocator that could result in microcode that needs
> further alignment in my testing, and only for the small microcode (2KiB and
> 3KiB) of ancient processors.

Right, it looks like slob could give objects aligned to < 16.

Ok, please add the jist of this to the commit message without going into
unnecessary detail too much.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
