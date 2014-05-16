Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbaEPWOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 18:14:46 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63836 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753485AbaEPWOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 18:14:44 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
        lenb@kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com
Subject: Re: [RFC PATCH 1/5] thermal: cpu_cooling: Support passing driver private data.
Date: Sat, 17 May 2014 00:31:34 +0200
Message-ID: <1615618.km3VldYPyl@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140515183307.GA3138@developer>
References: <1399559880-20562-1-git-send-email-amit.daniel@samsung.com> <1399559880-20562-2-git-send-email-amit.daniel@samsung.com> <20140515183307.GA3138@developer>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 15, 2014 02:33:07 PM Eduardo Valentin wrote:
> Hello Amit,
> 
> 
> On Thu, May 08, 2014 at 08:07:56PM +0530, Amit Daniel Kachhap wrote:
> > This patch is in preparation to add notfication support for cpufrequency
> > cooling changes. This change also removes the unnecessary exposing of
> > internal housekeeping structure via thermal_cooling_device->devdata to the
> > users of cpufreq cooling APIs.
> > 
> > Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> > ---
> >  drivers/thermal/cpu_cooling.c                      |   79 +++++++++++++++----
> >  drivers/thermal/db8500_cpufreq_cooling.c           |    2 +-
> >  drivers/thermal/samsung/exynos_thermal_common.c    |    2 +-
> >  drivers/thermal/ti-soc-thermal/ti-thermal-common.c |    2 +-
> >  include/linux/cpu_cooling.h                        |    5 +-
> >  5 files changed, 68 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
> > index 4246262..21f44d4 100644
> > --- a/drivers/thermal/cpu_cooling.c
> > +++ b/drivers/thermal/cpu_cooling.c
> > @@ -50,16 +50,18 @@ struct cpufreq_cooling_device {
> >  	unsigned int cpufreq_state;
> >  	unsigned int cpufreq_val;
> >  	struct cpumask allowed_cpus;
> > +	struct list_head node;
> >  };
> >  static DEFINE_IDR(cpufreq_idr);
> >  static DEFINE_MUTEX(cooling_cpufreq_lock);
> >  
> > -static unsigned int cpufreq_dev_count;
> > -
> >  /* notify_table passes value to the CPUFREQ_ADJUST callback function. */
> >  #define NOTIFY_INVALID NULL
> >  static struct cpufreq_cooling_device *notify_device;
> >  
> > +/* A list to hold all the cpufreq cooling devices registered */
> > +static LIST_HEAD(cpufreq_cooling_list);
> > +
> >  /**
> >   * get_idr - function to get a unique id.
> >   * @idr: struct idr * handle used to create a id.
> > @@ -357,12 +359,23 @@ static int cpufreq_thermal_notifier(struct notifier_block *nb,
> >  static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
> >  				 unsigned long *state)
> >  {
> > -	struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
> > -	struct cpumask *mask = &cpufreq_device->allowed_cpus;
> > +	struct cpufreq_cooling_device *cpufreq_device = NULL;
> > +	struct cpumask *mask = NULL;
> >  	unsigned int cpu;
> >  	unsigned int count = 0;
> >  	int ret;
> >  
> > +	mutex_lock(&cooling_cpufreq_lock);
> > +	list_for_each_entry(cpufreq_device, &cpufreq_cooling_list, node)
> > +		if (cpufreq_device->cool_dev == cdev)
> > +			break;
> > +	mutex_unlock(&cooling_cpufreq_lock);
> > +	if (!cpufreq_device) {
> > +		/* Cooling device pointer not found */
> > +		return -EINVAL;
> > +	}
> > +
> > +	mask = &cpufreq_device->allowed_cpus;
> >  	cpu = cpumask_any(mask);
> >  
> >  	ret = get_property(cpu, 0, &count, GET_MAXL);
> > @@ -386,7 +399,17 @@ static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
> >  static int cpufreq_get_cur_state(struct thermal_cooling_device *cdev,
> >  				 unsigned long *state)
> >  {
> > -	struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
> > +	struct cpufreq_cooling_device *cpufreq_device = NULL;
> > +
> > +	mutex_lock(&cooling_cpufreq_lock);
> > +	list_for_each_entry(cpufreq_device, &cpufreq_cooling_list, node)
> > +		if (cpufreq_device->cool_dev == cdev)
> > +			break;
> > +	mutex_unlock(&cooling_cpufreq_lock);
> > +	if (!cpufreq_device) {
> > +		/* Cooling device pointer not found */
> > +		return -EINVAL;
> > +	}
> >  
> >  	*state = cpufreq_device->cpufreq_state;
> >  
> > @@ -406,7 +429,17 @@ static int cpufreq_get_cur_state(struct thermal_cooling_device *cdev,
> >  static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
> >  				 unsigned long state)
> >  {
> > -	struct cpufreq_cooling_device *cpufreq_device = cdev->devdata;
> > +	struct cpufreq_cooling_device *cpufreq_device = NULL;
> > +
> > +	mutex_lock(&cooling_cpufreq_lock);
> > +	list_for_each_entry(cpufreq_device, &cpufreq_cooling_list, node)
> > +		if (cpufreq_device->cool_dev == cdev)
> > +			break;
> > +	mutex_unlock(&cooling_cpufreq_lock);
> > +	if (!cpufreq_device) {
> > +		/* Cooling device pointer not found */
> > +		return -EINVAL;
> > +	}
> >  
> >  	return cpufreq_apply_cooling(cpufreq_device, state);
> >  }
> > @@ -427,6 +460,7 @@ static struct notifier_block thermal_cpufreq_notifier_block = {
> >   * __cpufreq_cooling_register - helper function to create cpufreq cooling device
> >   * @np: a valid struct device_node to the cooling device device tree node
> >   * @clip_cpus: cpumask of cpus where the frequency constraints will happen.
> > + * @devdata: driver data pointer
> >   *
> >   * This interface function registers the cpufreq cooling device with the name
> >   * "thermal-cpufreq-%x". This api can support multiple instances of cpufreq
> > @@ -438,7 +472,7 @@ static struct notifier_block thermal_cpufreq_notifier_block = {
> >   */
> >  static struct thermal_cooling_device *
> >  __cpufreq_cooling_register(struct device_node *np,
> > -			   const struct cpumask *clip_cpus)
> > +			   const struct cpumask *clip_cpus, void *devdata)
> >  {
> >  	struct thermal_cooling_device *cool_dev;
> >  	struct cpufreq_cooling_device *cpufreq_dev = NULL;
> > @@ -477,7 +511,7 @@ __cpufreq_cooling_register(struct device_node *np,
> >  	snprintf(dev_name, sizeof(dev_name), "thermal-cpufreq-%d",
> >  		 cpufreq_dev->id);
> >  
> > -	cool_dev = thermal_of_cooling_device_register(np, dev_name, cpufreq_dev,
> > +	cool_dev = thermal_of_cooling_device_register(np, dev_name, devdata,
> >  						      &cpufreq_cooling_ops);
> >  	if (IS_ERR(cool_dev)) {
> >  		release_idr(&cpufreq_idr, cpufreq_dev->id);
> > @@ -489,10 +523,11 @@ __cpufreq_cooling_register(struct device_node *np,
> >  	mutex_lock(&cooling_cpufreq_lock);
> >  
> >  	/* Register the notifier for first cpufreq cooling device */
> > -	if (cpufreq_dev_count == 0)
> > +	if (list_empty(&cpufreq_cooling_list))
> >  		cpufreq_register_notifier(&thermal_cpufreq_notifier_block,
> >  					  CPUFREQ_POLICY_NOTIFIER);
> > -	cpufreq_dev_count++;
> > +
> > +	list_add(&cpufreq_dev->node, &cpufreq_cooling_list);
> >  
> >  	mutex_unlock(&cooling_cpufreq_lock);
> >  
> > @@ -502,6 +537,7 @@ __cpufreq_cooling_register(struct device_node *np,
> >  /**
> >   * cpufreq_cooling_register - function to create cpufreq cooling device.
> >   * @clip_cpus: cpumask of cpus where the frequency constraints will happen.
> > + * @devdata: driver data pointer
> >   *
> >   * This interface function registers the cpufreq cooling device with the name
> >   * "thermal-cpufreq-%x". This api can support multiple instances of cpufreq
> > @@ -511,9 +547,9 @@ __cpufreq_cooling_register(struct device_node *np,
> >   * on failure, it returns a corresponding ERR_PTR().
> >   */
> >  struct thermal_cooling_device *
> > -cpufreq_cooling_register(const struct cpumask *clip_cpus)
> > +cpufreq_cooling_register(const struct cpumask *clip_cpus, void *devdata)
> >  {
> > -	return __cpufreq_cooling_register(NULL, clip_cpus);
> > +	return __cpufreq_cooling_register(NULL, clip_cpus, devdata);
> >  }
> >  EXPORT_SYMBOL_GPL(cpufreq_cooling_register);
> >  
> > @@ -537,7 +573,7 @@ of_cpufreq_cooling_register(struct device_node *np,
> >  	if (!np)
> >  		return ERR_PTR(-EINVAL);
> >  
> > -	return __cpufreq_cooling_register(np, clip_cpus);
> > +	return __cpufreq_cooling_register(np, clip_cpus, NULL);
> >  }
> >  EXPORT_SYMBOL_GPL(of_cpufreq_cooling_register);
> >  
> > @@ -554,17 +590,26 @@ void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
> >  	if (!cdev)
> >  		return;
> >  
> > -	cpufreq_dev = cdev->devdata;
> >  	mutex_lock(&cooling_cpufreq_lock);
> > -	cpufreq_dev_count--;
> > +
> > +	list_for_each_entry(cpufreq_dev, &cpufreq_cooling_list, node)
> > +		if (cpufreq_dev->cool_dev == cdev)
> > +			break;
> > +
> > +	if (!cpufreq_dev) {
> > +		/* Cooling device pointer not found */
> > +		mutex_unlock(&cooling_cpufreq_lock);
> > +		return;
> > +	}
> 
> Because you are adding several times the same code to search through
> your list of cdevs, I recommend adding at least a helper function to
> perform this recurring operation.

Violently agreed.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
