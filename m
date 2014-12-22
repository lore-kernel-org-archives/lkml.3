Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbaLVT5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:57:14 -0500
Received: from mail-bl2on0112.outbound.protection.outlook.com ([65.55.169.112]:28576
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755174AbaLVT5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:57:06 -0500
X-Greylist: delayed 859 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Dec 2014 14:57:06 EST
X-WSS-ID: 0NH01F7-08-5IA-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <tony.luck@intel.com>, <bp@alien8.de>, <dougthompson@xmission.com>,
        <mchehab@osg.samsung.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>
CC: <dave.hansen@linux.intel.com>, <mgorman@suse.de>, <bp@suse.de>,
        <riel@redhat.com>, <jacob.w.shin@gmail.com>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH 3/3] edac, mce_amd_inj: Inject errors only on NBC for bank 4 errors
Date: Mon, 22 Dec 2014 14:10:12 -0600
Message-ID: <1419279012-4754-4-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <1419279012-4754-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
References: <1419279012-4754-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(43544003)(189002)(31966008)(50226001)(106466001)(86362001)(19580395003)(4396001)(50466002)(48376002)(36756003)(68736005)(64706001)(2201001)(20776003)(47776003)(97736003)(21056001)(107046002)(77096005)(2950100001)(92566001)(105586002)(46102003)(19580405001)(101416001)(76176999)(50986999)(229853001)(87936001)(89996001)(120916001)(84676001)(53416004)(77156002)(99396003)(62966003)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB193;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR02MB193;
X-Forefront-PRVS: 0433DB2766
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2014 19:42:50.0254
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR02MB193
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For Fam10h onwards, bank4 MCE are reported only to the node base
cores. This patch modifies the do_inject code path to take care
of this.

Refer D18F3x44[NbMcaToMstCpuEn] on BKDGs of Fam10h and later for
clarifications on the reporting of MC4 errors only to NBC MSRs.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 drivers/edac/mce_amd_inj.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/mce_amd_inj.c b/drivers/edac/mce_amd_inj.c
index 0bd91a8..d4aa14f 100644
--- a/drivers/edac/mce_amd_inj.c
+++ b/drivers/edac/mce_amd_inj.c
@@ -126,6 +126,7 @@ static void do_inject(void)
 {
 	u64 mcg_status = 0;
 	unsigned int cpu = i_mce.extcpu;
+	int saved_cpu = -1;
 	u8 b = i_mce.bank;
 
 	if (!(i_mce.inject_flags & MCJ_EXCEPTION)) {
@@ -143,22 +144,34 @@ static void do_inject(void)
 	if (!(i_mce.status & MCI_STATUS_PCC))
 		mcg_status |= MCG_STATUS_RIPV;
 
-	toggle_hw_mce_inject(cpu, true);
-
 	wrmsr_on_cpu(cpu, MSR_IA32_MCG_STATUS,
 		     (u32)mcg_status, (u32)(mcg_status >> 32));
 
+	/*
+	 * for Fam10h+, if bank = 4, then we should write to NBC MSR
+	 * for multi-node processors else to core 0 for single node processors
+	 */
+	if (boot_cpu_data.x86 >= 0x10 && b == 4) {
+		saved_cpu = cpu;
+		cpu = amd_get_nbc_for_cpu(cpu);
+	}
+
+	toggle_hw_mce_inject(cpu, true);
+
 	wrmsr_on_cpu(cpu, MSR_IA32_MCx_STATUS(b),
 		     (u32)i_mce.status, (u32)(i_mce.status >> 32));
 
 	wrmsr_on_cpu(cpu, MSR_IA32_MCx_ADDR(b),
 		     (u32)i_mce.addr, (u32)(i_mce.addr >> 32));
 
+	toggle_hw_mce_inject(cpu, false);
+
+	if (saved_cpu != -1)
+		cpu = saved_cpu;
+
 	wrmsr_on_cpu(cpu, MSR_IA32_MCx_MISC(b),
 		     (u32)i_mce.misc, (u32)(i_mce.misc >> 32));
 
-	toggle_hw_mce_inject(cpu, false);
-
 	smp_call_function_single(cpu, trigger_mce, NULL, 0);
 
 err:
-- 
2.0.2

