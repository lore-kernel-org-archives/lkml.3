Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab3FNHjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 03:39:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26635 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab3FNHjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 03:39:43 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-5e-51bac8bdbdfb
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
Subject: [PATCH v3 3/3] cpufreq:exynos:Extend Exynos cpufreq driver to support
 boost framework
Date: Fri, 14 Jun 2013 09:39:00 +0200
Message-id: <1371195540-2991-4-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1371195540-2991-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371195540-2991-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t9jQd19J3YFGsz7y2Lx5+1yVounTT/Y
	LeZ9lrXoPPuE2aJ3wVU2izePuC3ePNzMaHF51xw2i8+9RxgtbjeuYLPoX9jLZNFx5Buzxcav
	Hg68Hneu7WHzWDftLbNH35ZVjB6PFrcwenzeJBfAGsVlk5Kak1mWWqRvl8CV0fb1IGPBdr6K
	b3tamRoY+3m6GDk5JARMJF5cm8cCYYtJXLi3nq2LkYtDSGA6o8S5BTeYQRJCAl1MEjvnyYDY
	bAJ6Ep/vPmUCsUUEfCV6lh1iAmlgFnjLLPFt4V+whLBAgsSL3f2sIDaLgKrEwp1bwTbwCrhK
	TDjTxQSxTV7i6f0+NhCbU8BNYtqOhywQmxsZJZ4fecc0gZF3ASPDKkbR1ILkguKk9FwjveLE
	3OLSvHS95PzcTYzgcHwmvYNxVYPFIUYBDkYlHt6ECzsDhVgTy4orcw8xSnAwK4nwhv8FCvGm
	JFZWpRblxxeV5qQWH2KU5mBREuc92GodKCSQnliSmp2aWpBaBJNl4uCUamBUf3NsZa5SjPNs
	nsNrD3yeq9z51bui9d3tw3FzbaSykjM/xWhdk81ub/9tvv21wkzxXSekm8JONq6b17joj7qo
	8cMaA9Nbte0uL3Zy1AbH82RwX5U/9vv8km9WmWWlM3Z5KKtlvoyr+dv46uyv9HPrNPhv+tes
	5JP+GpT6rOdB5QYZZxb/6xlKLMUZiYZazEXFiQDLF19ZQwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct cpufreq_driver has been extended to embrace the information
related to boost support.

When "boost_mode" device tree attribute is defined for a platform, the
boost_supported flag is set. Moreover boost related attributes were
exported.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

Changes for v2:
- Removal of struct cpufreq_boost
- Removal of the CONFIG_CPU_FREQ_BOOST flag
- low_level_boost with valid address when boost is supported

Changes for v3:
- Remove low level boost code
- Move boost management code to cpufreq core code
- Use boost_supported flag to indicate if driver supports over clocking

---
 drivers/cpufreq/exynos-cpufreq.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 32ec2f6..0420d47 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -265,6 +265,7 @@ static int exynos_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 
 static struct freq_attr *exynos_cpufreq_attr[] = {
 	&cpufreq_freq_attr_scaling_available_freqs,
+	&cpufreq_freq_attr_scaling_boost_freqs,
 	NULL,
 };
 
@@ -360,6 +361,7 @@ static struct of_device_id exynos_cpufreq_of_match[] __initconst = {
 
 static int __init exynos_cpufreq_probe(struct platform_device *pdev)
 {
+	struct device_node *node = pdev->dev.of_node;
 	int ret = -EINVAL;
 
 	exynos_info = kzalloc(sizeof(struct exynos_dvfs_info), GFP_KERNEL);
@@ -392,6 +394,8 @@ static int __init exynos_cpufreq_probe(struct platform_device *pdev)
 	}
 
 	locking_frequency = exynos_getspeed(0);
+	if (of_property_read_bool(node, "boost_mode"))
+		exynos_driver.boost_supported = 1;
 
 	register_pm_notifier(&exynos_cpufreq_nb);
 
-- 
1.7.10.4

