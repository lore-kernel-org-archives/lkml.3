Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966163AbaLLGsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:48:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52598 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966121AbaLLGsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:48:41 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
        "Borislav Petkov" <bp@alien8.de>, "Ingo Molnar" <mingo@kernel.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.564039178@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 029/164] x86/intel/quark: Switch off CR4.PGE so TLB
 flush uses CR3 instead
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/intel.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -143,6 +143,21 @@ static void __cpuinit early_init_intel(s
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

