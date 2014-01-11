Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbaAKNGV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 08:06:21 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:63505 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaAKNF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 08:05:57 -0500
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com, roy.franz@linaro.org, msalter@redhat.com,
        linux@arm.linux.org.uk, grant.likely@secretlab.ca, patches@linaro.org,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v4 1/5] arm: break part of __soft_restart out into separate function
Date: Sat, 11 Jan 2014 13:05:20 +0000
Message-Id: <1389445524-30623-2-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain operations can be considered mandatory for any piece of code
preparing to switch off the MMU. Break this out into separate function
dmap_prepare().

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Suggested-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/include/asm/idmap.h |    1 +
 arch/arm/kernel/process.c    |   12 +-----------
 arch/arm/mm/idmap.c          |   15 +++++++++++++++
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/arm/include/asm/idmap.h b/arch/arm/include/asm/idmap.h
index bf863ed..2e914a8 100644
--- a/arch/arm/include/asm/idmap.h
+++ b/arch/arm/include/asm/idmap.h
@@ -10,5 +10,6 @@
 extern pgd_t *idmap_pgd;
 
 void setup_mm_for_reboot(void);
+void idmap_prepare(void);
 
 #endif	/* __ASM_IDMAP_H */
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 92f7b15..91b4cec 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -75,17 +75,7 @@ static void __soft_restart(void *addr)
 {
 	phys_reset_t phys_reset;
 
-	/* Take out a flat memory mapping. */
-	setup_mm_for_reboot();
-
-	/* Clean and invalidate caches */
-	flush_cache_all();
-
-	/* Turn off caching */
-	cpu_proc_fin();
-
-	/* Push out any further dirty data, and ensure cache is empty */
-	flush_cache_all();
+	idmap_prepare();
 
 	/* Switch to the identity mapping. */
 	phys_reset = (phys_reset_t)(unsigned long)virt_to_phys(cpu_reset);
diff --git a/arch/arm/mm/idmap.c b/arch/arm/mm/idmap.c
index 8e0e52e..5c85779 100644
--- a/arch/arm/mm/idmap.c
+++ b/arch/arm/mm/idmap.c
@@ -122,3 +122,18 @@ void setup_mm_for_reboot(void)
 	local_flush_tlb_all();
 #endif
 }
+
+void idmap_prepare(void)
+{
+	/* Take out a flat memory mapping. */
+	setup_mm_for_reboot();
+
+	/* Clean and invalidate caches */
+	flush_cache_all();
+
+	/* Turn off caching */
+	cpu_proc_fin();
+
+	/* Push out any further dirty data, and ensure cache is empty */
+	flush_cache_all();
+}
-- 
1.7.10.4

