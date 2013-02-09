Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab3BIBJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:09:23 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:40765 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947683Ab3BIBIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:08:54 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 15/16] intel_idle: remove assumption of one C-state per MWAIT flag
Date: Fri,  8 Feb 2013 20:08:19 -0500
Message-Id: <e022e7eb90f3edb83f9ff77825eda3d1b3a2f2e0.1360371180.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360372100-28482-1-git-send-email-lenb@kernel.org>
References: <1360372100-28482-1-git-send-email-lenb@kernel.org>
In-Reply-To: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
References: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Remove the assumption that cstate_tables are
indexed by MWAIT flag values.  Each entry
identifies itself via its own flags value.
This change is needed to support multiple states
that share the same MWAIT flags.

Note that this can have an effect on what state is described
by 'N' on cmdline intel_idle.max_cstate=N on some systems.

intel_idle.max_cstate=0 still disables the driver
intel_idle.max_cstate=1 still results in just C1(E)
However, "place holders" in the sparse C-state name-space
(eg. Atom) have been removed.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/include/asm/mwait.h |   2 +
 drivers/idle/intel_idle.c    | 110 +++++++++++++++++++++++--------------------
 2 files changed, 61 insertions(+), 51 deletions(-)

diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
index 3f44732..2f366d0 100644
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -4,6 +4,8 @@
 #define MWAIT_SUBSTATE_MASK		0xf
 #define MWAIT_CSTATE_MASK		0xf
 #define MWAIT_SUBSTATE_SIZE		4
