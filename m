Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbaIQNpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 09:45:20 -0400
Received: from smtp.citrix.com ([66.165.176.89]:45904 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbaIQNpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:45:16 -0400
X-IronPort-AV: E=Sophos;i="5.04,540,1406592000"; 
   d="scan'208";a="172413805"
Message-ID: <54199065.1020200@citrix.com>
Date: Wed, 17 Sep 2014 14:45:09 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH V2 2/3] xen: eliminate scalability issues
 from initrd handling
References: <1410927157-15069-1-git-send-email-jgross@suse.com> <1410927157-15069-3-git-send-email-jgross@suse.com>
In-Reply-To: <1410927157-15069-3-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/09/14 05:12, Juergen Gross wrote:
> Size restrictions native kernels wouldn't have resulted from the initrd
> getting mapped into the initial mapping. The kernel doesn't really need
> the initrd to be mapped, so use infrastructure available in Xen to avoid
> the mapping and hence the restriction.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  arch/x86/xen/enlighten.c | 11 +++++++++--
>  arch/x86/xen/xen-head.S  |  1 +
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index c0cb11f..8fd075f 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1519,6 +1519,7 @@ static void __init xen_pvh_early_guest_init(void)
>  asmlinkage __visible void __init xen_start_kernel(void)
>  {
>  	struct physdev_set_iopl set_iopl;
> +	unsigned long initrd_start = 0;
>  	int rc;
>  
>  	if (!xen_start_info)
> @@ -1667,10 +1668,16 @@ asmlinkage __visible void __init xen_start_kernel(void)
>  	new_cpu_data.x86_capability[0] = cpuid_edx(1);
>  #endif
>  
> +	if (xen_start_info->mod_start)
> +		initrd_start = __pa(xen_start_info->mod_start);
> +#ifdef CONFIG_BLK_DEV_INITRD
> +	if (xen_start_info->flags & SIF_MOD_START_PFN)
> +		initrd_start = PFN_PHYS(xen_start_info->mod_start);
> +#endif

Why the #ifdef?

I'll fix this up to be:

   if (xen_start_info->mod_start) {
       if (xen_start_info->flags & SIF_MOD_START_PFN)
           initrd_start = PFN_PHYS_(xen_start_info->mod_start);
       else
           initrd_start = __pa(xen_start_info->mod_start);
   }

Unless you object.

David
