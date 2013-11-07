Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab3KGAmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 19:42:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21056 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3KGAmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 19:42:03 -0500
Message-ID: <527AE1CA.7030703@oracle.com>
Date: Thu, 07 Nov 2013 08:41:46 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: konrad.wilk@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen/balloon: Set balloon's initial state
 to number of existing RAM pages
References: <1383770260-15395-1-git-send-email-boris.ostrovsky@oracle.com>
In-Reply-To: <1383770260-15395-1-git-send-email-boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/07/2013 04:37 AM, Boris Ostrovsky wrote:
> Currently balloon's initial value is set to max_pfn which includes
> non-RAM ranges such as MMIO hole. As result, initial memory target
> (specified by guest's configuration file) will appear smaller than
> what balloon driver perceives to be the current number of available
> pages. Thus it will balloon down "extra" pages, decreasing amount of
> available memory for no good reason.
> 

This fix the strange behavior I mentioned yesterday, every time after
guest started balloon driver will be triggered unreasonably.

> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> ---
>  drivers/xen/balloon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> index b232908..1b62304 100644
> --- a/drivers/xen/balloon.c
> +++ b/drivers/xen/balloon.c
> @@ -641,7 +641,7 @@ static int __init balloon_init(void)
>  
>  	balloon_stats.current_pages = xen_pv_domain()
>  		? min(xen_start_info->nr_pages - xen_released_pages, max_pfn)
> -		: max_pfn;
> +		: get_num_physpages();

By the way, should the other places using max_pfn also be changed with
get_num_physpages()?

>  	balloon_stats.target_pages  = balloon_stats.current_pages;
>  	balloon_stats.balloon_low   = 0;
>  	balloon_stats.balloon_high  = 0;
> 

-- 
Regards,
-Bob
