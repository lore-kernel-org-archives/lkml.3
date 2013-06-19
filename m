Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935002Ab3FSRN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:13:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11511 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934924Ab3FSRNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:13:22 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-55-51c1e6b13af4
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
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH v4 4/7] cpufreq:exynos:Extend Exynos cpufreq driver to support
 boost framework
Date: Wed, 19 Jun 2013 19:12:45 +0200
Message-id: <1371661969-7660-5-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jQd2Nzw4GGhxfrWPx5+1yVounTT/Y
	LeZ9lrVYs/8nk0Xn2SfMFr0LrrJZvHnEbfHm4WZGi8u75rBZfO49wmhxu3EFm0X/wl4miycP
	+9gsOo58Y7bY+NXDgd9j8Z6XTB53ru1h81g37S2zR9+WVYwejxa3MHocv7GdyePzJrkA9igu
	m5TUnMyy1CJ9uwSujKNPtrAUXOCr+PfzIWsD40KeLkZODgkBE4nXJ7ezQthiEhfurWcDsYUE
	pjNKPD3ND2F3MUl8nBcDYrMJ6El8vvuUCcQWEfCV6Fl2CMjm4mAW2MciMfVbB9ggYYEEiaVn
	X7KD2CwCqhJrtvwCa+AVcJW48ekgG8QyeYmn9/vAbE4BN4nj37rYQAYJCTQySqzd8IB5AiPv
	AkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBQftMegfjqgaLQ4wCHIxKPLwalw8GCrEm
	lhVX5h5ilOBgVhLhXXoUKMSbklhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFq
	EUyWiYNTqoHR3OD/ko3NXCk/Tm5/2H414XvjP10v6/vHmeziQ7VE2ON+RFTnzt7c2pS+ad4l
	wbVtOb+Y5k95xzvh2JkbNlOf6PGGeLzXLtAyvGFRxrxV4YjIvV37Gs8p1N6VEaqbfCnv+qd5
	OSui3zcfXKpyvHHuTrVpvBPWtK96ME1+n9n53jLhtczSXeFnlViKMxINtZiLihMBif8SGFYC	AAA=
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
---
 drivers/cpufreq/exynos-cpufreq.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 3197d88..b0e424e 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -264,6 +264,7 @@ static int exynos_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 
 static struct freq_attr *exynos_cpufreq_attr[] = {
 	&cpufreq_freq_attr_scaling_available_freqs,
+	&cpufreq_freq_attr_scaling_boost_freqs,
 	NULL,
 };
 
@@ -359,6 +360,7 @@ static struct of_device_id exynos_cpufreq_of_match[] __initconst = {
 
 static int __init exynos_cpufreq_probe(struct platform_device *pdev)
 {
+	struct device_node *node = pdev->dev.of_node;
 	int ret = -EINVAL;
 
 	exynos_info = kzalloc(sizeof(struct exynos_dvfs_info), GFP_KERNEL);
@@ -391,6 +393,8 @@ static int __init exynos_cpufreq_probe(struct platform_device *pdev)
 	}
 
 	locking_frequency = exynos_getspeed(0);
+	if (of_property_read_bool(node, "boost_mode"))
+		exynos_driver.boost_supported = 1;
 
 	register_pm_notifier(&exynos_cpufreq_nb);
 
-- 
1.7.10.4

