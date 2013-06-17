Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab3FQHQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 03:16:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56831 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3FQHQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 03:16:06 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-08-51beb7b39f53
Date: Mon, 17 Jun 2013 09:15:49 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
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
Subject: Re: [PATCH v3 1/3] cpufreq: Add boost frequency support in core
Message-id: <20130617091549.398b865f@amdc308.digital.local>
In-reply-to: <CAKohpokQAsuAqWi7rNx9RaFz8KVRNXVkBD22KC5_Qh05k66qqA@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371195540-2991-1-git-send-email-l.majewski@samsung.com>
 <1371195540-2991-2-git-send-email-l.majewski@samsung.com>
 <CAKohpokQAsuAqWi7rNx9RaFz8KVRNXVkBD22KC5_Qh05k66qqA@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t9jAd0t2/cFGhx6xWLx5+1yVounTT/Y
	LeZ9lrXoPPuE2aJ3wVU2izePuC0u75rDZvG59wijxe3GFWwW/Qt7mSw6jnxjttj41cOBx+PO
	tT1sHuumvWX26NuyitHj0eIWRo/Pm+QCWKO4bFJSczLLUov07RK4MrbNPcxScLyo4vuXlAbG
	3wFdjJwcEgImEn/P7WaDsMUkLtxbD2RzcQgJLGKU6JjcxwzhtDNJfDz+iAWkikVAVeLvxwVg
	HWwCehKf7z5l6mLk4BAR0JJ4eTMVpJ5Z4BmzxOMva1hBaoQFPCTOHZnGCFLDK2AtcarLACTM
	KRAsMXH3IRaI+S1MErv2dzOBJPgFJCXa//1ghrjITuLcpw3sIDavgKDEj8n3wG5gBtq1eVsT
	K4QtL7F5zVvmCYyCs5CUzUJSNgtJ2QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwZHy
	THoH46oGi0OMAhyMSjy8HHX7AoVYE8uKK3MPMUpwMCuJ8MZOBArxpiRWVqUW5ccXleakFh9i
	lOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpg1Lm04dO0rp2Skux/Ql6vXV99sJS/3vmr
	6beHL33CY5WvTKj1kdtzXTH1J0NAlmvahX9CW9c2KDs1bZ+7JVrA3f2rCteMrvfTHpxnmHz5
	eVnmIWk70X+qQlNSNi9vVcks3fHT1GPtWjOpK/MbTQM2zpzW7XvXa2OfHB/D91tHzsqdtuUs
	0c2Yp8RSnJFoqMVcVJwIAENTU8CQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jun 2013 11:13:18 +0530, Viresh Kumar wrote:
> On 14 June 2013 13:08, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > Changes for v2:
> > - Removal of cpufreq_boost structure and move its fields to
> > cpufreq_driver structure
> > - Flag to indicate if global boost attribute is already defined
> > - Extent the pr_{err|debbug} functions to show current function
> > names
> >
> > Changes for v3:
> > - Method for reading boost status
> > - Removal of cpufreq_frequency_table_max()
> > - Extent cpufreq_frequency_table_cpuinfo() to support boost
> > parameter
> > - boost_supported flag added to cpufreq_driver struct
> > - "boost" sysfs attribute control flag removed
> > - One global flag describing state of the boost defined at cpufreq
> > core
> > - Rename cpufreq_driver's low_level_boost field to set_boost_freq()
> > - Usage of cpufreq_sysfs_{remove|add}_file() routines
> 
> Latest change log first please.

Ok.

