Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbaLVT5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:57:36 -0500
Received: from mail-bn1bon0113.outbound.protection.outlook.com ([157.56.111.113]:65282
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754858AbaLVT5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:57:34 -0500
X-WSS-ID: 0NH01F7-07-0CC-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <tony.luck@intel.com>, <bp@alien8.de>, <dougthompson@xmission.com>,
        <mchehab@osg.samsung.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>
CC: <dave.hansen@linux.intel.com>, <mgorman@suse.de>, <bp@suse.de>,
        <riel@redhat.com>, <jacob.w.shin@gmail.com>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH 1/3] x86,amd: Refactor amd cpu topology functions for multi-node processors
Date: Mon, 22 Dec 2014 14:10:10 -0600
Message-ID: <1419279012-4754-2-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <1419279012-4754-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
References: <1419279012-4754-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(84676001)(105586002)(76176999)(87936001)(101416001)(106466001)(50986999)(19580405001)(2201001)(120916001)(53416004)(99396003)(19580395003)(229853001)(107046002)(50226001)(4396001)(36756003)(97736003)(68736005)(21056001)(20776003)(47776003)(48376002)(64706001)(2950100001)(89996001)(46102003)(77096005)(92566001)(86362001)(31966008)(575784001)(50466002)(77156002)(62966003)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB208;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CO1PR02MB208;
X-Forefront-PRVS: 0433DB2766
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2014 19:42:46.1704
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB208
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We would like to be able to provide a mechanism for finding the NBC for
each node in multi-node platforms. For this, we will need the number of
nodes per processor.

So, factor this calculation out of amd_get_topology() and provide separate
getter function 'amd_get_nbc_for_node' for obtaining NBC for a node.

Another useful calculation is to find the NBC of a node on which a given cpu
is on. Provide a getter for this as well.
 - We are using it in EDAC drivers, MCE handlers right away, so marked
  extern.
 - We currently don't use amd_get_nbc_for_node outside of here, so
  marking it static.  We can make this extern as and when need arises.

While at it, reverse the return condition in amd_get_topology
and save an indent level.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 arch/x86/include/asm/processor.h |  1 +
 arch/x86/kernel/cpu/amd.c        | 78 ++++++++++++++++++++++++++++++++--------
 2 files changed, 65 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index a092a0c..6e1dc06 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -979,6 +979,7 @@ static inline int mpx_disable_management(struct task_struct *tsk)
 #endif /* CONFIG_X86_INTEL_MPX */
 
 extern u16 amd_get_nb_id(int cpu);
+extern unsigned int amd_get_nbc_for_cpu(int cpu);
 
 static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t leaves)
 {
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index a220239..0c0eae5 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -281,6 +281,28 @@ static int nearby_node(int apicid)
 }
 #endif
 
+#ifdef CONFIG_X86_HT
+static u32 amd_get_num_nodes(struct cpuinfo_x86 *c)
+{
+	u32 nodes = 1;
+
+	if (cpu_has_topoext) {
+		u32 ecx;
+
+		ecx = cpuid_ecx(0x8000001e);
+		nodes = ((ecx >> 8) & 7) + 1;
+	} else if (cpu_has(c, X86_FEATURE_NODEID_MSR)) {
+		u64 value;
+
+		rdmsrl(MSR_FAM10H_NODE_ID, value);
+		nodes = ((value >> 3) & 7) + 1;
+	}
+
+	return nodes;
+}
+EXPORT_SYMBOL_GPL(amd_get_num_nodes);
+#endif
+
 /*
  * Fixup core topology information for
  * (1) AMD multi-node processors
@@ -291,15 +313,18 @@ static int nearby_node(int apicid)
 static void amd_get_topology(struct cpuinfo_x86 *c)
 {
 	u32 nodes, cores_per_cu = 1;
+	u32 cores_per_node;
+	u32 cus_per_node;
 	u8 node_id;
 	int cpu = smp_processor_id();
 
 	/* get information required for multi-node processors */
+	nodes = amd_get_num_nodes(c);
+
 	if (cpu_has_topoext) {
 		u32 eax, ebx, ecx, edx;
 
 		cpuid(0x8000001e, &eax, &ebx, &ecx, &edx);
-		nodes = ((ecx >> 8) & 7) + 1;
 		node_id = ecx & 7;
 
 		/* get compute unit information */
@@ -310,27 +335,24 @@ static void amd_get_topology(struct cpuinfo_x86 *c)
 		u64 value;
 
 		rdmsrl(MSR_FAM10H_NODE_ID, value);
-		nodes = ((value >> 3) & 7) + 1;
 		node_id = value & 7;
 	} else
 		return;
 
 	/* fixup multi-node processor information */
-	if (nodes > 1) {
-		u32 cores_per_node;
-		u32 cus_per_node;
+	if (nodes < 2)
+		return;
 
-		set_cpu_cap(c, X86_FEATURE_AMD_DCM);
-		cores_per_node = c->x86_max_cores / nodes;
-		cus_per_node = cores_per_node / cores_per_cu;
+	set_cpu_cap(c, X86_FEATURE_AMD_DCM);
+	cores_per_node = c->x86_max_cores / nodes;
+	cus_per_node = cores_per_node / cores_per_cu;
 
-		/* store NodeID, use llc_shared_map to store sibling info */
-		per_cpu(cpu_llc_id, cpu) = node_id;
+	/* store NodeID, use llc_shared_map to store sibling info */
+	per_cpu(cpu_llc_id, cpu) = node_id;
 
-		/* core id has to be in the [0 .. cores_per_node - 1] range */
-		c->cpu_core_id %= cores_per_node;
-		c->compute_unit_id %= cus_per_node;
-	}
+	/* core id has to be in the [0 .. cores_per_node - 1] range */
+	c->cpu_core_id %= cores_per_node;
+	c->compute_unit_id %= cus_per_node;
 }
 #endif
 
@@ -365,6 +387,34 @@ u16 amd_get_nb_id(int cpu)
 }
 EXPORT_SYMBOL_GPL(amd_get_nb_id);
 
+#ifdef CONFIG_X86_HT
+static u32 amd_get_nbc_for_node(int node_id)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	u32 nodes, cores_per_node;
+
+	nodes = amd_get_num_nodes(c);
+	cores_per_node = c->x86_max_cores / nodes;
+
+	return cores_per_node * node_id;
+}
+EXPORT_SYMBOL_GPL(amd_get_nbc_for_node);
+#endif
+
+#ifdef CONFIG_X86_HT
+unsigned int amd_get_nbc_for_cpu(int cpu)
+{
+	unsigned int nbc = 0;
+
+	/* for multi-node */
+	if (test_cpu_cap(&boot_cpu_data, X86_FEATURE_AMD_DCM))
+		nbc = amd_get_nbc_for_node(amd_get_nb_id(cpu));
+
+	return nbc;
+}
+EXPORT_SYMBOL_GPL(amd_get_nbc_for_cpu);
+#endif
+
 static void srat_detect_node(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_NUMA
-- 
2.0.2

