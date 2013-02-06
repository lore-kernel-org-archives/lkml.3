Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab3BFPzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:55:36 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:39207 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab3BFPzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:55:35 -0500
Date: Wed, 6 Feb 2013 10:49:13 -0500
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH] PVH linux: Use ballooning to allocate grant table pages
Message-ID: <20130206154910.GA31828@konrad-lan.dumpdata.com>
References: <20130131183015.13bc2bff@mantra.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131183015.13bc2bff@mantra.us.oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 06:30:15PM -0800, Mukesh Rathor wrote:
> This patch fixes a fixme in Linux to use alloc_xenballooned_pages() to
> allocate pfns for grant table pages instead of kmalloc. This also
> simplifies add to physmap on the xen side a bit.

Pulled this.
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> ---
>  drivers/xen/grant-table.c |   37 ++++++++++++++++++++++++++-----------
>  1 files changed, 26 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index 9c0019d..d731f39 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -47,6 +47,7 @@
>  #include <xen/grant_table.h>
>  #include <xen/interface/memory.h>
>  #include <xen/hvc-console.h>
> +#include <xen/balloon.h>
>  #include <asm/xen/hypercall.h>
>  #include <asm/xen/interface.h>
>  
> @@ -1138,27 +1139,41 @@ static void gnttab_request_version(void)
>  		grant_table_version);
>  }
>  
> +static int xlated_setup_gnttab_pages(int numpages, void **addr)
> +{
> +	int i, rc;
> +	unsigned long pfns[numpages];
> +	struct page *pages[numpages];
> +
> +	rc = alloc_xenballooned_pages(numpages, pages, 0);
> +	if (rc != 0) {
> +		pr_warn("%s Could not balloon alloc %d pfns rc:%d\n", __func__,
> +			numpages, rc);
> +		return -ENOMEM;
> +	}
> +	for (i = 0; i < numpages; i++)
> +		pfns[i] = page_to_pfn(pages[i]);
> +
> +	rc = arch_gnttab_map_shared(pfns, numpages, numpages, addr);
> +	return rc;
> +}
> +
>  int gnttab_resume(void)
>  {
> -	unsigned int max_nr_gframes;
> -	char *kmsg = "Failed to kmalloc pages for pv in hvm grant frames\n";
> +	unsigned int rc, max_nr_gframes;
>  
>  	gnttab_request_version();
>  	max_nr_gframes = gnttab_max_grant_frames();
>  	if (max_nr_gframes < nr_grant_frames)
>  		return -ENOSYS;
>  
> -	/* PVH note: xen will free existing kmalloc'd mfn in
> -	 * XENMEM_add_to_physmap. TBD/FIXME: use xen ballooning instead of
> -	 * kmalloc(). */
>  	if (xen_pv_domain() && xen_feature(XENFEAT_auto_translated_physmap) &&
>  	    !gnttab_shared.addr) {
> -		gnttab_shared.addr =
> -			kmalloc(max_nr_gframes * PAGE_SIZE, GFP_KERNEL);
> -		if (!gnttab_shared.addr) {
> -			pr_warn("%s", kmsg);
> -			return -ENOMEM;
> -		}
> +
> +		rc = xlated_setup_gnttab_pages(max_nr_gframes,
> +					       &gnttab_shared.addr);
> +		if (rc != 0)
> +			return rc;
>  	}
>  	if (xen_pv_domain())
>  		return gnttab_map(0, nr_grant_frames - 1);
> -- 
> 1.7.2.3
> 
