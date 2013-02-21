Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3BUXjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 18:39:17 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41079 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064Ab3BUXjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 18:39:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, linaro-dev@lists.linaro.org,
        francescolavra.fl@gmail.com, toddpoynor@google.com
Subject: Re: [PATCH V2 4/4] cpufreq: Get rid of "struct global_attr"
Date: Fri, 22 Feb 2013 00:45:55 +0100
Message-ID: <31684733.Z4gjoGKC1g@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <ef1aad61936c1ceaa7319953563825534daa7a32.1360568193.git.viresh.kumar@linaro.org>
References: <cover.1360568193.git.viresh.kumar@linaro.org> <ef1aad61936c1ceaa7319953563825534daa7a32.1360568193.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 11, 2013 01:20:03 PM Viresh Kumar wrote:
> We don't need to keep two structures for file attributes, global_attr and
> freq_attr. Lets use freq_attr only for cpufreq core and drivers.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/acpi-cpufreq.c |  9 ++++-----
>  drivers/cpufreq/intel_pstate.c | 30 +++++++++++++++---------------
>  include/linux/cpufreq.h        | 16 ----------------
>  3 files changed, 19 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
> index 937bc28..14219c3 100644
> --- a/drivers/cpufreq/acpi-cpufreq.c
> +++ b/drivers/cpufreq/acpi-cpufreq.c
> @@ -160,19 +160,18 @@ static ssize_t _store_boost(const char *buf, size_t count)
>  	return count;
>  }
>  
> -static ssize_t store_global_boost(struct kobject *kobj, struct attribute *attr,
> -				  const char *buf, size_t count)
> +static ssize_t store_global_boost(struct cpufreq_policy *policy,
> +		const char *buf, size_t count)
>  {
>  	return _store_boost(buf, count);
>  }
>  
> -static ssize_t show_global_boost(struct kobject *kobj,
> -				 struct attribute *attr, char *buf)
> +static ssize_t show_global_boost(struct cpufreq_policy *policy, char *buf)
>  {
>  	return sprintf(buf, "%u\n", boost_enabled);
>  }
>  
> -static struct global_attr global_boost = __ATTR(boost, 0644,
> +static struct freq_attr global_boost = __ATTR(boost, 0644,
>  						show_global_boost,
>  						store_global_boost);
>  
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index 86ad482..0f2d6a0 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -273,15 +273,15 @@ static void intel_pstate_debug_expose_params(void)
>  /************************** debugfs end ************************/
>  
>  /************************** sysfs begin ************************/
> -#define show_one(file_name, object)					\
> -	static ssize_t show_##file_name					\
> -	(struct kobject *kobj, struct attribute *attr, char *buf)	\
> -	{								\
> -		return sprintf(buf, "%u\n", limits.object);		\
> -	}
> +#define show_one(file_name, object)				\
> +static ssize_t show_##file_name					\
> +(struct cpufreq_policy *policy, char *buf)			\
> +{								\
> +	return sprintf(buf, "%u\n", limits.object);		\
> +}

Why did you change all of the lines of this macro instead of changing just the
one line you needed to change?

Please don't do that.

> -static ssize_t store_no_turbo(struct kobject *a, struct attribute *b,
> -				const char *buf, size_t count)
> +static ssize_t store_no_turbo(struct cpufreq_policy *policy, const char *buf,
> +		size_t count)
>  {
>  	unsigned int input;
>  	int ret;
> @@ -293,8 +293,8 @@ static ssize_t store_no_turbo(struct kobject *a, struct attribute *b,
>  	return count;
>  }
>  
> -static ssize_t store_max_perf_pct(struct kobject *a, struct attribute *b,
> -				const char *buf, size_t count)
> +static ssize_t store_max_perf_pct(struct cpufreq_policy *policy,
> +		const char *buf, size_t count)
>  {
>  	unsigned int input;
>  	int ret;
> @@ -307,8 +307,8 @@ static ssize_t store_max_perf_pct(struct kobject *a, struct attribute *b,
>  	return count;
>  }
>  
> -static ssize_t store_min_perf_pct(struct kobject *a, struct attribute *b,
> -				const char *buf, size_t count)
> +static ssize_t store_min_perf_pct(struct cpufreq_policy *policy,
> +		const char *buf, size_t count)
>  {
>  	unsigned int input;
>  	int ret;
> @@ -325,9 +325,9 @@ show_one(no_turbo, no_turbo);
>  show_one(max_perf_pct, max_perf_pct);
>  show_one(min_perf_pct, min_perf_pct);
>  
> -define_one_global_rw(no_turbo);
> -define_one_global_rw(max_perf_pct);
> -define_one_global_rw(min_perf_pct);
> +cpufreq_freq_attr_rw(no_turbo);
> +cpufreq_freq_attr_rw(max_perf_pct);
> +cpufreq_freq_attr_rw(min_perf_pct);
>  
>  static struct attribute *intel_pstate_attributes[] = {
>  	&no_turbo.attr,
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 0d84bfa..a092fcb 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -324,22 +324,6 @@ __ATTR(_name, _perm, show_##_name, NULL)
>  static struct freq_attr _name =			\
>  __ATTR(_name, 0644, show_##_name, store_##_name)
>  
> -struct global_attr {
> -	struct attribute attr;
> -	ssize_t (*show)(struct kobject *kobj,
> -			struct attribute *attr, char *buf);
> -	ssize_t (*store)(struct kobject *a, struct attribute *b,
> -			 const char *c, size_t count);
> -};
> -
> -#define define_one_global_ro(_name)		\
> -static struct global_attr _name =		\
> -__ATTR(_name, 0444, show_##_name, NULL)
> -
> -#define define_one_global_rw(_name)		\
> -static struct global_attr _name =		\
> -__ATTR(_name, 0644, show_##_name, store_##_name)
> -
>  struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu);
>  void cpufreq_cpu_put(struct cpufreq_policy *data);
>  const char *cpufreq_get_current_driver(void);

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
