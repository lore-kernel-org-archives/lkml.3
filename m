Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3IQLdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 07:33:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37667 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975Ab3IQLd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 07:33:29 -0400
Date: Tue, 17 Sep 2013 12:32:43 +0100
From: Will Deacon <will.deacon@arm.com>
To: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Cc: "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "JBottomley@Parallels.com" <JBottomley@Parallels.com>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel semantics of relaxed MMIO accessors
Message-ID: <20130917113243.GB29356@mudshark.cambridge.arm.com>
References: <20130909114449.GB5426@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909114449.GB5426@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[expanding CC list and bumping since the merge window is now over]

On Mon, Sep 09, 2013 at 12:44:49PM +0100, Will Deacon wrote:
> Hello,
> 
> During the review of a recent patch to add support for atomic MMIO
> read-modify-write sequences between drivers on ARM, it was suggested
> that this code could be made generic and used by other architectures.
> 
>   http://lists.infradead.org/pipermail/linux-arm-kernel/2013-August/194178.html
> 
> However, making this generic requires the availability of relaxed MMIO
> accessors across all architectures because { readX(); modify(); writeX(); }
> is an extremely expensive sequence on ARM. This expense is due to heavyweight
> barriers inside our accessor macros to satisfy the conclusions from this
> earlier thread with respect to cacheable memory ordering (which do make sense
> from a driver writer's perspective):
> 
>   http://www.gossamer-threads.com/lists/linux/kernel/932153?do=post_view_threaded#932153
> 
> The problem with relaxed accessors (which is also mentioned in the thread
> above) is that they don't seem to have well defined semantics across all
> architectures. For example, the table below illustrates a few architectures
> and their behaviour in this area (please correct any mistakes or add any
> interesting architectures):
> 
> 
> Ordered against: | IO (same device) | Cacheable accesses | Spin lock/unlock |
> -----------------+------------------+--------------------+------------------+
> ARM/ARM64        |                  |                    |                  |
>   readX/writeX   |        Y         |         Y          |        Y         |
>   _relaxed       |        Y         |         N          |        Y         |
>                  |                  |                    |                  |
> Alpha            |                  |                    |                  |
>   readX/writeX   |        Y         |         Y          |        Y         |
>   _relaxed       |        N*        |         N          |        Y         |
>                  |                  |                    |                  |
> PowerPC**        |                  |                    |                  |
>   readX/writeX   |        Y         |         Y          |        Y         |
>   _relaxed       |        Y         |         Y          |        Y         |
>                  |                  |                    |                  |
> x86              |                  |                    |                  |
>   readX/writeX   |        Y         |         Y          |        Y         |
>   _relaxed***    |        N         |         N          |        Y         |
> 
> *   Depends on specific machine afaict.
> **  _relaxed accessors just #defined as non-relaxed variants, so could be
>     improved.
> *** Potential for re-ordering by the compiler.
> 
> 
> On top of that, there is the concept of relaxed transactions in PCI-X and
> PCI-E, which seem to permit re-ordering of accesses to the same address!
> I think this is also behind the reason that, whilst readX_relaxed is
> implemented on almost all architectures, writeX_relaxed is very uncommon.
> 
> Documentation/memory-barriers.txt states vaguely that readX_relaxed is
> "not guaranteed to be ordered in any way" whilst
> Documentation/DocBook/deviceiobook.tmpl explicitly ties the relaxed ordering
> to IO accesses and DMA writes from a device.
> 
> So this email is a bit of a cry for help. I'd like to try and define some
> common semantics for relaxed I/O accessors so that they can be implemented
> by all architectures and relied upon by driver writers, including the
> addition of relaxed writes.
> 
> My basic proposal would be to copy the ARM definition of _relaxed accessors
> (i.e. only relax ordering against cacheable accesses), which is the semantic
> hinted at by Nick when this was last discussed:
> 
>   http://www.gossamer-threads.com/lists/linux/kernel/932390?do=post_view_threaded#932390
> 
> This should allow for significant performance improvements in drivers which
> don't care about normal memory ordering most of the time yet do have strict
> requirements on ordering of I/O accesses (I think this is the common case).
> 
> All feedback/suggestions/war stories welcome!
> 
> Will
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
