Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaEWSSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:18:51 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36264 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaEWSQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:16:55 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, dietmar.eggemann@arm.com
Subject: [RFC PATCH 10/16] sched, cpufreq: Current compute capacity hack for ARM TC2
Date: Fri, 23 May 2014 19:16:37 +0100
Message-Id: <1400869003-27769-11-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 23 May 2014 18:16:53.0010 (UTC) FILETIME=[2C379F20:01CF76B3]
X-MC-Unique: 114052319165313001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s4NIJ1nS005183

Hack to report different cpu capacities for big and little cpus.
This is for experimentation on ARM TC2 _only_. A proper solution
has to address this problem.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 drivers/cpufreq/cpufreq.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index a2b788d..134d777 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -316,7 +316,13 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 		pr_debug("FREQ: %lu - CPU: %lu\n",
 			 (unsigned long)freqs->new, (unsigned long)freqs->cpu);
 		trace_cpu_frequency(freqs->new, freqs->cpu);
-		set_curr_capacity(freqs->cpu, (freqs->new*1024)/policy->max);
+		/* Massive TC2 hack */
+		if (freqs->cpu == 1 || freqs->cpu == 2)
+			/* A15 cpus (max_capacity = 2015) */
+			set_curr_capacity(freqs->cpu, (freqs->new*2015)/1200000);
+		else
+			/* A7 cpus (nax_capacity = 1024) */
+			set_curr_capacity(freqs->cpu, (freqs->new*1024)/1000000);
 		srcu_notifier_call_chain(&cpufreq_transition_notifier_list,
 				CPUFREQ_POSTCHANGE, freqs);
 		if (likely(policy) && likely(policy->cpu == freqs->cpu))
-- 
1.7.9.5


