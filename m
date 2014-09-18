Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbaIRA5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 20:57:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:18690 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbaIRA5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 20:57:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,543,1406617200"; 
   d="scan'208";a="604534133"
Message-ID: <1411001832.1280.23.camel@rzhang1-toshiba>
Subject: Re: [PATCH] thermal: show supported policies
From: Zhang Rui <rui.zhang@intel.com>
To: Sanjay Singh Rawat <sanjay.rawat@linaro.org>
Cc: edubezval@gmail.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Date: Thu, 18 Sep 2014 08:57:12 +0800
In-Reply-To: <1410865062-28995-1-git-send-email-sanjay.rawat@linaro.org>
References: <1410865062-28995-1-git-send-email-sanjay.rawat@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-16 at 16:27 +0530, Sanjay Singh Rawat wrote:
> With knowledge of supported thermal policies from this attribute, it helps in
> setting the policy without failure from the available ones.
> 
Hmmm, I think it's better to reuse the "policy" attribute.
Say,
#cat policy
user_space [step_wise] fair_share
I'm not sure if this will break any userspace as it's an ABI change, but
we can give it a try, right?

thanks,
-rui
> Signed-off-by: Sanjay Singh Rawat <sanjay.rawat@linaro.org>
> ---
>  drivers/thermal/thermal_core.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 71b0ec0..6caefcd 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -772,6 +772,25 @@ policy_show(struct device *dev, struct device_attribute *devattr, char *buf)
>  	return sprintf(buf, "%s\n", tz->governor->name);
>  }
>  
> +static ssize_t
> +available_policy_show(struct device *dev, struct device_attribute *devattr,
> +			char *buf)
> +{
> +	ssize_t i = 0;
> +	struct thermal_governor *temp;
> +	struct thermal_zone_device *tz = to_thermal_zone(dev);
> +
> +	mutex_lock(&tz->lock);
> +
> +	list_for_each_entry(temp, &thermal_governor_list, governor_list)
> +		i += sprintf(&buf[i], "%s ", temp->name);
> +
> +	mutex_unlock(&tz->lock);
> +	i += sprintf(&buf[i], "\n");
> +
> +	return i;
> +}
> +
>  #ifdef CONFIG_THERMAL_EMULATION
>  static ssize_t
>  emul_temp_store(struct device *dev, struct device_attribute *attr,
> @@ -805,6 +824,7 @@ static DEVICE_ATTR(temp, 0444, temp_show, NULL);
>  static DEVICE_ATTR(mode, 0644, mode_show, mode_store);
>  static DEVICE_ATTR(passive, S_IRUGO | S_IWUSR, passive_show, passive_store);
>  static DEVICE_ATTR(policy, S_IRUGO | S_IWUSR, policy_show, policy_store);
> +static DEVICE_ATTR(available_policy, S_IRUGO, available_policy_show, NULL);
>  
>  /* sys I/F for cooling device */
>  #define to_cooling_device(_dev)	\
> @@ -1538,6 +1558,10 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
>  	if (result)
>  		goto unregister;
>  
> +	result = device_create_file(&tz->device, &dev_attr_available_policy);
> +	if (result)
> +		goto unregister;
> +
>  	/* Update 'this' zone's governor information */
>  	mutex_lock(&thermal_governor_lock);
>  


