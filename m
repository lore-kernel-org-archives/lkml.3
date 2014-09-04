Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaIDMwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 08:52:19 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:65255 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaIDMwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 08:52:18 -0400
X-IronPort-AV: E=Sophos;i="5.04,465,1406592000"; 
   d="scan'208";a="169064891"
Message-ID: <5408607F.6020108@citrix.com>
Date: Thu, 4 Sep 2014 13:52:15 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <jbeulich@suse.com>
Subject: Re: [PATCH 2/3] xen: eliminate scalability issues from initrd handling
References: <1409834326-29287-1-git-send-email-jgross@suse.com> <1409834326-29287-3-git-send-email-jgross@suse.com>
In-Reply-To: <1409834326-29287-3-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/14 13:38, Juergen Gross wrote:
> Size restrictions native kernels wouldn't have resulted from the initrd
> getting mapped into the initial mapping. The kernel doesn't really need
> the initrd to be mapped, so use infrastructure available in Xen to avoid
> the mapping and hence the restriction.
[...]
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
[...]
> @@ -1667,10 +1668,20 @@ asmlinkage __visible void __init xen_start_kernel(void)
>  	new_cpu_data.x86_capability[0] = cpuid_edx(1);
>  #endif
>  
> +	if (xen_start_info->mod_start)
> +		initrd_start = __pa(xen_start_info->mod_start);
> +#ifdef CONFIG_BLK_DEV_INITRD
> +#ifdef CONFIG_X86_32
> +	BUG_ON(xen_start_info->flags & SIF_MOD_START_PFN);
> +#else
> +	if (xen_start_info->flags & SIF_MOD_START_PFN)
> +		initrd_start = PFN_PHYS(xen_start_info->mod_start);
> +#endif
> +#endif

Remove these unnecessary #ifdefs and the BUG_ON().  We can trust Xen to
not set SIF_MOD_START_PFN if we haven't asked for it.

> --- a/arch/x86/xen/xen-head.S
> +++ b/arch/x86/xen/xen-head.S
> @@ -124,6 +124,9 @@ NEXT_HYPERCALL(arch_6)
>  	ELFNOTE(Xen, XEN_ELFNOTE_L1_MFN_VALID,
>  		.quad _PAGE_PRESENT; .quad _PAGE_PRESENT)
>  	ELFNOTE(Xen, XEN_ELFNOTE_SUSPEND_CANCEL, .long 1)
> +#ifdef CONFIG_X86_64
> +	ELFNOTE(Xen, XEN_ELFNOTE_MOD_START_PFN,  .long 1)
> +#endif

Why X86_64 only?  If there's a good reason the commit message needs to
explain why.

David
