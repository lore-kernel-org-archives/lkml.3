Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaCXIGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:06:15 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:47314 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbaCXIGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:06:08 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V5 2/3] cpufreq: Convert existing drivers to use cpufreq_freq_transition_{begin|end}
Date: Mon, 24 Mar 2014 13:35:45 +0530
Message-Id: <62df418d9218fd81679929b9e5e0e74b3113048a.1395644073.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1395644073.git.viresh.kumar@linaro.org>
References: <cover.1395644073.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1395644073.git.viresh.kumar@linaro.org>
References: <cover.1395644073.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUFreq core has new infrastructure that would guarantee serialized calls to
target() or target_index() callbacks. These are called
cpufreq_freq_transition_begin() and cpufreq_freq_transition_end().

This patch converts existing drivers to use these new set of routines.

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq-nforce2.c    | 4 ++--
 drivers/cpufreq/cpufreq.c            | 9 ++++-----
 drivers/cpufreq/exynos5440-cpufreq.c | 4 ++--
 drivers/cpufreq/gx-suspmod.c         | 4 ++--
 drivers/cpufreq/integrator-cpufreq.c | 4 ++--
 drivers/cpufreq/longhaul.c           | 4 ++--
 drivers/cpufreq/pcc-cpufreq.c        | 4 ++--
 drivers/cpufreq/powernow-k6.c        | 4 ++--
 drivers/cpufreq/powernow-k7.c        | 4 ++--
 drivers/cpufreq/powernow-k8.c        | 4 ++--
 drivers/cpufreq/s3c24xx-cpufreq.c    | 4 ++--
 drivers/cpufreq/sh-cpufreq.c         | 4 ++--
 drivers/cpufreq/unicore2-cpufreq.c   | 4 ++--
 13 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-nforce2.c b/drivers/cpufreq/cpufreq-nforce2.c
