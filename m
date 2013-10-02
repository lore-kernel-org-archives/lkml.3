Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3JBKEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:04:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35908 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab3JBKEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:04:31 -0400
Date: Wed, 2 Oct 2013 12:04:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Young <dyoung@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-efi@vger.kernel.org
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Message-ID: <20131002100426.GB20568@pd.tnic>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <1379602494-26684-12-git-send-email-bp@alien8.de>
 <20130921113929.GB1587@pd.tnic>
 <20130922123515.GA7476@dhcp-16-126.nay.redhat.com>
 <20130922133722.GC28718@pd.tnic>
 <1ba7eca6-419c-4181-9927-9ba0927a6abf@email.android.com>
 <20130924025209.GA5561@dhcp-16-126.nay.redhat.com>
 <2d27a1bc-eabf-4d45-8303-27ae58511b11@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2d27a1bc-eabf-4d45-8303-27ae58511b11@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 08:06:38PM -0700, H. Peter Anvin wrote:
> Okay... I see two problems.
> 
> 1. It looks like we subtract the region size after, rather than before, assigning an address.
> 

Ok, so I'm looking at this agan and, actually, we really do subtract the
region size *before* we assign the address:

---
       efi_va -= size;
       if (efi_va < EFI_VA_END) {
               pr_warning(FW_WARN "VA address range overflow!\n");
               return;
       }

       /*
        * Make sure the 1:1 mappings are present as a catch-all for b0rked
        * firmware which doesn't update all internal pointers after switching
        * to virtual mode and would otherwise crap on us.
        */
       __map_region(md, md->phys_addr);

       /* Do the VA map */
       __map_region(md, efi_va);
       md->virt_addr = efi_va;
--

So let me give an example why I think it is correct to subtract *before*
assigning and so that we can talk about it and we completely agree on
the details. :-)

When we start allocating from -4G, i.e. 0xffffffff00000000, I think we
want to do it bottom-up so that 0xffffffff00000000 is the *last*, i.e.
lowest address. Because we link the kernel text at 0xffffffff81000000 by
default, which would mean, if -4G was the first address, we'll have only
2G:

0xffffffff81000000 - 0xffffffff00000000 = 0x0000000081000000 = 2.164.260.864 bytes

of space for UEFI mappings.

That's why, I need to *first* subtract and *then* use the resulting
address to map the region to. Like so (4 hypothetical regions):

1st region: 0xfffffffeffffe000 - 0xffffffff00000000

2nd region: 0xfffffffeffff8000 - 0xfffffffeffffe000

3rd region: 0xfffffffefffec000 - 0xfffffffeffff8000

4th region: 0xfffffffefffd8000 - 0xfffffffefffec000

and so on...

IOW, the VA layout looks like this:

0xfffffffefffd8000
...
region 4
...
0xfffffffefffec000 (non including)
...
region 3
...
0xfffffffeffff8000 (ditto)
...
region 2
...
0xfffffffeffffe000 (ditto)
...
region 1
...
0xffffffff00000000 (ditto)

Am I even making sense here?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
