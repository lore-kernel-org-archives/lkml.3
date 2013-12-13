Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3LML5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 06:57:04 -0500
Received: from smtp.citrix.com ([66.165.176.89]:15280 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583Ab3LML5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 06:57:01 -0500
X-IronPort-AV: E=Sophos;i="4.95,478,1384300800"; 
   d="scan'208";a="84242331"
Date: Fri, 13 Dec 2013 11:56:31 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <george.dunlap@eu.citrix.com>, <ian.jackson@eu.citrix.com>,
        <mukesh.rathor@oracle.com>, <tim@xen.org>, <jbeulich@suse.com>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH V10 05/14] xen/pvh: balloon and grant changes.
In-Reply-To: <1386900621-27528-6-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1312131147230.8667@kaball.uk.xensource.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com> <1386900621-27528-6-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Dec 2013, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> For balloon changes we skip setting of local P2M as it's updated
> in Xen. For grant, the shared grant frame is the PFN and not MFN,
> hence its mapped via the same code path as HVM.
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> [v1: Rebase on v3.7-rc3]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> CC: <stefano.stabellini@eu.citrix.com>
> Conflicts:
> 	drivers/xen/balloon.c
> [v2: Rebase on v3.13-rc3 has lot of ARM changes.]
> ---
>  drivers/xen/balloon.c     |   37 ++++++++++++++++++++-----------------
>  drivers/xen/gntdev.c      |    3 ++-
>  drivers/xen/grant-table.c |   25 ++++++++++++++++++++++---
>  3 files changed, 44 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> index 55ea73f..0e9875a 100644
> --- a/drivers/xen/balloon.c
> +++ b/drivers/xen/balloon.c
> @@ -354,7 +354,9 @@ static enum bp_state increase_reservation(unsigned long nr_pages)
>  
>  #ifdef CONFIG_XEN_HAVE_PVMMU
>  		/* Link back into the page tables if not highmem. */
> -		if (xen_pv_domain() && !PageHighMem(page)) {
> +		if (xen_pv_domain() && !PageHighMem(page) &&
> +		    !xen_feature(XENFEAT_auto_translated_physmap)) {
> +
>  			int ret;
>  			ret = HYPERVISOR_update_va_mapping(
>  				(unsigned long)__va(pfn << PAGE_SHIFT),
> @@ -411,28 +413,29 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
>  
>  		scrub_page(page);
>  
> -		/*
> -		 * Ballooned out frames are effectively replaced with
> -		 * a scratch frame.  Ensure direct mappings and the
> -		 * p2m are consistent.
> -		 */
> -		scratch_page = get_balloon_scratch_page();
> +		if (!xen_feature(XENFEAT_auto_translated_physmap)) {
> +			unsigned long p;
> +
> +			/*
> +			 * Ballooned out frames are effectively replaced with
> +			 * a scratch frame.  Ensure direct mappings and the
> +			 * p2m are consistent.
> +			 */
> +			scratch_page = get_balloon_scratch_page();
>  #ifdef CONFIG_XEN_HAVE_PVMMU
> -		if (xen_pv_domain() && !PageHighMem(page)) {
> -			ret = HYPERVISOR_update_va_mapping(
> -				(unsigned long)__va(pfn << PAGE_SHIFT),
> -				pfn_pte(page_to_pfn(scratch_page),
> +			if (xen_pv_domain() && !PageHighMem(page)) {
> +				ret = HYPERVISOR_update_va_mapping(
> +					(unsigned long)__va(pfn << PAGE_SHIFT),
> +					pfn_pte(page_to_pfn(scratch_page),
>  					PAGE_KERNEL_RO), 0);
> -			BUG_ON(ret);
> -		}
> +				BUG_ON(ret);
> +			}
>  #endif
> -		if (!xen_feature(XENFEAT_auto_translated_physmap)) {
> -			unsigned long p;
>  			p = page_to_pfn(scratch_page);
>  			__set_phys_to_machine(pfn, pfn_to_mfn(p));
> -		}
> -		put_balloon_scratch_page();
>  
> +			put_balloon_scratch_page();
> +		}
>  		balloon_append(pfn_to_page(pfn));
>  	}

These changes to balloon.c are similar to my patch but:

- they don't prevent set_phys_to_machine from being called by
increase_reservation for auto_translated guests

- they don't prevent wasteful balloon_scratch_page from being allocated
for auto_translated guests

I think that it would be best to take my patch instead.



> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
> index e41c79c..c1ae3ce 100644
> --- a/drivers/xen/gntdev.c
> +++ b/drivers/xen/gntdev.c
> @@ -846,7 +846,8 @@ static int __init gntdev_init(void)
>  	if (!xen_domain())
>  		return -ENODEV;
>  
> -	use_ptemod = xen_pv_domain();
> +	use_ptemod = xen_pv_domain() &&
> +		     !xen_feature(XENFEAT_auto_translated_physmap);
>  
>  	err = misc_register(&gntdev_miscdev);
>  	if (err != 0) {

you might actually just want to have:
    
use_ptemod = !xen_feature(XENFEAT_auto_translated_physmap);




> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index 0283871..1fcf75b 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -1056,14 +1056,20 @@ static void gnttab_unmap_frames_v2(void)
>  static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
>  {
>  	struct gnttab_setup_table setup;
> +	unsigned long start_gpfn;
>  	xen_pfn_t *frames;
>  	unsigned int nr_gframes = end_idx + 1;
>  	int rc;
>  
> -	if (xen_hvm_domain()) {
> +	if (xen_hvm_domain() || xen_feature(XENFEAT_auto_translated_physmap)) {
>  		struct xen_add_to_physmap xatp;
>  		unsigned int i = end_idx;
>  		rc = 0;
> +
> +		if (xen_hvm_domain())
> +			start_gpfn = xen_hvm_resume_frames >> PAGE_SHIFT;
> +		else
> +			start_gpfn = virt_to_pfn(gnttab_shared.addr);
>  		/*
>  		 * Loop backwards, so that the first hypercall has the largest
>  		 * index, ensuring that the table will grow only once.
> @@ -1072,7 +1078,7 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
>  			xatp.domid = DOMID_SELF;
>  			xatp.idx = i;
>  			xatp.space = XENMAPSPACE_grant_table;
> -			xatp.gpfn = (xen_hvm_resume_frames >> PAGE_SHIFT) + i;
> +			xatp.gpfn = start_gpfn + i;
>  			rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp);
>  			if (rc != 0) {
>  				pr_warn("grant table add_to_physmap failed, err=%d\n",
> @@ -1135,7 +1141,7 @@ static void gnttab_request_version(void)
>  	int rc;
>  	struct gnttab_set_version gsv;
>  
> -	if (xen_hvm_domain())
> +	if (xen_hvm_domain() || xen_feature(XENFEAT_auto_translated_physmap))
>  		gsv.version = 1;
>  	else
>  		gsv.version = 2;
> @@ -1164,11 +1170,24 @@ static void gnttab_request_version(void)
>  static int gnttab_setup(void)
>  {
>  	unsigned int max_nr_gframes;
> +	char *kmsg = "Failed to kmalloc pages for pv in hvm grant frames\n";
>  
>  	max_nr_gframes = gnttab_max_grant_frames();
>  	if (max_nr_gframes < nr_grant_frames)
>  		return -ENOSYS;
>  
> +	/* PVH note: xen will free existing kmalloc'd mfn in
> +	 * XENMEM_add_to_physmap. TBD/FIXME: use xen ballooning instead of
> +	 * kmalloc(). */
> +	if (xen_pv_domain() && xen_feature(XENFEAT_auto_translated_physmap) &&
> +	    !gnttab_shared.addr) {
> +		gnttab_shared.addr =
> +			kmalloc(max_nr_gframes * PAGE_SIZE, GFP_KERNEL);
> +		if (!gnttab_shared.addr) {
> +			pr_warn("%s", kmsg);
> +			return -ENOMEM;
> +		}
> +	}
>  	if (xen_pv_domain())
>  		return gnttab_map(0, nr_grant_frames - 1);

Can't you just use xen_hvm_resume_frames instead? Just rename it
xen_auto_translated_frames and allocate memory to it from
arch/x86/xen/enlighten.c.
Then you can completely unify the hvm and pvh code paths in this file,
as a result all the

if (xen_hvm_domain() || xen_feature(XENFEAT_auto_translated_physmap))

tests, could be reduced to

if (xen_feature(XENFEAT_auto_translated_physmap))
