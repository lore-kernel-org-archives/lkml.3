Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbbAWWZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 17:25:17 -0500
Received: from mail-bl2on0107.outbound.protection.outlook.com ([65.55.169.107]:46944
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750817AbbAWWZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 17:25:14 -0500
X-WSS-ID: 0NINHJH-07-1DU-02
X-M-MSG: 
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
To: <tony.luck@intel.com>, <bp@alien8.de>, <mingo@redhat.com>,
        <tglx@linutronix.de>, <hpa@zytor.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Subject: [PATCH] x86, mce, amd: Enable interrupts by default if HW capable
Date: Fri, 23 Jan 2015 16:35:07 -0600
Message-ID: <1422052507-3823-1-git-send-email-aravind.gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; alien8.de; dkim=none (message
 not signed) header.d=none;alien8.de; dmarc=permerror action=none
 header.from=amd.com;
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(50226001)(50986999)(62966003)(77156002)(2201001)(19580405001)(19580395003)(92566002)(48376002)(101416001)(77096005)(47776003)(36756003)(46102003)(33646002)(53416004)(86362001)(50466002)(229853001)(106466001)(105586002)(87936001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BN1PR02MB197;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB197;
X-Forefront-PRVS: 0465429B7F
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2015 22:09:19.8899
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB197
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We setup APIC vectors for threshold errors if interrupt_capable.
However, we don't set interrupt_enable by default.
Re-working threshold_restart_bank() here so that the first time we
set up lvt_offset, we also set IntType to APIC.

If user wants to disable through sysfs, then that's fine too as
we will clear IntType if !tr->b->interrupt_enable

Also, we want to set IntType only if lvt_off_valid is true.
If not, then something is wrong (buggy BIOS maybe) and we'd rather
not have interrupts generated on overflow.

Misc other changes:
- lvt_interrupt_supported() says bank 4 supports APIC LVT always
  But, I looked at BKDG from K8 onwards and I am not seeing IntP
  bit(bit 60) set for any of them.
  - So, removing the bank = 4 check
  - msr_high_bits & BIT(28); will work anyway if bit is set

- We don't have to expose 'interrupt_enable' attribute if HW is
  not capable.
- Moving setting of b.threshold_limit to mce_amd_feature_init()
  - All other setup of struct threshold_block is done there anyway

- Fix comments/comment style issues

Testing details:
on Fam10h (does not have IntP set)
 - interrupt_enable attribute is not exposed.
on F15hM60h (IntP is set)
 - interrupt_enable is set by default
 - echo 0 > interrupt_enable clears IntType of respective register
 - Forcing error count to go over threshold_limit generates APIC
   interrupt and edac mce_amd catches it fine

Signed-off-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c | 43 +++++++++++++-----------------------
 1 file changed, 15 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index f1c3769..8b7dcc6 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -61,9 +61,7 @@ static DEFINE_PER_CPU(unsigned char, bank_map);	/* see which banks are on */
 
 static void amd_threshold_interrupt(void);
 
-/*
- * CPU Initialization
- */
+/* CPU Initialization */
 
 struct thresh_restart {
 	struct threshold_block	*b;
@@ -102,12 +100,6 @@ static const char * const bank4_names(struct threshold_block *b)
 static bool lvt_interrupt_supported(unsigned int bank, u32 msr_high_bits)
 {
 	/*
-	 * bank 4 supports APIC LVT interrupts implicitly since forever.
-	 */
-	if (bank == 4)
-		return true;
-
-	/*
 	 * IntP: interrupt present; if this bit is set, the thresholding
 	 * bank can generate APIC LVT interrupts
 	 */
@@ -161,23 +153,24 @@ static void threshold_restart_bank(void *_tr)
 		    (new_count & THRESHOLD_MAX);
 	}
 
-	/* clear IntType */
-	hi &= ~MASK_INT_TYPE_HI;
-
 	if (!tr->b->interrupt_capable)
 		goto done;
 
+	/* clear IntType */
+	if (!tr->b->interrupt_enable)
+		hi &= ~MASK_INT_TYPE_HI;
+
 	if (tr->set_lvt_off) {
 		if (lvt_off_valid(tr->b, tr->lvt_off, lo, hi)) {
 			/* set new lvt offset */
 			hi &= ~MASK_LVTOFF_HI;
 			hi |= tr->lvt_off << 20;
+
+			/* set IntType */
+			hi |= INT_TYPE_APIC;
 		}
 	}
 
-	if (tr->b->interrupt_enable)
-		hi |= INT_TYPE_APIC;
-
  done:
 
 	hi |= MASK_COUNT_EN_HI;
@@ -192,7 +185,6 @@ static void mce_threshold_block_init(struct threshold_block *b, int offset)
 		.lvt_off		= offset,
 	};
 
-	b->threshold_limit		= THRESHOLD_MAX;
 	threshold_restart_bank(&tr);
 };
 
@@ -246,6 +238,7 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 			b.block			= block;
 			b.address		= address;
 			b.interrupt_capable	= lvt_interrupt_supported(bank, high);
+			b.threshold_limit	= THRESHOLD_MAX;
 
 			if (!b.interrupt_capable)
 				goto init;
@@ -264,13 +257,9 @@ init:
 }
 
 /*
- * APIC Interrupt Handler
- */
-
-/*
- * threshold interrupt handler will service THRESHOLD_APIC_VECTOR.
+ * The threshold interrupt handler will service THRESHOLD_APIC_VECTOR.
  * the interrupt goes off when error_count reaches threshold_limit.
- * the handler will simply log mcelog w/ software defined bank number.
+ * the handler will simply call mcelog for error decoding
  */
 static void amd_threshold_interrupt(void)
 {
@@ -329,9 +318,7 @@ log:
 	wrmsrl(MSR_IA32_MCx_STATUS(bank), 0);
 }
 
-/*
- * Sysfs Interface
- */
+/* Sysfs Interface */
 
 struct threshold_attr {
 	struct attribute attr;
@@ -497,10 +484,10 @@ static int allocate_threshold_blocks(unsigned int cpu, unsigned int bank,
 	b->interrupt_capable	= lvt_interrupt_supported(bank, high);
 	b->threshold_limit	= THRESHOLD_MAX;
 
-	if (b->interrupt_capable)
+	if (b->interrupt_capable) {
 		threshold_ktype.default_attrs[2] = &interrupt_enable.attr;
-	else
-		threshold_ktype.default_attrs[2] = NULL;
+		b->interrupt_enable = 1;
+	}
 
 	INIT_LIST_HEAD(&b->miscj);
 
-- 
2.1.0

