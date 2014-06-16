Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbaFPONQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:13:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51523 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822AbaFPONP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:13:15 -0400
Date: Mon, 16 Jun 2014 15:12:42 +0100
From: Will Deacon <will.deacon@arm.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>
Subject: Re: [PATCH] arm64: Add flush_cache_vmap call in __early_set_fixmap
Message-ID: <20140616141242.GJ16758@arm.com>
References: <1402050590-23877-1-git-send-email-leif.lindholm@linaro.org>
 <1402065449.15402.2.camel@deneb.redhat.com>
 <20140606145324.GE4179@bivouac.eciton.net>
 <1402067373.15402.9.camel@deneb.redhat.com>
 <20140609110356.GD25590@arm.com>
 <20140609132429.GF4179@bivouac.eciton.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609132429.GF4179@bivouac.eciton.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 02:24:29PM +0100, Leif Lindholm wrote:
> On Mon, Jun 09, 2014 at 12:03:56PM +0100, Catalin Marinas wrote:
> > So I'm proposing an alternative patch (which needs some benchmarking as
> > well to see if anything is affected, maybe application startup time).

I don't like the proposed patch at all -- keeping the dsb out of set_pte is
worthwhile if we can manage it. That said, it would be interesting to know
how often we get a subsequent page fault after mapping invalid -> valid
because of the missing dsb. It could be that the cost of the benign fault is
hitting us more than we think.

> I'm happy for any fix which can be included in 3.16.
> 
> But is the dsb(ishst) sufficient? We need to also prevent reads from
> overtaking the set_pte(). i.e.:
> 
> ptr = early_ioremap(phys_addr, size);
> if (ptr && strcmp(ptr, "magic") == 0)
>    ...
> 
> Does it not require a dsb(ish)?

I don't think so. Crudely, the sequence above would look like:

  STR	x0, [PTEP]
  DSB	ISHST
  LDR	x0, [MAGIC]

The DSB can't complete until the STR is globally observed within the
inner-shareable domain, so the LDR cannot execute until the page table
update is visible to the walker.

If it was a DMB, we'd have a problem. Interestingly, the asm-generic
page table allocators (e.g. __pmd_alloc) *do* use dmb for ordering
observability of page-table updates via smp_wmb. I'm struggling to decide
whether that's broken or not.

Will
