Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaE0Knd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 06:43:33 -0400
Received: from smtp.citrix.com ([66.165.176.89]:50490 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbaE0Knc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 06:43:32 -0400
X-IronPort-AV: E=Sophos;i="4.98,918,1392163200"; 
   d="scan'208";a="136073173"
Message-ID: <53846C4C.1080701@citrix.com>
Date: Tue, 27 May 2014 11:43:24 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mukesh Rathor <mukesh.rathor@oracle.com>, <boris.ostrovsky@oracle.com>,
        <david.vrabel@citrix.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [V1 PATCH] dom0 pvh: map foreign pfns in our p2m
 for toolstack
References: <1400898824-18769-1-git-send-email-mukesh.rathor@oracle.com> <1400898824-18769-2-git-send-email-mukesh.rathor@oracle.com>
In-Reply-To: <1400898824-18769-2-git-send-email-mukesh.rathor@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.118.240]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/05/14 03:33, Mukesh Rathor wrote:
> When running as dom0 in pvh mode, foreign pfns that are accessed must be
> added to our p2m which is managed by xen. This is done via
> XENMEM_add_to_physmap_range hypercall. This is needed for toolstack
> building guests and mapping guest memory, xentrace mapping xen pages,
> etc..
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> ---
>  arch/x86/xen/mmu.c | 115 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 112 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 86e02ea..8efc066 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -2510,6 +2510,93 @@ void __init xen_hvm_init_mmu_ops(void)
>  }
>  #endif
>  
> +#ifdef CONFIG_XEN_PVH
> +/*
> + * Map foreign gmfn, fgmfn, to local pfn, lpfn. This for the user space
> + * creating new guest on pvh dom0 and needing to map domU pages.
> + */
> +static int xlate_add_to_p2m(unsigned long lpfn, unsigned long fgmfn,
> +			    unsigned int domid)
> +{
> +	int rc, err = 0;
> +	xen_pfn_t gpfn = lpfn;
> +	xen_ulong_t idx = fgmfn;
> +
> +	struct xen_add_to_physmap_range xatp = {
> +		.domid = DOMID_SELF,
> +		.foreign_domid = domid,
> +		.size = 1,
> +		.space = XENMAPSPACE_gmfn_foreign,
> +	};
> +	set_xen_guest_handle(xatp.idxs, &idx);
> +	set_xen_guest_handle(xatp.gpfns, &gpfn);
> +	set_xen_guest_handle(xatp.errs, &err);
> +
> +	rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap_range, &xatp);
> +	return rc;

Thanks for the patches, I see two problems with this approach, the first
one is that you are completely ignoring the error in the variable "err",
which means that you can end up with a pfn that Linux thinks it's valid,
but it's not mapped to any mfn, so when you try to access it you will
trigger the vioapic crash.

The second one is that this seems extremely inefficient, you are issuing
one hypercall for each memory page, when you could instead batch all the
pages into a single hypercall and map them in one shot.

Roger.

