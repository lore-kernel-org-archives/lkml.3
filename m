Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaKLPLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:11:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbaKLPLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:11:14 -0500
Date: Wed, 12 Nov 2014 16:11:06 +0100
From: Borislav Petkov <bp@suse.de>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG() at boot in __phys_addr with DEBUG_VIRTUAL
Message-ID: <20141112151106.GB17793@pd.tnic>
References: <5462999A.7090706@intel.com>
 <1415784298.14686.323.camel@mfleming-mobl1.ger.corp.intel.com>
 <54637576.7030004@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54637576.7030004@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 06:57:58AM -0800, Dave Hansen wrote:

> It's actually tripping over this in __phys_addr:
> 
>      VIRTUAL_BUG_ON((x > y) || !phys_addr_valid(x));
> 
> I dumped out a few of the variables too:
> 
> [    1.161406] __phys_addr() x: 0x000078009d3c6000
> [    1.166567] __phys_addr() origx: 0x000000009d3c6000
> [    1.171832] __phys_addr() y: 0x000000011d3c6000
> [    1.176999] __phys_addr() __START_KERNEL_map: 0xffffffff80000000
> [    1.183841] __phys_addr() PAGE_OFFSET: 0xffff880000000000
> [    1.189993] __phys_addr() x valid: 0
> 
> So it looks like the root cause is a physical address getting pass in in
> the first place instead of a virtual.

I'd say that's on purpose as we're mapping kernel text 1:1 in the EFI
page table.

Maybe we want this:

---
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 35aecb6042fb..8262d534080d 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -182,7 +182,7 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	efi_scratch.phys_stack += PAGE_SIZE; /* stack grows down */
 
 	npages = (_end - _text) >> PAGE_SHIFT;
-	text = __pa(_text);
+	text = __pa_nodebug(_text);
 
 	if (kernel_map_pages_in_pgd(pgd, text >> PAGE_SHIFT, text, npages, 0)) {
 		pr_err("Failed to map kernel text 1:1\n");


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
