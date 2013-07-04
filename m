Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964919Ab3GDIvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 04:51:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34848 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933707Ab3GDIvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 04:51:14 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-8c-51d5377eb17a
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v5 4/7] cpufreq:exynos:Extend Exynos cpufreq driver to support
 boost framework
Date: Thu, 04 Jul 2013 10:50:27 +0200
Message-id: <1372927830-2949-5-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t9jAd0686uBBs8nclj8ebuc1eJp0w92
	i3mfZS3W7P/JZNF59gmzRe+Cq2wWbx5xW7x5uJnR4vKuOWwWn3uPMFrcblzBZtG/sJfJ4snD
	PjaLjV89HPg8Fu95yeRx59oeNo91094ye/RtWcXo8WhxC6PH8RvbmTw+b5ILYI/isklJzcks
	Sy3St0vgytjf8YmpYClfxcKppxgbGD9wdzFyckgImEgc2HuQCcIWk7hwbz0biC0ksIhR4s4d
	mS5GLiC7i0niyr/HzCAJNgE9ic93n4I1iAjMASo66g5iMwusZJY40egIYgsLJEgsm/4AbBCL
	gKpE0+EjYDavgKvEpTs7GCGWyUs8vd8HFucUcJO4fKGHCWJZI6PEho4PLBMYeRcwMqxiFE0t
	SC4oTkrPNdQrTswtLs1L10vOz93ECA7VZ1I7GFc2WBxiFOBgVOLhlbC6EijEmlhWXJl7iFGC
	g1lJhNeJ42qgEG9KYmVValF+fFFpTmrxIUZpDhYlcd4DrdaBQgLpiSWp2ampBalFMFkmDk6p
	BsaoZb+/6/1aJHXOvGn/Vverbw51b9/5xIWxz+/fyxYGro+f154Wmndu92I2HcNXQkIp0/sf
	p76/M1W7YNPFu0se/FNfsf23XsWB+ikZj26zyJ3XNQk5utjged2BruCVl7iOTzLXWa80OVzs
	6rsvO1r0+OZK9RS5fwhgPZEm43I8Q848+1HkgZtMSizFGYmGWsxFxYkA5LRbDlECAAA=
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

---
Changes for v5:
- None

Changes for v4:
- None

Changes for v3:
- Remove low level boost code
- Move boost management code to cpufreq core code
- Use boost_supported flag to indicate if driver supports over clocking

Changes for v2:
- Removal of struct cpufreq_boost
- Removal of the CONFIG_CPU_FREQ_BOOST flag
- low_level_boost with valid address when boost is supported

 drivers/cpufreq/exynos-cpufreq.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 0d32f02..4f42fcc 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -267,6 +267,7 @@ static int exynos_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 
 static struct freq_attr *exynos_cpufreq_attr[] = {
 	&cpufreq_freq_attr_scaling_available_freqs,
+	&cpufreq_freq_attr_scaling_boost_freqs,
 	NULL,
 };
 
@@ -287,6 +288,7 @@ static struct cpufreq_driver exynos_driver = {
 
 static int __init exynos_cpufreq_init(void)
 {
+	struct device_node *node = pdev->dev.of_node;
 	int ret = -EINVAL;
 
 	exynos_info = kzalloc(sizeof(struct exynos_dvfs_info), GFP_KERNEL);
@@ -317,6 +319,8 @@ static int __init exynos_cpufreq_init(void)
 	}
 
 	locking_frequency = exynos_getspeed(0);
+	if (of_property_read_bool(node, "boost_mode"))
+		exynos_driver.boost_supported = 1;
 
 	register_pm_notifier(&exynos_cpufreq_nb);
 
-- 
1.7.10.4

