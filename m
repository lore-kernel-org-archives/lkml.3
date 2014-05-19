Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbaESNIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:08:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44916 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454AbaESNIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:08:34 -0400
Message-ID: <537A0247.1030503@ti.com>
Date: Mon, 19 May 2014 08:08:23 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chander Kashyap <chander.kashyap@linaro.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <rjw@rjwysocki.net>, <pavel@ucw.cz>, <len.brown@intel.com>,
        <gregkh@linuxfoundation.org>, <viresh.kumar@linaro.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Subject: Re: [PATCH v3] PM / OPP: discard duplicate OPPs
References: <1400230809-11401-1-git-send-email-chander.kashyap@linaro.org>
In-Reply-To: <1400230809-11401-1-git-send-email-chander.kashyap@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 04:00 AM, Chander Kashyap wrote:
> From: Chander Kashyap <k.chander@samsung.com>
> 
> This patch detects the duplicate OPP entries and discards them
> 
> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
> Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
> ---
>  Changes in v3:
> 	- Modify the commit log
>  Changes in v2:
> 	- Reorder check for duplicate opp
> 
>  drivers/base/power/opp.c |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index ca521e1..973da78 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -443,15 +443,24 @@ int dev_pm_opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
>  	new_opp->u_volt = u_volt;
>  	new_opp->available = true;
>  
> -	/* Insert new OPP in order of increasing frequency */
> +	/*
> +	 * Insert new OPP in order of increasing frequency
> +	 * and discard if already present
> +	 */
>  	head = &dev_opp->opp_list;
>  	list_for_each_entry_rcu(opp, &dev_opp->opp_list, node) {
> -		if (new_opp->rate < opp->rate)
> +		if (new_opp->rate <= opp->rate)
>  			break;
>  		else
>  			head = &opp->node;
>  	}
>  
> +	if (new_opp->rate == opp->rate) {
> +		mutex_unlock(&dev_opp_list_lock);
> +		kfree(new_opp);
> +		return 0;

IF we decide on ensuring that the OPP additions are done one time[1] -
then returning -EEXIST is appropriate here. we want to be able to
catch warnings of sequencing errors, and returning 0 is not the way to
do it.

> +	}
> +
>  	list_add_rcu(&new_opp->node, head);
>  	mutex_unlock(&dev_opp_list_lock);
>  
> 

[1] http://marc.info/?l=linux-pm&m=140034777229205&w=2

-- 
Regards,
Nishanth Menon
