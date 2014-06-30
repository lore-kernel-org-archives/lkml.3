Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbaF3Q7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:59:50 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:53447 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754658AbaF3Q7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:59:46 -0400
From: Stratos Karafotis <stratosk@semaphore.gr>
To: rjw@rjwysocki.net, viresh.kumar@linaro.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] cpufreq: Introduce new relation for freq selection
Date: Mon, 30 Jun 2014 19:59:33 +0300
Message-Id: <1404147574-17422-2-git-send-email-stratosk@semaphore.gr>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404147574-17422-1-git-send-email-stratosk@semaphore.gr>
References: <1404147574-17422-1-git-send-email-stratosk@semaphore.gr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce CPUFREQ_RELATION_C for frequency selection.
It selects the frequency with the minimum euclidean distance to target.
In case of equal distance between 2 frequencies, it will select the
greater frequency.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/freq_table.c | 12 +++++++++++-
 include/linux/cpufreq.h      |  1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index 1632981..df14766 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -117,7 +117,7 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 		.frequency = 0,
 	};
 	struct cpufreq_frequency_table *pos;
-	unsigned int freq, i = 0;
+	unsigned int freq, diff, i = 0;
 
 	pr_debug("request for target %u kHz (relation: %u) for cpu %u\n",
 					target_freq, relation, policy->cpu);
@@ -127,6 +127,7 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 		suboptimal.frequency = ~0;
 		break;
 	case CPUFREQ_RELATION_L:
+	case CPUFREQ_RELATION_C:
 		optimal.frequency = ~0;
 		break;
 	}
@@ -168,6 +169,15 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 				}
 			}
 			break;
+		case CPUFREQ_RELATION_C:
+			diff = abs(freq - target_freq);
+			if (diff < optimal.frequency ||
+			    (diff == optimal.frequency &&
+			     freq > table[optimal.driver_data].frequency)) {
+				optimal.frequency = diff;
+				optimal.driver_data = i;
+			}
+			break;
 		}
 	}
 	if (optimal.driver_data > i) {
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index ec4112d..00fad91 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -176,6 +176,7 @@ static inline void disable_cpufreq(void) { }
 
 #define CPUFREQ_RELATION_L 0  /* lowest frequency at or above target */
 #define CPUFREQ_RELATION_H 1  /* highest frequency below or at target */
+#define CPUFREQ_RELATION_C 2  /* closest frequency to target */
 
 struct freq_attr {
 	struct attribute attr;
-- 
1.9.3

