Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707Ab3HJGsy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:48:54 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:57238 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758694Ab3HJGss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:48:48 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        John Crispin <blogic@openwrt.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-cris-kernel@axis.com,
        linux-sh@vger.kernel.org, Mikael Starvik <starvik@axis.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        sparclinux@vger.kernel.org, spear-devel@list.st.com,
        Stephen Warren <swarren@nvidia.com>, Steven Miao <realmz6@gmail.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 08/44] cpufreq: define generic .attr, .exit() and .verify() routines
Date: Sat, 10 Aug 2013 12:14:04 +0530
Message-Id: <180b46ed83c4e51375c5c011110ce4f1bf9c963d.1376116345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376116344.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376116344.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
and .attr. So its better if we have generic routines for them which can be used
by cpufreq drivers then.

This patch introduces generic .attr, .exit() and .verify() cpufreq drivers.

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: John Crispin <blogic@openwrt.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-cris-kernel@axis.com
Cc: linux-sh@vger.kernel.org
Cc: Mikael Starvik <starvik@axis.com>
Cc: Paul Mundt <lethal@linux-sh.org>
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
 drivers/cpufreq/freq_table.c | 20 ++++++++++++++++++++
 include/linux/cpufreq.h      |  8 ++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index 11f6fa9..b198458 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -87,6 +87,20 @@ int cpufreq_frequency_table_verify(struct cpufreq_policy *policy,
 }
 EXPORT_SYMBOL_GPL(cpufreq_frequency_table_verify);
 
+/*
+ * Generic routine to verify policy & frequency table, requires driver to call
+ * cpufreq_frequency_table_get_attr() prior to it.
+ */
+int cpufreq_generic_frequency_table_verify(struct cpufreq_policy *policy)
+{
+	struct cpufreq_frequency_table *table =
+		cpufreq_frequency_get_table(policy->cpu);
+	if (!table)
+		return -ENODEV;
+
+	return cpufreq_frequency_table_verify(policy, table);
+}
+EXPORT_SYMBOL_GPL(cpufreq_generic_frequency_table_verify);
 
 int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 				   struct cpufreq_frequency_table *table,
@@ -200,6 +214,12 @@ struct freq_attr cpufreq_freq_attr_scaling_available_freqs = {
 };
 EXPORT_SYMBOL_GPL(cpufreq_freq_attr_scaling_available_freqs);
 
+struct freq_attr *cpufreq_generic_attr[] = {
+	&cpufreq_freq_attr_scaling_available_freqs,
+	NULL,
+};
+EXPORT_SYMBOL_GPL(cpufreq_generic_attr);
+
 /*
  * if you use these, you must assure that the frequency table is valid
  * all the time between get_attr and put_attr!
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index c0297a6..4907eb2 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -393,6 +393,7 @@ int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
 
 int cpufreq_frequency_table_verify(struct cpufreq_policy *policy,
 				   struct cpufreq_frequency_table *table);
+int cpufreq_generic_frequency_table_verify(struct cpufreq_policy *policy);
 
 int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 				   struct cpufreq_frequency_table *table,
@@ -408,10 +409,17 @@ struct cpufreq_frequency_table *cpufreq_frequency_get_table(unsigned int cpu);
 
 /* the following are really really optional */
 extern struct freq_attr cpufreq_freq_attr_scaling_available_freqs;
+extern struct freq_attr *cpufreq_generic_attr[];
 void cpufreq_frequency_table_get_attr(struct cpufreq_frequency_table *table,
 				      unsigned int cpu);
 void cpufreq_frequency_table_put_attr(unsigned int cpu);
 int cpufreq_table_validate_and_show(struct cpufreq_policy *policy,
 				      struct cpufreq_frequency_table *table);
 
+static inline int cpufreq_generic_exit(struct cpufreq_policy *policy)
+{
+	cpufreq_frequency_table_put_attr(policy->cpu);
+	return 0;
+}
+
 #endif /* _LINUX_CPUFREQ_H */
-- 
1.7.12.rc2.18.g61b472e

