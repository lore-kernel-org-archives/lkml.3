Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaLXQ3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 11:29:03 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49336 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbaLXQ3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 11:29:00 -0500
Message-ID: <549AE9BA.2050308@ti.com>
Date: Wed, 24 Dec 2014 10:28:42 -0600
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
Subject: Re: [PATCH 1/4] PM / OPP: add some lockdep annotations
References: <1418771379-24369-1-git-send-email-dtor@chromium.org> <1418771379-24369-2-git-send-email-dtor@chromium.org>
In-Reply-To: <1418771379-24369-2-git-send-email-dtor@chromium.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 05:09 PM, Dmitry Torokhov wrote:
> Certain OPP APIs need to be called under RCU lock; let's add a few
> rcu_lockdep_assert() calls to warn about potential misuse.
> 
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
> ---
>  drivers/base/power/opp.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index d24dd614a..b78c14d 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -108,6 +108,14 @@ static LIST_HEAD(dev_opp_list);
>  /* Lock to allow exclusive modification to the device and opp lists */
>  static DEFINE_MUTEX(dev_opp_list_lock);
>  
> +#define opp_rcu_lockdep_assert()					\
> +do {									\
> +	rcu_lockdep_assert(rcu_read_lock_held() ||			\
> +				lockdep_is_held(&dev_opp_list_lock),	\
> +			   "Missing rcu_read_lock() or "		\
> +			   "dev_opp_list_lock protection");		\
> +} while (0)
> +
>  /**
>   * find_device_opp() - find device_opp struct using device pointer
>   * @dev:	device pointer used to lookup device OPPs
> @@ -218,6 +226,8 @@ int dev_pm_opp_get_opp_count(struct device *dev)
>  	struct dev_pm_opp *temp_opp;
>  	int count = 0;
>  
> +	opp_rcu_lockdep_assert();
> +
>  	dev_opp = find_device_opp(dev);
>  	if (IS_ERR(dev_opp)) {
>  		int r = PTR_ERR(dev_opp);
> @@ -267,6 +277,8 @@ struct dev_pm_opp *dev_pm_opp_find_freq_exact(struct device *dev,
>  	struct device_opp *dev_opp;
>  	struct dev_pm_opp *temp_opp, *opp = ERR_PTR(-ERANGE);
>  
> +	opp_rcu_lockdep_assert();
> +
>  	dev_opp = find_device_opp(dev);
>  	if (IS_ERR(dev_opp)) {
>  		int r = PTR_ERR(dev_opp);
> @@ -313,6 +325,8 @@ struct dev_pm_opp *dev_pm_opp_find_freq_ceil(struct device *dev,
>  	struct device_opp *dev_opp;
>  	struct dev_pm_opp *temp_opp, *opp = ERR_PTR(-ERANGE);
>  
> +	opp_rcu_lockdep_assert();
> +
>  	if (!dev || !freq) {
>  		dev_err(dev, "%s: Invalid argument freq=%p\n", __func__, freq);
>  		return ERR_PTR(-EINVAL);
> @@ -361,6 +375,8 @@ struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
>  	struct device_opp *dev_opp;
>  	struct dev_pm_opp *temp_opp, *opp = ERR_PTR(-ERANGE);
>  
> +	opp_rcu_lockdep_assert();
> +
>  	if (!dev || !freq) {
>  		dev_err(dev, "%s: Invalid argument freq=%p\n", __func__, freq);
>  		return ERR_PTR(-EINVAL);
> 

You should also add opp_rcu_lockdep_assert to the following functions:
dev_pm_opp_get_voltage and dev_pm_opp_get_freq - both of which must be
used under rcu read lock.

dev_pm_opp_get_notifier references the RCU protected dev_opp list ->
so that must also be under rcu read lock.


love the concept, and I suggest splitting this into the following:

RCU readers: trivial as rcu_read_lock_help dumps
RCU updates: (adding, updating, removing): for the helper functions
ensure mutex_lock held assertion.



-- 
Regards,
Nishanth Menon
