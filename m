Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaFPORs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:17:48 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51591 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189AbaFPORr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:17:47 -0400
Date: Mon, 16 Jun 2014 15:17:17 +0100
From: Will Deacon <will.deacon@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>
Subject: Re: [PATCH] arm64: Add flush_cache_vmap call in __early_set_fixmap
Message-ID: <20140616141717.GK16758@arm.com>
References: <1402050590-23877-1-git-send-email-leif.lindholm@linaro.org>
 <1402065449.15402.2.camel@deneb.redhat.com>
 <20140606145324.GE4179@bivouac.eciton.net>
 <1402067373.15402.9.camel@deneb.redhat.com>
 <20140609110356.GD25590@arm.com>
 <20140609132429.GF4179@bivouac.eciton.net>
 <20140609133859.GB18487@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609133859.GB18487@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 02:38:59PM +0100, Catalin Marinas wrote:
> On Mon, Jun 09, 2014 at 02:24:29PM +0100, Leif Lindholm wrote:
> > On Mon, Jun 09, 2014 at 12:03:56PM +0100, Catalin Marinas wrote:
> > > A quick grep through the kernel shows that we have other set_pte() calls
> > > without additional dsb() like create_mapping(), I think kvm_set_pte() as
> > > well.
> > > 
> > > So I'm proposing an alternative patch (which needs some benchmarking as
> > > well to see if anything is affected, maybe application startup time).
> > 
> > I'm happy for any fix which can be included in 3.16.
> 
> Steve Capper made a point about performance. He'll follow up.
> 
> > But is the dsb(ishst) sufficient? We need to also prevent reads from
> > overtaking the set_pte(). i.e.:
> > 
> > ptr = early_ioremap(phys_addr, size);
> > if (ptr && strcmp(ptr, "magic") == 0)
> >    ...
> > 
> > Does it not require a dsb(ish)?
> 
> So doesn't early_ioremap() now include a dsb() after set_pte() with my
> patch?
> 
> BTW, according to the ARM ARM (and confirmed with architects), we needs
> DSB+ISB even if we have just a data access (rather than instruction
> fetch). We have to revisit both 32 and 64-bit code for this.

The impact of this really depends on whether or not we need to sandwich
DSB+ISB between every update to a set of page tables (possibly plumbing
together different levels) or whether the ISB can just come at the end.

If the latter case is true, we just need to add something for kernel
mappings, which should be pretty low overhead,

Will
