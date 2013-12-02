Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab3LBFe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 00:34:27 -0500
Received: from mail-qe0-f46.google.com ([209.85.128.46]:41253 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab3LBFeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 00:34:22 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 1/5] cpufreq: Introduce cpufreq_notify_post_transition()
Date: Mon,  2 Dec 2013 11:04:12 +0530
Message-Id: <a6668c7fa63d67ca33b9e59d0189cd99a2ddcd05.1385962178.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces another routine cpufreq_notify_post_transition() which can be
used to send POSTCHANGE notification for new freq with or without both
{PRE|POST}CHANGE notifications for last freq. This is useful at multiple places,
specially for sending transition failure notifications.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---

V1->V2:
- Not required to push it for 3.13 anymore and can go in 3.14.
- Rebased over following patchset as there were conflicts in unicore2 driver if
  following patchset is applied first (which should be the case):
  https://lkml.org/lkml/2013/10/30/553 (create cpufreq_generic_get() routine)

 drivers/cpufreq/cpufreq.c | 14 ++++++++++++++
 include/linux/cpufreq.h   |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 5e27def..3b877d4 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -338,6 +338,20 @@ void cpufreq_notify_transition(struct cpufreq_policy *policy,
 }
 EXPORT_SYMBOL_GPL(cpufreq_notify_transition);
 
+/* Do post notifications when there are chances that transition has failed */
+void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
+		struct cpufreq_freqs *freqs, int transition_failed)
+{
+	cpufreq_notify_transition(policy, freqs, CPUFREQ_POSTCHANGE);
+	if (!transition_failed)
+		return;
+
+	swap(freqs->old, freqs->new);
+	cpufreq_notify_transition(policy, freqs, CPUFREQ_PRECHANGE);
+	cpufreq_notify_transition(policy, freqs, CPUFREQ_POSTCHANGE);
+}
+EXPORT_SYMBOL_GPL(cpufreq_notify_post_transition);
+
 
 /*********************************************************************
  *                          SYSFS INTERFACE                          *
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 276e646..b26bfab 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -316,6 +316,8 @@ int cpufreq_unregister_notifier(struct notifier_block *nb, unsigned int list);
 
 void cpufreq_notify_transition(struct cpufreq_policy *policy,
 		struct cpufreq_freqs *freqs, unsigned int state);
+void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
+		struct cpufreq_freqs *freqs, int transition_failed);
 
 #else /* CONFIG_CPU_FREQ */
 static inline int cpufreq_register_notifier(struct notifier_block *nb,
-- 
1.7.12.rc2.18.g61b472e

