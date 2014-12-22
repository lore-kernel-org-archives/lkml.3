Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbaLVTmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:42:52 -0500
Received: from mail-bn1bon0130.outbound.protection.outlook.com ([157.56.111.130]:17632
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755035AbaLVTmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:42:50 -0500
X-WSS-ID: 0NH01F9-07-0CD-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <tony.luck@intel.com>, <bp@alien8.de>, <dougthompson@xmission.com>,
        <mchehab@osg.samsung.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>
CC: <dave.hansen@linux.intel.com>, <mgorman@suse.de>, <bp@suse.de>,
        <riel@redhat.com>, <jacob.w.shin@gmail.com>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH 2/3] x86, mce: Handle AMD MCE on bank4 on NBC for multi-node processors
Date: Mon, 22 Dec 2014 14:10:11 -0600
Message-ID: <1419279012-4754-3-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <1419279012-4754-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
References: <1419279012-4754-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(19580405001)(50226001)(46102003)(19580395003)(92566001)(120916001)(48376002)(47776003)(50466002)(64706001)(68736005)(20776003)(84676001)(76176999)(101416001)(77096005)(2950100001)(21056001)(89996001)(36756003)(50986999)(97736003)(87936001)(31966008)(99396003)(105586002)(86362001)(62966003)(107046002)(229853001)(106466001)(77156002)(53416004)(2201001)(4396001)(921003)(217873001)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB200;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB200;
X-Forefront-PRVS: 0433DB2766
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2014 19:42:48.2296
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem is that when MC4 error happens on AMD multi-node processors,
they are reported only to corresponding node base core of the cpu
on which the error occurred.

We don't have the exception handler wired up to handle this currently.
As a consequence, do_machine_check only runs on the core on which error
occurred and (since according to the BKDGs, reads to MC4_STATUS MSR of
non-NBC will simply RAZ) the exception is ignored for the core.

Now, when an exception _does_ happen on the node base core, that gets
handled properly. I tested this on Fam10h and Fam15h using mce_amd_inj
and by triggering a real HW MCE using Boris' new interface; And can
confirm the behavior. (Of course, with mce_amd_inj I could only inject
on the NBC as BKDGs state that writes are ignored. The following patch
addresses this problem)

This patch fixes the issue by reading (or writing) only to the NBC MSR
for bank 4 errors on multi node processors for Fam10h onwards.
For this, we need to rdmsrl_on_cpu and I have provided wrappers that
also supports the injection interface used by mce-inject.c

The handling of CE also has to be corrected as a result of this.
 - Since MC4 errors are only processed on NBCs, we can theoritically
   have multiple number of CEs in flight waiting to be handled (as many
   as there are nodes on the system)
 - Providing an array to save cpu on which CEs occur
 - Later, when the poller runs, it only need to verify if the current
   cpu is the saved one for the node on which current cpu is on. If yes,
   handle the error.

Misc changes:
 - Modify mce_read_aux to use bank value off existing mce struct argument
 - modifying mce_clear_state to take a cpu argument as it will be needed
   for clearing correct MSR STATUS register if we need_amd_nbc_handling

Testing details:
 - Tested the patch on
   - multi node: Fam10h, Fam15h Model 00h
   - single node: Fam15h Model 60h
 - Before patch, no error injected to non NBC is handled by MCE handler
 - After patch, UE are handled immediately by looking at correct NBC
 - For CEs cpu values are stored and handled by polling mechanism
   later on the correct cpu on which error happened.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 167 +++++++++++++++++++++++++++++++++++----
 1 file changed, 153 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d2c6116..c5eedbd 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -87,6 +87,12 @@ static DECLARE_WAIT_QUEUE_HEAD(mce_chrdev_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
 static int			cpu_missing;
 
+/* AMD fam10h and later can only access NBC MSRs for MC4 errors */
+static int need_amd_nbc_handling;
+
+/* multiple CEs can be in flight on the per-node MSR waiting to be handled */
+static int *amd_saved_ce_on_cpu;
+
 /* CMCI storm detection filter */
 static DEFINE_PER_CPU(unsigned long, mce_polled_error);
 
@@ -428,6 +434,45 @@ static void mce_wrmsrl(u32 msr, u64 v)
 	wrmsrl(msr, v);
 }
 
