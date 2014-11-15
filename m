Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbaKOXK7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 18:10:59 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57912 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754667AbaKOXK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 18:10:58 -0500
X-Sasl-enc: 4BZlV0eRM0vDNpc1BO/ovdNfsWTLnHMJ33ESfvu5i/sG 1416093056
Date: Sat, 15 Nov 2014 21:10:44 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: guard against misaligned
 microcode data
Message-ID: <20141115231044.GA8968@khazad-dum.debian.net>
References: <20141107225425.GC18128@khazad-dum.debian.net>
 <20141107234806.GG5180@pd.tnic>
 <20141108215749.GC32023@khazad-dum.debian.net>
 <20141111104700.GC31490@pd.tnic>
 <20141111165731.GA2584@khazad-dum.debian.net>
 <20141111171357.GK31490@pd.tnic>
 <20141111195400.GG2584@khazad-dum.debian.net>
 <20141112123115.GC16807@pd.tnic>
 <20141113001846.GB19734@khazad-dum.debian.net>
 <20141113115332.GB14070@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113115332.GB14070@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014, Borislav Petkov wrote:
> On Wed, Nov 12, 2014 at 10:18:47PM -0200, Henrique de Moraes Holschuh wrote:
> > The detail is that: since most Intel microcodes are bigger than the kmalloc
> > cache, most of the time kmalloc will return page-aligned addresses, which
> > don't need any alignment.
> 
> Yeah, you keep saying that. Do you have an actual proof too?

I believe so, from documention gathered through google... but I could be
wrong about this.

And since I have learned my lesson, I took your comment to mean "look
deeper".  I took the time to both try to understand somewhat the mm/ code
AND write a kernel module to do empiric testing before I wrote this reply,
instead of trusting the documentation.

And it turns out I failed at proving myself wrong, either because I am not
wrong, or by sheer unluckyness.


Important detail: intel microcodes have 1KiB size granularity, are never
smaller than 2048 bytes, and so far the largest ones are close to 64KiB.


For SLUB:

kmalloc() will do kmalloc_large() for anything > 8192 bytes and that should
return page-aligned data since it calls alloc_kmem_pages()/alloc_pages().

For 2048 bytes to 8192 bytes, we will get memory from one of the following
slabs: kmalloc-2048, kmalloc-4096 or kmalloc-8192.

As far as I could understand (and here I could easily be wrong as the mm/
slab cache code is not trivial to grok), those are going to be object-size
aligned, because the allocation size will be rounded up to the slab's object
size (i.e. 2048/4096/8192 bytes).  The objects are allocated from the start
of the slab (which is page-aligned), back-to-back.

Thus SLUB would always return 16-byte aligned memory for the size range of
Intel microcode.  In fact, it will return 2048-byte aligned memory in the
worst case (2048-byte microcode).

Empiric testing in x86-64 resulted in data compatible with the above
reasoning.


For SLAB:

SLAB is nasty to grok with a first look due to the whole complexity re. its
queues and cpu caches, and I don't think I understood the code properly.

intel microcode sized allocations end up in slabs with large objects that
are all of the same 2^n size (i.e. 2048 bytes, 4096 bytes, etc).  I could
not grok the code enough to assert what real alignment I could expect for
2KiB to 64KiB objects.

Empiric testing in x86-64 SLAB, done by allocating 63 objects of the same
size in a row, for all possible microcode sizes, did not result in a single
kmalloc() that was not sufficiently aligned, and in fact all of them were
object-size aligned, even for the smallest microcodes (2048 bytes).  I even
tried it with CONFIG_DEBUG_SLAB turned on and off to see if it changed
anything (it didn't).

So, while I didn't understand the code enough to prove that we'd mostly get
good microcode alignment out of SLAB, I couldn't get it to return pointers
that would require extra alignment either.  The worst case was 2048-byte
alignment, for microcodes with 2048 bytes.


For SLOB:

SLOB will call the page allocator for anything bigger than 4095 bytes, so
all microcodes from 4096 bytes and above will be page-aligned.

Only 2048-byte and 3072-byte microcode wouldn't go directly to the page
allocator.  This is microcode for ancient processors: Pentium M and earlier,
and the first NetBurst processors.

I didn't bother to test, but from the code, I expect that 2048-byte and
3072-byte sized microcode would *not* be aligned to 16 bytes.  However, we
have very few users of these ancient processors left.  Calling kmalloc(s);
kfree(); kmalloc(s+15); for these rare processors doesn't look like too much
of an issue IMHO.

SLOB was the only allocator that could result in microcode that needs
further alignment in my testing, and only for the small microcode (2KiB and
3KiB) of ancient processors.

> Because if this turns out wrong, we'll end up doing two allocations
> instead of one, which is dumb. My suggestion was to do one allocation
> only.

See above.  As far as I could verify, we wouldn't be doing two allocations
in the common cases.

I really don't like the idea of increasing the allocation order by one for
4KiB, 8KiB, 16KiB, 32KiB and 64KiB microcodes just to alocate 15 bytes of
extra padding that, at least as far as I could check, seem to be most often
not needed.

Note that I did not do any empiric testing on 32 bits.

> > Your version also needs to keep the original pointer around for kfree, which
> > is going to be annoying.
> > 
> > My version has the drawback that it requires the use of INTEL_UCODE_PTR(p)
> 
> Yeah, just drop that macro - use simply PTR_ALIGN and
> INTEL_MICROCODE_MINALIGN.

I will do that.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
