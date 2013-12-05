Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab3LEXch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:32:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44699 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab3LEXcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:32:32 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Kim Naru <kim.naru@amd.com>, Thomas Renninger <trenn@suse.de>
Subject: [PATCH 2/4] x86, microcode: Share native MSR accessing variants
Date: Fri,  6 Dec 2013 00:32:26 +0100
Message-Id: <1386286348-5144-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386286348-5144-1-git-send-email-bp@alien8.de>
References: <1386286348-5144-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We want to use those in AMD's early loading path too. Also, add a
native_wrmsrl variant.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/microcode.h        | 15 +++++++++++++++
 arch/x86/kernel/microcode_intel_early.c | 10 ----------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index f98bd6625318..b59827e76529 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -1,6 +1,21 @@
 #ifndef _ASM_X86_MICROCODE_H
 #define _ASM_X86_MICROCODE_H
 
+#define native_rdmsr(msr, val1, val2)			\
+do {							\
+	u64 __val = native_read_msr((msr));		\
+	(void)((val1) = (u32)__val);			\
+	(void)((val2) = (u32)(__val >> 32));		\
+} while (0)
+
+#define native_wrmsr(msr, low, high)			\
+	native_write_msr(msr, low, high)
+
+#define native_wrmsrl(msr, val)				\
+	native_write_msr((msr),				\
+			 (u32)((u64)(val)),		\
+			 (u32)((u64)(val) >> 32))
+
 struct cpu_signature {
 	unsigned int sig;
 	unsigned int pf;
diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
index 1575deb2e636..18f739129e72 100644
--- a/arch/x86/kernel/microcode_intel_early.c
+++ b/arch/x86/kernel/microcode_intel_early.c
@@ -365,16 +365,6 @@ out:
 	return state;
 }
 
-#define native_rdmsr(msr, val1, val2)		\
-do {						\
-	u64 __val = native_read_msr((msr));	\
-	(void)((val1) = (u32)__val);		\
-	(void)((val2) = (u32)(__val >> 32));	\
-} while (0)
-
-#define native_wrmsr(msr, low, high)		\
-	native_write_msr(msr, low, high);
-
 static int collect_cpu_info_early(struct ucode_cpu_info *uci)
 {
 	unsigned int val[2];
-- 
1.8.4

