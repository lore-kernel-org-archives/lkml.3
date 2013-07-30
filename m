Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab3G3IUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:20:13 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38486 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976Ab3G3IR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:17:56 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-b0-51f776b1168a
From: Konstantin Krivyakin <k.krivyakin@samsung.com>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl, viresh.kumar@linaro.org,
        mingo@redhat.com, peterz@infradead.org, kgene.kim@samsung.com,
        linux-pm@vger.kernel.org
Cc: k.krivyakin@samsung.com, i.zhbanov@samsung.com, e.voevodin@samsung.com,
        kyungmin.park@samsung.com, akpm@linux-foundation.org
Subject: [PATCH RFC 1/3] Add interface to receive current cpu power
Date: Tue, 30 Jul 2013 12:17:37 +0400
Message-id: <1375172259-9641-2-git-send-email-k.krivyakin@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1375172259-9641-1-git-send-email-k.krivyakin@samsung.com>
References: <1375172259-9641-1-git-send-email-k.krivyakin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t/xq7oby74HGsy4rWQxZ/0aNou159qZ
	LFZcPcJoMXXhYXaL3gVX2SzONr1ht7i8aw6bxedeoMSlAwuYLI73HmCy6F/Yy2Sx8auHA4/H
	5hVaHneu7WHzODHjN4vH+31X2Tz6tqxi9Hi0uIXR4/MmuQD2KC6blNSczLLUIn27BK6Md5M/
	MhesEqh4MGEdawNjH28XIyeHhICJxNazU5ggbDGJC/fWs3UxcnEICSxllFjZ+hfK6WaSWHdw
	HTtIFRtQx+69F5lBEiICixkllt2cBNbOLNDEKPHvRBGILSzgLLF1Rz8riM0ioCpx9/8GoGYO
	Dl4BN4kvS8pBTAkBBYk5k2xAKjgF3CVajh1jBrGFgCqunVnBOIGRdwEjwypG0dTS5ILipPRc
	I73ixNzi0rx0veT83E2MkLD8uoNx6TGrQ4wCHIxKPLwcxd8ChVgTy4orcw8xSnAwK4nwstwA
	CvGmJFZWpRblxxeV5qQWH2Jk4uCUamBUjZhXdz40XafnhVOZpmSOz/l5kj6mv+4+/7+g2yvo
	y4Z73g8utejUWOiw/PL8f7Bf9ExR9uHTRywaRN2P6rdM9FEUEX7fuYOlc+2lm65rdB6eOOy9
	1Wj6xPUBR+qZFf5MFjq1KPTmuxk6B6zuLzgSnSFb1lfOcy6tv1TpbGjhNc+Zs+5vywxRYinO
	SDTUYi4qTgQACr6+VCkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Konstantin Krivyakin <k.krivyakin@samsung.com>
---
 drivers/cpufreq/cpufreq.c |   17 +++++++++++++++++
 include/linux/cpufreq.h   |    6 ++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 6a015ad..4180e89 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1538,6 +1538,23 @@ int cpufreq_unregister_notifier(struct notifier_block *nb, unsigned int list)
 }
 EXPORT_SYMBOL(cpufreq_unregister_notifier);
 
+/**
+ * cpu_power_get - get current CPU power
+ * @cpu: CPU number
+ */
+u64 cpu_power_get(int cpu)
+{
+	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
+	u64 ret_power = 0;
+
+	if (policy) {
+		ret_power = policy->current_power;
+		cpufreq_cpu_put(policy);
+	}
+
+	return ret_power;
+}
+EXPORT_SYMBOL(cpu_power_get);
 
 /*********************************************************************
  *                              GOVERNORS                            *
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 4d7390b..67323af 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -107,6 +107,7 @@ struct cpufreq_policy {
 	unsigned int		max;    /* in kHz */
 	unsigned int		cur;    /* in kHz, only needed if cpufreq
 					 * governors are used */
+	u64			current_power;
 	unsigned int		policy; /* see above */
 	struct cpufreq_governor	*governor; /* see below */
 	void			*governor_data;
@@ -365,6 +366,7 @@ static inline unsigned int cpufreq_get(unsigned int cpu)
 #ifdef CONFIG_CPU_FREQ
 unsigned int cpufreq_quick_get(unsigned int cpu);
 unsigned int cpufreq_quick_get_max(unsigned int cpu);
+u64 cpu_power_get(int cpu);
 #else
 static inline unsigned int cpufreq_quick_get(unsigned int cpu)
 {
@@ -374,6 +376,10 @@ static inline unsigned int cpufreq_quick_get_max(unsigned int cpu)
 {
 	return 0;
 }
+static inline u64 cpu_power_get(unsigned int cpu)
+{
+	return 0;
+}
 #endif
 
 /*********************************************************************
-- 
1.7.9.5

