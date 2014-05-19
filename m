Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964773AbaESNNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:13:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45118 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932229AbaESNNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:13:43 -0400
Message-ID: <537A037E.8000800@ti.com>
Date: Mon, 19 May 2014 08:13:34 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Inderpal Singh <inderpal.s@samsung.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <rjw@rjwysocki.net>, <pavel@ucw.cz>, <viresh.kumar@linaro.org>
Subject: Re: [PATCH] PM / OPP: Implement free_opp_table function
References: <1400231366-1221-1-git-send-email-inderpal.s@samsung.com>
In-Reply-To: <1400231366-1221-1-git-send-email-inderpal.s@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 04:09 AM, Inderpal Singh wrote:
> At the driver unloading time the associated opp table may need
> to be deleted. Otherwise it amounts to memory leak. The existing
> OPP library does not have provison to do so.
> 
> Hence this patch implements the function to free the opp table.
> 
> Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
> ---
>  drivers/base/power/opp.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/pm_opp.h   |  6 ++++++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index d9e376a..d45ffd5 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -654,4 +654,45 @@ int of_init_opp_table(struct device *dev)
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(of_init_opp_table);
> +
> +/**
> + * dev_pm_opp_free_opp_table() - free the opp table
> + * @dev:	device for which we do this operation
> + *
> + * Free up the allocated opp table
> + *
> + * Locking: The internal device_opp and opp structures are RCU protected.
> + * Hence this function internally uses RCU updater strategy with mutex locks to
> + * keep the integrity of the internal data structures. Callers should ensure
> + * that this function is *NOT* called under RCU protection or in contexts where
> + * mutex locking or synchronize_rcu() blocking calls cannot be used.
> + */
> +void dev_pm_opp_free_opp_table(struct device *dev)
> +{
> +	struct device_opp *dev_opp = NULL;
> +	struct dev_pm_opp *opp;
> +
if (!dev)
	return;

> +	/* Hold our list modification lock here */
> +	mutex_lock(&dev_opp_list_lock);
> +
> +	/* Check for existing list for 'dev' */
> +	dev_opp = find_device_opp(dev);
> +	if (IS_ERR(dev_opp)) {
> +		mutex_unlock(&dev_opp_list_lock);
> +		return;
> +	}
> +
> +	while (!list_empty(&dev_opp->opp_list)) {
> +		opp = list_entry_rcu(dev_opp->opp_list.next,
> +					struct dev_pm_opp, node);
> +		list_del_rcu(&opp->node);
> +		kfree_rcu(opp, head);
> +	}

How about the OPP notifiers? should'nt we add a new event
OPP_EVENT_REMOVE?

To maintain non-dt behavior coherency, should'nt we rather add a
opp_remove or an opp_del function?

> +
> +	list_del_rcu(&dev_opp->node);
> +	mutex_unlock(&dev_opp_list_lock);
> +	synchronize_rcu();
> +	kfree(dev_opp);
> +}
> +EXPORT_SYMBOL_GPL(dev_pm_opp_free_opp_table);
>  #endif
> diff --git a/include/linux/pm_opp.h b/include/linux/pm_opp.h
> index 0330217..3c29620 100644
> --- a/include/linux/pm_opp.h
> +++ b/include/linux/pm_opp.h
> @@ -50,6 +50,8 @@ int dev_pm_opp_enable(struct device *dev, unsigned long freq);
>  int dev_pm_opp_disable(struct device *dev, unsigned long freq);
>  
>  struct srcu_notifier_head *dev_pm_opp_get_notifier(struct device *dev);
> +
> +void dev_pm_opp_free_opp_table(struct device *dev);
>  #else
>  static inline unsigned long dev_pm_opp_get_voltage(struct dev_pm_opp *opp)
>  {
> @@ -105,6 +107,10 @@ static inline struct srcu_notifier_head *dev_pm_opp_get_notifier(
>  {
>  	return ERR_PTR(-EINVAL);
>  }
> +
> +void dev_pm_opp_free_opp_table(struct device *dev)
> +{
> +}
>  #endif		/* CONFIG_PM_OPP */
>  
>  #if defined(CONFIG_PM_OPP) && defined(CONFIG_OF)
> 


-- 
Regards,
Nishanth Menon
