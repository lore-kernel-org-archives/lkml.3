Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaCLKLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:11:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48935 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaCLKLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:11:32 -0400
Date: Wed, 12 Mar 2014 03:10:55 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-4191c29f0593e82d19c3cd05de67e55467aca6b5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, sfr@canb.auug.org.au,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        sfr@canb.auug.org.au
In-Reply-To: <20140311235329.GA28624@quad>
References: <20140311235329.GA28624@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/uncore:
  Fix compilation warning in snb_uncore_imc_init_box()
Git-Commit-ID: 4191c29f0593e82d19c3cd05de67e55467aca6b5
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

Commit-ID:  4191c29f0593e82d19c3cd05de67e55467aca6b5
Gitweb:     http://git.kernel.org/tip/4191c29f0593e82d19c3cd05de67e55467aca6b5
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 12 Mar 2014 00:53:30 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 12 Mar 2014 10:49:13 +0100

perf/x86/uncore: Fix compilation warning in snb_uncore_imc_init_box()

This patch fixes a compilation problem (unused variable) with the
new SNB/IVB/HSW uncore IMC code.

[ In -v2 we simplify the fix as suggested by Peter Zjilstra. ]

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140311235329.GA28624@quad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 5c2537a..dfd50ea 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1722,15 +1722,16 @@ static struct attribute_group snb_uncore_imc_format_group = {
 static void snb_uncore_imc_init_box(struct intel_uncore_box *box)
 {
 	struct pci_dev *pdev = box->pci_dev;
-	u32 addr_lo, addr_hi;
+	int where = SNB_UNCORE_PCI_IMC_BAR_OFFSET;
 	resource_size_t addr;
+	u32 pci_dword;
 
-	pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET, &addr_lo);
-	addr = addr_lo;
+	pci_read_config_dword(pdev, where, &pci_dword);
+	addr = pci_dword;
 
 #ifdef CONFIG_PHYS_ADDR_T_64BIT
-	pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET+4, &addr_hi);
-	addr = ((resource_size_t)addr_hi << 32) | addr_lo;
+	pci_read_config_dword(pdev, where + 4, &pci_dword);
+	addr |= ((resource_size_t)pci_dword << 32);
 #endif
 
 	addr &= ~(PAGE_SIZE - 1);
