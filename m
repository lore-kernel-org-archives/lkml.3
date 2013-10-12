Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab3JLKbG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 06:31:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57814 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab3JLKbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 06:31:04 -0400
Date: Sat, 12 Oct 2013 12:30:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: Dave Young <dyoung@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org,
        fwts-devel@lists.ubuntu.com
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Message-ID: <20131012103054.GA13739@pd.tnic>
References: <20131008164551.GB16793@pd.tnic>
 <20131008164831.GD16793@pd.tnic>
 <20131010080635.GA3692@dhcp-16-126.nay.redhat.com>
 <20131010081434.GB3692@dhcp-16-126.nay.redhat.com>
 <20131010085827.GA9929@pd.tnic>
 <20131010123453.GA12321@console-pimps.org>
 <20131011062437.GA14115@dhcp-16-126.nay.redhat.com>
 <20131011074144.GA18719@pd.tnic>
 <20131012075443.GD7550@dhcp-16-126.nay.redhat.com>
 <20131012101308.GI12321@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131012101308.GI12321@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 11:13:08AM +0100, Matt Fleming wrote:
> On Sat, 12 Oct, at 03:54:44PM, Dave Young wrote:
> > Boris:
> > 
> > For the boot service region overlapping problem I have another idea,
> > how about modify your mapping code to always mapping the RUNTIME region
> > (non boot service region) firstly from the efi_va, then mapping other
> > regions in order, in this way kexec 2nd kernel will be happy because
> > it does not call SetVirtualAddressMap and it does not need the boot
> > service area at all.
> 
> Coalescing the runtime regions together implies that the second kernel
> would care about the fragmentation caused by unmapping the boot service
> regions - it shouldn't. We've sliced up a considerable chunk of kernel
> virtual address space (64G) and fragmentation shouldn't be an issue
> right now.
> 
> Even if we run out of address space in the future due to fragmentation,
> and end up needing to coalesce runtime regions, this would be
> transparent to the kexec kernel because it's passed the memmap entries
> through setup_data.
> 
> Though we are defining an ABI around the EFI address range
> (0xffffffef00000000 - 0xffffffff00000000), such that it needs to be the
> same between kernels, we must not make the layout of regions within that
> range part of the ABI. We need the freedom to change the layout in the
> future.

Basically, to sum up what Matt so eloquently explained, we will be
passing all the runtime regions *but* *not* the boot regions (because
the kexec kernel doesn't need them anyway) through setup_data to the
kexec kernel.

I.e., boot services regions is a dont-care for kexec.

And it is very important to restate that we want to reserve ourselves
the most flexible way of passing regions to the kexec kernel in case we
want to change the mapping algorithm in the future. Therefore, kexec
should simply not know anything about the VA layout of the EFI regions
but will get them spelled out through the boot header's setup_data.

This is the picture so far, AFAICT. Matt, please make a lot of noise if
I've misrepresented anything.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
