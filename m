Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3GYQeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:34:31 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62126 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab3GYQe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:34:27 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-a9-51f1539201ea
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com
Subject: [PATCH v6 6/8] cpufreq:exynos:Extend Exynos cpufreq driver to support
 boost framework
Date: Thu, 25 Jul 2013 18:33:29 +0200
Message-id: <1374770011-22171-7-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t9jQd1JwR8DDVa+FLPYOGM9q8XTph/s
	FvM+y1r0/bzCbLFm/08mi86zT5gtehdcZbN484jb4s3DzYwWl3fNYbP43HuE0eJ24wo2i/6F
	vUwWTx72sVls/OrhwO+xeM9LJo871/aweayb9pbZo2/LKkaPR4tbGD2O39jO5PF5k1wAexSX
	TUpqTmZZapG+XQJXxorDc5kLDvJWtG7bztbAuJa7i5GTQ0LAROLHxRdsELaYxIV764FsLg4h
	gemMEpNO7YByupgk7jcdAKtiE9CT+Hz3KROILSIwh1HizlF3kCJmgQfMEou/f2EESQgLJEg8
	2n2JBcRmEVCVuDHlEjuIzSvgJtF6aAM7xDp5iaf3+8CGcgq4S0yYPIURYlsTo8S/G3eZJzDy
	LmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHLjPpHYwrmywOMQowMGoxMOr4PQxUIg1
	say4MvcQowQHs5IIr7klUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILU
	IpgsEwenVAOjUt68fCM5zcP6m5OP5fQ/D3slVPfOKjSppMf48z2e7CWG351Pvv32c5JJUP7R
	sKcua1a+crl4Q+53U+7ksPmfH7Dx3nOd+qxJS2363rze+ReVbizvXCLkp/vrfceFy3libVME
	HYV3nxcsW1hcz7P1wazixi2s/47VC9kxzrpb+W6WToTe1wm3lFiKMxINtZiLihMBAeir81gC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpufreq_driver's boost_supported flag is true only when boost
support is explicitly enabled. Boost related attributes are exported only
under the same condition.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

---
Changes for v6:
- Replace exynos_driver.boost_supported = 1 to = true
- Protect boost attributes export with CONFIG_CPU_FREQ_BOOST_SW

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

 drivers/cpufreq/exynos-cpufreq.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 9ae1871..175172d9 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -270,6 +270,9 @@ static int exynos_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 
 static struct freq_attr *exynos_cpufreq_attr[] = {
 	&cpufreq_freq_attr_scaling_available_freqs,
+#ifdef CONFIG_CPU_FREQ_BOOST_SW
+	&cpufreq_freq_attr_scaling_boost_freqs,
+#endif
 	NULL,
 };
 
@@ -332,6 +335,9 @@ static int __init exynos_cpufreq_probe(struct platform_device *pdev)
 
 	locking_frequency = exynos_getspeed(0);
 
+#ifdef CONFIG_CPU_FREQ_BOOST_SW
+	exynos_driver.boost_supported = true;
+#endif
 	register_pm_notifier(&exynos_cpufreq_nb);
 
 	if (cpufreq_register_driver(&exynos_driver)) {
-- 
1.7.10.4

