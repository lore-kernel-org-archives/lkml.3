Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab3AaEyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 23:54:04 -0500
Received: from service87.mimecast.com ([91.220.42.44]:34784 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab3AaEyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 23:54:02 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: SPEAr: Notify all policy->cpus of frequency change
Date: Thu, 31 Jan 2013 10:23:56 +0530
Message-Id: <ddc1bb4ed278819ffc7fac229134c01e17f03477.1359607980.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 31 Jan 2013 04:53:59.0366 (UTC) FILETIME=[FB722660:01CDFF6E]
X-MC-Unique: 113013104540000201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r0V4s84R018444

SPEAr cpufreq driver supports dual core Cortex-A9 SoC's, where cpus share policy
structure. Whenever we update frequency of a cpu, we must notify all
policy->cpus.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/spear-cpufreq.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
index 4575cfe..63c6a7f 100644
--- a/drivers/cpufreq/spear-cpufreq.c
+++ b/drivers/cpufreq/spear-cpufreq.c
@@ -157,7 +157,9 @@ static int spear_cpufreq_target(struct cpufreq_policy *policy,
 
 	freqs.new = newfreq / 1000;
 	freqs.new /= mult;
-	cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
+
+	for_each_cpu(freqs.cpu, policy->cpus)
+		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 
 	if (mult == 2)
 		ret = spear1340_set_cpu_rate(srcclk, newfreq);
@@ -170,7 +172,8 @@ static int spear_cpufreq_target(struct cpufreq_policy *policy,
 		freqs.new = clk_get_rate(spear_cpufreq.clk) / 1000;
 	}
 
-	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
+	for_each_cpu(freqs.cpu, policy->cpus)
+		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	return ret;
 }
 
-- 
1.7.12.rc2.18.g61b472e


