Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab3JBRFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:05:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43290 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634Ab3JBRF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:05:28 -0400
Date: Wed, 2 Oct 2013 19:05:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Young <dyoung@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Message-ID: <20131002170522.GA20647@pd.tnic>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <1379602494-26684-12-git-send-email-bp@alien8.de>
 <20130921113929.GB1587@pd.tnic>
 <20130922123515.GA7476@dhcp-16-126.nay.redhat.com>
 <20130922133722.GC28718@pd.tnic>
 <1ba7eca6-419c-4181-9927-9ba0927a6abf@email.android.com>
 <20130924025209.GA5561@dhcp-16-126.nay.redhat.com>
 <2d27a1bc-eabf-4d45-8303-27ae58511b11@email.android.com>
 <20131002100426.GB20568@pd.tnic>
 <524C3F38.6050507@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <524C3F38.6050507@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 08:43:52AM -0700, H. Peter Anvin wrote:
> On 10/02/2013 03:04 AM, Borislav Petkov wrote:
> > When we start allocating from -4G, i.e. 0xffffffff00000000, I think we
> > want to do it bottom-up so that 0xffffffff00000000 is the *last*, i.e.
> > lowest address. Because we link the kernel text at 0xffffffff81000000 by
> > default, which would mean, if -4G was the first address, we'll have only
> > 2G:
> 
> Right.

Btw, Matt just found another issue with the bottom-up approach - due to
different alignment of VA and PA addresses, this messes up the pagetable
in terms of the order in which we're using 4K, 2M, etc pages.

What can happen is that, you can get a non-2M aligned PA mapped with
2M-aligned VA which results in a #PF with PF_RSVD set, which most likely
happens because one or more of the bits in the [12:20] slice of the PMD
are reserved but they get set due to the PA having address bits set in
the aforementioned slice and thus a #PF is raised.

So we changed the mapping method to a more straight-forward one: we map
all EFI regions in the following range:

[ efi_va - -4G ]

and we compute efi_va by subtracting the highest EFI region address from
-4G, i.e. 0xffff_ffff_0000_0000.

Then, each VA is computed by doing efi_va + PA.

Basically, we have a non-contiguous window in the virtual address space
with the highest address of it being -4G. In OVMF, f.e., we get the
following mappings:

VA: 0xfffffffe80800000..0xfffffffe81000000 -> PA: 0x800000..0x1000000
VA: 0xfffffffefc000000..0xfffffffefc020000 -> PA: 0x7c000000..0x7c020000
VA: 0xfffffffefdc5b000..0xfffffffefe146000 -> PA: 0x7dc5b000..0x7e146000

...

VA: 0xfffffffeffa65000..0xfffffffefffe0000 -> PA: 0x7fa65000..0x7ffe0000
VA: 0xfffffffefffe0000..0xffffffff00000000 -> PA: 0x7ffe0000..0x80000000

So, basically, the EFI regions occupy a 2Gish window with holes in the
range:

[ 0xfffffffe80800000 - 0xffffffff00000000 )

and since we said, we want to give the whole EFI memmap 64G max, that
should be ok.

Oh, and the alignment remains compatible this way.

So this mapping scheme - courtesy of Matt - is very straight-forward
and simple and I like simple. This way we won't need the setup_data
games with kexec tools as we'll be simply doing the same mappings in the
kexec'ed kernel.

Anyway, I'll clean up the patch and send it out later.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
