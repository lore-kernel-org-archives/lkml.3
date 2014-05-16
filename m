Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbaEPJHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:07:40 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:61894 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616AbaEPJHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:07:36 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        swarren@nvidia.com, nicolas.pitre@linaro.org, swarren@wwwdotorg.org,
        dianders@chromium.org, linux@arm.linux.org.uk,
        thomas.abraham@linaro.org, pdeschrijver@nvidia.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 2/3] cpufreq: add support for intermediate (stable) frequencies
Date: Fri, 16 May 2014 14:37:18 +0530
Message-Id: <9e1ed1bf8c3610709436fe5ef8df3a63856f8f5c.1400230695.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1400230695.git.viresh.kumar@linaro.org>
References: <cover.1400230695.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Douglas Anderson, recently pointed out an interesting problem due to which
udelay() was expiring earlier than it should.

While transitioning between frequencies few platforms may temporarily switch to
a stable frequency, waiting for the main PLL to stabilize.

For example: When we transition between very low frequencies on exynos, like
between 200MHz and 300MHz, we may temporarily switch to a PLL running at 800MHz.
No CPUFREQ notification is sent for that. That means there's a period of time
when we're running at 800MHz but loops_per_jiffy is calibrated at between 200MHz
and 300MHz. And so udelay behaves badly.

To get this fixed in a generic way, lets introduce another set of callbacks
get_intermediate() and target_intermediate(), only for drivers with
target_index() and CPUFREQ_ASYNC_NOTIFICATION unset.

get_intermediate should return a stable intermediate frequency platform wants to
switch to, and target_intermediate() should set CPU to to that frequency, before
jumping to the frequency corresponding to 'index'. Core will take care of
sending notifications and driver doesn't have to handle them in
target_intermediate() or target_index().

NOTE: Once set to intermediate frequency, driver isn't expected to fail for the
following ->target_index() call, if it fails core will issue a WARN().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 Documentation/cpu-freq/cpu-drivers.txt | 19 ++++++++++++++--
 drivers/cpufreq/cpufreq.c              | 40 +++++++++++++++++++++++++++-------
 include/linux/cpufreq.h                | 15 +++++++++++++
 3 files changed, 64 insertions(+), 10 deletions(-)

diff --git a/Documentation/cpu-freq/cpu-drivers.txt b/Documentation/cpu-freq/cpu-drivers.txt
index b045fe5..dd64602 100644
--- a/Documentation/cpu-freq/cpu-drivers.txt
+++ b/Documentation/cpu-freq/cpu-drivers.txt
@@ -26,6 +26,7 @@ Contents:
 1.4  target/target_index or setpolicy?
 1.5  target/target_index
 1.6  setpolicy
+1.7  get_intermediate and target_intermediate
 2.   Frequency Table Helpers
 
 
@@ -79,6 +80,10 @@ cpufreq_driver.attr -		A pointer to a NULL-terminated list of
 				"struct freq_attr" which allow to
 				export values to sysfs.
 
+cpufreq_driver.get_intermediate
+and target_intermediate		Uset to switch to stable frequency while
+				changing CPU frequency.
+
 
 1.2 Per-CPU Initialization
 --------------------------
@@ -151,7 +156,7 @@ Some cpufreq-capable processors switch the frequency between certain
 limits on their own. These shall use the ->setpolicy call
 
 
-1.4. target/target_index
+1.5. target/target_index
 -------------
 
 The target_index call has two arguments: struct cpufreq_policy *policy,
@@ -179,7 +184,7 @@ Here again the frequency table helper might assist you - see section 2
 for details.
 
 
-1.5 setpolicy
+1.6 setpolicy
 ---------------
 
 The setpolicy call only takes a struct cpufreq_policy *policy as
@@ -190,6 +195,16 @@ setting when policy->policy is CPUFREQ_POLICY_PERFORMANCE, and a
 powersaving-oriented setting when CPUFREQ_POLICY_POWERSAVE. Also check
 the reference implementation in drivers/cpufreq/longrun.c
 
