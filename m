Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbaD1QSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 12:18:49 -0400
Received: from mail.tpi.com ([74.45.170.26]:44385 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932875AbaD1QSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 12:18:34 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Zhuoyu Zhang <Zhuoyu.Zhang@freescale.com>
Subject: [PATCH 3.15-rc3] cpufreq: ppc-corenet-cpufreq: Fix __udivdi3 modpost error
Date: Mon, 28 Apr 2014 10:18:18 -0600
Message-Id: <1398701898-68201-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bfa709bc823fc32ee8dd5220d1711b46078235d8 (cpufreq: powerpc: add cpufreq
transition latency for FSL e500mc SoCs) introduced a modpost error:

ERROR: "__udivdi3" [drivers/cpufreq/ppc-corenet-cpufreq.ko] undefined!
make[1]: *** [__modpost] Error 1

Fix this by avoiding 64 bit integer division.

gcc version 4.8.2

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Zhuoyu Zhang <Zhuoyu.Zhang@freescale.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/cpufreq/ppc-corenet-cpufreq.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
index a1ca3dd..0af618a 100644
--- a/drivers/cpufreq/ppc-corenet-cpufreq.c
+++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
@@ -138,6 +138,7 @@ static int corenet_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	struct cpufreq_frequency_table *table;
 	struct cpu_data *data;
 	unsigned int cpu = policy->cpu;
+	u64 transition_latency_hz;
 
 	np = of_get_cpu_node(cpu, NULL);
 	if (!np)
@@ -205,8 +206,10 @@ static int corenet_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	for_each_cpu(i, per_cpu(cpu_mask, cpu))
 		per_cpu(cpu_data, i) = data;
 
+	transition_latency_hz = 12ULL * NSEC_PER_SEC;
 	policy->cpuinfo.transition_latency =
-				(12ULL * NSEC_PER_SEC) / fsl_get_sys_freq();
+		do_div(transition_latency_hz, fsl_get_sys_freq());
+
 	of_node_put(np);
 
 	return 0;
-- 
1.7.9.5

