Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab3I0IKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:10:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57400 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab3I0IKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:10:24 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Rob Landley <rob@landley.net>,
        Jiang Liu <jiang.liu@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Jiang Liu <liuj97@gmail.com>
Subject: [RFT PATCH v1 4/7] arm64: provide boot option "eagerfpu" to control FPSIMD restore policy
Date: Fri, 27 Sep 2013 16:04:44 +0800
Message-Id: <1380269087-8520-5-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380269087-8520-1-git-send-email-liuj97@gmail.com>
References: <1380269087-8520-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Provide tristate kernel boot option "eagerfpu" to control FPSIMD state
save and restore policy. It adopts the same scematics as x86.

The lazy FPSIMD restore policy needs to configured before any thread
makes use of FPSIMD registers, so change fpsimd_init() as arch_initcall.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
---
 Documentation/kernel-parameters.txt |  5 +++--
 arch/arm64/kernel/fpsimd.c          | 19 ++++++++++++++++++-
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 539a236..236e342 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2020,11 +2020,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			and restore using xsave. The kernel will fallback to
 			enabling legacy floating-point and sse state.
 
-	eagerfpu=	[X86]
+	eagerfpu=	[X86,ARM64]
 			on	enable eager fpu restore
 			off	disable eager fpu restore
 			auto	selects the default scheme, which automatically
-				enables eagerfpu restore for xsaveopt.
+				enables eagerfpu restore for xsaveopt on x86
+				and disables eager fpu restore on ARM64.
 
 	nohlt		[BUGS=ARM,SH] Tells the kernel that the sleep(SH) or
 			wfi(ARM) instruction doesn't work correctly and not to
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 2208ba3..c14f5e9 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -256,6 +256,20 @@ EXPORT_SYMBOL(kernel_neon_end);
 
 #endif /* CONFIG_KERNEL_MODE_NEON */
 
+static enum { AUTO, ENABLE, DISABLE } eagerfpu = AUTO;
+
+static int __init eager_fpu_setup(char *s)
+{
+	if (!strcmp(s, "on"))
+		eagerfpu = ENABLE;
+	else if (!strcmp(s, "off"))
+		eagerfpu = DISABLE;
+	else if (!strcmp(s, "auto"))
+		eagerfpu = AUTO;
+	return 1;
+}
+__setup("eagerfpu=", eager_fpu_setup);
+
 /*
  * FP/SIMD support code initialisation.
  */
@@ -274,6 +288,9 @@ static int __init fpsimd_init(void)
 	else
 		elf_hwcap |= HWCAP_ASIMD;
 
+	if (eagerfpu == DISABLE || eagerfpu == AUTO)
+		static_key_slow_inc(&fpsimd_lazy_mode);
+
 	return 0;
 }
-late_initcall(fpsimd_init);
+arch_initcall(fpsimd_init);
-- 
1.8.1.2

