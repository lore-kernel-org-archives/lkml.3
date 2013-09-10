Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab3IJQXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:23:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65140 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3IJQX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:23:29 -0400
Date: Tue, 10 Sep 2013 18:22:48 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: "cpufreq: fix serialization issues with freq change notifiers"
 breaks cpufreq too
In-Reply-To: <CAKohpomBBKLhNemVUpUHAftGhPJJe+ZB7T_9UYLD7LwpR1nK0g@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1309101740120.16010@axis700.grange>
References: <Pine.LNX.4.64.1309091656200.6602@axis700.grange>
 <CAKohponZ+FnzqXYMbBzbun0-1iQMi2fS4syrEBC_MdF41vLCeA@mail.gmail.com>
 <Pine.LNX.4.64.1309101656150.16010@axis700.grange>
 <CAKohpomBBKLhNemVUpUHAftGhPJJe+ZB7T_9UYLD7LwpR1nK0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:4WD/d6JczBAK6wibxkkWbmhD5WCf49EytDZ5weOK48V
 uVxkgrBd2r4bRVYfvBv6p7vilTMcN9KQM7YO5bz2QExOelSWsB
 AyOaetdJz2pQVqWfQs3zXydiVGZE5k+joity4XmybWnOkmMKPM
 sQKdSdo9dXhb7A5zNKkXBQLWA95lMrDwh7D2s8shsO3+YJpFP0
 wB52JzX2IrnmPM8GctNuBpc+o39q6K48Hq78c9aWRBazDXMM4g
 l6H3yIm/SvosXc/DElt44L4Lw5u2ooVUU8Brb8x4zIYjpqhTEF
 Xw7tbKheP6WwLj3bi55EsMZuFjzOVjHKZy0WAMF8mJ+rV7KbJj
 SIrBUHdZNRR5TAplTRhFkxkVm98jI67yKRVZyCrGIkFYhuJP46
 GY3qrs08ML2+w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013, Viresh Kumar wrote:

> On 10 September 2013 20:42, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > 4. reverted that commit, resolving a trivial conflict. Added a debug
> > output in __cpufreq_driver_target() of
> >
> >
> >         if (cpufreq_disabled())
> >                 return -ENODEV;
> > +       pr_info("%s() %d\n", __func__, policy->transition_ongoing);
> >         if (policy->transition_ongoing)
> >                 return -EBUSY;
> 
> Are you sure this diff is on linux-next and not after the revert that
> you mentioned later in the mail? There is some locking introduced
> by my patch which I can't see in you diff..

Of course, isn't that what I've written above? reverted a commit and added 
debug - in that order.

> > Built and booted, got
> >
> > cpufreq: __cpufreq_driver_target(): 1
> >
> > printed out 4 times from the beginning.
> >
> > 5. tried
> >
> > echo powersave > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
> >
> > the above output appeared 2 more times - no frequency change resulted.
> >
> > 6. reverted commit dceff5ce18801dddc220d6238628619c93bc3cb6, built booted
> > - cpufreq works again.
> >
> >> I am afraid you need to give us some more information on how it broke
> >> your stuff.. :)
> >
> > Hope the above is enough.
> 
> A bit more would be helpful.. Can you add these debug prints to all the places
> where transition_ongoing is getting modified? with %s, __func__ to distinguish
> them better? That will make it a bit easy for me...

Sure, I can... So, with the performance governor I get

[    1.290000] cpufreq-cpu0 cpufreq-cpu0: Looking up cpu0-supply from device tree
[    1.290000] cpufreq: trying to register driver generic_cpu0
[    1.290000] cpufreq: adding CPU 0
[    1.290000] cpufreq: Adding link for CPU: 1
[    1.290000] cpufreq: setting new policy for CPU 0: 398667 - 1196000 kHz
[    1.290000] cpufreq: new min and max freqs are 398667 - 1196000 kHz
[    1.290000] cpufreq: governor switch
[    1.290000] cpufreq: __cpufreq_governor for CPU 0, event 4
[    1.290000] cpufreq: __cpufreq_governor for CPU 0, event 1
[    1.290000] cpufreq_performance: setting to 1196000 kHz because of event 1
[    1.290000] cpufreq: __cpufreq_driver_target().1665 1

This is my debug - .transition_ongoing is incremented ^^^^^^^^

[    1.300000] cpufreq: target for CPU 0: 1196000 kHz, relation 1, requested 1196000 kHz
[    1.300000] cpufreq: governor: change or update limits
[    1.300000] cpufreq: __cpufreq_governor for CPU 0, event 3
[    1.300000] cpufreq_performance: setting to 1196000 kHz because of event 3
[    1.300000] cpufreq: initialization complete
[    1.300000] cpufreq: adding CPU 1
[    1.300000] cpufreq: driver generic_cpu0 up and running

That's it. It never gets decremented again.

> Also, what's the configuration of your system? How many CPUs?

2 CPU cores.

> And are all of them sharing clock? (I believe yes, as you are using cpufreq-cpu0)..

Correct. Debug diff is below.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index ecc55d1..374e030 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -15,6 +15,8 @@
  * published by the Free Software Foundation.
  */
 
+#define DEBUG
+
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/cpu.h>
@@ -292,6 +294,7 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 
 		policy->transition_ongoing++;
 		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+		pr_info("%s().%d %d\n", __func__, __LINE__, policy->transition_ongoing);
 
 		/* detect if the driver reported a value as "old frequency"
 		 * which is not equal to what the cpufreq core thinks is
@@ -321,6 +324,7 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 
 		policy->transition_ongoing--;
 		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+		pr_info("%s().%d %d\n", __func__, __LINE__, policy->transition_ongoing);
 
 		adjust_jiffies(CPUFREQ_POSTCHANGE, freqs);
 		pr_debug("FREQ: %lu - CPU: %lu", (unsigned long)freqs->new,
@@ -359,6 +363,7 @@ void cpufreq_notify_transition(struct cpufreq_policy *policy,
 		write_lock_irqsave(&cpufreq_driver_lock, flags);
 		policy->transition_ongoing--;
 		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+		pr_info("%s().%d %d\n", __func__, __LINE__, policy->transition_ongoing);
 	}
 }
 EXPORT_SYMBOL_GPL(cpufreq_notify_transition);
@@ -1356,6 +1361,7 @@ static void cpufreq_out_of_sync(unsigned int cpu, unsigned int old_freq,
 	}
 	policy->transition_ongoing++;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	pr_info("%s().%d %d\n", __func__, __LINE__, policy->transition_ongoing);
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
@@ -1656,6 +1662,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 	}
 	policy->transition_ongoing++;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+	pr_info("%s().%d %d\n", __func__, __LINE__, policy->transition_ongoing);
 
 	/* Make sure that target_freq is within supported range */
 	if (target_freq > policy->max)
diff --git a/drivers/cpufreq/cpufreq_performance.c b/drivers/cpufreq/cpufreq_performance.c
index cf117de..5575b08 100644
--- a/drivers/cpufreq/cpufreq_performance.c
+++ b/drivers/cpufreq/cpufreq_performance.c
@@ -10,6 +10,8 @@
  *
  */
 
+#define DEBUG
+
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/cpufreq.h>
