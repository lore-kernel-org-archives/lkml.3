Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab3D2OfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 10:35:16 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:19090 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab3D2OfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 10:35:14 -0400
X-IronPort-AV: E=Sophos;i="4.87,552,1363132800"; 
   d="scan'208";a="4040847"
Message-ID: <1367246111.3142.309.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH v2 1/2] xen/balloon: Notify a host about a guest memory
 size limit
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: "carsten@schiers.de" <carsten@schiers.de>,
        "darren.s.shepherd@gmail.com" <darren.s.shepherd@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "Ian Jackson" <Ian.Jackson@eu.citrix.com>,
        "james-xen@dingwall.me.uk" <james-xen@dingwall.me.uk>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Date: Mon, 29 Apr 2013 15:35:11 +0100
In-Reply-To: <1367235468-8360-2-git-send-email-daniel.kiper@oracle.com>
References: <1367235468-8360-1-git-send-email-daniel.kiper@oracle.com>
	 <1367235468-8360-2-git-send-email-daniel.kiper@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-29 at 12:37 +0100, Daniel Kiper wrote:
> Notify a host about a guest memory size limit.
> 
> Idea of this patch was discussed with Ian Campbell and Ian Jackson.
> 
> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> ---
>  drivers/xen/balloon.c |   25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> index a56776d..856661f 100644
> --- a/drivers/xen/balloon.c
> +++ b/drivers/xen/balloon.c
> @@ -65,6 +65,7 @@
>  #include <xen/balloon.h>
>  #include <xen/features.h>
>  #include <xen/page.h>
> +#include <xen/xenbus.h>
>  
>  /*
>   * balloon_process() state:
> @@ -586,6 +587,9 @@ static void __init balloon_add_region(unsigned long start_pfn,
>  static int __init balloon_init(void)
>  {
>  	int i;
> +#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
> +	int rc;
> +#endif
>  
>  	if (!xen_domain())
>  		return -ENODEV;
> @@ -621,6 +625,27 @@ static int __init balloon_init(void)
>  			balloon_add_region(PFN_UP(xen_extra_mem[i].start),
>  					   PFN_DOWN(xen_extra_mem[i].size));
>  
> +#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
> +	/*
> +	 * Notify a host about our memory size limit.
> +	 *
> +	 * The guest-max value is in KiB, so MAX_DOMAIN_PAGES should
> +	 * be converted respectively. PAGE_SHIFT converts pages to bytes,
> +	 * hence PAGE_SHIFT - 10.
> +	 */
> +	rc = xenbus_printf(XBT_NIL, "memory", "guest-max", "%lu",
> +				MAX_DOMAIN_PAGES << (PAGE_SHIFT - 10));
> +
> +	if (rc < 0)
> +		pr_info("xen/balloon: Memory hotplug may not be supported "
> +			"in some environments: %i\n", rc);
> +#else
> +	xenbus_printf(XBT_NIL, "memory", "guest-max", "%lu",

Would it be OK to not do anything in the non-hotplug case? That's just
the historical behaviour right?

Would you expect this value to differ from static-max?

> +			(balloon_stats.current_pages +
> +			 balloon_stats.balloon_low +
> +			 balloon_stats.balloon_high) << (PAGE_SHIFT - 10));
> +#endif
> +
>  	return 0;
>  }
>  


