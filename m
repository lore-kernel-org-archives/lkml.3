Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaLXQse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 11:48:34 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35977 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbaLXQsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 11:48:32 -0500
Message-ID: <549AEE52.9080607@ti.com>
Date: Wed, 24 Dec 2014 10:48:18 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@chromium.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] PM / OPP: take RCU lock in dev_pm_opp_get_opp_count
References: <1418771379-24369-1-git-send-email-dtor@chromium.org> <1418771379-24369-4-git-send-email-dtor@chromium.org>
In-Reply-To: <1418771379-24369-4-git-send-email-dtor@chromium.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 05:09 PM, Dmitry Torokhov wrote:
> A lot of callers are missing the fact that dev_pm_opp_get_opp_count
> needs to be called under RCU lock. Given that RCU locks can safely be
> nested, instead of providing *_locked() API, let's take RCU lock inside
> dev_pm_opp_get_opp_count() and leave callers as is.

While it is true that we can safely do nested RCU locks, This also
encourages wrong usage.

count = dev_pm_opp_get_opp_count(dev)
^^ point A
array   = kzalloc(count * sizeof (*array));
rcu_read_lock();
^^ point B
.. work down the list and add OPPs..
...

Between A and B, we might have had list modification (dynamic OPP
addition or deletion) - which implies that the count is no longer
accurate between point A and B. instead, enforcing callers to have the
responsibility of rcu_lock is exactly what we have to do since the OPP
library has no clue how to enforce pointer or data accuracy.

Sorry, NAK. this setsup stage for further similar additions to
get_voltage, freq etc.. basically encourages errorneous usage of the
functions and misinterpretation of data procured.

> 
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
> ---
>  drivers/base/power/opp.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index 413c7fe..ee5eca2 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -216,9 +216,7 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_get_freq);
>   * This function returns the number of available opps if there are any,
>   * else returns 0 if none or the corresponding error value.
>   *
> - * Locking: This function must be called under rcu_read_lock(). This function
> - * internally references two RCU protected structures: device_opp and opp which
> - * are safe as long as we are under a common RCU locked section.
> + * Locking: This function takes rcu_read_lock().
>   */
>  int dev_pm_opp_get_opp_count(struct device *dev)
>  {
> @@ -226,13 +224,14 @@ int dev_pm_opp_get_opp_count(struct device *dev)
>  	struct dev_pm_opp *temp_opp;
>  	int count = 0;
>  
> -	opp_rcu_lockdep_assert();
> +	rcu_read_lock();
>  
>  	dev_opp = find_device_opp(dev);
>  	if (IS_ERR(dev_opp)) {
> -		int r = PTR_ERR(dev_opp);
> -		dev_err(dev, "%s: device OPP not found (%d)\n", __func__, r);
> -		return r;
> +		count = PTR_ERR(dev_opp);
> +		dev_err(dev, "%s: device OPP not found (%d)\n",
> +			__func__, count);
> +		goto out_unlock;
>  	}
>  
>  	list_for_each_entry_rcu(temp_opp, &dev_opp->opp_list, node) {
> @@ -240,6 +239,8 @@ int dev_pm_opp_get_opp_count(struct device *dev)
>  			count++;
>  	}
>  
> +out_unlock:
> +	rcu_read_unlock();
>  	return count;
>  }
>  EXPORT_SYMBOL_GPL(dev_pm_opp_get_opp_count);
> 
-- 
Regards,
Nishanth Menon
