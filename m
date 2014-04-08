Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbaDHNJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:09:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756778AbaDHNJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:09:42 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-X86 <x86@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Noonan <steven@uplinklabs.net>, Rik van Riel <riel@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] x86: Allow Xen to enable NUMA_BALANCING
Date: Tue,  8 Apr 2014 14:09:30 +0100
Message-Id: <1396962570-18762-6-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1396962570-18762-1-git-send-email-mgorman@suse.de>
References: <1396962570-18762-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen cannot use automatic NUMA balancing as they are depending on the same PTE
bit. There is another software bit that is currently used by software dirty
tracking of pages. This patch allows Xen to use that bit for automatic NUMA
balancing if MEM_SOFT_DIRTY is not enabled. If KMEMCHECK is enabled then
the bit is only set on global page tables so there should be no collision
with NUMA_BALANCING. This shuffling can be disabled if/when Xen moves away
from using _PAGE_BIT_IOMAP.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 arch/x86/Kconfig                     |  2 +-
 arch/x86/include/asm/pgtable_types.h | 14 +++++++++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 4fab25a..3c4ba81 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -26,7 +26,7 @@ config X86
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select HAVE_AOUT if X86_32
 	select HAVE_UNSTABLE_SCHED_CLOCK
-	select ARCH_SUPPORTS_NUMA_BALANCING if X86_64 && !XEN
+	select ARCH_SUPPORTS_NUMA_BALANCING if X86_64 && (!XEN || !MEM_SOFT_DIRTY)
 	select ARCH_SUPPORTS_INT128 if X86_64
 	select ARCH_WANTS_PROT_NUMA_PROT_NONE
 	select HAVE_IDE
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 49b3e15..fa84d1f 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -24,11 +24,23 @@
 #define _PAGE_BIT_CPA_TEST	_PAGE_BIT_SOFTW1
 #define _PAGE_BIT_SPLITTING	_PAGE_BIT_SOFTW1 /* only valid on a PSE pmd */
 #define _PAGE_BIT_IOMAP		_PAGE_BIT_SOFTW2 /* flag used to indicate IO mapping */
-#define _PAGE_BIT_NUMA		_PAGE_BIT_SOFTW2 /* for NUMA balancing hinting */
 #define _PAGE_BIT_HIDDEN	_PAGE_BIT_SOFTW3 /* hidden by kmemcheck */
 #define _PAGE_BIT_SOFT_DIRTY	_PAGE_BIT_SOFTW3 /* software dirty tracking */
 #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
 
+/*
+ * Automatic NUMA balancing uses _PAGE_BIT_SOFTW2 if available as generally it
+ * is only used on the kernel page tables and is easily shared. Unfortunately,
+ * Xen also uses this bit so on those configurations it is necessary to use
+ * _PAGE_BIT_SOFTW3 but then MEM_SOFT_DIRTY cannot be enabled at the same time
+ * as it also requires that bit. Constraint is enforced by Kconfig.
+ */
+#ifndef CONFIG_XEN
+#define _PAGE_BIT_NUMA		_PAGE_BIT_SOFTW2
+#else
+#define _PAGE_BIT_NUMA		_PAGE_BIT_SOFTW3
+#endif
+
 /* If _PAGE_BIT_PRESENT is clear, we use these: */
 /* - if the user mapped it with PROT_NONE; pte_present gives true */
 #define _PAGE_BIT_PROTNONE	_PAGE_BIT_GLOBAL
-- 
1.8.4.5

