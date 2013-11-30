Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab3K3P4f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 10:56:35 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:50971 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3K3P4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 10:56:32 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/5] cpufreq: Introduce cpufreq_notify_post_transition()
Date: Sat, 30 Nov 2013 21:26:19 +0530
Message-Id: <0d635c6701654a75f6d25dd435705dc1ede3e19c.1385826776.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces another routine cpufreq_notify_post_transition() which can be
used to send POSTCHANGE notification for new freq with or without both
{PRE|POST}CHANGE notifications for last freq in case of failures. This is useful
at multiple places, specially for sending transition failure notifications.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---

Hi Rafael,

Please see if you want to take it for 3.13 or 14, as this fixes bugs which are
partly introduced in 3.13..

 drivers/cpufreq/cpufreq.c | 14 ++++++++++++++
 include/linux/cpufreq.h   |  2 ++
 2 files changed, 16 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 606224a..a862aa9 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -324,6 +324,20 @@ void cpufreq_notify_transition(struct cpufreq_policy *policy,
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
index ee5fe9d..57e48db 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -314,6 +314,8 @@ int cpufreq_unregister_notifier(struct notifier_block *nb, unsigned int list);
 
 void cpufreq_notify_transition(struct cpufreq_policy *policy,
 		struct cpufreq_freqs *freqs, unsigned int state);
+void cpufreq_notify_post_transition(struct cpufreq_policy *policy,
+		struct cpufreq_freqs *freqs, int transition_failed);
 
 #else /* CONFIG_CPU_FREQ */
 static inline int cpufreq_register_notifier(struct notifier_block *nb,
-- 
1.7.12.rc2.18.g61b472e