+1.7 get_intermediate and target_intermediate
+--------------------------------------------
+
+Only for drivers with target_index() and CPUFREQ_ASYNC_NOTIFICATION unset.
+
+get_intermediate should return a stable intermediate frequency platform wants to
+switch to, and target_intermediate() should set CPU to to that frequency, before
+jumping to the frequency corresponding to 'index'. Core will take care of
+sending notifications and driver doesn't have to handle them in
+target_intermediate() or target_index().
 
 
 2. Frequency Table Helpers
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 9bf12a2..f38f2f2 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1819,27 +1819,50 @@ EXPORT_SYMBOL(cpufreq_unregister_notifier);
 static int __target_index(struct cpufreq_policy *policy,
 			  struct cpufreq_frequency_table *freq_table, int index)
 {
-	struct cpufreq_freqs freqs;
+	struct cpufreq_freqs freqs = {.old = policy->cur, .flags = 0};
 	int retval = -EINVAL;
 	bool notify;
 
 	notify = !(cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION);
+	if (!notify)
+		goto skip_notify;
 
-	if (notify) {
-		freqs.old = policy->cur;
-		freqs.new = freq_table[index].frequency;
-		freqs.flags = 0;
+	/* Handle switching to intermediate frequency */
+	if (cpufreq_driver->get_intermediate) {
+		freqs.new = cpufreq_driver->get_intermediate(policy, index);
 
-		pr_debug("%s: cpu: %d, oldfreq: %u, new freq: %u\n",
+		pr_debug("%s: cpu: %d, switching to intermediate freq: oldfreq: %u, intermediate freq: %u\n",
 				__func__, policy->cpu, freqs.old, freqs.new);
 
 		cpufreq_freq_transition_begin(policy, &freqs);
+		retval = cpufreq_driver->target_intermediate(policy, freqs.new);
+		cpufreq_freq_transition_end(policy, &freqs, retval);
+
+		if (retval) {
+			pr_err("%s: Failed to change to intermediate frequency: %d\n",
+				__func__, retval);
+			return retval;
+		}
+
+		/* Set intermediate as old freq */
+		freqs.old = freqs.new;
 	}
 
+	freqs.new = freq_table[index].frequency;
+
+	pr_debug("%s: cpu: %d, oldfreq: %u, new freq: %u\n", __func__,
+		 policy->cpu, freqs.old, freqs.new);
+
+	cpufreq_freq_transition_begin(policy, &freqs);
+
+skip_notify:
 	retval = cpufreq_driver->target_index(policy, index);
-	if (retval)
+	if (retval) {
+		/* We shouldn't fail after setting intermediate freq */
+		WARN_ON(cpufreq_driver->get_intermediate);
 		pr_err("%s: Failed to change cpu frequency: %d\n",
 				__func__, retval);
+	}
 
 	if (notify)
 		cpufreq_freq_transition_end(policy, &freqs, retval);
@@ -2361,7 +2384,8 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	    !(driver_data->setpolicy || driver_data->target_index ||
 		    driver_data->target) ||
 	     (driver_data->setpolicy && (driver_data->target_index ||
-		    driver_data->target)))
+		    driver_data->target)) ||
+	     (!!driver_data->get_intermediate ^ !!driver_data->target_intermediate))
 		return -EINVAL;
 
 	pr_debug("trying to register driver %s\n", driver_data->name);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 3f45889..bfcba11 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -226,6 +226,21 @@ struct cpufreq_driver {
 				 unsigned int relation);
 	int	(*target_index)	(struct cpufreq_policy *policy,
 				 unsigned int index);
+	/*
+	 * Only for drivers with target_index() and CPUFREQ_ASYNC_NOTIFICATION
+	 * unset.
+	 *
+	 * get_intermediate should return a stable intermediate frequency
+	 * platform wants to switch to and target_intermediate() should set CPU
+	 * to to that frequency, before jumping to the frequency corresponding
+	 * to 'index'. Core will take care of sending notifications and driver
+	 * doesn't have to handle them in target_intermediate() or
+	 * target_index().
+	 */
+	unsigned int (*get_intermediate)(struct cpufreq_policy *policy,
+					 unsigned int index);
+	int	(*target_intermediate)(struct cpufreq_policy *policy,
+				       unsigned int frequency);
 
 	/* should be defined, if possible */
 	unsigned int	(*get)	(unsigned int cpu);
-- 
2.0.0.rc2

