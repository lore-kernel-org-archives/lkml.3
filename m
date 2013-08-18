Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab3HRKmG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 06:42:06 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:64790 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3HRKmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 06:42:02 -0400
MIME-Version: 1.0
In-Reply-To: <eb988fc9e72b90b7ba99f16405f5dcb072da7840.1376392602.git.viresh.kumar@linaro.org>
References: <cover.1376392602.git.viresh.kumar@linaro.org>
	<eb988fc9e72b90b7ba99f16405f5dcb072da7840.1376392602.git.viresh.kumar@linaro.org>
Date: Sun, 18 Aug 2013 16:11:59 +0530
X-Google-Sender-Auth: 61rRIQYcstaVUouaSNREQgHcy08
Message-ID: <CADGdYn4=si46x7b5Qa0EJ1vUDKrP3maXBqWwQ6s7gkep-8MxFg@mail.gmail.com>
Subject: Re: [PATCH V2 01/35] cpufreq: Implement light weight ->target_index() routine
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linaro-kernel@lists.linaro.org,
        "patches@linaro.org" <patches@linaro.org>, cpufreq@vger.kernel.org,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Andrew Lunn <andrew@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        John Crispin <blogic@openwrt.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-cris-kernel@axis.com,
        Mikael Starvik <starvik@axis.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        sparclinux@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Steven Miao <realmz6@gmail.com>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Tue, Aug 13, 2013 at 7:02 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Currently prototype of cpufreq_drivers target routines is:
>
> int target(struct cpufreq_policy *policy, unsigned int target_freq,
>                 unsigned int relation);
>
> And most of the drivers call cpufreq_frequency_table_target() to get a valid
> index of their frequency table which is closest to the target_freq. And they
> don't use target_freq and relation after it.
>
> So, it makes sense to just do this work in cpufreq core before calling
> cpufreq_frequency_table_target() and simply pass index instead. But this can be
> done only with drivers which expose their frequency table with cpufreq core. For
> others we need to stick with the old prototype of target() until those drivers
> are converted to expose frequency tables.
>
> This patch implements the new light weight prototype for target_index() routine.
> It looks like this:
>
> int target_index(struct cpufreq_policy *policy, unsigned int index);
This new API is fine but I have another idea.
Say During the registration of the frequency table cpufreq_policy can
be registered as SCALE_DIRECT or SCALE_STEPS. With SCALE_DIRECT flag,
valid frequency will be requested. With this flags the governor itself
can  can figure out if frequency scaling is required or not and very
few calls to __cpufreq_driver_target will happen.
But i agree that in this approach cpufreq_frequency_table_target is
still required but again it can be optimized by binary search as
currently the search is linear.