> 
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > index 2ce86ed..02e57db 100644
> > --- a/drivers/cpufreq/cpufreq.c
> > +++ b/drivers/cpufreq/cpufreq.c
> > @@ -40,6 +40,7 @@
> >   * also protects the cpufreq_cpu_data array.
> >   */
> >  static struct cpufreq_driver *cpufreq_driver;
> > +static bool cpufreq_boost_enabled;
> >  static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
> >  #ifdef CONFIG_HOTPLUG_CPU
> >  /* This one keeps track of the previously set governor of a
> > removed CPU */ @@ -315,6 +316,30 @@
> > EXPORT_SYMBOL_GPL(cpufreq_notify_transition); /*********************************************************************
> >   *                          SYSFS
> > INTERFACE                          *
> > *********************************************************************/
> > +ssize_t show_boost(struct kobject *kobj,
> > +                                struct attribute *attr, char *buf)
> > +{
> > +       return sprintf(buf, "%d\n", cpufreq_boost_enabled);
> > +}
> > +
> > +static ssize_t store_boost(struct kobject *kobj, struct attribute
> > *attr,
> > +                                 const char *buf, size_t count)
> > +{
> > +       int ret, enable;
> > +
> > +       ret = sscanf(buf, "%d", &enable);
> > +       if (ret != 1 || enable < 0 || enable > 1)
> > +               return -EINVAL;
> > +
> > +       if (cpufreq_boost_trigger_state(enable)) {
> > +               pr_err("%s: Cannot %sable boost!\n", __func__,
> > +                      enable ? "en" : "dis");
> 
> Please don't use %sable as discussed earlier.

My bad. I've overlooked this one.

> 
> > +               return -EINVAL;
> > +       }
> > +
> > +       return count;
> > +}
> > +define_one_global_rw(boost);
> >
> >  static struct cpufreq_governor *__find_governor(const char
> > *str_governor) {
> > @@ -1896,6 +1921,55 @@ static struct notifier_block __refdata
> > cpufreq_cpu_notifier = { };
> >
> >  /*********************************************************************
> > + *
> > BOOST                                              *
> > +
> > *********************************************************************/
> > +int cpufreq_boost_trigger_state(int state) +{
> > +       struct cpufreq_frequency_table *freq_table;
> > +       struct cpufreq_policy *policy;
> > +       unsigned long flags;
> > +       int ret = 0, cpu;
> > +
> > +       if (!cpufreq_driver->boost_supported)
> > +               return -ENODEV;
> 
> This can't happen. sysfs directory is present only when we
> have boost supported.

I know, that we shall not look into the future. But this method will be
used when somebody would like to enable boost from kernel. Let's say
new governor or such :-). 

I can remove this and add it later, but I think, that it is safer to
add it straightaway.

> 
> > +       if (cpufreq_boost_enabled != state) {
> > +               if (cpufreq_driver->set_boost_freq) {
> > +                       ret = cpufreq_driver->set_boost_freq(state);
> 
> I thought this routine was for setting boost frequency and not
> for enabling boost feature. If boost has to be enabled separately
> then this routine must take care of it while setting freq.
> 
> So, in other words, this must not be called here.

This function explicitly follows current logic of acpi-cpufreq.c.

I would like to avoid modifying legacy/working code as much as
possible (especially when I hadn't yet received any feedback about
acpi-cpufreq.c file changes).


> 
> > +                       if (ret) {
> > +                               pr_err("%s: BOOST cannot enable
> > (%d)\n",
> > +                                      __func__, ret);
> > +                               return ret;
> > +                       }
> > +               }
> > +
> > +               for_each_possible_cpu(cpu) {
> > +                       policy = cpufreq_cpu_get(cpu);
> 
> In case this code is required, it would make more sense to keep list
> of all available policies, which we can iterate through.

Maybe I don't get the big picture, but why we cannot iterate
through possible CPUs? At least one shall have valid policy and
freq_table combination. 

I've already proposed list of all policies (at v1), but we decided to
abandon this idea.

In which way list is better than iteration through all possible per-cpu
variables, which store policies?


> 
> > +                       freq_table =
> > cpufreq_frequency_get_table(cpu);
> > +                       if (policy && freq_table) {
> > +
> > write_lock_irqsave(&cpufreq_driver_lock, flags);
> > +
> > cpufreq_frequency_table_cpuinfo(policy,
> > +
> > freq_table,
> > +
> > state);
> 
> We obviously don't need the last param to this routine and so bunch
> of changes you did in this patch.
> 
> cpufreq_frequency_table_cpuinfo() can itself check if boost is enabled
> or not.

Yes, you are right. We can check if boost is supported and enabled
inside this function.

> 
> > +                               cpufreq_boost_enabled = state;
> > +
> > write_unlock_irqrestore(&cpufreq_driver_lock,
> > +                                                       flags);
> > +                       }
> > +               }
> 
> I am not sure if this is required at all. Or what complications can be
> there when we update max/min on the fly here.

Correct me if I'm wrong, but I'm using scripts for tests which run
simultaneously and enables/disables boost feature. I don't recall if
there is a lock at sysfs, which would prevent from simultaneous write
to the "boost" sysfs attribute. 

I will doubble check that.

> 
> > +       }
> > +
> > +       pr_debug("%s: cpufreq BOOST %s\n", __func__,
> > +                state ? "enabled" : "disabled");
> > +
> > +       return 0;
> > +}
> > +
> > +int cpufreq_boost_state(void)
> 
> s/cpufreq_boost_state/cpufreq_boost_enabled

