Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaANK4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 05:56:19 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:49101 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaANK4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 05:56:14 -0500
Subject: [PATCH v1 5/6] pseries/cpuidle: Remove MAX_IDLE_STATE macro.
To: linux-pm@vger.kernel.org, benh@kernel.crashing.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Date: Tue, 14 Jan 2014 16:26:28 +0530
Message-ID: <20140114105624.3064.76270.stgit@deepthi.in.ibm.com>
In-Reply-To: <20140114105525.3064.52013.stgit@deepthi.in.ibm.com>
References: <20140114105525.3064.52013.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011410-9574-0000-0000-00000B7ABBB8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the usage of MAX_IDLE_STATE macro
and dead code around it. The number of states
are determined at run time based on the cpuidle
state table selected on a given platform

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 drivers/cpuidle/cpuidle-pseries.c |   28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-pseries.c b/drivers/cpuidle/cpuidle-pseries.c
index 5e13f6c..bb56091 100644
--- a/drivers/cpuidle/cpuidle-pseries.c
+++ b/drivers/cpuidle/cpuidle-pseries.c
@@ -24,9 +24,7 @@ struct cpuidle_driver pseries_idle_driver = {
 	.owner            = THIS_MODULE,
 };
 
-#define MAX_IDLE_STATE_COUNT	2
-
-static int max_idle_state = MAX_IDLE_STATE_COUNT - 1;
+static int max_idle_state;
 static struct cpuidle_state *cpuidle_state_table;
 
 static inline void idle_loop_prolog(unsigned long *in_purr)
@@ -134,7 +132,7 @@ static int shared_cede_loop(struct cpuidle_device *dev,
 /*
  * States for dedicated partition case.
  */
-static struct cpuidle_state dedicated_states[MAX_IDLE_STATE_COUNT] = {
+static struct cpuidle_state dedicated_states[] = {
 	{ /* Snooze */
 		.name = "snooze",
 		.desc = "snooze",
@@ -154,7 +152,7 @@ static struct cpuidle_state dedicated_states[MAX_IDLE_STATE_COUNT] = {
 /*
  * States for shared partition case.
  */
-static struct cpuidle_state shared_states[MAX_IDLE_STATE_COUNT] = {
+static struct cpuidle_state shared_states[] = {
 	{ /* Shared Cede */
 		.name = "Shared Cede",
 		.desc = "Shared Cede",
@@ -225,12 +223,8 @@ static int pseries_cpuidle_driver_init(void)
 
 	drv->state_count = 0;
 
-	for (idle_state = 0; idle_state < MAX_IDLE_STATE_COUNT; ++idle_state) {
-
-		if (idle_state > max_idle_state)
-			break;
-
-		/* is the state not enabled? */
+	for (idle_state = 0; idle_state < max_idle_state; ++idle_state) {
+		/* Is the state not enabled? */
 		if (cpuidle_state_table[idle_state].enter == NULL)
 			continue;
 
@@ -253,16 +247,14 @@ static int pseries_idle_probe(void)
 	if (cpuidle_disable != IDLE_NO_OVERRIDE)
 		return -ENODEV;
 
-	if (max_idle_state == 0) {
-		printk(KERN_DEBUG "pseries processor idle disabled.\n");
-		return -EPERM;
-	}
-
 	if (firmware_has_feature(FW_FEATURE_SPLPAR)) {
-		if (lppaca_shared_proc(get_lppaca()))
+		if (lppaca_shared_proc(get_lppaca())) {
 			cpuidle_state_table = shared_states;
-		else
+			max_idle_state = ARRAY_SIZE(shared_states);
+		} else {
 			cpuidle_state_table = dedicated_states;
+			max_idle_state = ARRAY_SIZE(dedicated_states);
+		}
 	} else
 		return -ENODEV;
 

