Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaFDUdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 16:33:17 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:59421
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750997AbaFDUdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 16:33:15 -0400
From: Ed Swarthout <Ed.Swarthout@freescale.com>
To: <tim.gardner@canonical.com>, <scottwood@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
CC: Ed Swarthout <Ed.Swarthout@freescale.com>
Subject: [PATCH] cpufreq: ppc-corenet-cpu-freq: do_div use quotient
Date: Wed, 4 Jun 2014 15:32:53 -0500
Message-ID: <1401913973-22536-1-git-send-email-Ed.Swarthout@freescale.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398701898-68201-1-git-send-email-tim.gardner@canonical.com>
References: <1398701898-68201-1-git-send-email-tim.gardner@canonical.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(81542001)(79102001)(36756003)(83796001)(85852003)(93916002)(92726001)(46102001)(76482001)(50466002)(74502001)(86362001)(2201001)(74662001)(4396001)(84676001)(97736001)(48376002)(92566001)(99396002)(62966002)(77156001)(50226001)(81342001)(87936001)(26826002)(50986999)(102836001)(83072002)(87286001)(89996001)(76176999)(88136002)(44976005)(6806004)(77982001)(83322001)(47776003)(104166001)(16796002)(31966008)(57986005)(20776003)(46656002)(80022001)(21056001)(64706001)(68736004)(19580405001)(19580395003)(70036006)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB228;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0232B30BBC
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=ed.swarthout@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

6712d2931933ada259b82f06c03a855b19937074 (cpufreq:
ppc-corenet-cpufreq: Fix __udivdi3 modpost error) used the remainder
from do_div instead of the quotient. Fix that and add one to ensure
minimum is met.

Signed-off-by: Ed Swarthout <Ed.Swarthout@freescale.com>
---
 drivers/cpufreq/ppc-corenet-cpufreq.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
index 0af618a..3607070 100644
--- a/drivers/cpufreq/ppc-corenet-cpufreq.c
+++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
@@ -138,7 +138,7 @@ static int corenet_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	struct cpufreq_frequency_table *table;
 	struct cpu_data *data;
 	unsigned int cpu = policy->cpu;
-	u64 transition_latency_hz;
+	u64 u64temp;
 
 	np = of_get_cpu_node(cpu, NULL);
 	if (!np)
@@ -206,9 +206,10 @@ static int corenet_cpufreq_cpu_init(struct cpufreq_policy *policy)
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
 
-- 
1.9.1

