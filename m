Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbaIHOVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:21:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbaIHOVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:21:36 -0400
Message-ID: <1410186065.27715.2.camel@deneb.redhat.com>
Subject: Re: [PATCH] efi/arm64: fix fdt-related memory reservation
From: Mark Salter <msalter@redhat.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 08 Sep 2014 10:21:05 -0400
In-Reply-To: <20140908140609.GI12081@leverpostej>
References: <1410183102-6969-1-git-send-email-msalter@redhat.com>
	 <20140908140609.GI12081@leverpostej>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-08 at 15:06 +0100, Mark Rutland wrote:
> Hi Mark,
> 
> On Mon, Sep 08, 2014 at 02:31:42PM +0100, Mark Salter wrote:
> > Commit 86c8b27a01cf:
> >  "arm64: ignore DT memreserve entries when booting in UEFI mode
> > 
> > prevents early_init_fdt_scan_reserved_mem() from being called for
> > arm64 kernels booting via UEFI. This was done because the kernel
> > will use the UEFI memory map to determine reserved memory regions.
> > That approach has problems in that early_init_fdt_scan_reserved_mem()
> > also reserves the FDT itself and any node-specific reserved memory.
> > By chance of some kernel configs, the FDT may be overwritten before
> > it can be unflattened and the kernel will fail to boot. More subtle
> > problems will result if the FDT has node specific reserved memory
> > which is not really reserved.
> 
> That doesn't sound like fun; apologies for allowing such brokenness
> through in the first place.

Heh. It was obvious that DT unflattening was broken, but bisecting
didn't help much because I kept finding patches which when reverted
made the problem go away even though they obviously weren't the
cause.

> 
> [...]
> 
> > +	/*
> > +	 * Delete all memory reserve map entries. When booting via UEFI,
> > +	 * kernel will use the UEFI memory map to find reserved regions.
> > +	 */
> > +	num_rsv = fdt_num_mem_rsv(fdt);
> > +	for (i = 0; i < num_rsv; i++)
> > +		fdt_del_mem_rsv(fdt, i);
> 
> I don't think that's right. Won't the memreserve entries shift down by
> one each time we call fdt_del_mem_rsv?
> 
> Shouldn't this be something like:
> 
> while (fdt_num_mem_rsv(fdt))
> 	fdt_del_mem_rsv(fdt, 0);
> 
> Or we could count downwards.
> 

Sigh. Yes, you are right. I only tested with one reserved region.
I think counting down would be the way to go. I'll send a fixed
patch shortly.