+#define MWAIT_HINT2CSTATE(hint)		(((hint) >> MWAIT_SUBSTATE_SIZE) & MWAIT_CSTATE_MASK)
+#define MWAIT_HINT2SUBSTATE(hint)	((hint) & MWAIT_CSTATE_MASK)
 
 #define CPUID_MWAIT_LEAF		5
 #define CPUID5_ECX_EXTENSIONS_SUPPORTED 0x1
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index c949a6f..927cfb4 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -124,158 +124,161 @@ static struct cpuidle_state *cpuidle_state_table;
  * Thus C0 is a dummy.
  */
 static struct cpuidle_state nehalem_cstates[CPUIDLE_STATE_MAX] = {
-	{ /* MWAIT C0 */ },
-	{ /* MWAIT C1 */
+	{
 		.name = "C1-NHM",
 		.desc = "MWAIT 0x00",
 		.flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
 		.exit_latency = 3,
 		.target_residency = 6,
 		.enter = &intel_idle },
-	{ /* MWAIT C2 */
+	{
 		.name = "C3-NHM",
 		.desc = "MWAIT 0x10",
 		.flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 20,
 		.target_residency = 80,
 		.enter = &intel_idle },
-	{ /* MWAIT C3 */
+	{
 		.name = "C6-NHM",
 		.desc = "MWAIT 0x20",
 		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 200,
 		.target_residency = 800,
 		.enter = &intel_idle },
+	{
+		.enter = NULL }
 };
 
 static struct cpuidle_state snb_cstates[CPUIDLE_STATE_MAX] = {
-	{ /* MWAIT C0 */ },
-	{ /* MWAIT C1 */
+	{
 		.name = "C1-SNB",
 		.desc = "MWAIT 0x00",
 		.flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
 		.exit_latency = 1,
 		.target_residency = 1,
 		.enter = &intel_idle },
-	{ /* MWAIT C2 */
+	{
 		.name = "C3-SNB",
 		.desc = "MWAIT 0x10",
 		.flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 80,
 		.target_residency = 211,
 		.enter = &intel_idle },
-	{ /* MWAIT C3 */
+	{
 		.name = "C6-SNB",
 		.desc = "MWAIT 0x20",
 		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 104,
 		.target_residency = 345,
 		.enter = &intel_idle },
-	{ /* MWAIT C4 */
+	{
 		.name = "C7-SNB",
 		.desc = "MWAIT 0x30",
 		.flags = MWAIT2flg(0x30) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 109,
 		.target_residency = 345,
 		.enter = &intel_idle },
+	{
+		.enter = NULL }
 };
 
 static struct cpuidle_state ivb_cstates[CPUIDLE_STATE_MAX] = {
-	{ /* MWAIT C0 */ },
-	{ /* MWAIT C1 */
+	{
 		.name = "C1-IVB",
 		.desc = "MWAIT 0x00",
 		.flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
 		.exit_latency = 1,
 		.target_residency = 1,
 		.enter = &intel_idle },
-	{ /* MWAIT C2 */
+	{
 		.name = "C3-IVB",
 		.desc = "MWAIT 0x10",
 		.flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 59,
 		.target_residency = 156,
 		.enter = &intel_idle },
-	{ /* MWAIT C3 */
+	{
 		.name = "C6-IVB",
 		.desc = "MWAIT 0x20",
 		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 80,
 		.target_residency = 300,
 		.enter = &intel_idle },
-	{ /* MWAIT C4 */
+	{
 		.name = "C7-IVB",
 		.desc = "MWAIT 0x30",
 		.flags = MWAIT2flg(0x30) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 87,
 		.target_residency = 300,
 		.enter = &intel_idle },
+	{
+		.enter = NULL }
 };
 
 static struct cpuidle_state hsw_cstates[CPUIDLE_STATE_MAX] = {
-	{ /* MWAIT C0 */ },
-	{ /* MWAIT C1 */
+	{
 		.name = "C1-HSW",
 		.desc = "MWAIT 0x00",
 		.flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
 		.exit_latency = 2,
 		.target_residency = 2,
 		.enter = &intel_idle },
-	{ /* MWAIT C2 */
+	{
 		.name = "C3-HSW",
 		.desc = "MWAIT 0x10",
 		.flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 33,
 		.target_residency = 100,
 		.enter = &intel_idle },
-	{ /* MWAIT C3 */
+	{
 		.name = "C6-HSW",
 		.desc = "MWAIT 0x20",
 		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 133,
 		.target_residency = 400,
 		.enter = &intel_idle },
-	{ /* MWAIT C4 */
+	{
 		.name = "C7s-HSW",
 		.desc = "MWAIT 0x32",
 		.flags = MWAIT2flg(0x32) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 166,
 		.target_residency = 500,
 		.enter = &intel_idle },
+	{
+		.enter = NULL }
 };
 
 static struct cpuidle_state atom_cstates[CPUIDLE_STATE_MAX] = {
-	{ /* MWAIT C0 */ },
-	{ /* MWAIT C1 */
+	{
 		.name = "C1-ATM",
 		.desc = "MWAIT 0x00",
 		.flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
 		.exit_latency = 1,
 		.target_residency = 4,
 		.enter = &intel_idle },
-	{ /* MWAIT C2 */
+	{
 		.name = "C2-ATM",
 		.desc = "MWAIT 0x10",
 		.flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID,
 		.exit_latency = 20,
 		.target_residency = 80,
 		.enter = &intel_idle },
-	{ /* MWAIT C3 */ },
-	{ /* MWAIT C4 */
+	{
 		.name = "C4-ATM",
 		.desc = "MWAIT 0x30",
 		.flags = MWAIT2flg(0x30) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 100,
 		.target_residency = 400,
 		.enter = &intel_idle },
-	{ /* MWAIT C5 */ },
-	{ /* MWAIT C6 */
+	{
 		.name = "C6-ATM",
 		.desc = "MWAIT 0x52",
 		.flags = MWAIT2flg(0x52) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 140,
 		.target_residency = 560,
 		.enter = &intel_idle },
+	{
+		.enter = NULL }
 };
 
 /**
@@ -503,32 +506,31 @@ static int intel_idle_cpuidle_driver_init(void)
 
 	drv->state_count = 1;
 
-	for (cstate = 1; cstate < CPUIDLE_STATE_MAX; ++cstate) {
-		int num_substates;
+	for (cstate = 0; cstate < CPUIDLE_STATE_MAX; ++cstate) {
+		int num_substates, mwait_hint, mwait_cstate, mwait_substate;
 
-		if (cstate > max_cstate) {
+		if (cpuidle_state_table[cstate].enter == NULL)
+			break;
+
+		if (cstate + 1 > max_cstate) {
 			printk(PREFIX "max_cstate %d reached\n",
 				max_cstate);
 			break;
 		}
 
+		mwait_hint = flg2MWAIT(cpuidle_state_table[cstate].flags);
+		mwait_cstate = MWAIT_HINT2CSTATE(mwait_hint);
+		mwait_substate = MWAIT_HINT2SUBSTATE(mwait_hint);
+
 		/* does the state exist in CPUID.MWAIT? */
-		num_substates = (mwait_substates >> ((cstate) * 4))
+		num_substates = (mwait_substates >> ((mwait_cstate + 1) * 4))
 					& MWAIT_SUBSTATE_MASK;
-		if (num_substates == 0)
-			continue;
-		/* is the state not enabled? */
-		if (cpuidle_state_table[cstate].enter == NULL) {
-			/* does the driver not know about the state? */
-			if (*cpuidle_state_table[cstate].name == '\0')
-				pr_debug(PREFIX "unaware of model 0x%x"
-					" MWAIT %d please"
-					" contact lenb@kernel.org\n",
-				boot_cpu_data.x86_model, cstate);
+
+		/* if sub-state in table is not enumerated by CPUID */
+		if ((mwait_substate + 1) > num_substates)
 			continue;
-		}
 
-		if ((cstate > 2) &&
+		if (((mwait_cstate + 1) > 2) &&
 			!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
 			mark_tsc_unstable("TSC halts in idle"
 					" states deeper than C2");
@@ -560,21 +562,27 @@ static int intel_idle_cpu_init(int cpu)
 
 	dev->state_count = 1;
 
-	for (cstate = 1; cstate < CPUIDLE_STATE_MAX; ++cstate) {
-		int num_substates;
+	for (cstate = 0; cstate < CPUIDLE_STATE_MAX; ++cstate) {
+		int num_substates, mwait_hint, mwait_cstate, mwait_substate;
 
-		if (cstate > max_cstate) {
+		if (cpuidle_state_table[cstate].enter == NULL)
+			continue;
+
+		if (cstate + 1 > max_cstate) {
 			printk(PREFIX "max_cstate %d reached\n", max_cstate);
 			break;
 		}
 
+		mwait_hint = flg2MWAIT(cpuidle_state_table[cstate].flags);
+		mwait_cstate = MWAIT_HINT2CSTATE(mwait_hint);
+		mwait_substate = MWAIT_HINT2SUBSTATE(mwait_hint);
+
 		/* does the state exist in CPUID.MWAIT? */
-		num_substates = (mwait_substates >> ((cstate) * 4))
-			& MWAIT_SUBSTATE_MASK;
-		if (num_substates == 0)
-			continue;
-		/* is the state not enabled? */
-		if (cpuidle_state_table[cstate].enter == NULL)
+		num_substates = (mwait_substates >> ((mwait_cstate + 1) * 4))
+					& MWAIT_SUBSTATE_MASK;
+
+		/* if sub-state in table is not enumerated by CPUID */
+		if ((mwait_substate + 1) > num_substates)
 			continue;
 
 		dev->state_count += 1;
-- 
1.8.1.3.535.ga923c31