OK.

> 
> > +{
> > +       return cpufreq_boost_enabled;
> 
> s/cpufreq_boost_enabled/boost_enabled
> 
> > +}
> > +
> > +/*********************************************************************
> >   *               REGISTER / UNREGISTER CPUFREQ
> > DRIVER                *
> > *********************************************************************/
> >
> > @@ -1934,6 +2008,15 @@ int cpufreq_register_driver(struct
> > cpufreq_driver *driver_data) cpufreq_driver = driver_data;
> >         write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> >
> > +       if (cpufreq_driver->boost_supported) {
> > +               ret = cpufreq_sysfs_create_file(&(boost.attr));
> > +               if (ret) {
> > +                       pr_err("%s: cannot register global boost
> > sysfs file\n",
> > +                               __func__);
> > +                       goto err_null_driver;
> > +               }
> > +       }
> > +
> >         ret = subsys_interface_register(&cpufreq_interface);
> >         if (ret)
> >                 goto err_null_driver;
> > @@ -1990,6 +2073,10 @@ int cpufreq_unregister_driver(struct
> > cpufreq_driver *driver) pr_debug("unregistering driver %s\n",
> > driver->name);
> >
> >         subsys_interface_unregister(&cpufreq_interface);
> > +
> > +       if (cpufreq_driver->boost_supported)
> > +               cpufreq_sysfs_remove_file(&(boost.attr));
> > +
> >         unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
> >
> >         write_lock_irqsave(&cpufreq_driver_lock, flags);
> 
> This part looked good :)
> 
> > diff --git a/drivers/cpufreq/freq_table.c
> > b/drivers/cpufreq/freq_table.c index d7a7966..f1a4d785 100644
> > --- a/drivers/cpufreq/freq_table.c
> > +++ b/drivers/cpufreq/freq_table.c
> > @@ -21,7 +21,8 @@
> >   *********************************************************************/
> >
> >  int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
> > -                                   struct cpufreq_frequency_table
> > *table)
> > +                                   struct cpufreq_frequency_table
> > *table,
> > +                                   int boost)
> >  {
> >         unsigned int min_freq = ~0;
> >         unsigned int max_freq = 0;
> > @@ -31,9 +32,11 @@ int cpufreq_frequency_table_cpuinfo(struct
> > cpufreq_policy *policy, unsigned int freq = table[i].frequency;
> >                 if (freq == CPUFREQ_ENTRY_INVALID) {
> >                         pr_debug("table entry %u is invalid,
> > skipping\n", i); -
> >                         continue;
> >                 }
> > +               if (!boost && table[i].index == CPUFREQ_BOOST_FREQ)
> > +                       continue;
> > +
> >                 pr_debug("table entry %u: %u kHz, %u index\n",
> >                                         i, freq, table[i].index);
> >                 if (freq < min_freq)
> > @@ -171,7 +174,8 @@ static DEFINE_PER_CPU(struct
> > cpufreq_frequency_table *, cpufreq_show_table); /**
> >   * show_available_freqs - show available frequencies for the
> > specified CPU */
> > -static ssize_t show_available_freqs(struct cpufreq_policy *policy,
> > char *buf) +static ssize_t show_available_freqs(struct
> > cpufreq_policy *policy, char *buf,
> > +                                   int show_boost)
> >  {
> >         unsigned int i = 0;
> >         unsigned int cpu = policy->cpu;
> > @@ -186,22 +190,42 @@ static ssize_t show_available_freqs(struct
> > cpufreq_policy *policy, char *buf) for (i = 0;
> > (table[i].frequency != CPUFREQ_TABLE_END); i++) { if
> > (table[i].frequency == CPUFREQ_ENTRY_INVALID) continue;
> > +               if (show_boost && table[i].index !=
> > CPUFREQ_BOOST_FREQ)
> > +                       continue;
> > +               if (!show_boost && table[i].index ==
> > CPUFREQ_BOOST_FREQ)
> > +                       continue;
> 
> Maybe, this instead of above two if statements:
> 
> if (show_boost ^ (table[i].index == CPUFREQ_BOOST_FREQ))
>     continue

Yes. Good point.

> 
> >                 count += sprintf(&buf[count], "%d ",
> > table[i].frequency); }
> >         count += sprintf(&buf[count], "\n");
> >
> >         return count;
> > -
> >  }
> >
> > -struct freq_attr cpufreq_freq_attr_scaling_available_freqs = {
> > -       .attr = { .name = "scaling_available_frequencies",
> > -                 .mode = 0444,
> > -               },
> > -       .show = show_available_freqs,
> > -};
> > +/**
> > + * show_scaling_available_frequencies - show normal boost
> > frequencies for
> 
> s/boost /

Ok.

> 
> > + * the specified CPU
> > + */
> > +static ssize_t scaling_available_frequencies_show(struct
> > cpufreq_policy *policy,
> > +                                                 char *buf)
> > +{
> > +       return show_available_freqs(policy, buf, 0);
> > +}
> > +cpufreq_attr_available_freq(scaling_available);
> >  EXPORT_SYMBOL_GPL(cpufreq_freq_attr_scaling_available_freqs);
> >
> > +/**
> > + * show_available_boost_freqs - show available boost frequencies
> > for
> > + * the specified CPU
> > + */
> > +static ssize_t scaling_boost_frequencies_show(struct
> > cpufreq_policy *policy,
> > +                                             char *buf)
> > +{
> > +       return show_available_freqs(policy, buf, 1);
> > +}
> > +cpufreq_attr_available_freq(scaling_boost);
> > +EXPORT_SYMBOL_GPL(cpufreq_freq_attr_scaling_boost_freqs);
> > +
> >  /*
> >   * if you use these, you must assure that the frequency table is
> > valid
> >   * all the time between get_attr and put_attr!
> 
> > diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> > index ab1932c..027442d 100644
> > --- a/include/linux/cpufreq.h
> > +++ b/include/linux/cpufreq.h
> > @@ -266,6 +266,10 @@ struct cpufreq_driver {
> >         int     (*suspend)      (struct cpufreq_policy *policy);
> >         int     (*resume)       (struct cpufreq_policy *policy);
> >         struct freq_attr        **attr;
> > +
> > +       /* platform specific boost support code */
> > +       bool                    boost_supported;
> > +       int (*set_boost_freq)   (int state);
> >  };
> >
> >  /* flags */
> > @@ -318,6 +322,10 @@ __ATTR(_name, _perm, show_##_name, NULL)
> >  static struct freq_attr _name =                        \
> >  __ATTR(_name, 0644, show_##_name, store_##_name)
> >
> > +#define cpufreq_attr_available_freq(_name)       \
> > +struct freq_attr cpufreq_freq_attr_##_name##_freqs =     \
> > +__ATTR_RO(_name##_frequencies)
> 
> What is this doing in cpufreq.h? It will only be used by freq_table.c
> file.

I wanted to add those #defines to the place where other similar ones
are placed.

I can put it to freq_table.c.

> 
> 
> Again, I couldn't see how boost freqs are getting used? You have
> probably made them part of normal freq range here and so they
> might be used during normal operations. But we wanted it to be
> used only when we have few cpus on... etc.. Where is that logic?

The logic is as follow:
- cpufreq_driver exports .attr field. When driver supports boost then
  two attributes are exported (even when boost is not enabled, but
  supported):
	- scaling_available_frequencies (only normal frequencies - this
	  attribute is unchanged)
	- scaling_boost_frequencies - list possible boost frequencies. 
  
When boost is not supported - then only scaling_available_frequencies
is exported (as it is done now). 

Please refer to patch 3/3.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
