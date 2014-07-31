Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbaGaROW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:14:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44432 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbaGaROT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:14:19 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, CPU, AMD: Move K8 TLB flush filter workaround to K8 code
Date: Thu, 31 Jul 2014 19:14:16 +0200
Message-Id: <1406826856-11487-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

This belongs with the rest of the code in init_amd_k8() which gets
executed on family 0xf.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/amd.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index bc360d3df60e..d978f2aa98a7 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -559,6 +559,17 @@ static void init_amd_k8(struct cpuinfo_x86 *c)
 
 	if (!c->x86_model_id[0])
 		strcpy(c->x86_model_id, "Hammer");
+
+#ifdef CONFIG_SMP
+	/*
+	 * Disable TLB flush filter by setting HWCR.FFDIS on K8
+	 * bit 6 of msr C001_0015
+	 *
+	 * Errata 63 for SH-B3 steppings
+	 * Errata 122 for all steppings (F+ have it disabled by default)
+	 */
+	msr_set_bit(MSR_K7_HWCR, 6);
+#endif
 }
 
 static void init_amd_gh(struct cpuinfo_x86 *c)
@@ -629,18 +640,6 @@ static void init_amd(struct cpuinfo_x86 *c)
 {
 	u32 dummy;
 
-#ifdef CONFIG_SMP
-	/*
-	 * Disable TLB flush filter by setting HWCR.FFDIS on K8
-	 * bit 6 of msr C001_0015
-	 *
-	 * Errata 63 for SH-B3 steppings
-	 * Errata 122 for all steppings (F+ have it disabled by default)
-	 */
-	if (c->x86 == 0xf)
-		msr_set_bit(MSR_K7_HWCR, 6);
-#endif
-
 	early_init_amd(c);
 
 	/*
-- 
2.0.0

