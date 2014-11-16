Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbaKPJuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 04:50:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34371 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbaKPJuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 04:50:12 -0500
Date: Sun, 16 Nov 2014 01:49:42 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-68055915c1c22489f9658bd2b7391bb11b2cf4e4@git.kernel.org>
Cc: tglx@linutronix.de, patrick.lu@intel.com, ak@linux.intel.com,
        alexei.starovoitov@gmail.com, mingo@kernel.org, acme@kernel.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org, hpa@zytor.com
Reply-To: tglx@linutronix.de, patrick.lu@intel.com,
        alexei.starovoitov@gmail.com, ak@linux.intel.com, mingo@kernel.org,
        peterz@infradead.org, acme@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1415062828-19759-4-git-send-email-andi@firstfloor.org>
References: <1415062828-19759-4-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/intel/uncore:
  Fix boot crash on SBOX PMU on Haswell-EP
Git-Commit-ID: 68055915c1c22489f9658bd2b7391bb11b2cf4e4
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

Commit-ID:  68055915c1c22489f9658bd2b7391bb11b2cf4e4
Gitweb:     http://git.kernel.org/tip/68055915c1c22489f9658bd2b7391bb11b2cf4e4
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 3 Nov 2014 17:00:28 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 09:53:36 +0100

perf/x86/intel/uncore: Fix boot crash on SBOX PMU on Haswell-EP

There were several reports that on some systems writing the SBOX0 PMU
initialization MSR would #GP at boot. This did not happen on all
systems -- my two test systems booted fine.

Writing the three initialization bits bit-by-bit seems to avoid the
problem. So add a special callback to do just that.

This replaces an earlier patch that disabled the SBOX.

Reported-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Reported-and-Tested-by: Patrick Lu <patrick.lu@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Link: http://lkml.kernel.org/r/1415062828-19759-4-git-send-email-andi@firstfloor.org
[ Fixed a whitespace error and added attribution tags that were left out inexplicably. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 .../x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 33 ++++++++++++++++++++--
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index 0af1c93..f9ed429 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -486,14 +486,17 @@ static struct attribute_group snbep_uncore_qpi_format_group = {
 	.attrs = snbep_uncore_qpi_formats_attr,
 };
 
-#define SNBEP_UNCORE_MSR_OPS_COMMON_INIT()			\
-	.init_box	= snbep_uncore_msr_init_box,		\
+#define __SNBEP_UNCORE_MSR_OPS_COMMON_INIT()			\
 	.disable_box	= snbep_uncore_msr_disable_box,		\
 	.enable_box	= snbep_uncore_msr_enable_box,		\
 	.disable_event	= snbep_uncore_msr_disable_event,	\
 	.enable_event	= snbep_uncore_msr_enable_event,	\
 	.read_counter	= uncore_msr_read_counter
 
+#define SNBEP_UNCORE_MSR_OPS_COMMON_INIT()			\
+	__SNBEP_UNCORE_MSR_OPS_COMMON_INIT(),			\
+	.init_box	= snbep_uncore_msr_init_box		\
+
 static struct intel_uncore_ops snbep_uncore_msr_ops = {
 	SNBEP_UNCORE_MSR_OPS_COMMON_INIT(),
 };
@@ -1919,6 +1922,30 @@ static struct intel_uncore_type hswep_uncore_cbox = {
 	.format_group		= &hswep_uncore_cbox_format_group,
 };
 
+/*
+ * Write SBOX Initialization register bit by bit to avoid spurious #GPs
+ */
+static void hswep_uncore_sbox_msr_init_box(struct intel_uncore_box *box)
+{
+	unsigned msr = uncore_msr_box_ctl(box);
+
+	if (msr) {
+		u64 init = SNBEP_PMON_BOX_CTL_INT;
+		u64 flags = 0;
+		int i;
+
+		for_each_set_bit(i, (unsigned long *)&init, 64) {
+			flags |= (1ULL << i);
+			wrmsrl(msr, flags);
+		}
+	}
+}
+
+static struct intel_uncore_ops hswep_uncore_sbox_msr_ops = {
+	__SNBEP_UNCORE_MSR_OPS_COMMON_INIT(),
+	.init_box		= hswep_uncore_sbox_msr_init_box
+};
+
 static struct attribute *hswep_uncore_sbox_formats_attr[] = {
 	&format_attr_event.attr,
 	&format_attr_umask.attr,
@@ -1944,7 +1971,7 @@ static struct intel_uncore_type hswep_uncore_sbox = {
 	.event_mask		= HSWEP_S_MSR_PMON_RAW_EVENT_MASK,
 	.box_ctl		= HSWEP_S0_MSR_PMON_BOX_CTL,
 	.msr_offset		= HSWEP_SBOX_MSR_OFFSET,
-	.ops			= &snbep_uncore_msr_ops,
+	.ops			= &hswep_uncore_sbox_msr_ops,
 	.format_group		= &hswep_uncore_sbox_format_group,
 };
 
