Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaETO2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:28:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50686 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbaETO2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:28:09 -0400
Message-ID: <537B6663.30005@ti.com>
Date: Tue, 20 May 2014 09:27:47 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, <rjw@rjwysocki.net>
CC: <linaro-kernel@lists.linaro.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <arvind.chauhan@arm.com>,
        <inderpal.s@samsung.com>, <chander.kashyap@linaro.org>, <pavel@ucw.cz>,
        <len.brown@intel.com>, Chander Kashyap <k.chander@samsung.com>,
        Viresh Kumar <viresh.kumar@linrao.org>
Subject: Re: [PATCH V4] PM/OPP: discard duplicate OPPs
References: <d0200ee9e30de19f69ca1b7e53a8cd7a047fa436.1400595283.git.viresh.kumar@linaro.org>
In-Reply-To: <d0200ee9e30de19f69ca1b7e53a8cd7a047fa436.1400595283.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 09:17 AM, Viresh Kumar wrote:
> From: Chander Kashyap <k.chander@samsung.com>
> 
> We don't have any protection against addition of duplicate OPPs currently and
> in case some code tries to add them it will end up corrupting OPP tables.
> 
> There can be many combinations in which we may end up trying duplicate OPPs:
> - both freq and volt are same, but earlier OPP may or may not be active.
> - only freq is same and volt is different.
> 
> This patch tries to implement below logic for these cases:
> 
> Return 0 if new OPP was duplicate of existing one (i.e. same freq and volt) and
> return -EEXIST if new OPP had same freq but different volt as of an existing OPP
> OR if both freq/volt were same but earlier OPP was disabled.
> 
> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
> Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linrao.org>
> ---
> V3->V4:
> - handle duplicate OPPs more appropriately
> - update comment over routine and enhance commit log
> 
> @Chander: I have kept your authorship as is, hope you don't mind me sending it
> on your behalf :)
> 
>  drivers/base/power/opp.c | 25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index 2553867..cd9af42 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -389,6 +389,11 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_floor);
>   * The opp is made available by default and it can be controlled using
>   * dev_pm_opp_enable/disable functions.
>   *
> + * Duplicate OPPs are discarded. Will return 0 if new OPP was duplicate of
> + * existing one (i.e. same freq and volt) and -EEXIST would be returned if new
> + * OPP had same freq but different volt as of an existing OPP OR if both were
> + * same but earlier OPP was disabled.
How about we use the kernel-doc's "Return:"
Return: Returns 0 if new OPP was successfully added OR if the new OPP
was exact duplicate of existing one (i.e. same frequency and volt).
-EEXIST would be returned if new
OPP had same freq but different volt as of an existing OPP OR if both
were same but earlier OPP was disabled. -ENOMEM is returned if there
is no memory available to allocate requisite internal structures.

> + *
>   * Locking: The internal device_opp and opp structures are RCU protected.
>   * Hence this function internally uses RCU updater strategy with mutex locks
>   * to keep the integrity of the internal data structures. Callers should ensure
> @@ -443,15 +448,31 @@ int dev_pm_opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
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
> +	/* Duplicate OPPs ? */
> +	if (new_opp->rate == opp->rate) {
> +		int ret = (new_opp->u_volt == opp->u_volt) && opp->available ?
> +			0 : -EEXIST;
> +
> +		pr_warn("%s: duplicate OPPs detected. Existing: freq: %lu, volt: %lu, enabled: %d. New: freq: %lu, volt: %lu, enabled: %d\n",
dev_warn please? we already know the dev pointer. Also can we reduce
this down to 80 character limit if possible?

> +			__func__, opp->rate, opp->u_volt, opp->available,
> +			new_opp->rate, new_opp->u_volt, new_opp->available);
> +		mutex_unlock(&dev_opp_list_lock);
> +		kfree(new_opp);
> +		return ret;
> +	}
> +
>  	list_add_rcu(&new_opp->node, head);
>  	mutex_unlock(&dev_opp_list_lock);
>  
> 

Otherwise, this looks fine to me.

-- 
Regards,
Nishanth Menon
