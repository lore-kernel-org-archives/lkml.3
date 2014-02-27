Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaB0GoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 01:44:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:16368 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbaB0GoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 01:44:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,552,1389772800"; 
   d="scan'208";a="490714889"
Message-ID: <1393483447.2637.10.camel@rzhang1-mobl4>
Subject: Re: [PATCH 1/1] thermal: fix default governor assignment
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Wei Ni <wni@nvidia.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 27 Feb 2014 14:44:07 +0800
In-Reply-To: <1389725137-16147-1-git-send-email-eduardo.valentin@ti.com>
References: <1389725137-16147-1-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-14 at 14:45 -0400, Eduardo Valentin wrote:
> When registering a thermal zone, passing an invalid
> .governor_name via struct thermal_zone_params may
> create a thermal zone without a governor, when it
> is supposed to be the default governor.
> 
> This patch fixes this issue by assigning the
> default governor, whenever the zone has a governor
> set to NULL.
> 
please check if the patch at https://patchwork.kernel.org/patch/3730391/
fixes the same problem?

thanks,
rui

> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Reported-by: Wei Ni <wni@nvidia.com>
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  drivers/thermal/thermal_core.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index a621e90..967d980 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -89,7 +89,7 @@ int thermal_register_governor(struct thermal_governor *governor)
>  	list_for_each_entry(pos, &thermal_tz_list, node) {
>  		if (pos->governor)
>  			continue;
> -		if (pos->tzp)
> +		if (pos->tzp && pos->tzp->governor_name)
>  			name = pos->tzp->governor_name;
>  		else
>  			name = DEFAULT_THERMAL_GOVERNOR;
> @@ -1527,9 +1527,10 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
>  	/* Update 'this' zone's governor information */
>  	mutex_lock(&thermal_governor_lock);
>  
> -	if (tz->tzp)
> +	if (tz->tzp && tz->tzp->governor_name)
>  		tz->governor = __find_governor(tz->tzp->governor_name);
> -	else
> +
> +	if (!tz->governor)
>  		tz->governor = __find_governor(DEFAULT_THERMAL_GOVERNOR);
>  
>  	mutex_unlock(&thermal_governor_lock);


