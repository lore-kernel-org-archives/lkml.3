Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaKLWSg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:18:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23131 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbaKLWSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:18:35 -0500
Date: Wed, 12 Nov 2014 17:18:13 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH V3 6/8] xen: Hide get_phys_to_machine() to be able to
 tune common path
Message-ID: <20141112221813.GE7549@laptop.dumpdata.com>
References: <1415684626-18590-1-git-send-email-jgross@suse.com>
 <1415684626-18590-7-git-send-email-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415684626-18590-7-git-send-email-jgross@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 06:43:44AM +0100, Juergen Gross wrote:
> Today get_phys_to_machine() is always called when the mfn for a pfn
> is to be obtained. Add a wrapper __pfn_to_mfn() as inline function
> to be able to avoid calling get_phys_to_machine() when possible as

s/when/where/
> soon as the switch to a linear mapped p2m list has been done.

But your inline function still calls get_phys_to_machine?


> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  arch/x86/include/asm/xen/page.h | 27 +++++++++++++++++++++------
>  arch/x86/xen/mmu.c              |  2 +-
>  arch/x86/xen/p2m.c              |  6 +++---
>  3 files changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
> index 28fa795..07d8a7b 100644
> --- a/arch/x86/include/asm/xen/page.h
> +++ b/arch/x86/include/asm/xen/page.h
> @@ -59,6 +59,22 @@ extern int clear_foreign_p2m_mapping(struct gnttab_unmap_grant_ref *unmap_ops,
>  				     struct page **pages, unsigned int count);
>  extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
>  
> +/*
> + * When to use pfn_to_mfn(), __pfn_to_mfn() or get_phys_to_machine():
> + * - pfn_to_mfn() returns either INVALID_P2M_ENTRY or the mfn. In case of an
> + *   identity entry the identity indicator will be cleared.

Why don't you say : In case of identity PFN the same PFN is returned.

But you did miss that also the FOREIGN_FRAME_BIT is cleared.

> + * - __pfn_to_mfn() returns the found entry of the p2m table. A possibly set

s/of the/in the/
> + *   identity indicator will be still set. __pfn_to_mfn() is encapsulating
.. be still set if the PFN is an identity one.
> + *   get_phys_to_machine() and might skip that function if possible to speed
> + *   up the common path.

How is is skipping that function? The patch below does no such thing?

> + * - get_phys_to_machine() is basically the same as __pfn_to_mfn(), but
> + *   without any short cuts for the common fast path.

Right. Perhpas we should call it 'slow_p2m' instead of the 'get_phys_to_machine'.

> + */
> +static inline unsigned long __pfn_to_mfn(unsigned long pfn)
> +{
> +	return get_phys_to_machine(pfn);
> +}
> +
