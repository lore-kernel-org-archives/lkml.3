Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab3IVBXn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 21:23:43 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:61342 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab3IVBXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 21:23:40 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, daniel.lezcano@linaro.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 21/21] cpuidle: change governor from within cpuidle_replace_governor()
Date: Sun, 22 Sep 2013 06:51:13 +0530
Message-Id: <5b758e21eeb97f5f68191819c0820673692b6b75.1379779777.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379779777.git.viresh.kumar@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I first read cpuidle_replace_governor()'s name I thought it will replace
the governor (as per its name) but then found that it just returns the next best
governor. And cpuidle_unregister_governor() actually replaces it.

We always replace current governor with the next best and this information is
already present with cpuidle_replace_governor() and so we don't really need to
send an additional argument for it.

Also, it makes sense to actually call cpuidle_switch_governor() from within
cpuidle_replace_governor() instead.

Along with this ret_gov is now renamed as new_gov to better suit its purpose.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpuidle/governor.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/cpuidle/governor.c b/drivers/cpuidle/governor.c
index ea2f8e7..deb6e50 100644
--- a/drivers/cpuidle/governor.c
+++ b/drivers/cpuidle/governor.c
@@ -98,26 +98,27 @@ int cpuidle_register_governor(struct cpuidle_governor *gov)
 }
 
 /**
- * cpuidle_replace_governor - find a replacement governor
- * @exclude_rating: the rating that will be skipped while looking for
- * new governor.
+ * cpuidle_replace_governor - replace governor with highest rating one
+ *
+ * Finds governor (excluding cpuidle_curr_governor) with highest rating and
+ * replaces cpuidle_curr_governor with it.
  */
-static struct cpuidle_governor *cpuidle_replace_governor(int exclude_rating)
+static inline void cpuidle_replace_governor(void)
 {
 	struct cpuidle_governor *gov;
-	struct cpuidle_governor *ret_gov = NULL;
+	struct cpuidle_governor *new_gov = NULL;
 	unsigned int max_rating = 0;
 
 	list_for_each_entry(gov, &cpuidle_governors, governor_list) {
-		if (gov->rating == exclude_rating)
+		if (gov == cpuidle_curr_governor)
 			continue;
 		if (gov->rating > max_rating) {
 			max_rating = gov->rating;
-			ret_gov = gov;
+			new_gov = gov;
 		}
 	}
 
-	return ret_gov;
+	cpuidle_switch_governor(new_gov);
 }
 
 /**
@@ -130,11 +131,8 @@ void cpuidle_unregister_governor(struct cpuidle_governor *gov)
 		return;
 
 	mutex_lock(&cpuidle_lock);
-	if (gov == cpuidle_curr_governor) {
-		struct cpuidle_governor *new_gov;
-		new_gov = cpuidle_replace_governor(gov->rating);
-		cpuidle_switch_governor(new_gov);
-	}
+	if (gov == cpuidle_curr_governor)
+		cpuidle_replace_governor();
 	list_del(&gov->governor_list);
 	mutex_unlock(&cpuidle_lock);
 }
-- 
1.7.12.rc2.18.g61b472e

