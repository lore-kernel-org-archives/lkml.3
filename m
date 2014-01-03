Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaACQoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 11:44:23 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:29975 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaACQoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 11:44:22 -0500
X-IronPort-AV: E=Sophos;i="4.95,598,1384300800"; 
   d="scan'208";a="87398412"
Date: Fri, 3 Jan 2014 16:43:33 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 13/18] xen/grant-table: Refactor gnttab_init
In-Reply-To: <1388550945-25499-14-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1401031642050.8667@kaball.uk.xensource.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-14-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Dec 2013, Konrad Rzeszutek Wilk wrote:
> We have this odd scenario of where for PV paths we take a shortcut
> but for the HVM paths we first ioremap xen_hvm_resume_frames, then
> assign it to gnttab_shared.addr. This is needed because gnttab_map
> uses gnttab_shared.addr.
> 
> Instead of having:
> 	if (pv)
> 		return gnttab_map
> 	if (hvm)
> 		...
> 
> 	gnttab_map
> 
> Lets move the HVM part before the gnttab_map and remove the
> first call to gnttab_map.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/grant-table.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index 99399cb..cc1b4fa 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -1173,22 +1173,17 @@ static int gnttab_setup(void)
>  	if (max_nr_gframes < nr_grant_frames)
>  		return -ENOSYS;
>  
> -	if (xen_pv_domain())
> -		return gnttab_map(0, nr_grant_frames - 1);
> -
> -	if (gnttab_shared.addr == NULL) {
> +	if (xen_feature(XENFEAT_auto_translated_physmap) && gnttab_shared.addr == NULL)
> +	{
>  		gnttab_shared.addr = xen_remap(xen_hvm_resume_frames,
> -						PAGE_SIZE * max_nr_gframes);
> +					       PAGE_SIZE * max_nr_gframes);

                          ^ spurious change
Aside from that:

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  		if (gnttab_shared.addr == NULL) {
>  			pr_warn("Failed to ioremap gnttab share frames (addr=0x%08lx)!\n",
>  					xen_hvm_resume_frames);
>  			return -ENOMEM;
>  		}
>  	}
> -
> -	gnttab_map(0, nr_grant_frames - 1);
> -
> -	return 0;
> +	return gnttab_map(0, nr_grant_frames - 1);
>  }
>  
>  int gnttab_resume(void)
> -- 
> 1.8.3.1
> 
