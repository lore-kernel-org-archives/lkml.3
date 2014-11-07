Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbaKGNyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:54:41 -0500
Received: from smtp.citrix.com ([66.165.176.89]:55147 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbaKGNyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:54:35 -0500
X-IronPort-AV: E=Sophos;i="5.07,332,1413244800"; 
   d="scan'208";a="189129741"
Message-ID: <545CCF15.4070402@citrix.com>
Date: Fri, 7 Nov 2014 13:54:29 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>,
        <x86@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH V2 5/5] Xen: switch to linear virtual mapped
 sparse p2m list
References: <1415252853-7106-1-git-send-email-jgross@suse.com> <1415252853-7106-6-git-send-email-jgross@suse.com>
In-Reply-To: <1415252853-7106-6-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/14 05:47, Juergen Gross wrote:
> At start of the day the Xen hypervisor presents a contiguous mfn list
> to a pv-domain. In order to support sparse memory this mfn list is
> accessed via a three level p2m tree built early in the boot process.
> Whenever the system needs the mfn associated with a pfn this tree is
> used to find the mfn.
> 
> Instead of using a software walked tree for accessing a specific mfn
> list entry this patch is creating a virtual address area for the
> entire possible mfn list including memory holes. The holes are
> covered by mapping a pre-defined  page consisting only of "invalid
> mfn" entries. Access to a mfn entry is possible by just using the
> virtual base address of the mfn list and the pfn as index into that
> list. This speeds up the (hot) path of determining the mfn of a
> pfn.
> 
> Kernel build on a Dell Latitude E6440 (2 cores, HT) in 64 bit Dom0
> showed following improvements:
> 
> Elapsed time: 32:50 ->  32:35
> System:       18:07 ->  17:47
> User:        104:00 -> 103:30

After implementing my suggestions below, please provided updated figure.
 They should be better.

> Tested on 64 bit dom0 and 32 bit domU.
[...]
> --- a/arch/x86/include/asm/xen/page.h
> +++ b/arch/x86/include/asm/xen/page.h
> @@ -59,6 +59,23 @@ extern int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
>  				     struct page **pages, unsigned int count);
>  extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
>  
> +static inline unsigned long __pfn_to_mfn(unsigned long pfn)

These variations of pfn_to_mfn() (__pfn_to_mfn() and
get_phys_to_machine() and any others), need comments explaining their
differences.

Can you add __pfn_to_mfn() and the docs in a separate patch?

> +	pr_notice("p2m virtual area at %p, size is %lx\n", vm.addr, vm.size);

pr_info().

> @@ -526,23 +411,83 @@ unsigned long get_phys_to_machine(unsigned long pfn)
>  		return IDENTITY_FRAME(pfn);
>  	}
>  
> -	topidx = p2m_top_index(pfn);
> -	mididx = p2m_mid_index(pfn);
> -	idx = p2m_index(pfn);
> +	ptep = lookup_address((unsigned long)(xen_p2m_addr + pfn), &level);
> +	BUG_ON(!ptep || level != PG_LEVEL_4K);
>  
>  	/*
>  	 * The INVALID_P2M_ENTRY is filled in both p2m_*identity
>  	 * and in p2m_*missing, so returning the INVALID_P2M_ENTRY
>  	 * would be wrong.
>  	 */
> -	if (p2m_top[topidx][mididx] == p2m_identity)
> +	if (pte_pfn(*ptep) == PFN_DOWN(__pa(p2m_identity)))
>  		return IDENTITY_FRAME(pfn);
>  
> -	return p2m_top[topidx][mididx][idx];
> +	return xen_p2m_addr[pfn];

You should test xen_p2m_addr[pfn] == INVALID_P2M_ENTRY before checking
if it's an identity entry.  This should skip the more expensive
lookup_address() in the common case.

>  bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)

I think you should map p2m_missing and p2m_identity as read-only and do
the new page allocation on a write fault.

set_phys_to_machine() is used every grant map and unmap and in the
common case (already allocated array page) it must be a fast and simple:

    xen_p2m_addr[pfn] = mfn;

David
