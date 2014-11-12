Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaKLOQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:16:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50016 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbaKLOQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:16:32 -0500
Date: Wed, 12 Nov 2014 06:15:32 -0800
From: tip-bot for Aravind Gopalakrishnan <tipbot@zytor.com>
Message-ID: <tip-904cb3677f3adcd3d837be0a0d0b14251ba8d6f7@git.kernel.org>
Cc: bp@suse.de, hpa@zytor.com, paulus@samba.org,
        Aravind.Gopalakrishnan@amd.com, tglx@linutronix.de, acme@kernel.org,
        peterz@infradead.org, fenghua.yu@intel.com, jan.kiszka@siemens.com,
        len.brown@intel.com, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        mingo@kernel.org
Reply-To: pbonzini@redhat.com, len.brown@intel.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, fenghua.yu@intel.com,
        jan.kiszka@siemens.com, acme@kernel.org, tglx@linutronix.de,
        peterz@infradead.org, bp@suse.de, Aravind.Gopalakrishnan@amd.com,
        paulus@samba.org, hpa@zytor.com
In-Reply-To: <1415651066-13523-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
References: <1415651066-13523-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/amd/ibs:
  Update IBS MSRs and feature definitions
Git-Commit-ID: 904cb3677f3adcd3d837be0a0d0b14251ba8d6f7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  904cb3677f3adcd3d837be0a0d0b14251ba8d6f7
Gitweb:     http://git.kernel.org/tip/904cb3677f3adcd3d837be0a0d0b14251ba8d6f7
Author:     Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
AuthorDate: Mon, 10 Nov 2014 14:24:26 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 12 Nov 2014 15:12:32 +0100

perf/x86/amd/ibs: Update IBS MSRs and feature definitions

New Fam15h models carry extra feature bits and extend
the MSR register space for IBS ops. Adding them here.

While at it, add functionality to read IbsBrTarget and
OpData4 depending on their availability if user wants a
PERF_SAMPLE_RAW.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <paulus@samba.org>
Cc: <acme@kernel.org>
Link: http://lkml.kernel.org/r/1415651066-13523-1-git-send-email-Aravind.Gopalakrishnan@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/perf_event.h        |  3 +++
 arch/x86/include/uapi/asm/msr-index.h    |  1 +
 arch/x86/kernel/cpu/perf_event_amd_ibs.c | 15 +++++++++++++++
 3 files changed, 19 insertions(+)

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
index e21331c..8f02f69 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -206,6 +206,7 @@
 #define MSR_AMD64_IBSOP_REG_MASK	((1UL<<MSR_AMD64_IBSOP_REG_COUNT)-1)
 #define MSR_AMD64_IBSCTL		0xc001103a
 #define MSR_AMD64_IBSBRTARGET		0xc001103b
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