index a05b876..bc447b9 100644
--- a/drivers/cpufreq/cpufreq-nforce2.c
+++ b/drivers/cpufreq/cpufreq-nforce2.c
@@ -270,7 +270,7 @@ static int nforce2_target(struct cpufreq_policy *policy,
 	pr_debug("Old CPU frequency %d kHz, new %d kHz\n",
 	       freqs.old, freqs.new);
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+	cpufreq_freq_transition_begin(policy, &freqs);
 
 	/* Disable IRQs */
 	/* local_irq_save(flags); */
@@ -285,7 +285,7 @@ static int nforce2_target(struct cpufreq_policy *policy,
 	/* Enable IRQs */
 	/* local_irq_restore(flags); */
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	cpufreq_freq_transition_end(policy, &freqs, 0);
 
 	return 0;
 }
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index d57806a..eb562d0 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1507,8 +1507,8 @@ static void cpufreq_out_of_sync(unsigned int cpu, unsigned int old_freq,
 	policy = per_cpu(cpufreq_cpu_data, cpu);
 	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	cpufreq_freq_transition_begin(policy, &freqs);
+	cpufreq_freq_transition_end(policy, &freqs, 0);
 }
 
 /**
@@ -1868,8 +1868,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 			pr_debug("%s: cpu: %d, oldfreq: %u, new freq: %u\n",
 				 __func__, policy->cpu, freqs.old, freqs.new);
 
-			cpufreq_notify_transition(policy, &freqs,
-					CPUFREQ_PRECHANGE);
+			cpufreq_freq_transition_begin(policy, &freqs);
 		}
 
 		retval = cpufreq_driver->target_index(policy, index);
@@ -1878,7 +1877,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 			       __func__, retval);
 
 		if (notify)
-			cpufreq_notify_post_transition(policy, &freqs, retval);
+			cpufreq_freq_transition_end(policy, &freqs, retval);
 	}
 
 out:
diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index 7f776aa..a6b8214 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -219,7 +219,7 @@ static int exynos_target(struct cpufreq_policy *policy, unsigned int index)
 	freqs.old = policy->cur;
 	freqs.new = freq_table[index].frequency;
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+	cpufreq_freq_transition_begin(policy, &freqs);
 
 	/* Set the target frequency in all C0_3_PSTATE register */
 	for_each_cpu(i, policy->cpus) {
@@ -258,7 +258,7 @@ static void exynos_cpufreq_work(struct work_struct *work)
 		dev_crit(dvfs_info->dev, "New frequency out of range\n");
 		freqs.new = freqs.old;
 	}
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	cpufreq_freq_transition_end(policy, &freqs, 0);
 
 	cpufreq_cpu_put(policy);
 	mutex_unlock(&cpufreq_lock);
diff --git a/drivers/cpufreq/gx-suspmod.c b/drivers/cpufreq/gx-suspmod.c
index d83e826..1d723dc 100644
--- a/drivers/cpufreq/gx-suspmod.c
+++ b/drivers/cpufreq/gx-suspmod.c
@@ -265,7 +265,7 @@ static void gx_set_cpuspeed(struct cpufreq_policy *policy, unsigned int khz)
 
 	freqs.new = new_khz;
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+	cpufreq_freq_transition_begin(policy, &freqs);
 	local_irq_save(flags);
 
 	if (new_khz != stock_freq) {
@@ -314,7 +314,7 @@ static void gx_set_cpuspeed(struct cpufreq_policy *policy, unsigned int khz)
 
 	gx_params->pci_suscfg = suscfg;
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	cpufreq_freq_transition_end(policy, &freqs, 0);
 
 	pr_debug("suspend modulation w/ duration of ON:%d us, OFF:%d us\n",
 		gx_params->on_duration * 32, gx_params->off_duration * 32);
diff --git a/drivers/cpufreq/integrator-cpufreq.c b/drivers/cpufreq/integrator-cpufreq.c
index 0e27844..e5122f1 100644
--- a/drivers/cpufreq/integrator-cpufreq.c
+++ b/drivers/cpufreq/integrator-cpufreq.c
@@ -122,7 +122,7 @@ static int integrator_set_target(struct cpufreq_policy *policy,
 		return 0;
 	}
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+	cpufreq_freq_transition_begin(policy, &freqs);
 
 	cm_osc = __raw_readl(cm_base + INTEGRATOR_HDR_OSC_OFFSET);
 
@@ -143,7 +143,7 @@ static int integrator_set_target(struct cpufreq_policy *policy,
 	 */
 	set_cpus_allowed(current, cpus_allowed);
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	cpufreq_freq_transition_end(policy, &freqs, 0);
 
 	return 0;
 }
diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index 7b94da3..5c440f8 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -269,7 +269,7 @@ static void longhaul_setstate(struct cpufreq_policy *policy,
 	freqs.old = calc_speed(longhaul_get_cpu_mult());
 	freqs.new = speed;
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+	cpufreq_freq_transition_begin(policy, &freqs);
 
 	pr_debug("Setting to FSB:%dMHz Mult:%d.%dx (%s)\n",
 			fsb, mult/10, mult%10, print_speed(speed/1000));
@@ -386,7 +386,7 @@ retry_loop:
 		}
 	}
 	/* Report true CPU frequency */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	cpufreq_freq_transition_end(policy, &freqs, 0);
 
 	if (!bm_timeout)
 		printk(KERN_INFO PFX "Warning: Timeout while waiting for "
diff --git a/drivers/cpufreq/pcc-cpufreq.c b/drivers/cpufreq/pcc-cpufreq.c
index 1c0f106..728a2d8 100644
--- a/drivers/cpufreq/pcc-cpufreq.c
+++ b/drivers/cpufreq/pcc-cpufreq.c
@@ -215,7 +215,7 @@ static int pcc_cpufreq_target(struct cpufreq_policy *policy,
 
 	freqs.old = policy->cur;
 	freqs.new = target_freq;
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+	cpufreq_freq_transition_begin(policy, &freqs);
 
 	input_buffer = 0x1 | (((target_freq * 100)
 			       / (ioread32(&pcch_hdr->nominal) * 1000)) << 8);
@@ -231,7 +231,7 @@ static int pcc_cpufreq_target(struct cpufreq_policy *policy,
 	status = ioread16(&pcch_hdr->status);
 	iowrite16(0, &pcch_hdr->status);
 
-	cpufreq_notify_post_transition(policy, &freqs, status != CMD_COMPLETE);
+	cpufreq_freq_transition_end(policy, &freqs, status != CMD_COMPLETE);
 	spin_unlock(&pcc_lock);
 
 	if (status != CMD_COMPLETE) {
diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index ce27e6c..62c6f2e 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -148,11 +148,11 @@ static int powernow_k6_target(struct cpufreq_policy *policy,
 	freqs.old = busfreq * powernow_k6_get_cpu_multiplier();
 	freqs.new = busfreq * clock_ratio[best_i].driver_data;
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+	cpufreq_freq_transition_begin(policy, &freqs);
 
 	powernow_k6_set_cpu_multiplier(best_i);
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	cpufreq_freq_transition_end(policy, &freqs, 0);
 
 	return 0;
 }
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index 0e68e02..f911645 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -269,7 +269,7 @@ static int powernow_target(struct cpufreq_policy *policy, unsigned int index)
 
 	freqs.new = powernow_table[index].frequency;
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+	cpufreq_freq_transition_begin(policy, &freqs);
 
 	/* Now do the magic poking into the MSRs.  */
 
@@ -290,7 +290,7 @@ static int powernow_target(struct cpufreq_policy *policy, unsigned int index)
 	if (have_a0 == 1)
 		local_irq_enable();
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	cpufreq_freq_transition_end(policy, &freqs, 0);
 
 	return 0;
 }
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 27eb2be..770a9e1 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -963,9 +963,9 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data,
 	policy = cpufreq_cpu_get(smp_processor_id());
 	cpufreq_cpu_put(policy);
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+	cpufreq_freq_transition_begin(policy, &freqs);
 	res = transition_fid_vid(data, fid, vid);
-	cpufreq_notify_post_transition(policy, &freqs, res);
+	cpufreq_freq_transition_end(policy, &freqs, res);
 
 	return res;
 }
diff --git a/drivers/cpufreq/s3c24xx-cpufreq.c b/drivers/cpufreq/s3c24xx-cpufreq.c
index 2506974..a3dc192 100644
--- a/drivers/cpufreq/s3c24xx-cpufreq.c
+++ b/drivers/cpufreq/s3c24xx-cpufreq.c
@@ -217,7 +217,7 @@ static int s3c_cpufreq_settarget(struct cpufreq_policy *policy,
 	s3c_cpufreq_updateclk(clk_pclk, cpu_new.freq.pclk);
 
 	/* start the frequency change */
-	cpufreq_notify_transition(policy, &freqs.freqs, CPUFREQ_PRECHANGE);
+	cpufreq_freq_transition_begin(policy, &freqs.freqs);
 
 	/* If hclk is staying the same, then we do not need to
 	 * re-write the IO or the refresh timings whilst we are changing
@@ -261,7 +261,7 @@ static int s3c_cpufreq_settarget(struct cpufreq_policy *policy,
 	local_irq_restore(flags);
 
 	/* notify everyone we've done this */
-	cpufreq_notify_transition(policy, &freqs.freqs, CPUFREQ_POSTCHANGE);
+	cpufreq_freq_transition_end(policy, &freqs.freqs, 0);
 
 	s3c_freq_dbg("%s: finished\n", __func__);
 	return 0;
diff --git a/drivers/cpufreq/sh-cpufreq.c b/drivers/cpufreq/sh-cpufreq.c
index 696170e..86628e2 100644
--- a/drivers/cpufreq/sh-cpufreq.c
+++ b/drivers/cpufreq/sh-cpufreq.c
@@ -68,10 +68,10 @@ static int sh_cpufreq_target(struct cpufreq_policy *policy,
 	freqs.new	= (freq + 500) / 1000;
 	freqs.flags	= 0;
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+	cpufreq_freq_transition_begin(policy, &freqs);
 	set_cpus_allowed_ptr(current, &cpus_allowed);
 	clk_set_rate(cpuclk, freq);
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	cpufreq_freq_transition_end(policy, &freqs, 0);
 
 	dev_dbg(dev, "set frequency %lu Hz\n", freq);
 
diff --git a/drivers/cpufreq/unicore2-cpufreq.c b/drivers/cpufreq/unicore2-cpufreq.c
index 36cc330..13be802 100644
--- a/drivers/cpufreq/unicore2-cpufreq.c
+++ b/drivers/cpufreq/unicore2-cpufreq.c
@@ -44,9 +44,9 @@ static int ucv2_target(struct cpufreq_policy *policy,
 	freqs.old = policy->cur;
 	freqs.new = target_freq;
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+	cpufreq_freq_transition_begin(policy, &freqs);
 	ret = clk_set_rate(policy->mclk, target_freq * 1000);
-	cpufreq_notify_post_transition(policy, &freqs, ret);
+	cpufreq_freq_transition_end(policy, &freqs, ret);
 
 	return ret;
 }
-- 
1.7.12.rc2.18.g61b472e

