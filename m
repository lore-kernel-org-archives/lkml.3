Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab3CHF4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 00:56:48 -0500
Received: from mga03.intel.com ([143.182.124.21]:38884 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738Ab3CHF4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 00:56:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,806,1355126400"; 
   d="scan'208";a="210947054"
Subject: [PATCH 3/3] intel_idle: set the state_tables array as __initdata
 to save mem
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: lenb@kernel.org
Cc: daniel.lezcano@linaro.org, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
In-Reply-To: <1362754926.31506.42.camel@cliu38-desktop-build>
References: <1362674529.31506.17.camel@cliu38-desktop-build>
	 <1362754926.31506.42.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Mar 2013 23:06:09 +0800
Message-ID: <1362755169.31506.47.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently, in intel_idle.c, there are 5 state_tables array, every
array size is sizeof(struct cpuidle_state) * CPUIDLE_STATE_MAX.

As in intel_idle_cpuidle_driver_init(), we have copied the data into
intel_idle_driver->state[], so do not need to keep state_tables[]
there any more after system init.

It will save about 3~4k memory, also benefits mobile devices.
Here changing them as __initdata, also removing global var
cpuidle_state_table pointer.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/idle/intel_idle.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 503b401..cbdc952 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -99,8 +99,6 @@ static int intel_idle(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv, int index);
 static int intel_idle_cpu_init(int cpu);
 
-static struct cpuidle_state *cpuidle_state_table;
-
 /*
  * Set this flag for states where the HW flushes the TLB for us
  * and so we don't need cross-calls to keep it consistent.
@@ -124,7 +122,7 @@ static struct cpuidle_state *cpuidle_state_table;
  * which is also the index into the MWAIT hint array.
  * Thus C0 is a dummy.
  */
-static struct cpuidle_state nehalem_cstates[CPUIDLE_STATE_MAX] = {
+static struct cpuidle_state nehalem_cstates[CPUIDLE_STATE_MAX] __initdata = {
 	{
 		.name = "C1-NHM",
 		.desc = "MWAIT 0x00",
@@ -157,7 +155,7 @@ static struct cpuidle_state nehalem_cstates[CPUIDLE_STATE_MAX] = {
 		.enter = NULL }
 };
 
-static struct cpuidle_state snb_cstates[CPUIDLE_STATE_MAX] = {
+static struct cpuidle_state snb_cstates[CPUIDLE_STATE_MAX] __initdata = {
 	{
 		.name = "C1-SNB",
 		.desc = "MWAIT 0x00",
@@ -197,7 +195,7 @@ static struct cpuidle_state snb_cstates[CPUIDLE_STATE_MAX] = {
 		.enter = NULL }
 };
 
-static struct cpuidle_state ivb_cstates[CPUIDLE_STATE_MAX] = {
+static struct cpuidle_state ivb_cstates[CPUIDLE_STATE_MAX] __initdata = {
 	{
 		.name = "C1-IVB",
 		.desc = "MWAIT 0x00",
@@ -237,7 +235,7 @@ static struct cpuidle_state ivb_cstates[CPUIDLE_STATE_MAX] = {
 		.enter = NULL }
 };
 
-static struct cpuidle_state hsw_cstates[CPUIDLE_STATE_MAX] = {
+static struct cpuidle_state hsw_cstates[CPUIDLE_STATE_MAX] __initdata = {
 	{
 		.name = "C1-HSW",
 		.desc = "MWAIT 0x00",
@@ -277,7 +275,7 @@ static struct cpuidle_state hsw_cstates[CPUIDLE_STATE_MAX] = {
 		.enter = NULL }
 };
 
-static struct cpuidle_state atom_cstates[CPUIDLE_STATE_MAX] = {
+static struct cpuidle_state atom_cstates[CPUIDLE_STATE_MAX] __initdata = {
 	{
 		.name = "C1E-ATM",
 		.desc = "MWAIT 0x00",
@@ -472,7 +470,7 @@ MODULE_DEVICE_TABLE(x86cpu, intel_idle_ids);
 /*
  * intel_idle_probe()
  */
-static int intel_idle_probe(void)
+static int __init intel_idle_probe(void)
 {
 	unsigned int eax, ebx, ecx;
 	const struct x86_cpu_id *id;
@@ -504,7 +502,6 @@ static int intel_idle_probe(void)
 	pr_debug(PREFIX "MWAIT substates: 0x%x\n", mwait_substates);
 
 	icpu = (const struct idle_cpu *)id->driver_data;
-	cpuidle_state_table = icpu->state_table;
 
 	if (boot_cpu_has(X86_FEATURE_ARAT))	/* Always Reliable APIC Timer */
 		lapic_timer_reliable_states = LAPIC_TIMER_ALWAYS_RELIABLE;
@@ -540,10 +537,11 @@ static void intel_idle_cpuidle_devices_uninit(void)
  * intel_idle_cpuidle_driver_init()
  * allocate, initialize cpuidle_states
  */
-static int intel_idle_cpuidle_driver_init(void)
+static int __init intel_idle_cpuidle_driver_init(void)
 {
 	int cstate;
 	struct cpuidle_driver *drv = &intel_idle_driver;
+	struct cpuidle_state *cpuidle_state_table = icpu->state_table;
 
 	drv->state_count = 1;
 
-- 
1.7.0.4



