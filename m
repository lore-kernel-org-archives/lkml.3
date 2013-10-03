Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab3JCP6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:58:51 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:47089 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab3JCP6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:58:49 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 16/16] cpuidle: remove cpuidle_unregister_governor()
Date: Thu,  3 Oct 2013 21:26:55 +0530
Message-Id: <37fdfe53136ec441698be7371a1c8b541014d969.1380815504.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1380815504.git.viresh.kumar@linaro.org>
References: <cover.1380815504.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1380815504.git.viresh.kumar@linaro.org>
References: <cover.1380815504.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuidle_unregister_governor()  and cpuidle_replace_governor() routines aren't
used anymore and so can be removed. These were used by cpufreq governors
earlier, which can't be compiled in as modules anymore and so these are useless.

Suggested-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 Documentation/cpuidle/governor.txt |  1 -
 drivers/cpuidle/governor.c         | 43 --------------------------------------
 include/linux/cpuidle.h            |  6 ------
 3 files changed, 50 deletions(-)

diff --git a/Documentation/cpuidle/governor.txt b/Documentation/cpuidle/governor.txt
index 12c6bd5..d9020f5 100644
--- a/Documentation/cpuidle/governor.txt
+++ b/Documentation/cpuidle/governor.txt
@@ -25,5 +25,4 @@ kernel configuration and platform will be selected by cpuidle.
 
 Interfaces:
 extern int cpuidle_register_governor(struct cpuidle_governor *gov);
-extern void cpuidle_unregister_governor(struct cpuidle_governor *gov);
 struct cpuidle_governor
diff --git a/drivers/cpuidle/governor.c b/drivers/cpuidle/governor.c
index ea2f8e7..ca89412 100644
--- a/drivers/cpuidle/governor.c
+++ b/drivers/cpuidle/governor.c
@@ -96,46 +96,3 @@ int cpuidle_register_governor(struct cpuidle_governor *gov)
 
 	return ret;
 }
-
-/**
- * cpuidle_replace_governor - find a replacement governor
- * @exclude_rating: the rating that will be skipped while looking for
- * new governor.
- */
-static struct cpuidle_governor *cpuidle_replace_governor(int exclude_rating)
-{
-	struct cpuidle_governor *gov;
-	struct cpuidle_governor *ret_gov = NULL;
-	unsigned int max_rating = 0;
-
-	list_for_each_entry(gov, &cpuidle_governors, governor_list) {
-		if (gov->rating == exclude_rating)
-			continue;
-		if (gov->rating > max_rating) {
-			max_rating = gov->rating;
-			ret_gov = gov;
-		}
-	}
-
-	return ret_gov;
-}
-
-/**
- * cpuidle_unregister_governor - unregisters a governor
- * @gov: the governor
- */
-void cpuidle_unregister_governor(struct cpuidle_governor *gov)
-{
-	if (!gov)
-		return;
-
-	mutex_lock(&cpuidle_lock);
-	if (gov == cpuidle_curr_governor) {
-		struct cpuidle_governor *new_gov;
-		new_gov = cpuidle_replace_governor(gov->rating);
-		cpuidle_switch_governor(new_gov);
-	}
-	list_del(&gov->governor_list);
-	mutex_unlock(&cpuidle_lock);
-}
-
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index c082425..50fcbb0 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -195,16 +195,10 @@ struct cpuidle_governor {
 };
 
 #ifdef CONFIG_CPU_IDLE
-
 extern int cpuidle_register_governor(struct cpuidle_governor *gov);
-extern void cpuidle_unregister_governor(struct cpuidle_governor *gov);
-
 #else
-
 static inline int cpuidle_register_governor(struct cpuidle_governor *gov)
 {return 0;}
-static inline void cpuidle_unregister_governor(struct cpuidle_governor *gov) { }
-
 #endif
 
 #ifdef CONFIG_ARCH_HAS_CPU_RELAX
-- 
1.7.12.rc2.18.g61b472e

