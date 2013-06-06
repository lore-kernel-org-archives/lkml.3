Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3FFHJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:09:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11261 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab3FFHJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 03:09:32 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-5f-51b035abbe45
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
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 4/5] cpufreq:exynos:Extend exynos cpufreq driver to support
 boost
Date: Thu, 06 Jun 2013 09:07:51 +0200
Message-id: <1370502472-7249-5-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jQd3VphsCDU7vMLX483Y5q8XTph/s
	FvM+y1p0nn3CbPHmEbfFm4ebGS0u75rDZvG59wijxe3GFWwW/Qt7mSw6jnxjttj41cOBx+PO
	tT1sHuumvWX26NuyitHj0eIWRo/Pm+QCWKO4bFJSczLLUov07RK4MtqXvmQv+ChZsXHRKpYG
	xiWiXYycHBICJhK9/f8ZIWwxiQv31rN1MXJxCAlMZ5Ro6rnDCuF0MUk833eFDaSKTUBP4vPd
	p0wgtoiAr0TPskNgNrPASWaJu8cCQWxhgWCJpVt3sHcxcnCwCKhKfN3uAhLmFXCVOPL0AzvE
	MnmJp/f7wEZyCrhJzP30AswWAqq5+WElywRG3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLz
	czcxggPwmdQOxpUNFocYBTgYlXh4JQLWBwqxJpYVV+YeYpTgYFYS4Y0V2RAoxJuSWFmVWpQf
	X1Sak1p8iFGag0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJg1OqgbHq0PwfP6ZWqNyXbeVIjtL0
	CYl2j33x4qLmn+7P7hfuntm598f/PQFn7wldEb7w1CzTN0roV+freUc0K3ZeWCu81OCcujbv
	BjbDJRHR+yYuC8z33nBnv4diD+9HjrCfa3P79a5U+G7Kal231tl/uXd/3/lCix2Tuapu73l6
	NWlv6dRvGlm31cOVWIozEg21mIuKEwE8sVyiPAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New structure - exynos_boost has been created to embrace the information
related to boost support.

The CONFIG_CPU_FREQ_BOOST flag is responsible for attaching the boost structure
to the cpufreq driver.
Setting exynos cpufreq driver .boost field to NULL, indicates that boost is
not supported.
Moreover device tree attribute "boost_mode" defines if exynos platform
support frequency overclocking (boost).

Moreover new attribute structure describing extra CPU features supported when boost
is enabled is also provided.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/cpufreq/exynos-cpufreq.c |   48 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 3197d88..0b6fdf6 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -267,6 +267,38 @@ static struct freq_attr *exynos_cpufreq_attr[] = {
 	NULL,
 };
 
+/* per CPU boost attributes to be exported to sysfs */
+static struct freq_attr *exynos_cpufreq_boost_attr[] = {
+	&cpufreq_freq_attr_boost_available_freqs,
+	NULL,
+};
+
+/* low level code to enable/disable boost */
+static int
+exynos_cpufreq_boost_trigger(struct cpufreq_policy *policy, int state)
+{
+
+	if (!policy || !policy->boost)
+		return -ENODEV;
+
+	if (state) {
+		policy->boost->max_normal_freq = policy->max;
+		policy->max = policy->boost->max_boost_freq;
+		policy->cpuinfo.max_freq = policy->max;
+	} else {
+		policy->max = policy->boost->max_normal_freq;
+		policy->cpuinfo.max_freq = policy->max;
+	}
+
+	return 0;
+}
+
+static struct cpufreq_boost exynos_boost = {
+	.attr                   = exynos_cpufreq_boost_attr,
+	.low_level_boost        = exynos_cpufreq_boost_trigger,
+	.policies               = LIST_HEAD_INIT(exynos_boost.policies),
+};
+
 static struct cpufreq_driver exynos_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= exynos_verify_speed,
@@ -276,6 +308,9 @@ static struct cpufreq_driver exynos_driver = {
 	.exit		= exynos_cpufreq_cpu_exit,
 	.name		= "exynos_cpufreq",
 	.attr		= exynos_cpufreq_attr,
+#ifdef CONFIG_CPU_FREQ_BOOST
+	.boost		= &exynos_boost,
+#endif
 #ifdef CONFIG_PM
 	.suspend	= exynos_cpufreq_suspend,
 	.resume		= exynos_cpufreq_resume,
@@ -359,6 +394,8 @@ static struct of_device_id exynos_cpufreq_of_match[] __initconst = {
 
 static int __init exynos_cpufreq_probe(struct platform_device *pdev)
 {
+	struct device_node *node = pdev->dev.of_node;
+
 	int ret = -EINVAL;
 
 	exynos_info = kzalloc(sizeof(struct exynos_dvfs_info), GFP_KERNEL);
@@ -390,6 +427,17 @@ static int __init exynos_cpufreq_probe(struct platform_device *pdev)
 		goto err_vdd_arm;
 	}
 
+	/* If boost_mode property not available - then NULL out the boost
+	   pointer to indicate thst boost is not supported*/
+	if (exynos_driver.boost) {
+		if (of_property_read_bool(node, "boost_mode"))
+			exynos_boost.max_boost_freq =
+				cpufreq_frequency_table_boost_max(
+						 exynos_info->freq_table);
+		else
+			exynos_driver.boost = NULL;
+	}
+
 	locking_frequency = exynos_getspeed(0);
 
 	register_pm_notifier(&exynos_cpufreq_nb);
-- 
1.7.10.4

