Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab3H0ScT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 14:32:19 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:42760 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab3H0ScQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:32:16 -0400
Subject: [PATCH V6 4/7] pseries/cpuidle: Remove MAX_IDLE_STATE macro.
To: linux-pm@lists.linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: b.zolnierkie@samsung.com, benh@kernel.crashing.org,
        daniel.lezcano@linaro.org, dongsheng.wang@freescale.com,
        michael@ellerman.id.au, scottwood@freescale.com,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com
Date: Wed, 28 Aug 2013 00:01:28 +0530
Message-ID: <20130827183126.18579.80649.stgit@deepthi.in.ibm.com>
In-Reply-To: <20130827183016.18579.16595.stgit@deepthi.in.ibm.com>
References: <20130827183016.18579.16595.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082718-1396-0000-0000-0000037668ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the usage of MAX_IDLE_STATE macro
and dead code around it. The number of states
are determined at run time based on the cpuidle
state table selected on a given platform

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 drivers/cpuidle/cpuidle-ibm-power.c |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-ibm-power.c b/drivers/cpuidle/cpuidle-ibm-power.c
index 262db3c..14ebdb4 100644
--- a/drivers/cpuidle/cpuidle-ibm-power.c
+++ b/drivers/cpuidle/cpuidle-ibm-power.c
@@ -25,9 +25,7 @@ struct cpuidle_driver pseries_idle_driver = {
 	.owner            = THIS_MODULE,
 };
 
-#define MAX_IDLE_STATE_COUNT	2
-
-static int max_idle_state = MAX_IDLE_STATE_COUNT - 1;
+static int max_idle_state;
 static struct cpuidle_state *cpuidle_state_table;
 
 static inline void idle_loop_prolog(unsigned long *in_purr)
@@ -133,7 +131,7 @@ static int shared_cede_loop(struct cpuidle_device *dev,
 /*
  * States for dedicated partition case.
  */
-static struct cpuidle_state dedicated_states[MAX_IDLE_STATE_COUNT] = {
+static struct cpuidle_state dedicated_states[] = {
 	{ /* Snooze */
 		.name = "snooze",
 		.desc = "snooze",
@@ -153,7 +151,7 @@ static struct cpuidle_state dedicated_states[MAX_IDLE_STATE_COUNT] = {
 /*
  * States for shared partition case.
  */
-static struct cpuidle_state shared_states[MAX_IDLE_STATE_COUNT] = {
+static struct cpuidle_state shared_states[] = {
 	{ /* Shared Cede */
 		.name = "Shared Cede",
 		.desc = "Shared Cede",
@@ -223,11 +221,7 @@ static int pseries_cpuidle_driver_init(void)
 	struct cpuidle_driver *drv = &pseries_idle_driver;
 
 	drv->state_count = 0;
-
-	for (idle_state = 0; idle_state < MAX_IDLE_STATE_COUNT; ++idle_state) {
-
-		if (idle_state > max_idle_state)
-			break;
+	for (idle_state = 0; idle_state < max_idle_state; ++idle_state) {
 
 		/* is the state not enabled? */
 		if (cpuidle_state_table[idle_state].enter == NULL)
@@ -252,16 +246,14 @@ static int pseries_idle_probe(void)
 	if (cpuidle_disable != IDLE_NO_OVERRIDE)
 		return -ENODEV;
 
-	if (max_idle_state == 0) {
-		printk(KERN_DEBUG "pseries processor idle disabled.\n");
-		return -EPERM;
-	}
-
 	if (firmware_has_feature(FW_FEATURE_SPLPAR)) {
-		if (get_lppaca()->shared_proc)
+		if (get_lppaca()->shared_proc) {
 			cpuidle_state_table = shared_states;
-		else
+			max_idle_state = ARRAY_SIZE(shared_states);
+		} else {
 			cpuidle_state_table = dedicated_states;
+			max_idle_state = ARRAY_SIZE(dedicated_states);
+		}
 	} else
 		return -ENODEV;
 

