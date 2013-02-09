Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab3BIBI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:08:59 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:34611 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332Ab3BIBI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:08:56 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 16/16] intel_idle: export both C1 and C1E
Date: Fri,  8 Feb 2013 20:08:20 -0500
Message-Id: <073240cd5420f86654579aa80e16427b578d3e82.1360371180.git.len.brown@intel.com>
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

Here we disable HW promotion of C1 to C1E
and export both C1 and C1E and distinct C-states.

This allows a cpuidle governor to choose a lower latency
C-state than C1E when necessary to satisfy performance
and QOS constraints -- and still save power versus polling.
This also corrects the erroneous latency previously reported
for C1E -- it is 10usec, not 1usec.

Note that if you use "intel_idle.max_cstate=N",
then you must increment N by 1 to get the same behavior
after this change.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/idle/intel_idle.c | 55 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 5 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 927cfb4..fe2d397 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -90,6 +90,7 @@ struct idle_cpu {
 	 * Indicate which enable bits to clear here.
 	 */
 	unsigned long auto_demotion_disable_flags;
+	bool disable_promotion_to_c1e;
 };
 
 static const struct idle_cpu *icpu;
@@ -132,6 +133,13 @@ static struct cpuidle_state nehalem_cstates[CPUIDLE_STATE_MAX] = {
 		.target_residency = 6,
 		.enter = &intel_idle },
 	{
+		.name = "C1E-NHM",
+		.desc = "MWAIT 0x01",
+		.flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 10,
+		.target_residency = 20,
+		.enter = &intel_idle },
+	{
 		.name = "C3-NHM",
 		.desc = "MWAIT 0x10",
 		.flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
@@ -154,8 +162,15 @@ static struct cpuidle_state snb_cstates[CPUIDLE_STATE_MAX] = {
 		.name = "C1-SNB",
 		.desc = "MWAIT 0x00",
 		.flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
-		.exit_latency = 1,
-		.target_residency = 1,
+		.exit_latency = 2,
+		.target_residency = 2,
+		.enter = &intel_idle },
+	{
+		.name = "C1E-SNB",
+		.desc = "MWAIT 0x01",
+		.flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 10,
+		.target_residency = 20,
 		.enter = &intel_idle },
 	{
 		.name = "C3-SNB",
@@ -191,6 +206,13 @@ static struct cpuidle_state ivb_cstates[CPUIDLE_STATE_MAX] = {
 		.target_residency = 1,
 		.enter = &intel_idle },
 	{
+		.name = "C1E-IVB",
+		.desc = "MWAIT 0x01",
+		.flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 10,
+		.target_residency = 20,
+		.enter = &intel_idle },
+	{
 		.name = "C3-IVB",
 		.desc = "MWAIT 0x10",
 		.flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
@@ -224,6 +246,13 @@ static struct cpuidle_state hsw_cstates[CPUIDLE_STATE_MAX] = {
 		.target_residency = 2,
 		.enter = &intel_idle },
 	{
+		.name = "C1E-HSW",
+		.desc = "MWAIT 0x01",
+		.flags = MWAIT2flg(0x01) | CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 10,
+		.target_residency = 20,
+		.enter = &intel_idle },
+	{
 		.name = "C3-HSW",
 		.desc = "MWAIT 0x10",
 		.flags = MWAIT2flg(0x10) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
@@ -250,11 +279,11 @@ static struct cpuidle_state hsw_cstates[CPUIDLE_STATE_MAX] = {
 
 static struct cpuidle_state atom_cstates[CPUIDLE_STATE_MAX] = {
 	{
-		.name = "C1-ATM",
+		.name = "C1E-ATM",
 		.desc = "MWAIT 0x00",
 		.flags = MWAIT2flg(0x00) | CPUIDLE_FLAG_TIME_VALID,
-		.exit_latency = 1,
-		.target_residency = 4,
+		.exit_latency = 10,
+		.target_residency = 20,
 		.enter = &intel_idle },
 	{
 		.name = "C2-ATM",
@@ -377,10 +406,19 @@ static void auto_demotion_disable(void *dummy)
 	msr_bits &= ~(icpu->auto_demotion_disable_flags);
 	wrmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
 }
+static void c1e_promotion_disable(void *dummy)
+{
+	unsigned long long msr_bits;
+
+	rdmsrl(MSR_IA32_POWER_CTL, msr_bits);
+	msr_bits &= ~0x2;
+	wrmsrl(MSR_IA32_POWER_CTL, msr_bits);
+}
 
 static const struct idle_cpu idle_cpu_nehalem = {
 	.state_table = nehalem_cstates,
 	.auto_demotion_disable_flags = NHM_C1_AUTO_DEMOTE | NHM_C3_AUTO_DEMOTE,
+	.disable_promotion_to_c1e = true,
 };
 
 static const struct idle_cpu idle_cpu_atom = {
@@ -390,18 +428,22 @@ static const struct idle_cpu idle_cpu_atom = {
 static const struct idle_cpu idle_cpu_lincroft = {
 	.state_table = atom_cstates,
 	.auto_demotion_disable_flags = ATM_LNC_C6_AUTO_DEMOTE,
+	.disable_promotion_to_c1e = true,
 };
 
 static const struct idle_cpu idle_cpu_snb = {
 	.state_table = snb_cstates,
+	.disable_promotion_to_c1e = true,
 };
 
 static const struct idle_cpu idle_cpu_ivb = {
 	.state_table = ivb_cstates,
+	.disable_promotion_to_c1e = true,
 };
 
 static const struct idle_cpu idle_cpu_hsw = {
 	.state_table = hsw_cstates,
+	.disable_promotion_to_c1e = true,
 };
 
 #define ICPU(model, cpu) \
@@ -544,6 +586,9 @@ static int intel_idle_cpuidle_driver_init(void)
 	if (icpu->auto_demotion_disable_flags)
 		on_each_cpu(auto_demotion_disable, NULL, 1);
 
+	if (icpu->disable_promotion_to_c1e)	/* each-cpu is redundant */
+		on_each_cpu(c1e_promotion_disable, NULL, 1);
+
 	return 0;
 }
 
-- 
1.8.1.3.535.ga923c31

