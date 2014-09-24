Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaIXPCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:02:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59949 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbaIXPCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:02:10 -0400
Date: Wed, 24 Sep 2014 08:01:37 -0700
From: "tip-bot for Bryan O'Donoghue" <tipbot@zytor.com>
Message-ID: <tip-ee1b5b165c0a2f04d2107e634e51f05d0eb107de@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        pure.logic@nexus-software.ie, stable@vger.kernel.org,
        tglx@linutronix.de, bp@alien8.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pure.logic@nexus-software.ie, tglx@linutronix.de,
        stable@vger.kernel.org, bp@alien8.de
In-Reply-To: <1411514784-14885-1-git-send-email-pure.logic@nexus-software.ie>
References: <1411514784-14885-1-git-send-email-pure.logic@nexus-software.ie>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/intel/quark:
  Switch off CR4.PGE so TLB flush uses CR3 instead
Git-Commit-ID: ee1b5b165c0a2f04d2107e634e51f05d0eb107de
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

Commit-ID:  ee1b5b165c0a2f04d2107e634e51f05d0eb107de
Gitweb:     http://git.kernel.org/tip/ee1b5b165c0a2f04d2107e634e51f05d0eb107de
Author:     Bryan O'Donoghue <pure.logic@nexus-software.ie>
AuthorDate: Wed, 24 Sep 2014 00:26:24 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 15:06:15 +0200

x86/intel/quark: Switch off CR4.PGE so TLB flush uses CR3 instead

Quark x1000 advertises PGE via the standard CPUID method
PGE bits exist in Quark X1000's PTEs. In order to flush
an individual PTE it is necessary to reload CR3 irrespective
of the PTE.PGE bit.

See Quark Core_DevMan_001.pdf section 6.4.11

This bug was fixed in Galileo kernels, unfixed vanilla kernels are expected to
crash and burn on this platform.

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc: Borislav Petkov <bp@alien8.de>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/1411514784-14885-1-git-send-email-pure.logic@nexus-software.ie
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/intel.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 74e804d..50ce751 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -144,6 +144,21 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 			setup_clear_cpu_cap(X86_FEATURE_ERMS);
 		}
 	}
+
+	/*
+	 * Intel Quark Core DevMan_001.pdf section 6.4.11
+	 * "The operating system also is required to invalidate (i.e., flush)
+	 *  the TLB when any changes are made to any of the page table entries.
+	 *  The operating system must reload CR3 to cause the TLB to be flushed"
+	 *
+	 * As a result cpu_has_pge() in arch/x86/include/asm/tlbflush.h should
+	 * be false so that __flush_tlb_all() causes CR3 insted of CR4.PGE
+	 * to be modified
+	 */
+	if (c->x86 == 5 && c->x86_model == 9) {
+		pr_info("Disabling PGE capability bit\n");
+		setup_clear_cpu_cap(X86_FEATURE_PGE);
+	}
 }
 
 #ifdef CONFIG_X86_32
