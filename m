Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaIAReL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 13:34:11 -0400
Received: from smtp.citrix.com ([66.165.176.89]:31094 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbaIAReK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 13:34:10 -0400
X-IronPort-AV: E=Sophos;i="5.04,443,1406592000"; 
   d="scan'208";a="166967051"
Message-ID: <5404AE0F.1010207@citrix.com>
Date: Mon, 1 Sep 2014 18:34:07 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefan Bader <stefan.bader@canonical.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: David Vrabel <david.vrabel@citrix.com>, Kees Cook <keescook@chromium.org>
Subject: Re: [Xen-devel] [PATCH] x86/xen: Fix 64bit kernel pagetable setup
 of PV guests
References: <1409325477-2186-1-git-send-email-stefan.bader@canonical.com>
In-Reply-To: <1409325477-2186-1-git-send-email-stefan.bader@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/14 16:17, Stefan Bader wrote:
> 
> This change might not be the fully correct approach as it basically
> removes the pre-set page table entry for the fixmap that is compile
> time set (level2_fixmap_pgt[506]->level1_fixmap_pgt). For one the
> level1 page table is not yet declared in C headers (that might be
> fixed). But also with the current bug, it was removed, too. Since
> the Xen mappings for level2_kernel_pgt only covered kernel + initrd
> and some Xen data this did never reach that far. And still, something
> does create entries at level2_fixmap_pgt[506..507]. So it should be
> ok. At least I was able to successfully boot a kernel with 1G kernel
> image size without any vmalloc whinings.
[...]
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1902,8 +1902,22 @@ void __init xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
>  		/* L3_i[0] -> level2_ident_pgt */
>  		convert_pfn_mfn(level3_ident_pgt);
>  		/* L3_k[510] -> level2_kernel_pgt
> -		 * L3_i[511] -> level2_fixmap_pgt */
> +		 * L3_k[511] -> level2_fixmap_pgt */
>  		convert_pfn_mfn(level3_kernel_pgt);
> +
> +		/* level2_fixmap_pgt contains a single entry for the
> +		 * fixmap area at offset 506. The correct way would
> +		 * be to convert level2_fixmap_pgt to mfn and set the
> +		 * level1_fixmap_pgt (which is completely empty) to RO,
> +		 * too. But currently this page table is not declared,
> +		 * so it would be a bit of voodoo to get its address.
> +		 * And also the fixmap entry was never set due to using
> +		 * the wrong l2 when getting Xen's tables. So let's just
> +		 * just nuke it.
> +		 * This orphans level1_fixmap_pgt, but that was basically
> +		 * done before the change as well.
> +		 */
> +		memset(level2_fixmap_pgt, 0, 512*sizeof(long));

level2_fixmap_pgt etc. are defined for the benefit of Xen only so I
think you should add an extern for level1_fixmap_pgt and fix this up
properly.

It might not matter now, but it might in the future...

David
