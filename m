Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab3HPC0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:26:04 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59583 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab3HPCZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:25:59 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        John Crispin <blogic@openwrt.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-cris-kernel@axis.com,
        Mikael Starvik <starvik@axis.com>,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        sparclinux@vger.kernel.org, spear-devel@list.st.com,
        Stephen Warren <swarren@nvidia.com>, Steven Miao <realmz6@gmail.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 01/34] cpufreq: move freq change notifications to cpufreq core
Date: Fri, 16 Aug 2013 07:54:58 +0530
Message-Id: <8d083bb5c2d167aa0b52f48c3f17a1320b3e0249.1376619363.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376619363.git.viresh.kumar@linaro.org>
References: <cover.1376619363.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376619363.git.viresh.kumar@linaro.org>
References: <cover.1376619363.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the drivers do following in their ->target_index() routines:

	struct cpufreq_freqs freqs;
	freqs.old = old freq...
	freqs.new = new freq...

	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);

	/* Change rate here */

	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);

This is replicated over all cpufreq drivers today and there doesn't exists a
good enough reason why this shouldn't be moved to cpufreq core instead.

There are few special cases though, like exynos5440, which doesn't do everything
on the call to ->target_index() routine and call some kind of bottom halves for
doing this work, work/tasklet/etc..

They may continue doing notification from their own code and so this patch
introduces another flag: CPUFREQ_NO_NOTIFICATION, which will be set by such
drivers.

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: John Crispin <blogic@openwrt.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-cris-kernel@axis.com
Cc: Mikael Starvik <starvik@axis.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: sparclinux@vger.kernel.org
Cc: spear-devel@list.st.com
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 34 ++++++++++++++++++++++++++++++++++
 include/linux/cpufreq.h   |  6 ++++++
 2 files changed, 40 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index a7a1d3e..2782949 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1673,6 +1673,9 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 		retval = cpufreq_driver->target(policy, target_freq, relation);
 	else if (cpufreq_driver->target_index) {
 		struct cpufreq_frequency_table *freq_table;
+		struct cpufreq_freqs freqs;
+		unsigned long flags;
+		bool notify;
 		int index;
 
 		freq_table = cpufreq_frequency_get_table(policy->cpu);
@@ -1691,7 +1694,38 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
 		if (freq_table[index].frequency == policy->cur)
 			return 0;
 
+		read_lock_irqsave(&cpufreq_driver_lock, flags);
+		notify = !(cpufreq_driver->flags | CPUFREQ_NO_NOTIFICATION);
+		read_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
+		if (notify) {
+			freqs.old = policy->cur;
+			freqs.new = freq_table[index].frequency;
+
+			pr_debug("%s: cpu: %d, oldfreq: %u, new freq: %u\n",
+					__func__, policy->cpu, freqs.old,
+					freqs.new);
+
+			cpufreq_notify_transition(policy, &freqs,
+					CPUFREQ_PRECHANGE);
+		}
+
 		retval = cpufreq_driver->target_index(policy, index);
+		if (retval)
+			pr_err("%s: Failed to change cpu frequency: %d\n",
+					__func__, retval);
+
+		if (notify) {
+			/*
+			 * Notify with old freq in case we failed to change
+			 * frequency
+			 */
+			if (retval)
+				freqs.new = freqs.old;
+
+			cpufreq_notify_transition(policy, &freqs,
+					CPUFREQ_POSTCHANGE);
+		}
 	}
 
 	return retval;
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index ff9c8df..62ce478 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -221,6 +221,12 @@ struct cpufreq_driver {
 					 * frequency transitions */
 #define CPUFREQ_PM_NO_WARN	0x04	/* don't warn on suspend/resume speed
 					 * mismatches */
+/*
+ * Driver will call cpufreq_notify_transition() in its target_index() routine
+ * and so cpufreq core must not call it. Only useful for drivers that implement
+ * target_index(), unused otherwise.
+ */
+#define CPUFREQ_NO_NOTIFICATION	0x08
 
 int cpufreq_register_driver(struct cpufreq_driver *driver_data);
 int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
-- 
1.7.12.rc2.18.g61b472e

