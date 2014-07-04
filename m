Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031308AbaGDW7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:59:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760666AbaGDWQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:16:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ed Swarthout <Ed.Swarthout@freescale.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.15 54/66] cpufreq: ppc-corenet-cpu-freq: do_div use quotient
Date: Fri,  4 Jul 2014 15:14:53 -0700
Message-Id: <20140704221425.278311922@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ed Swarthout <Ed.Swarthout@freescale.com>

commit 906fe033145aab7d65a428bfda2cf19c75720894 upstream.

Commit 6712d2931933 (cpufreq: ppc-corenet-cpufreq: Fix __udivdi3 modpost
error) used the remainder from do_div instead of the quotient.  Fix that
and add one to ensure minimum is met.

Fixes: 6712d2931933 (cpufreq: ppc-corenet-cpufreq: Fix __udivdi3 modpost error)
Signed-off-by: Ed Swarthout <Ed.Swarthout@freescale.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/ppc-corenet-cpufreq.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/cpufreq/ppc-corenet-cpufreq.c
+++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
@@ -138,7 +138,7 @@ static int corenet_cpufreq_cpu_init(stru
 	struct cpufreq_frequency_table *table;
 	struct cpu_data *data;
 	unsigned int cpu = policy->cpu;
-	u64 transition_latency_hz;
+	u64 u64temp;
 
 	np = of_get_cpu_node(cpu, NULL);
 	if (!np)
@@ -206,9 +206,10 @@ static int corenet_cpufreq_cpu_init(stru
 	for_each_cpu(i, per_cpu(cpu_mask, cpu))
 		per_cpu(cpu_data, i) = data;
 
-	transition_latency_hz = 12ULL * NSEC_PER_SEC;
-	policy->cpuinfo.transition_latency =
-		do_div(transition_latency_hz, fsl_get_sys_freq());
+	/* Minimum transition latency is 12 platform clocks */
+	u64temp = 12ULL * NSEC_PER_SEC;
+	do_div(u64temp, fsl_get_sys_freq());
+	policy->cpuinfo.transition_latency = u64temp + 1;
 
 	of_node_put(np);
 


