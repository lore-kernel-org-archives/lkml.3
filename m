Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaABQ1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 11:27:23 -0500
Received: from smtp.citrix.com ([66.165.176.89]:9117 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbaABQ1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 11:27:22 -0500
X-IronPort-AV: E=Sophos;i="4.95,591,1384300800"; 
   d="scan'208";a="89275865"
Message-ID: <52C59367.70707@citrix.com>
Date: Thu, 2 Jan 2014 16:27:19 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 14/18] xen/grant: Implement an grant frame array struct.
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-15-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1388550945-25499-15-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> The 'xen_hvm_resume_frames' used to be an 'unsigned long'
> and contain the virtual address of the grants. That was OK
> for most architectures (PVHVM, ARM) were the grants are contingous
> in memory. That however is not the case for PVH - in which case
> we will have to do a lookup for each virtual address for the PFN.
> 
> Instead of doing that, lets make it a structure which will contain
> the array of PFNs, the virtual address and the count of said PFNs.
> 
> Also provide a generic functions: gnttab_setup_auto_xlat_frames and
> gnttab_free_auto_xlat_frames to populate said structure with
> appropiate values for PVHVM and ARM.
> 
> To round it off, change the name from 'xen_hvm_resume_frames' to
> a more descriptive one - 'xen_auto_xlat_grant_frames'.
> 
> For PVH, in patch "xen/pvh: Piggyback on PVHVM for grant driver"
> we will populate the 'xen_auto_xlat_grant_frames' by ourselves.
[...]
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
[...]
> @@ -838,6 +838,40 @@ unsigned int gnttab_max_grant_frames(void)
>  }
>  EXPORT_SYMBOL_GPL(gnttab_max_grant_frames);
>  
> +int gnttab_setup_auto_xlat_frames(unsigned long addr)
> +{
> +	xen_pfn_t *pfn;
> +	unsigned int max_nr_gframes = __max_nr_grant_frames();
> +	int i;
> +
> +	if (xen_auto_xlat_grant_frames.count)
> +		return -EINVAL;
> +
> +	pfn = kcalloc(max_nr_gframes, sizeof(pfn[0]), GFP_KERNEL);
> +	if (!pfn)
> +		return -ENOMEM;
> +	for (i = 0; i < max_nr_gframes; i++)
> +		pfn[i] = PFN_DOWN(addr + (i * PAGE_SIZE));

PFN_DOWN(addr) + i looks better to me.

> +
> +	xen_auto_xlat_grant_frames.vaddr = addr;

Huh? addr is a physical address but you're assigning it to a field
called vaddr?  I think you mean to set this field to the result of the
xen_remap() call, yes?

> --- a/include/xen/grant_table.h
> +++ b/include/xen/grant_table.h
> @@ -178,8 +178,15 @@ int arch_gnttab_map_status(uint64_t *frames, unsigned long nr_gframes,
>  			   grant_status_t **__shared);
>  void arch_gnttab_unmap(void *shared, unsigned long nr_gframes);
>  
> -extern unsigned long xen_hvm_resume_frames;
> +struct grant_frames {
> +	xen_pfn_t *pfn;
> +	int count;

unsigned int.

> +	unsigned long vaddr;

void * if this is a virtual address.

David

