Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab3FGXDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:03:51 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:59627 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab3FGXDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:46 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 01/31] MIPS: Move allocate_kscratch to cpu-probe.c and make it public.
Date: Fri,  7 Jun 2013 16:03:05 -0700
Message-Id: <1370646215-6543-2-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney@caviumnetworks.com>

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 arch/mips/include/asm/mipsregs.h |  2 ++
 arch/mips/kernel/cpu-probe.c     | 29 +++++++++++++++++++++++++++++
 arch/mips/mm/tlbex.c             | 20 +-------------------
 3 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/arch/mips/include/asm/mipsregs.h b/arch/mips/include/asm/mipsregs.h
index 87e6207..6e0da5aa 100644
--- a/arch/mips/include/asm/mipsregs.h
+++ b/arch/mips/include/asm/mipsregs.h
@@ -1806,6 +1806,8 @@ __BUILD_SET_C0(brcm_cmt_ctrl)
 __BUILD_SET_C0(brcm_config)
 __BUILD_SET_C0(brcm_mode)
 
+int allocate_kscratch(void);
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_MIPSREGS_H */
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index c6568bf..ee1014e 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1064,3 +1064,32 @@ __cpuinit void cpu_report(void)
 	if (c->options & MIPS_CPU_FPU)
 		printk(KERN_INFO "FPU revision is: %08x\n", c->fpu_id);
 }
+
+static DEFINE_SPINLOCK(kscratch_used_lock);
+
+static unsigned int kscratch_used_mask;
+
+int allocate_kscratch(void)
+{
+	int r;
+	unsigned int a;
+
+	spin_lock(&kscratch_used_lock);
+
+	a = cpu_data[0].kscratch_mask & ~kscratch_used_mask;
+
+	r = ffs(a);
+
+	if (r == 0) {
+		r = -1;
+		goto out;
+	}
+
+	r--; /* make it zero based */
+
+	kscratch_used_mask |= (1 << r);
+out:
+	spin_unlock(&kscratch_used_lock);
+
+	return r;
+}
diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index ce9818e..001b87c 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -30,6 +30,7 @@
 #include <linux/cache.h>
 
 #include <asm/cacheflush.h>
+#include <asm/mipsregs.h>
 #include <asm/pgtable.h>
 #include <asm/war.h>
 #include <asm/uasm.h>
@@ -307,25 +308,6 @@ static int check_for_high_segbits __cpuinitdata;
 
 static int check_for_high_segbits __cpuinitdata;
 
-static unsigned int kscratch_used_mask __cpuinitdata;
-
-static int __cpuinit allocate_kscratch(void)
-{
-	int r;
-	unsigned int a = cpu_data[0].kscratch_mask & ~kscratch_used_mask;
-
-	r = ffs(a);
-
-	if (r == 0)
-		return -1;
-
-	r--; /* make it zero based */
-
-	kscratch_used_mask |= (1 << r);
-
-	return r;
-}
-
 static int scratch_reg __cpuinitdata;
 static int pgd_reg __cpuinitdata;
 enum vmalloc64_mode {not_refill, refill_scratch, refill_noscratch};
-- 
1.7.11.7

