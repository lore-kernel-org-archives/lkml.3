Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaJ0TDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:03:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52763 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbaJ0TDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:03:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 042/105] x86/intel/quark: Switch off CR4.PGE so TLB flush uses CR3 instead
Date: Mon, 27 Oct 2014 11:56:17 -0700
Message-Id: <1414436240-13879-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <pure.logic@nexus-software.ie>

commit ee1b5b165c0a2f04d2107e634e51f05d0eb107de upstream.

Quark x1000 advertises PGE via the standard CPUID method
PGE bits exist in Quark X1000's PTEs. In order to flush
an individual PTE it is necessary to reload CR3 irrespective
of the PTE.PGE bit.

See Quark Core_DevMan_001.pdf section 6.4.11

This bug was fixed in Galileo kernels, unfixed vanilla kernels are expected to
crash and burn on this platform.

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1411514784-14885-1-git-send-email-pure.logic@nexus-software.ie
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/cpu/intel.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index bbe1b8b..46d612d 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -154,6 +154,21 @@ static void early_init_intel(struct cpuinfo_x86 *c)
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
-- 
1.9.1

