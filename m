Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaKYN3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:29:34 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38353 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172AbaKYN3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:29:32 -0500
X-Sasl-enc: QdNYr3R3Y6UrIGqwc1hsevUkifCjo7ID1daaREAtbRQm 1416922171
Date: Tue, 25 Nov 2014 11:29:19 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: guard against misaligned
 microcode data
Message-ID: <20141125132919.GA23248@khazad-dum.debian.net>
References: <20141108215749.GC32023@khazad-dum.debian.net>
 <20141111104700.GC31490@pd.tnic>
 <20141111165731.GA2584@khazad-dum.debian.net>
 <20141111171357.GK31490@pd.tnic>
 <20141111195400.GG2584@khazad-dum.debian.net>
 <20141112123115.GC16807@pd.tnic>
 <20141113001846.GB19734@khazad-dum.debian.net>
 <20141113115332.GB14070@pd.tnic>
 <20141115231044.GA8968@khazad-dum.debian.net>
 <20141124173517.GE20296@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124173517.GE20296@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014, Borislav Petkov wrote:
> On Sat, Nov 15, 2014 at 09:10:44PM -0200, Henrique de Moraes Holschuh wrote:
> > For SLAB:
> > 
> > SLAB is nasty to grok with a first look due to the whole complexity re. its
> > queues and cpu caches, and I don't think I understood the code properly.
> >
> > intel microcode sized allocations end up in slabs with large objects that
> > are all of the same 2^n size (i.e. 2048 bytes, 4096 bytes, etc).  I could
> > not grok the code enough to assert what real alignment I could expect for
> > 2KiB to 64KiB objects.
> 
> Well, 2KiB alignment certainly satisfies 16 bytes alignment.

Yeah, however I was not sure SLAB wouldn't spoil the fun by adding a header
before the slab and screwing up MIN(page-size, object-size) alignment inside
the slab.

Unlike SLUB, SLAB is documented to add an enemy-of-large-alignment
head-of-slab header in an attempt to make the world a sadder place where
even SIMD instructions (that want cache-line alignment) would suffer...

But my empiric testing didn't show any of that sadness for these larger
allocation sizes (2KiB and bigger).  They're all either page-aligned or
object-size aligned, regardless of whether SLAB debug mode was compiled in
or not. 

> > Empiric testing in x86-64 SLAB, done by allocating 63 objects of the same
> > size in a row, for all possible microcode sizes, did not result in a single
> > kmalloc() that was not sufficiently aligned, and in fact all of them were
> > object-size aligned, even for the smallest microcodes (2048 bytes).  I even
> > tried it with CONFIG_DEBUG_SLAB turned on and off to see if it changed
> > anything (it didn't).
> 
> Ok.
> 
> > So, while I didn't understand the code enough to prove that we'd mostly get
> > good microcode alignment out of SLAB, I couldn't get it to return pointers
> > that would require extra alignment either.  The worst case was 2048-byte
> > alignment, for microcodes with 2048 bytes.
> 
> Well, looking at calculate_alignment() in mm/slab_common.c
> and since we're being called with SLAB_HWCACHE_ALIGN, i.e.
> create_kmalloc_caches(ARCH_KMALLOC_FLAGS) in kmem_cache_init(), then the
> loop in calculate_alignment() will definitely give higher alignment than
> 16 for the larger caches. This is, of course AFAICT.

Ah, that explains it.  Thanks.  I missed the
create_kmalloc_caches(ARCH_KMALLOC_FLAGS) detail, which indeed ensures there
is no slab info at the head of the slab, so all intel microcode objects will
end up aligned to MIN(page-size, object-size).

> > For SLOB:
> > 
> > SLOB will call the page allocator for anything bigger than 4095 bytes, so
> > all microcodes from 4096 bytes and above will be page-aligned.
> > 
> > Only 2048-byte and 3072-byte microcode wouldn't go directly to the page
> > allocator.  This is microcode for ancient processors: Pentium M and earlier,
> > and the first NetBurst processors.
> > 
> > I didn't bother to test, but from the code, I expect that 2048-byte and
> > 3072-byte sized microcode would *not* be aligned to 16 bytes.  However, we
> > have very few users of these ancient processors left.  Calling kmalloc(s);
> > kfree(); kmalloc(s+15); for these rare processors doesn't look like too much
> > of an issue IMHO.
> > 
> > SLOB was the only allocator that could result in microcode that needs
> > further alignment in my testing, and only for the small microcode (2KiB and
> > 3KiB) of ancient processors.
> 
> Right, it looks like slob could give objects aligned to < 16.
> 
> Ok, please add the jist of this to the commit message without going into
> unnecessary detail too much.

Will do, thanks!

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
