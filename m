Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbaKPJuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 04:50:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34369 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbaKPJuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 04:50:12 -0500
Date: Sun, 16 Nov 2014 01:49:27 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-41a134a5830a5e1396723ace0a63000780d6e267@git.kernel.org>
Cc: peterz@infradead.org, mingo@kernel.org, acme@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: hpa@zytor.com, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, peterz@infradead.org, acme@kernel.org,
        mingo@kernel.org
In-Reply-To: <1415062828-19759-3-git-send-email-andi@firstfloor.org>
References: <1415062828-19759-3-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/intel/uncore:
  Fix IRP uncore register offsets on Haswell EP
Git-Commit-ID: 41a134a5830a5e1396723ace0a63000780d6e267
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

Commit-ID:  41a134a5830a5e1396723ace0a63000780d6e267
Gitweb:     http://git.kernel.org/tip/41a134a5830a5e1396723ace0a63000780d6e267
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 3 Nov 2014 17:00:27 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 09:45:47 +0100

perf/x86/intel/uncore: Fix IRP uncore register offsets on Haswell EP

The counter register offsets for the IRP box PMU for Haswell-EP
were incorrect. The offsets actually changed over IvyBridge EP.

Fix them to the correct values. For this we need to fork the read
function from the IVB and use an own counter array.

Tested-by: patrick.lu@intel.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Link: http://lkml.kernel.org/r/1415062828-19759-3-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index adf138e..0af1c93 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -2025,13 +2025,27 @@ static struct intel_uncore_type hswep_uncore_imc = {
 	SNBEP_UNCORE_PCI_COMMON_INIT(),
 };
 
+static unsigned hswep_uncore_irp_ctrs[] = {0xa0, 0xa8, 0xb0, 0xb8};
+
+static u64 hswep_uncore_irp_read_counter(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct pci_dev *pdev = box->pci_dev;
+	struct hw_perf_event *hwc = &event->hw;
+	u64 count = 0;
+
+	pci_read_config_dword(pdev, hswep_uncore_irp_ctrs[hwc->idx], (u32 *)&count);
+	pci_read_config_dword(pdev, hswep_uncore_irp_ctrs[hwc->idx] + 4, (u32 *)&count + 1);
+
+	return count;
+}
+
 static struct intel_uncore_ops hswep_uncore_irp_ops = {
 	.init_box	= snbep_uncore_pci_init_box,
 	.disable_box	= snbep_uncore_pci_disable_box,
 	.enable_box	= snbep_uncore_pci_enable_box,
 	.disable_event	= ivbep_uncore_irp_disable_event,
 	.enable_event	= ivbep_uncore_irp_enable_event,
-	.read_counter	= ivbep_uncore_irp_read_counter,
+	.read_counter	= hswep_uncore_irp_read_counter,
 };
 
 static struct intel_uncore_type hswep_uncore_irp = {
