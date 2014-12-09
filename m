Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbaLIKfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:35:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45505 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114AbaLIKfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:35:22 -0500
Date: Tue, 9 Dec 2014 11:35:18 +0100
From: Borislav Petkov <bp@suse.de>
To: Matt Fleming <matt.fleming@intel.com>, Dave Hansen <dave.hansen@intel.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG() at boot in __phys_addr with DEBUG_VIRTUAL
Message-ID: <20141209103518.GA4147@pd.tnic>
References: <5462999A.7090706@intel.com>
 <1415784298.14686.323.camel@mfleming-mobl1.ger.corp.intel.com>
 <54637576.7030004@intel.com>
 <20141112151106.GB17793@pd.tnic>
 <54637AD5.6060300@intel.com>
 <20141112172513.GC17793@pd.tnic>
 <1415874993.14686.434.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1415874993.14686.434.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 10:36:33AM +0000, Matt Fleming wrote:
> So that when we switch into 32-bit mode we can still access the kernel
> text via the 1:1 mapping in protected mode.

Ok, I am able to trigger the same splat with latest EDKII here. Applying
the hunk below fixes it and the guest boots fine.

And this is the thing we could now do short of teaching pageattr.c to
distinguish PGDs. This way we're sending any mapping requests which have
a pgd different than the implicit kernel one into populate_pgd().

What that does is overwrite any mappings there are in the pagetable
prior to that because the userspace part is reserved for UEFI RT 1:1
mappings and since those should be static and not change, we can allow
ourselves the more clumsy method of simply overwriting the page table
with the regions.

The VA mappings region is also reserved for UEFI so not an issue there
right now.

What I'm having problems with is mapping the kernel text 1:1 for
EFI_MIXED in the presence of KASLR and then, as getting "lucky" and
having the kernel addresses overlap with EFI regions. I think if that
happens, then we have a boom but I could very well be missing something.

Matt?

---
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index a3a5d46605d2..226ecb319913 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1120,7 +1140,7 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
                address = *cpa->vaddr;
 repeat:
        kpte = _lookup_address_cpa(cpa, address, &level);
-       if (!kpte)
+       if (!kpte || cpa->pgd)
                return __cpa_process_fault(cpa, address, primary);
 
        old_pte = *kpte;



-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
