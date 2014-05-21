Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaEUJEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:04:54 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:56448 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbaEUJEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:04:50 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        swarren@nvidia.com, dianders@chromium.org, linux@arm.linux.org.uk,
        nicolas.pitre@linaro.org, thomas.abraham@linaro.org,
        pdeschrijver@nvidia.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V4 2/3] cpufreq: add support for intermediate (stable) frequencies
Date: Wed, 21 May 2014 14:29:30 +0530
Message-Id: <59e1185a31e61c428aca9f4b8f0a69f182ee458e.1400662383.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1400662383.git.viresh.kumar@linaro.org>
References: <cover.1400662383.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1400662383.git.viresh.kumar@linaro.org>
References: <cover.1400662383.git.viresh.kumar@linaro.org>
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

get_intermediate() should return a stable intermediate frequency platform wants
to switch to, and target_intermediate() should set CPU to to that frequency,
before jumping to the frequency corresponding to 'index'. Core will take care of
sending notifications and driver doesn't have to handle them in
target_intermediate() or target_index().

NOTE: ->target_index() should restore to policy->restore_freq in case of
failures as core would send notifications for that.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 Documentation/cpu-freq/cpu-drivers.txt | 29 ++++++++++++++-
 drivers/cpufreq/cpufreq.c              | 67 ++++++++++++++++++++++++++++++----
 include/linux/cpufreq.h                | 25 +++++++++++++
 3 files changed, 112 insertions(+), 9 deletions(-)

diff --git a/Documentation/cpu-freq/cpu-drivers.txt b/Documentation/cpu-freq/cpu-drivers.txt
index b045fe5..14f4e63 100644
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
+and target_intermediate		Used to switch to stable frequency while
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
@@ -160,6 +165,9 @@ and unsigned int index (into the exposed frequency table).
 The CPUfreq driver must set the new frequency when called here. The
 actual frequency must be determined by freq_table[index].frequency.
 
+It should always restore to earlier frequency (i.e. policy->restore_freq) in
+case of errors, even if we switched to intermediate frequency earlier.
+
 Deprecated:
 ----------
 The target call has three arguments: struct cpufreq_policy *policy,
@@ -179,7 +187,7 @@ Here again the frequency table helper might assist you - see section 2
 for details.
 
 
-1.5 setpolicy
+1.6 setpolicy
 ---------------
 
 The setpolicy call only takes a struct cpufreq_policy *policy as
@@ -190,6 +198,23 @@ setting when policy->policy is CPUFREQ_POLICY_PERFORMANCE, and a
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
+
+Drivers can return '0' from get_intermediate() in case they don't wish to switch
+to intermediate frequency for some target frequency. In that case core will
+directly call ->target_index().
+
+NOTE: ->target_index() should restore to policy->restore_freq in case of
+failures as core would send notifications for that.
 
 
 2. Frequency Table Helpers
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index ae11dd5..a72c4d5 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1816,20 +1816,55 @@ EXPORT_SYMBOL(cpufreq_unregister_notifier);
  *                              GOVERNORS                            *
  *********************************************************************/
 