+/* MSR per-cpu access wrappers */
+static u64 mce_rdmsrl_on_cpu(unsigned int cpu, u32 msr)
+{
+	struct mce *reg = per_cpu_ptr(&injectm, cpu);
+	u64 v;
+
+	if (reg->finished) {
+		int offset = msr_to_offset(msr);
+
+		if (offset < 0)
+			return 0;
+		return *(u64 *)((char *)per_cpu_ptr(&injectm, cpu) + offset);
+	}
+
+	if (rdmsrl_on_cpu(cpu, msr, &v)) {
+		WARN_ONCE(1, "mce: Unable to read msr %d!\n", msr);
+		v = 0;
+	}
+
+	return v;
+}
+
+static void mce_wrmsrl_on_cpu(unsigned int cpu, u32 msr, u64 v)
+{
+	struct mce *reg = per_cpu_ptr(&injectm, cpu);
+
+	if (reg->finished) {
+		int offset = msr_to_offset(msr);
+
+		if (offset >= 0)
+			*(u64 *)((char *)per_cpu_ptr(&injectm, cpu) +
+							offset) = v;
+		return;
+	}
+
+	if (wrmsrl_on_cpu(cpu, msr, v))
+		WARN_ONCE(1, "mce: Unable to write to msr %d!\n", msr);
+}
+
 /*
  * Collect all global (w.r.t. this processor) status about this machine
  * check into our "mce" struct so that we can use it later to assess
@@ -557,12 +602,19 @@ static void mce_report_event(struct pt_regs *regs)
 /*
  * Read ADDR and MISC registers.
  */
-static void mce_read_aux(struct mce *m, int i)
+static void mce_read_aux(struct mce *m)
 {
 	if (m->status & MCI_STATUS_MISCV)
-		m->misc = mce_rdmsrl(MSR_IA32_MCx_MISC(i));
+		m->misc = mce_rdmsrl(MSR_IA32_MCx_MISC(m->bank));
 	if (m->status & MCI_STATUS_ADDRV) {
-		m->addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(i));
+		if (m->bank == 4 && need_amd_nbc_handling) {
+			unsigned int nbc = amd_get_nbc_for_cpu(m->extcpu);
+
+			m->addr = mce_rdmsrl_on_cpu(nbc,
+						MSR_IA32_MCx_ADDR(m->bank));
+		} else {
+			m->addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(m->bank));
+		}
 
 		/*
 		 * Mask the reported address by the reported granularity.
@@ -627,6 +679,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 {
 	struct mce m;
 	int severity;
+	u16 nid = 0;
 	int i;
 
 	this_cpu_inc(mce_poll_count);
@@ -643,7 +696,19 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		m.tsc = 0;
 
 		barrier();
-		m.status = mce_rdmsrl(MSR_IA32_MCx_STATUS(i));
+		if (i == 4 && need_amd_nbc_handling) {
+			nid = amd_get_nb_id(m.extcpu);
+			if (amd_saved_ce_on_cpu[nid] != -1 &&
+			    amd_saved_ce_on_cpu[nid] != m.extcpu)
+				continue;
+			else
+				m.status = mce_rdmsrl_on_cpu(
+						amd_get_nbc_for_cpu(m.extcpu),
+						MSR_IA32_MCx_STATUS(i));
+		} else {
+			m.status = mce_rdmsrl(MSR_IA32_MCx_STATUS(i));
+		}
+
 		if (!(m.status & MCI_STATUS_VAL))
 			continue;
 
@@ -658,7 +723,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		    (m.status & (mca_cfg.ser ? MCI_STATUS_S : MCI_STATUS_UC)))
 			continue;
 
-		mce_read_aux(&m, i);
+		mce_read_aux(&m);
 
 		if (!(flags & MCP_TIMESTAMP))
 			m.tsc = 0;
@@ -686,7 +751,21 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		/*
 		 * Clear state for this bank.
 		 */
