Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaAOLwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 06:52:24 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56510 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaAOLwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:52:21 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH] x86, CPU, AMD: Fix a shadowed variable situation
Date: Wed, 15 Jan 2014 12:52:15 +0100
Message-Id: <1389786735-16751-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Having u32 and struct cpuinfo_x86 * by the same name is not very smart,
although it was ok in this case due to the limited scope of u32 c and it
being used only once in there.

Fix this.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/amd.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 6ac3a67ad471..d3153e281d72 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -799,14 +799,10 @@ static void cpu_detect_tlb_amd(struct cpuinfo_x86 *c)
 	}
 
 	/* Handle DTLB 2M and 4M sizes, fall back to L1 if L2 is disabled */
-	if (!((eax >> 16) & mask)) {
-		u32 a, b, c, d;
-
-		cpuid(0x80000005, &a, &b, &c, &d);
-		tlb_lld_2m[ENTRIES] = (a >> 16) & 0xff;
-	} else {
+	if (!((eax >> 16) & mask))
+		tlb_lld_2m[ENTRIES] = (cpuid_eax(0x80000005) >> 16) & 0xff;
+	else
 		tlb_lld_2m[ENTRIES] = (eax >> 16) & mask;
-	}
 
 	/* a 4M entry uses two 2M entries */
 	tlb_lld_4m[ENTRIES] = tlb_lld_2m[ENTRIES] >> 1;
-- 
1.8.5.2.192.g7794a68

