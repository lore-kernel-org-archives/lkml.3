Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab3FKJF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 05:05:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17137 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3FKJFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 05:05:22 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-f4-51b6e851c386
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocky" <rjw@sisk.pl>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH v2 3/3] cpufreq:exynos:Extend Exynos cpufreq driver to support
 boost framework
Date: Tue, 11 Jun 2013 11:03:28 +0200
Message-id: <1370941408-29304-4-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1370941408-29304-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1370941408-29304-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t9jQd3AF9sCDabt4LD483Y5q8XTph/s
	FvM+y1p0nn3CbNG74CqbxZtH3BZvHm5mtLi8aw6bxefeI4wWtxtXsFn0L+xlsug48o3ZYuNX
	DwdejzvX9rB5rJv2ltmjb8sqRo9Hi1sYPT5vkgtgjeKySUnNySxLLdK3S+DKePX1KlvBdaWK
	DW1trA2M72S6GDk5JARMJLY3dDND2GISF+6tZ+ti5OIQEpjOKNH75C2U08UkcWDOcXaQKjYB
	PYnPd58ygdgiAr4SPcsOMYEUMQu8ZZb4tvAvWEJYIEFixoYVjCA2i4CqxLzZB1hBbF4BN4nX
	h1YxQqyTl3h6v48NxOYUcJd4/HoXmC0k0MQosfNLzgRG3gWMDKsYRVMLkguKk9JzDfWKE3OL
	S/PS9ZLzczcxgsPxmdQOxpUNFocYBTgYlXh4Exi3BQqxJpYVV+YeYpTgYFYS4TXdDhTiTUms
	rEotyo8vKs1JLT7EKM3BoiTOe6DVOlBIID2xJDU7NbUgtQgmy8TBKdXAuPXxUQ7r++F/tU3l
	lFcmeQRoc91fUpfit+72UfPTG84WRF15ePJpy4Rty6U7TwlWyFjsiPW2W1t4vjD/iXP3+22M
	JRGh/5fsyw9PD5x7WTvw5raLp3smlWr0JNo8NSySv+jizX9xP9skho9HzrRtWW3S/+8ERyir
	pfsvtauXDl5/dCg8oNyFRYmlOCPRUIu5qDgRAM6rISRDAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct cpufreq_driver has been extended to embrace the information
related to boost support.

When "boost_mode" device tree attribute is defined for a platform, the
low_level_boost pointer is filled with proper address. The
.low_level_boost field filled to NULL, indicates that boost is not
supported.

Operations of exynos_cpufreq_boost_trigger() function are protected with
"local" mutex.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

---
Changes for v2:
- Removal of struct cpufreq_boost
- Removal of the CONFIG_CPU_FREQ_BOOST flag
- low_level_boost with valid address when boost is supported
---
 drivers/cpufreq/exynos-cpufreq.c |   49 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 3197d88..8cf5636 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -33,6 +33,7 @@ static struct cpufreq_freqs freqs;
 static unsigned int locking_frequency;
 static bool frequency_locked;
 static DEFINE_MUTEX(cpufreq_lock);
+static struct cpufreq_cpuinfo *cpufreq_cpu_info;
 
 static int exynos_verify_speed(struct cpufreq_policy *policy)
 {
@@ -154,6 +155,7 @@ out:
 	return ret;
 }
 
+static struct cpufreq_driver exynos_driver;
 static int exynos_target(struct cpufreq_policy *policy,
 			  unsigned int target_freq,
 			  unsigned int relation)
@@ -244,6 +246,9 @@ static struct notifier_block exynos_cpufreq_nb = {
 
 static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
+	unsigned int max_freq;
+	int ret;
+
 	policy->cur = policy->min = policy->max = exynos_getspeed(policy->cpu);
 
 	cpufreq_frequency_table_get_attr(exynos_info->freq_table, policy->cpu);
@@ -253,7 +258,19 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 	cpumask_setall(policy->cpus);
 
-	return cpufreq_frequency_table_cpuinfo(policy, exynos_info->freq_table);
+	ret = cpufreq_frequency_table_cpuinfo(policy, exynos_info->freq_table);
+	if (ret)
+		return ret;
+
+	if (exynos_driver.low_level_boost) {
+		/* disable boost by default */
+		max_freq = cpufreq_frequency_table_max(exynos_info->freq_table,
+						       0);
+		policy->cpuinfo.max_freq = policy->max = max_freq;
+		cpufreq_cpu_info = &policy->cpuinfo;
+	}
+
+	return 0;
 }
 
 static int exynos_cpufreq_cpu_exit(struct cpufreq_policy *policy)
@@ -264,9 +281,32 @@ static int exynos_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 
 static struct freq_attr *exynos_cpufreq_attr[] = {
 	&cpufreq_freq_attr_scaling_available_freqs,
+	&cpufreq_freq_attr_boost_available_freqs,
 	NULL,
 };
 
+static int exynos_cpufreq_boost_trigger(int state)
+{
+	struct cpufreq_policy *policy = container_of(cpufreq_cpu_info,
+						     struct cpufreq_policy,
+						     cpuinfo);
+	unsigned int max_freq;
+
+	mutex_lock(&cpufreq_lock);
+	exynos_driver.boost_en = state;
+
+	/* Recalculate maximal frequency */
+	max_freq = cpufreq_frequency_table_max(exynos_info->freq_table,
+					       exynos_driver.boost_en);
+
+	if (policy->max != max_freq)
+		policy->cpuinfo.max_freq = policy->max = max_freq;
+
+	mutex_unlock(&cpufreq_lock);
+
+	return 0;
+}
+
 static struct cpufreq_driver exynos_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= exynos_verify_speed,
@@ -275,7 +315,7 @@ static struct cpufreq_driver exynos_driver = {
 	.init		= exynos_cpufreq_cpu_init,
 	.exit		= exynos_cpufreq_cpu_exit,
 	.name		= "exynos_cpufreq",
-	.attr		= exynos_cpufreq_attr,
+	.attr	= exynos_cpufreq_attr,
 #ifdef CONFIG_PM
 	.suspend	= exynos_cpufreq_suspend,
 	.resume		= exynos_cpufreq_resume,
@@ -359,6 +399,8 @@ static struct of_device_id exynos_cpufreq_of_match[] __initconst = {
 
 static int __init exynos_cpufreq_probe(struct platform_device *pdev)
 {
+	struct device_node *node = pdev->dev.of_node;
+
 	int ret = -EINVAL;
 
 	exynos_info = kzalloc(sizeof(struct exynos_dvfs_info), GFP_KERNEL);
@@ -391,6 +433,9 @@ static int __init exynos_cpufreq_probe(struct platform_device *pdev)
 	}
 
 	locking_frequency = exynos_getspeed(0);
+	if (of_property_read_bool(node, "boost_mode"))
+		exynos_driver.low_level_boost =
+			&exynos_cpufreq_boost_trigger;
 
 	register_pm_notifier(&exynos_cpufreq_nb);
 
-- 
1.7.10.4

