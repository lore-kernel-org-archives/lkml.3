Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715AbaGCQdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:33:40 -0400
Received: from service88.mimecast.com ([195.130.217.12]:54509 "EHLO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759698AbaGCQdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:33:38 -0400
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2014 12:33:38 EDT
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, Dietmar.Eggemann@arm.com, pjt@google.com
Subject: [RFCv2 PATCH 16/23] sched, cpufreq: Current compute capacity hack for ARM TC2
Date: Thu,  3 Jul 2014 17:26:03 +0100
Message-Id: <1404404770-323-17-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 03 Jul 2014 16:26:19.0475 (UTC) FILETIME=[85424230:01CF96DB]
X-MC-Unique: 114070317261905801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s63GXp4M010770

Hack to report different cpu capacities for big and little cpus.
This is for experimentation on ARM TC2 _only_. A proper solution
has to address this problem.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 drivers/cpufreq/cpufreq.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index a2b788d..efec777 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -316,7 +316,13 @@ static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 		pr_debug("FREQ: %lu - CPU: %lu\n",
 			 (unsigned long)freqs->new, (unsigned long)freqs->cpu);
 		trace_cpu_frequency(freqs->new, freqs->cpu);
-		set_curr_capacity(freqs->cpu, (freqs->new*1024)/policy->max);
+		/* Massive TC2 hack */
+		if (freqs->cpu == 0 || freqs->cpu == 1)
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


