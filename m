Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbaCSKgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:36:05 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:20936 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758590AbaCSKgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:36:01 -0400
Date: Wed, 19 Mar 2014 10:35:21 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Roy Franz <roy.franz@linaro.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 11/15] arm64: add EFI stub
Message-ID: <20140319103521.GD2214@arm.com>
References: <1394750828-16351-1-git-send-email-leif.lindholm@linaro.org>
 <1394750828-16351-12-git-send-email-leif.lindholm@linaro.org>
 <20140318120919.GG13200@arm.com>
 <1395153629.2967.10.camel@deneb.redhat.com>
 <20140318182826.GC20497@arm.com>
 <1395178831.2967.29.camel@deneb.redhat.com>
 <CAFECyb_NuHBQD3zPouDde3WTyz8RrUu1OWFOt6VWX_U5n1g8MA@mail.gmail.com>
 <20140318222105.GA11178@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140318222105.GA11178@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 10:21:05PM +0000, Jason Gunthorpe wrote:
> On Tue, Mar 18, 2014 at 02:48:30PM -0700, Roy Franz wrote:
> 
> > > It isn't clear to me if UEFI does cache flushing at ExitBootServices
> > > time, but even so, at least stack use will get cached between then and
> > > the kernel entry point. The stub could conceivably get its hands on the
> > > EFI memmap and invalidate dcache using address ranges from UEFI memory
> > > descriptors so maybe that is the way we should do it.
> 
> > I looked at the UEFI spec and there is no mention of cache flushing
> > in ExitBootServices(), so it seems it is up to the OS to do any
> > cache management.
> 
> Something to think about: On mvebu we recently confirmed a situation
> where turning off the L1 cache is not sufficient for booting. The L2
> cache must also be completely off and disabled prior to jumping in to
> the kernel.
> 
> The issue is the decompressor turns the L1 cache back on, and if the
> L2 is also enabled at this point then it gets filled with
> decompression data. Things go wrong from here because after
> decompression the L1 dcache is switched off, but the L2 isn't
> flush-invalidated.
> 
> So now the L2 holds writeback data and uncached reads return garbage,
> and/or the L2 misses the uncached writes (eg relocation fixup) and
> becomes inconsistent with memory. Either case gives a black screen
> crash at boot.
> 
> Fundementally if the L2 doesn't monitor uncached read/writes then it
> will cause a big problem.

Yes, that's a problem on (ARMv7) SoCs booting in non-secure mode with
external L2 already enabled. For ARMv8 at least, the SoCs I've seen with
external caches detect the data cache by MVA ops.

> Thus, if the UEFI calls the sub with the caches on, and the stub
> doesn't know enough to turn off the L2 then you might not be able to
> turn the dcache off at all. :(
> 
> On ARM64 at least the L1 cache ops are standardized so maybe ARM64
> could keep the mmu+caches enabled during boot and do the L1
> d-flush/i-inval required for instruction coherency?

We thought about keeping the MMU on from EFI_STUB into the kernel but it
gets messier since UEFI has different MMU settings. So with some sane
external cache, we could get away with flushing a range.

-- 
Catalin
