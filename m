Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582AbbA1EPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:15:41 -0500
Received: from mail.kernel.org ([198.145.29.136]:37418 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760830AbbA1EPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:15:31 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 024/177] x86/intel/quark: Switch off CR4.PGE so TLB flush uses CR3 instead
Date: Wed, 28 Jan 2015 12:06:55 +0800
Message-Id: <1422418236-12852-48-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bryan O'Donoghue <pure.logic@nexus-software.ie>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/x86/kernel/cpu/intel.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 3e6ff6c..e7a64dd 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -143,6 +143,21 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
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