+/* Must set freqs->new to intermediate frequency */
+static int __target_intermediate(struct cpufreq_policy *policy,
+				 struct cpufreq_freqs *freqs, int index)
+{
+	int ret;
+
+	freqs->new = cpufreq_driver->get_intermediate(policy, index);
+
+	/* We don't need to switch to intermediate freq */
+	if (!freqs->new)
+		return 0;
+
+	pr_debug("%s: cpu: %d, switching to intermediate freq: oldfreq: %u, intermediate freq: %u\n",
+		 __func__, policy->cpu, freqs->old, freqs->new);
+
+	cpufreq_freq_transition_begin(policy, freqs);
+	ret = cpufreq_driver->target_intermediate(policy, index);
+	cpufreq_freq_transition_end(policy, freqs, ret);
+
+	if (ret)
+		pr_err("%s: Failed to change to intermediate frequency: %d\n",
+		       __func__, ret);
+	else
+		/* Set old freq to intermediate */
+		freqs->old = freqs->new;
+
+	return ret;
+}
+
 static int __target_index(struct cpufreq_policy *policy,
 			  struct cpufreq_frequency_table *freq_table, int index)
 {
-	struct cpufreq_freqs freqs;
+	struct cpufreq_freqs freqs = {.old = policy->cur, .flags = 0};
+	unsigned int intermediate_freq = 0;
 	int retval = -EINVAL;
 	bool notify;
 
 	notify = !(cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION);
-
 	if (notify) {
-		freqs.old = policy->cur;
-		freqs.new = freq_table[index].frequency;
-		freqs.flags = 0;
+		/* Handle switching to intermediate frequency */
+		if (cpufreq_driver->get_intermediate) {
+			retval = __target_intermediate(policy, &freqs, index);
+			if (retval)
+				return retval;
 
+			intermediate_freq = freqs.new;
+		}
+
+		freqs.new = freq_table[index].frequency;
 		pr_debug("%s: cpu: %d, oldfreq: %u, new freq: %u\n",
 			 __func__, policy->cpu, freqs.old, freqs.new);
 
@@ -1841,9 +1876,23 @@ static int __target_index(struct cpufreq_policy *policy,
 		pr_err("%s: Failed to change cpu frequency: %d\n", __func__,
 		       retval);
 
-	if (notify)
+	if (notify) {
 		cpufreq_freq_transition_end(policy, &freqs, retval);
 
+		/*
+		 * Failed after setting to intermediate freq? Driver should have
+		 * reverted back to initial frequency and so should we. Check
+		 * here for intermediate_freq instead of get_intermediate, in
+		 * case we have't switched to intermediate freq at all.
+		 */
+		if (unlikely(retval && intermediate_freq)) {
+			freqs.old = intermediate_freq;
+			freqs.new = policy->restore_freq;
+			cpufreq_freq_transition_begin(policy, &freqs);
+			cpufreq_freq_transition_end(policy, &freqs, retval);
+		}
+	}
+
 	return retval;
 }
 
@@ -1875,6 +1924,9 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 	if (target_freq == policy->cur)
 		return 0;
 
+	/* Save last value to restore later on errors */
+	policy->restore_freq = policy->cur;
+
 	if (cpufreq_driver->target)
 		retval = cpufreq_driver->target(policy, target_freq, relation);
 	else if (cpufreq_driver->target_index) {
@@ -2361,7 +2413,8 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	    !(driver_data->setpolicy || driver_data->target_index ||
 		    driver_data->target) ||
 	     (driver_data->setpolicy && (driver_data->target_index ||
-		    driver_data->target)))
+		    driver_data->target)) ||
+	     (!!driver_data->get_intermediate != !!driver_data->target_intermediate))
 		return -EINVAL;
 
 	pr_debug("trying to register driver %s\n", driver_data->name);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 3f45889..ec4112d 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -75,6 +75,7 @@ struct cpufreq_policy {
 	unsigned int		max;    /* in kHz */
 	unsigned int		cur;    /* in kHz, only needed if cpufreq
 					 * governors are used */
+	unsigned int		restore_freq; /* = policy->cur before transition */
 	unsigned int		suspend_freq; /* freq to set during suspend */
 
 	unsigned int		policy; /* see above */
@@ -221,11 +222,35 @@ struct cpufreq_driver {
 
 	/* define one out of two */
 	int	(*setpolicy)	(struct cpufreq_policy *policy);
+
+	/*
+	 * On failure, should always restore frequency to policy->restore_freq
+	 * (i.e. old freq).
+	 */
 	int	(*target)	(struct cpufreq_policy *policy,	/* Deprecated */
 				 unsigned int target_freq,
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
+	 *
+	 * Drivers can return '0' from get_intermediate() in case they don't
+	 * wish to switch to intermediate frequency for some target frequency.
+	 * In that case core will directly call ->target_index().
+	 */
+	unsigned int (*get_intermediate)(struct cpufreq_policy *policy,
+					 unsigned int index);
+	int	(*target_intermediate)(struct cpufreq_policy *policy,
+				       unsigned int index);
 
 	/* should be defined, if possible */
 	unsigned int	(*get)	(unsigned int cpu);
-- 
2.0.0.rc2

