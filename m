Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaKKTyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:54:14 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54071 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbaKKTyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:54:12 -0500
X-Sasl-enc: TE+41/CZIiSdY7UmwYRAdADiVPwS/LGW2fV+jqONbz+1 1415735651
Date: Tue, 11 Nov 2014 17:54:00 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: guard against misaligned
 microcode data
Message-ID: <20141111195400.GG2584@khazad-dum.debian.net>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-8-git-send-email-hmh@hmh.eng.br>
 <20141107195905.GE5180@pd.tnic>
 <20141107225425.GC18128@khazad-dum.debian.net>
 <20141107234806.GG5180@pd.tnic>
 <20141108215749.GC32023@khazad-dum.debian.net>
 <20141111104700.GC31490@pd.tnic>
 <20141111165731.GA2584@khazad-dum.debian.net>
 <20141111171357.GK31490@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111171357.GK31490@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2014, Borislav Petkov wrote:
> On Tue, Nov 11, 2014 at 02:57:31PM -0200, Henrique de Moraes Holschuh wrote:
> > Meh, I don't know where I came up with the wrong information that kmalloc
> > aligned to 16-bytes instead of 8 bytes.
> > 
> > I do wonder why I didn't hit this while testing, though.  Maybe an artifact
> > of slub, or just my luck that I never got a memory block that was not
> > aligned to 16 bytes.
> 
> The ARCH_KMALLOC_MINALIGN is conditioned on ARCH_DMA_MINALIGN and a
> bunch of other things. All I'm saying is, this needs a careful study
> when, if at all, kmalloc will not give an 16-byte aligned buffer.

I tried to do that in order to answer my own question.  After a quick look,
it looks like it ends up being an implementation detail of SLUB/SLAB/SLOB,
and it depends on the size of the object being allocated (i.e. if it is
bigger than KMALLOC_MAX_CACHE_SIZE).

I was always getting page-aligned memory blocks out of kmalloc() in my
testing because of that.

It won't be an ugly fix anyway, something like this (conceptual code):

/* as required by Intel SDM blahblahblah */
#define INTEL_MICROCODE_MINALIGN 16
#define INTEL_UCODE_PTR(x) PTR_ALIGN(x, INTEL_MICROCODE_MINALIGN)

void *intel_ucode_kmalloc(size_t size)
{
	void *p = kmalloc(size, GFP_KERNEL);
	if (likely(p == INTEL_UCODE_PTR(p))
		return p;

	kfree(p);
	return kmalloc(size + INTEL_MICROCODE_MINALIGN - 1, GFP_KERNEL);
}

For most users, that "p == INTEL_UCODE_PTR(p)" will always be true (SLUB
alocator, and microcode size >= 4096).

This way, we don't go around wasting pages when the microcode size is large
enough for the allocation to get kicked directly to the page allocator and
it is also is a multiple of PAGE_SIZE (which it often is).

I will need to add some defense against (size + 15) overflow in that custom
kmalloc, or ensure that we refuse ridiculously large microcode early (say,
larger than 4MiB).  Not a big deal, we probably already do this, and if we
don't, it will be an worthwhile enhancement by itself.  The largest
microcode I have been made aware of is ~64KiB.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