Thanks,
Amit
>
> CPUFreq core will call cpufreq_frequency_table_target() before calling this
> routine and pass index to it. Because CPUFreq core now requires to call routines
> present in freq_table.c CONFIG_CPU_FREQ_TABLE must be enabled all the time.
>
> This also marks target() interface as deprecated. So, that new drivers avoid
> using it. And
>
> Documentation is updated accordingly.
>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: John Crispin <blogic@openwrt.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: linux-cris-kernel@axis.com
> Cc: Mikael Starvik <starvik@axis.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: sparclinux@vger.kernel.org
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Steven Miao <realmz6@gmail.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  Documentation/cpu-freq/cpu-drivers.txt | 27 +++++++++++------
>  Documentation/cpu-freq/governors.txt   |  4 +--
>  drivers/cpufreq/Kconfig                |  1 +
>  drivers/cpufreq/cpufreq.c              | 55 +++++++++++++++++++++++++++-------
>  include/linux/cpufreq.h                |  4 ++-
>  5 files changed, 68 insertions(+), 23 deletions(-)
>
> diff --git a/Documentation/cpu-freq/cpu-drivers.txt b/Documentation/cpu-freq/cpu-drivers.txt
> index 40282e6..8b1a445 100644
> --- a/Documentation/cpu-freq/cpu-drivers.txt
> +++ b/Documentation/cpu-freq/cpu-drivers.txt
> @@ -23,8 +23,8 @@ Contents:
>  1.1  Initialization
>  1.2  Per-CPU Initialization
>  1.3  verify
> -1.4  target or setpolicy?
> -1.5  target
> +1.4  target/target_index or setpolicy?
> +1.5  target/target_index
>  1.6  setpolicy
>  2.   Frequency Table Helpers
>
> @@ -56,7 +56,8 @@ cpufreq_driver.init -         A pointer to the per-CPU initialization
>  cpufreq_driver.verify -                A pointer to a "verification" function.
>
>  cpufreq_driver.setpolicy _or_
> -cpufreq_driver.target -                See below on the differences.
> +cpufreq_driver.target/
> +target_index           -       See below on the differences.
>
>  And optionally
>
> @@ -66,7 +67,7 @@ cpufreq_driver.resume -               A pointer to a per-CPU resume function
>                                 which is called with interrupts disabled
>                                 and _before_ the pre-suspend frequency
>                                 and/or policy is restored by a call to
> -                               ->target or ->setpolicy.
> +                               ->target/target_index or ->setpolicy.
>
>  cpufreq_driver.attr -          A pointer to a NULL-terminated list of
>                                 "struct freq_attr" which allow to
> @@ -103,8 +104,8 @@ policy->governor            must contain the "default policy" for
>                                 this CPU. A few moments later,
>                                 cpufreq_driver.verify and either
>                                 cpufreq_driver.setpolicy or
> -                               cpufreq_driver.target is called with
> -                               these values.
> +                               cpufreq_driver.target/target_index is called
> +                               with these values.
>
>  For setting some of these values (cpuinfo.min[max]_freq, policy->min[max]), the
>  frequency table helpers might be helpful. See the section 2 for more information
> @@ -133,20 +134,28 @@ range) is within policy->min and policy->max. If necessary, increase
>  policy->max first, and only if this is no solution, decrease policy->min.
>
>
> -1.4 target or setpolicy?
> +1.4 target/target_index or setpolicy?
>  ----------------------------
>
>  Most cpufreq drivers or even most cpu frequency scaling algorithms
>  only allow the CPU to be set to one frequency. For these, you use the
> -->target call.
> +->target/target_index call.
>
>  Some cpufreq-capable processors switch the frequency between certain
>  limits on their own. These shall use the ->setpolicy call
>
>
> -1.4. target
> +1.4. target/target_index
>  -------------
>
> +The target_index call has two arguments: struct cpufreq_policy *policy,
> +and unsigned int index (into the exposed frequency table).
> +
> +The CPUfreq driver must set the new frequency when called here. The
> +actual frequency must be determined by freq_table[index].frequency.
> +
> +Deprecated:
> +----------
>  The target call has three arguments: struct cpufreq_policy *policy,
>  unsigned int target_frequency, unsigned int relation.
>
> diff --git a/Documentation/cpu-freq/governors.txt b/Documentation/cpu-freq/governors.txt
> index 219970b..77ec215 100644
> --- a/Documentation/cpu-freq/governors.txt
> +++ b/Documentation/cpu-freq/governors.txt
> @@ -40,7 +40,7 @@ Most cpufreq drivers (in fact, all except one, longrun) or even most
>  cpu frequency scaling algorithms only offer the CPU to be set to one
>  frequency. In order to offer dynamic frequency scaling, the cpufreq
>  core must be able to tell these drivers of a "target frequency". So
> -these specific drivers will be transformed to offer a "->target"
> +these specific drivers will be transformed to offer a "->target/target_index"
>  call instead of the existing "->setpolicy" call. For "longrun", all
>  stays the same, though.
>
> @@ -71,7 +71,7 @@ CPU can be set to switch independently         |         CPU can only be set
>                     /                          the limits of policy->{min,max}
>                    /                                \
>                   /                                  \
> -       Using the ->setpolicy call,              Using the ->target call,
> +       Using the ->setpolicy call,              Using the ->target/target_index call,
>             the limits and the                    the frequency closest
>              "policy" is set.                     to target_freq is set.
>                                                   It is assured that it
> diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
> index 534fcb8..2d06754 100644
> --- a/drivers/cpufreq/Kconfig
> +++ b/drivers/cpufreq/Kconfig
> @@ -2,6 +2,7 @@ menu "CPU Frequency scaling"
>
>  config CPU_FREQ
>         bool "CPU Frequency scaling"
> +       select CPU_FREQ_TABLE
>         help
>           CPU Frequency scaling allows you to change the clock speed of
>           CPUs on the fly. This is a nice method to save power, because
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 37a6874..f1b0e0f 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -47,6 +47,11 @@ static LIST_HEAD(cpufreq_policy_list);
>  static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
>  #endif
>
> +static inline bool has_target(void)
> +{
> +       return cpufreq_driver->target_index || cpufreq_driver->target;
> +}
> +
>  /*
>   * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
>   * all cpufreq/hotplug/workqueue/etc related lock issues.
> @@ -377,7 +382,7 @@ static int cpufreq_parse_governor(char *str_governor, unsigned int *policy,
>                         *policy = CPUFREQ_POLICY_POWERSAVE;
>                         err = 0;
>                 }
> -       } else if (cpufreq_driver->target) {
> +       } else if (has_target()) {
>                 struct cpufreq_governor *t;
>
>                 mutex_lock(&cpufreq_governor_mutex);
> @@ -539,7 +544,7 @@ static ssize_t show_scaling_available_governors(struct cpufreq_policy *policy,
>         ssize_t i = 0;
>         struct cpufreq_governor *t;
>
> -       if (!cpufreq_driver->target) {
> +       if (!has_target()) {
>                 i += sprintf(buf, "performance powersave");
>                 goto out;
>         }
> @@ -822,7 +827,7 @@ static int cpufreq_add_dev_interface(struct cpufreq_policy *policy,
>                 if (ret)
>                         goto err_out_kobj_put;
>         }
> -       if (cpufreq_driver->target) {
> +       if (has_target()) {
>                 ret = sysfs_create_file(&policy->kobj, &scaling_cur_freq.attr);
>                 if (ret)
>                         goto err_out_kobj_put;
> @@ -871,10 +876,10 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
>                                   unsigned int cpu, struct device *dev,
>                                   bool frozen)
>  {
> -       int ret = 0, has_target = !!cpufreq_driver->target;
> +       int ret = 0;
>         unsigned long flags;
>
> -       if (has_target) {
> +       if (has_target()) {
>                 ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
>                 if (ret) {
>                         pr_err("%s: Failed to stop governor\n", __func__);
> @@ -893,7 +898,7 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
>
>         unlock_policy_rwsem_write(policy->cpu);
>
> -       if (has_target) {
> +       if (has_target()) {
>                 if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
>                         (ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
>                         pr_err("%s: Failed to start governor\n", __func__);
> @@ -1204,7 +1209,7 @@ static int __cpufreq_remove_dev(struct device *dev,
>                 return -EINVAL;
>         }
>
> -       if (cpufreq_driver->target) {
> +       if (has_target()) {
>                 ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
>                 if (ret) {
>                         pr_err("%s: Failed to stop governor\n", __func__);
> @@ -1244,7 +1249,7 @@ static int __cpufreq_remove_dev(struct device *dev,
>
>         /* If cpu is last user of policy, free policy */
>         if (cpus == 1) {
> -               if (cpufreq_driver->target) {
> +               if (has_target()) {
>                         ret = __cpufreq_governor(policy,
>                                         CPUFREQ_GOV_POLICY_EXIT);
>                         if (ret) {
> @@ -1282,7 +1287,7 @@ static int __cpufreq_remove_dev(struct device *dev,
>                 if (!frozen)
>                         cpufreq_policy_free(policy);
>         } else {
> -               if (cpufreq_driver->target) {
> +               if (has_target()) {
>                         if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
>                                         (ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
>                                 pr_err("%s: Failed to start governor\n",
> @@ -1646,11 +1651,39 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
>         pr_debug("target for CPU %u: %u kHz, relation %u, requested %u kHz\n",
>                         policy->cpu, target_freq, relation, old_target_freq);
>
> +       /*
> +        * This might look like a redundant call as we are checking it again
> +        * after finding index. But it is left intentionally for cases where
> +        * exactly same freq is called again and so we can save on few function
> +        * calls.
> +        */
>         if (target_freq == policy->cur)
>                 return 0;
>
>         if (cpufreq_driver->target)
>                 retval = cpufreq_driver->target(policy, target_freq, relation);
> +       else if (cpufreq_driver->target_index) {
> +               struct cpufreq_frequency_table *freq_table;
> +               int index;
> +
> +               freq_table = cpufreq_frequency_get_table(policy->cpu);
> +               if (unlikely(!freq_table)) {
> +                       pr_err("%s: Unable to find freq_table\n", __func__);
> +                       return retval;
> +               }
> +
> +               retval = cpufreq_frequency_table_target(policy, freq_table,
> +                               target_freq, relation, &index);
> +               if (unlikely(retval)) {
> +                       pr_err("%s: Unable to find matching freq\n", __func__);
> +                       return retval;
> +               }
> +
> +               if (freq_table[index].frequency == policy->cur)
> +                       return 0;
> +
> +               retval = cpufreq_driver->target_index(policy, index);
> +       }
>
>         return retval;
>  }
> @@ -1983,7 +2016,7 @@ int cpufreq_update_policy(unsigned int cpu)
>                         pr_debug("Driver did not initialize current freq");
>                         policy->cur = new_policy.cur;
>                 } else {
> -                       if (policy->cur != new_policy.cur && cpufreq_driver->target)
> +                       if (policy->cur != new_policy.cur && has_target())
>                                 cpufreq_out_of_sync(cpu, policy->cur,
>                                                                 new_policy.cur);
>                 }
> @@ -2058,7 +2091,7 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
>                 return -ENODEV;
>
>         if (!driver_data || !driver_data->verify || !driver_data->init ||
> -           ((!driver_data->setpolicy) && (!driver_data->target)))
> +           (!driver_data->setpolicy && !has_target()))
>                 return -EINVAL;
>
>         pr_debug("trying to register driver %s\n", driver_data->name);
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 4907eb2..ff9c8df 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -195,9 +195,11 @@ struct cpufreq_driver {
>
>         /* define one out of two */
>         int     (*setpolicy)    (struct cpufreq_policy *policy);
> -       int     (*target)       (struct cpufreq_policy *policy,
> +       int     (*target)       (struct cpufreq_policy *policy, /* Deprecated */
>                                  unsigned int target_freq,
>                                  unsigned int relation);
> +       int     (*target_index) (struct cpufreq_policy *policy,
> +                                unsigned int index);
>
>         /* should be defined, if possible */
>         unsigned int    (*get)  (unsigned int cpu);
> --
> 1.7.12.rc2.18.g61b472e
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
