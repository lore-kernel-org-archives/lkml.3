Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaKFQ3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:29:31 -0500
Received: from mail-by2on0133.outbound.protection.outlook.com ([207.46.100.133]:2272
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751187AbaKFQ3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:29:25 -0500
X-WSS-ID: 0NEMLSV-07-0PQ-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@kernel.org>, <tglx@linutronix.de>, <hpa@zytor.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@suse.de>,
        Jan Kiszka <jan.kiszka@siemens.com>, Len Brown <len.brown@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH] perf, amd, ibs: Update IBS MSRs and feature definitions
Date: Thu, 6 Nov 2014 10:26:22 -0600
Message-ID: <1415291182-4324-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(77096003)(102836001)(87286001)(50466002)(120916001)(77156002)(21056001)(86362001)(104166001)(84676001)(68736004)(53416004)(89996001)(31966008)(101416001)(99396003)(87936001)(48376002)(4396001)(46102003)(93916002)(97736003)(88136002)(575784001)(2201001)(64706001)(50226001)(47776003)(106466001)(20776003)(229853001)(19580395003)(50986999)(62966003)(92726001)(92566001)(36756003)(105586002)(44976005)(95666004)(19580405001)(107046002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB203;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0387D64A71
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New Fam15h models carry extra feature bits and extend
the MSR register space for IBS ops. Adding them here.

While at it, add functionality to read IbsBrTarget and
OpData4 depending on their availability if user wants a
PERF_SAMPLE_RAW.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 arch/x86/include/asm/perf_event.h        |  3 +++
 arch/x86/include/uapi/asm/msr-index.h    |  2 ++
 arch/x86/kernel/cpu/perf_event_amd_ibs.c | 15 +++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8dfc9fd..dc0f6ed 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -177,6 +177,9 @@ struct x86_pmu_capability {
 #define IBS_CAPS_BRNTRGT		(1U<<5)
 #define IBS_CAPS_OPCNTEXT		(1U<<6)
 #define IBS_CAPS_RIPINVALIDCHK		(1U<<7)
+#define IBS_CAPS_OPBRNFUSE		(1U<<8)
+#define IBS_CAPS_FETCHCTLEXTD		(1U<<9)
+#define IBS_CAPS_OPDATA4		(1U<<10)
 
 #define IBS_CAPS_DEFAULT		(IBS_CAPS_AVAIL		\
 					 | IBS_CAPS_FETCHSAM	\
diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index e21331c..ba7b609 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -206,6 +206,8 @@
 #define MSR_AMD64_IBSOP_REG_MASK	((1UL<<MSR_AMD64_IBSOP_REG_COUNT)-1)
 #define MSR_AMD64_IBSCTL		0xc001103a
 #define MSR_AMD64_IBSBRTARGET		0xc001103b
+#define MSR_AMD64_IBS_FETCH_EXTD_CTL	0xc001103c
+#define MSR_AMD64_IBSOPDATA4		0xc001103d
 #define MSR_AMD64_IBS_REG_COUNT_MAX	8 /* includes MSR_AMD64_IBSBRTARGET */
 
 /* Fam 16h MSRs */
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index cbb1be3e..a61f5c6 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -565,6 +565,21 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 				       perf_ibs->offset_max,
 				       offset + 1);
 	} while (offset < offset_max);
+	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
+		/*
+		 * Read IbsBrTarget and IbsOpData4 separately
+		 * depending on their availability.
+		 * Can't add to offset_max as they are staggered
+		 */
+		if (ibs_caps & IBS_CAPS_BRNTRGT) {
+			rdmsrl(MSR_AMD64_IBSBRTARGET, *buf++);
+			size++;
+		}
+		if (ibs_caps & IBS_CAPS_OPDATA4) {
+			rdmsrl(MSR_AMD64_IBSOPDATA4, *buf++);
+			size++;
+		}
+	}
 	ibs_data.size = sizeof(u64) * size;
 
 	regs = *iregs;
-- 
1.9.1

