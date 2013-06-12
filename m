Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab3FLFJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 01:09:54 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:45313 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab3FLFJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 01:09:52 -0400
MIME-Version: 1.0
In-Reply-To: <1370941408-29304-2-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1370941408-29304-1-git-send-email-l.majewski@samsung.com>
	<1370941408-29304-2-git-send-email-l.majewski@samsung.com>
Date: Wed, 12 Jun 2013 10:39:51 +0530
Message-ID: <CAKohpomD1ru3_nqQkUq8EmMjJzR7hrtRNAY=UNPWCDHuVxZfBA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] cpufreq:boost: CPU frequency boost code
 unification for software and hardware solutions
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Change subject to: "cpufreq: Add boost frequency support in core"

On 11 June 2013 14:33, Lukasz Majewski <l.majewski@samsung.com> wrote:
> This commit adds support for software based frequency boosting.

No. It adds support for both software and hardware boosting. So just
write: This commit adds boost frequency support in cpufreq core (Hardware
& Software).

> Some SoC (like Exynos4 - e.g. 4x12) allow setting frequency above
> its normal condition limits. Such a change shall be only done for a short

s/condition/operation
s/change/mode
s/done/used

> time.
>
> Overclocking (boost) support is essentially provided by platform
> dependent cpufreq driver.
>
> This commit unifies support for SW and HW (Intel) over clocking solutions
> in the core cpufreq driver. Previously the "boost" sysfs attribute was
> defined at acpi driver code.
> By default boost is disabled. One global attribute is available at:
> /sys/devices/system/cpu/cpufreq/boost.

Enter a blank line here.

> It only shows up when cpufreq driver supports overclocking.
> Under the hood frequencies dedicated for boosting are marked with a
> special flag (CPUFREQ_BOOST_FREQ) at driver's frequency table.
> It is the user's concern to enable/disable overclocking with proper call to
> sysfs.

Good.

> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>
> ---
> Changes for v2:
> - Removal of cpufreq_boost structure and move its fields to cpufreq_driver
>   structure
> - Flag to indicate if global boost attribute is already defined
> - Extent the pr_{err|debbug} functions to show current function names
> ---

You don't have to manually add "---" here. Just keep a blank line instead.

>  drivers/cpufreq/cpufreq.c    |   69 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/cpufreq/freq_table.c |   57 ++++++++++++++++++++++++++++++++--
>  include/linux/cpufreq.h      |   12 ++++++++
>  3 files changed, 136 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 1b8a48e..98ba5f1 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -40,6 +40,7 @@
>   * also protects the cpufreq_cpu_data array.
>   */
>  static struct cpufreq_driver *cpufreq_driver;
> +static bool cpufreq_boost_sysfs_defined;
>  static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
>  #ifdef CONFIG_HOTPLUG_CPU
>  /* This one keeps track of the previously set governor of a removed CPU */
> @@ -315,6 +316,33 @@ EXPORT_SYMBOL_GPL(cpufreq_notify_transition);
>  /*********************************************************************
>   *                          SYSFS INTERFACE                          *
>   *********************************************************************/
> +ssize_t show_boost_status(struct kobject *kobj,
> +                                struct attribute *attr, char *buf)
> +{
> +       return sprintf(buf, "%d\n", cpufreq_driver->boost_en);

This isn't correct. It shows if cpufreq driver supports boost or
not and it should show if boost is enabled from sysfs when
cpufreq driver supports boost.

> +}
> +
> +static ssize_t store_boost_status(struct kobject *kobj, struct attribute *attr,
> +                                 const char *buf, size_t count)
> +{
> +       int ret, enable;
> +
> +       ret = sscanf(buf, "%d", &enable);
> +       if (ret != 1 || enable < 0 || enable > 1)
> +               return -EINVAL;
> +
> +       if (cpufreq_boost_trigger_state(enable)) {
> +               pr_err("%s: Cannot %sable boost!\n", __func__,
> +                      enable ? "en" : "dis");

%sable doesn't look very much readable. Use complete strings:
"enable" and "disable".

> +               return -EINVAL;
> +       }
> +
> +       return count;
> +}
> +
> +static struct global_attr global_boost = __ATTR(boost, 0644,
> +                                               show_boost_status,
> +                                               store_boost_status);

User define_one_global_rw.

