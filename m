Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaIZEbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 00:31:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:2796 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187AbaIZEbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 00:31:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,603,1406617200"; 
   d="scan'208";a="605641324"
From: Ong Boon Leong <boon.leong.ong@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH] x86, setup: add __flush_tlb() for Intel Quark X1000
Date: Fri, 26 Sep 2014 12:30:27 +0800
Message-Id: <1411705827-2522-2-git-send-email-boon.leong.ong@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411705827-2522-1-git-send-email-boon.leong.ong@intel.com>
References: <1411705827-2522-1-git-send-email-boon.leong.ong@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel Quark X1000 advertises PGE (bit 13 of EDX) in CPUID.
In reality, it does not implement PGE in current silicon.

This is an issue because __flush_tlb_all() depends on cpu_has_pge
which has following dependency:
 - cpu_has_pge --> boot_cpu_data --> new_cpu_data obtained from CPUID
   in head_32.S.

On another note in reference to the below commit:

  x86/intel/quark: Switch off CR4.PGE so TLB flush uses CR3 instead

The value of cpu_has_pge is updated to correctly reflect the
capability for Quark later within early_init_intel() through
setup_clear_cpu_cap(X86_FEATURE_PGE). So, future reference to
__flush_tlb_all() is mapped to __flush_tlb().

As this is early stage of kernel boot-up and  adding
__flush_tlb() is not going to hurt much in CPU cycles, we add it
here and together with the explanation for future reference.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 arch/x86/kernel/setup.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 41ead8d..90e0b85 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -880,6 +880,13 @@ void __init setup_arch(char **cmdline_p)
 
 	load_cr3(swapper_pg_dir);
 	__flush_tlb_all();
+	/*
+	 * Quark X1000 wrongly advertises PGE, add __flush_tlb()
+	 * below to make sure TLB is flushed correctly in the early stage
+	 * of setup_arch() for Quark X1000.
+	 * X86_FEATURE_PGE flag is only setup later stage at early_cpu_init();
+	 */
+	__flush_tlb();
 #else
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
-- 
1.7.9.5

