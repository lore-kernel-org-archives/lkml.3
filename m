Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab3IYWRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:17:05 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:53841 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab3IYWRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:17:01 -0400
Message-ID: <524360D9.3000706@linaro.org>
Date: Thu, 26 Sep 2013 00:16:57 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@sisk.pl
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/21] cpuidle: avoid unnecessary kzalloc/free of struct
 cpuidle_driver_kobj
References: <cover.1379779777.git.viresh.kumar@linaro.org> <b9855839a2067249d5992acd46140e834737c1b7.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <b9855839a2067249d5992acd46140e834737c1b7.1379779777.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 03:21 AM, Viresh Kumar wrote:
> For CONFIG_CPU_IDLE_MULTIPLE_DRIVERS, struct cpuidle_device always needs to
> allocate struct cpuidle_driver_kobj for all CPUs and so there is no real need to
> have a pointer to it inside struct cpuidle_device.
> 
> This patch makes a object instance of struct cpuidle_driver_kobj inside struct
> cpuidle_device instead of a pointer.
> 
> It also makes kobj_driver dependent on CONFIG_CPU_IDLE_MULTIPLE_DRIVERS.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Comment similar to patch 16/21. If you try to offline/online a cpu, that
should lead to a kernel warning.

> ---
>  drivers/cpuidle/sysfs.c | 20 +++-----------------
>  include/linux/cpuidle.h | 11 +++++++++--
>  2 files changed, 12 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
> index db0aac3..3386d64 100644
> --- a/drivers/cpuidle/sysfs.c
> +++ b/drivers/cpuidle/sysfs.c
> @@ -439,12 +439,6 @@ static void cpuidle_remove_state_sysfs(struct cpuidle_device *device)
>  	static struct cpuidle_driver_attr attr_driver_##_name = \
>  		__ATTR(_name, 0644, show, NULL)
>  
> -struct cpuidle_driver_kobj {
> -	struct cpuidle_driver *drv;
> -	struct completion kobj_unregister;
> -	struct kobject kobj;
> -};
> -
>  struct cpuidle_driver_attr {
>  	struct attribute attr;
>  	ssize_t (*show)(struct cpuidle_driver *, char *);
> @@ -518,27 +512,20 @@ static struct kobj_type ktype_driver_cpuidle = {
>   */
>  static int cpuidle_add_driver_sysfs(struct cpuidle_device *dev)
>  {
> -	struct cpuidle_driver_kobj *kdrv;
> +	struct cpuidle_driver_kobj *kdrv = &dev->kobj_driver;
>  	struct cpuidle_device_kobj *kdev = &dev->kobj_dev;
>  	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
>  	int ret;
>  
> -	kdrv = kzalloc(sizeof(*kdrv), GFP_KERNEL);
> -	if (!kdrv)
> -		return -ENOMEM;
> -
>  	kdrv->drv = drv;
>  	init_completion(&kdrv->kobj_unregister);
>  
>  	ret = kobject_init_and_add(&kdrv->kobj, &ktype_driver_cpuidle,
>  				   &kdev->kobj, "driver");
> -	if (ret) {
> -		kfree(kdrv);
> +	if (ret)
>  		return ret;
> -	}
>  
>  	kobject_uevent(&kdrv->kobj, KOBJ_ADD);
> -	dev->kobj_driver = kdrv;
>  
>  	return ret;
>  }
> @@ -549,10 +536,9 @@ static int cpuidle_add_driver_sysfs(struct cpuidle_device *dev)
>   */
>  static void cpuidle_remove_driver_sysfs(struct cpuidle_device *dev)
>  {
> -	struct cpuidle_driver_kobj *kdrv = dev->kobj_driver;
> +	struct cpuidle_driver_kobj *kdrv = &dev->kobj_driver;
>  	kobject_put(&kdrv->kobj);
>  	wait_for_completion(&kdrv->kobj_unregister);
> -	kfree(kdrv);
>  }
>  #else
>  static inline int cpuidle_add_driver_sysfs(struct cpuidle_device *dev)
> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> index 1fc5cb5..0f0da17 100644
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -62,7 +62,6 @@ struct cpuidle_state {
>  #define CPUIDLE_DRIVER_FLAGS_MASK (0xFFFF0000)
>  
>  struct cpuidle_state_kobj;
> -struct cpuidle_driver_kobj;
>  
>  struct cpuidle_device_kobj {
>  	struct cpuidle_device *dev;
> @@ -70,6 +69,12 @@ struct cpuidle_device_kobj {
>  	struct kobject kobj;
>  };
>  
> +struct cpuidle_driver_kobj {
> +	struct cpuidle_driver *drv;
> +	struct completion kobj_unregister;
> +	struct kobject kobj;
> +};
> +
>  struct cpuidle_device {
>  	unsigned int		registered:1;
>  	unsigned int		enabled:1;
> @@ -79,7 +84,9 @@ struct cpuidle_device {
>  	int			state_count;
>  	struct cpuidle_state_usage	states_usage[CPUIDLE_STATE_MAX];
>  	struct cpuidle_state_kobj *kobjs[CPUIDLE_STATE_MAX];
> -	struct cpuidle_driver_kobj *kobj_driver;
> +#ifdef CONFIG_CPU_IDLE_MULTIPLE_DRIVERS
> +	struct cpuidle_driver_kobj kobj_driver;
> +#endif
>  	struct cpuidle_device_kobj kobj_dev;
>  	struct list_head 	device_list;
>  
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