-		mce_wrmsrl(MSR_IA32_MCx_STATUS(i), 0);
+		if (i == 4 &&
+		    need_amd_nbc_handling &&
+		    amd_saved_ce_on_cpu[nid] != -1 &&
+		    amd_saved_ce_on_cpu[nid] == m.extcpu) {
+			mce_wrmsrl_on_cpu(amd_get_nbc_for_cpu(m.extcpu),
+					  MSR_IA32_MCx_STATUS(i),
+					  0);
+			/*
+			 * We also need to reset
+			 * saved_ce_on_cpu for future CEs
+			 */
+			amd_saved_ce_on_cpu[nid] = -1;
+		} else {
+			mce_wrmsrl(MSR_IA32_MCx_STATUS(i), 0);
+		}
 	}
 
 	/*
@@ -708,7 +787,13 @@ static int mce_no_way_out(struct mce *m, char **msg, unsigned long *validp,
 	int i, ret = 0;
 
 	for (i = 0; i < mca_cfg.banks; i++) {
-		m->status = mce_rdmsrl(MSR_IA32_MCx_STATUS(i));
+		if (i == 4 && need_amd_nbc_handling)
+			m->status = mce_rdmsrl_on_cpu(
+					amd_get_nbc_for_cpu(m->extcpu),
+					MSR_IA32_MCx_STATUS(i));
+		else
+			m->status = mce_rdmsrl(MSR_IA32_MCx_STATUS(i));
+
 		if (m->status & MCI_STATUS_VAL) {
 			__set_bit(i, validp);
 			if (quirk_no_way_out)
@@ -992,13 +1077,23 @@ static int mce_usable_address(struct mce *m)
 	return 1;
 }
 
-static void mce_clear_state(unsigned long *toclear)
+/*
+ * If need_amd_nbc_handling is set, then we'll need a cpu
+ * value to be able to clean the status on the correct core
+ */
+static void mce_clear_state(unsigned long *toclear, unsigned int cpu)
 {
 	int i;
 
 	for (i = 0; i < mca_cfg.banks; i++) {
-		if (test_bit(i, toclear))
-			mce_wrmsrl(MSR_IA32_MCx_STATUS(i), 0);
+		if (test_bit(i, toclear)) {
+			if (i == 4 && need_amd_nbc_handling)
+				mce_wrmsrl_on_cpu(cpu,
+						  MSR_IA32_MCx_STATUS(i),
+						  0);
+			else
+				mce_wrmsrl(MSR_IA32_MCx_STATUS(i), 0);
+		}
 	}
 }
 
@@ -1081,6 +1176,10 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * error.
 	 */
 	int kill_it = 0;
+
+	/* for saving nbc value for AMD systems that need_amd_nbc_handling */
+	unsigned int nbc = 0;
+
 	DECLARE_BITMAP(toclear, MAX_NR_BANKS);
 	DECLARE_BITMAP(valid_banks, MAX_NR_BANKS);
 	char *msg = "Unknown";
@@ -1125,7 +1224,14 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		m.addr = 0;
 		m.bank = i;
 
-		m.status = mce_rdmsrl(MSR_IA32_MCx_STATUS(i));
+		if (i == 4 && need_amd_nbc_handling) {
+			nbc = amd_get_nbc_for_cpu(m.extcpu);
+			m.status = mce_rdmsrl_on_cpu(nbc,
+						     MSR_IA32_MCx_STATUS(i));
+		} else {
+			m.status = mce_rdmsrl(MSR_IA32_MCx_STATUS(i));
+		}
+
 		if ((m.status & MCI_STATUS_VAL) == 0)
 			continue;
 
@@ -1133,9 +1239,22 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		 * Non uncorrected or non signaled errors are handled by
 		 * machine_check_poll. Leave them alone, unless this panics.
 		 */
+
+		/*
+		 * Also, If we are on AMD system and need_amd_nbc_handling is
+		 * set, then keep track of the cpu number on which error
+		 * happened so that polling mechanism can handle it on the
+		 * correct core later on
+		 */
 		if (!(m.status & (cfg->ser ? MCI_STATUS_S : MCI_STATUS_UC)) &&
-			!no_way_out)
+			!no_way_out) {
+			if (i == 4 && need_amd_nbc_handling) {
+				u16 nid = amd_get_nb_id(m.extcpu);
+
+				amd_saved_ce_on_cpu[nid] = m.extcpu;
+			}
 			continue;
+		}
 
 		/*
 		 * Set taint even when machine check was not enabled.
@@ -1160,7 +1279,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 			continue;
 		}
 
-		mce_read_aux(&m, i);
+		mce_read_aux(&m);
 
 		/*
 		 * Action optional error. Queue address for later processing.
@@ -1184,7 +1303,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	m = *final;
 
 	if (!no_way_out)
-		mce_clear_state(toclear);
+		mce_clear_state(toclear, nbc);
 
 	/*
 	 * Do most of the synchronization with other CPUs.
@@ -1559,6 +1678,26 @@ static int __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 
 	/* This should be disabled by the BIOS, but isn't always */
 	if (c->x86_vendor == X86_VENDOR_AMD) {
+		if (c->x86 >= 0x10) {
+			int n_nodes = num_online_nodes();
+			int i;
+
+			/* we only need to initialize once */
+			if (!amd_saved_ce_on_cpu) {
+				amd_saved_ce_on_cpu = (int *)
+					kzalloc(sizeof(int) * n_nodes,
+						GFP_KERNEL);
+
+				if (!amd_saved_ce_on_cpu)
+					return -ENOMEM;
+
+				for (i = 0; i < n_nodes; i++)
+					amd_saved_ce_on_cpu[i] = -1;
+
+				need_amd_nbc_handling = 1;
+			}
+		}
+
 		if (c->x86 == 15 && cfg->banks > 4) {
 			/*
 			 * disable GART TBL walk error reporting, which
-- 
2.0.2