>  static struct cpufreq_governor *__find_governor(const char *str_governor)
>  {
> @@ -754,6 +782,17 @@ static int cpufreq_add_dev_interface(unsigned int cpu,

Why not do this in cpufreq_register_driver()?

>                         goto err_out_kobj_put;
>                 drv_attr++;
>         }
> +       if (cpufreq_driver->low_level_boost && !cpufreq_boost_sysfs_defined) {

I thought low_level_boost() is a function which will only be supported
for drivers
using hardware boost feature, like intel. And so we must have used boost_en
here.

> +               ret = sysfs_create_file(cpufreq_global_kobject,
> +                                       &(global_boost.attr));

cpufreq_sysfs_create_file(), check 2361be23666232dbb4851a527f466c4cbf5340fc
for details.

> +               if (ret) {
> +                       pr_err("%s: cannot register global boost sysfs file\n",
> +                               __func__);
> +                       goto err_out_kobj_put;
> +               }
> +               cpufreq_boost_sysfs_defined = 1;
> +       }
> +
>         if (cpufreq_driver->get) {
>                 ret = sysfs_create_file(&policy->kobj, &cpuinfo_cur_freq.attr);
>                 if (ret)
> @@ -1853,6 +1892,30 @@ static struct notifier_block __refdata cpufreq_cpu_notifier = {
>  };
>
>  /*********************************************************************
> + *               BOOST                                              *
> + *********************************************************************/
> +int cpufreq_boost_trigger_state(int state)
> +{
> +       int ret = 0;
> +
> +       if (!cpufreq_driver->low_level_boost)
> +               return -ENODEV;

I am certainly not aligned with your design. What's the
use of this field? And please update documentation too for these
new entries in cpufreq_driver structure.

> +       if (cpufreq_driver->boost_en != state) {

So, you are using boost_en to see if boost is enabled from sysfs?
Then you have put it at wrong place.

I thought there would be three variables:
- cpufreq_driver->boost_supported: boost is enabled for driver
- cpufreq_driver->low_level_boost(): to set desired boost state
(Only for hardware boosting)
- boost_enabled: global variable in cpufreq.c file, used only if
cpufreq_driver->boost_supported is true.


> diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
> index d7a7966..4e4f692 100644
> --- a/drivers/cpufreq/freq_table.c
> +++ b/drivers/cpufreq/freq_table.c
> @@ -20,6 +20,27 @@
>   *                     FREQUENCY TABLE HELPERS                       *
>   *********************************************************************/
>
> +unsigned int
> +cpufreq_frequency_table_max(struct cpufreq_frequency_table *freq_table,
> +                           int boost)
> +{
> +       int i = 0, boost_freq_max = 0, freq_max = 0;
> +
> +       for (; freq_table[i].frequency != CPUFREQ_TABLE_END; i++) {
> +               if (freq_table[i].index == CPUFREQ_BOOST_FREQ) {
> +                       if (freq_table[i].frequency > boost_freq_max)
> +                               boost_freq_max = freq_table[i].frequency;

Do above only when boost==true and below when boost==false.

> +               } else {
> +                       if (freq_table[i].frequency > freq_max)
> +                               freq_max = freq_table[i].frequency;
> +               }
> +       }
> +
> +       return boost ? boost_freq_max : freq_max;
> +
> +}
> +EXPORT_SYMBOL_GPL(cpufreq_frequency_table_max);
> +
>  int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
>                                     struct cpufreq_frequency_table *table)
>  {
> @@ -171,7 +192,8 @@ static DEFINE_PER_CPU(struct cpufreq_frequency_table *, cpufreq_show_table);
>  /**
>   * show_available_freqs - show available frequencies for the specified CPU
>   */
> -static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf)
> +static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf,
> +                                   int show_boost)
>  {
>         unsigned int i = 0;
>         unsigned int cpu = policy->cpu;
> @@ -186,22 +208,53 @@ static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf)
>         for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
>                 if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
>                         continue;
> +               if (show_boost)
> +                       if (table[i].index != CPUFREQ_BOOST_FREQ)
> +                               continue;
> +

Looks wrong. You will show boost freqs when show_boost is false.

>                 count += sprintf(&buf[count], "%d ", table[i].frequency);
>         }
>         count += sprintf(&buf[count], "\n");
>
>         return count;
> +}
>
> +/**
> + * show_available_normal_freqs - show normal boost frequencies for
> + * the specified CPU
> + */
> +static ssize_t show_available_normal_freqs(struct cpufreq_policy *policy,
> +                                          char *buf)
> +{
> +       return show_available_freqs(policy, buf, 0);
>  }
>
>  struct freq_attr cpufreq_freq_attr_scaling_available_freqs = {
>         .attr = { .name = "scaling_available_frequencies",
>                   .mode = 0444,
>                 },
> -       .show = show_available_freqs,
> +       .show = show_available_normal_freqs,
>  };
>  EXPORT_SYMBOL_GPL(cpufreq_freq_attr_scaling_available_freqs);
>
> +/**
> + * show_available_boost_freqs - show available boost frequencies for
> + * the specified CPU
> + */
> +static ssize_t show_available_boost_freqs(struct cpufreq_policy *policy,
> +                                         char *buf)
> +{
> +       return show_available_freqs(policy, buf, 1);
> +}
> +
> +struct freq_attr cpufreq_freq_attr_boost_available_freqs = {
> +       .attr = { .name = "scaling_boost_frequencies",
> +                 .mode = 0444,
> +               },
> +       .show = show_available_boost_freqs,
> +};
> +EXPORT_SYMBOL_GPL(cpufreq_freq_attr_boost_available_freqs);
> +

Code redundancy can be reduced by creating a macro for declaring
**_availabe_freqs, its attributes and export symbol.

>  /*
>   * if you use these, you must assure that the frequency table is valid
>   * all the time between get_attr and put_attr!

With this patch alone, we would be using boost frequencies even in
normal cases where we haven't enabled boost.
