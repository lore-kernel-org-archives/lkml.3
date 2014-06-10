Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaFJKjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 06:39:25 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:15095 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751002AbaFJKjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 06:39:23 -0400
Date: Tue, 10 Jun 2014 11:39:01 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steve Capper <steve.capper@linaro.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH] arm64: Add flush_cache_vmap call in __early_set_fixmap
Message-ID: <20140610103901.GB3523@arm.com>
References: <1402050590-23877-1-git-send-email-leif.lindholm@linaro.org>
 <1402065449.15402.2.camel@deneb.redhat.com>
 <20140606145324.GE4179@bivouac.eciton.net>
 <1402067373.15402.9.camel@deneb.redhat.com>
 <20140609110356.GD25590@arm.com>
 <20140609132429.GF4179@bivouac.eciton.net>
 <20140609133859.GB18487@localhost>
 <20140609163954.GA22876@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609163954.GA22876@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 05:40:05PM +0100, Steve Capper wrote:
> On Mon, Jun 09, 2014 at 02:38:59PM +0100, Catalin Marinas wrote:
> > On Mon, Jun 09, 2014 at 02:24:29PM +0100, Leif Lindholm wrote:
> > > On Mon, Jun 09, 2014 at 12:03:56PM +0100, Catalin Marinas wrote:
> > > > A quick grep through the kernel shows that we have other set_pte() calls
> > > > without additional dsb() like create_mapping(), I think kvm_set_pte() as
> > > > well.
> > > > 
> > > > So I'm proposing an alternative patch (which needs some benchmarking as
> > > > well to see if anything is affected, maybe application startup time).
> > > 
> > > I'm happy for any fix which can be included in 3.16.
> > 
> > Steve Capper made a point about performance. He'll follow up.
> 
> My concern was initially about splitting THPs, as with a 64K granule,
> we will have 2048 calls to set_pte_at in a loop. Having thought about
> it, these should be relatively rare events though.

Are there any THP benchmarks?

> There will be an impact on various aspects of the memory system (for
> instance fork), but this will need to be measured.

There is but I don't think we have an easy around. Grep'ing the kernel
for set_pte_at() shows several places where this is called without a
corresponding DSB (currently only as part of flush_cache_vmap and
update_mmu_cache).

For example, insert_page(), though insert_pfn() calls update_mmu_cache()
and it even has a comment "why not for insert page?".

So we need to run some benchmarks to assess the impact. If significant,
we can look at alternatives (in addition to the above, possibly adding
barriers to arch_leave_lazy_mmu_mode).

-- 
Catalin
