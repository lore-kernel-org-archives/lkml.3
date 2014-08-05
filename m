Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaHEBdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:33:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42802 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbaHEBdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:33:25 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lina Iyer <lina.iyer@linaro.org>
Subject: [PATCH 4/8] msm: scm: Add atomic SCM APIs
Date: Mon,  4 Aug 2014 18:31:46 -0700
Message-Id: <1407202310-3359-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org>
References: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atomic SCM APIs are useful for commands that are guaranteed
by the secure side to be uninterruptable, atomic and SMP safe.
The calling convention use registers for passing parameters and
return values between the secure and non-secure side. Support
this interface with  scm_call_atomic[1-2]() functions
corresponding to the number of arguments passed.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-qcom/scm.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-qcom/scm.h |  5 +++-
 2 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-qcom/scm.c b/arch/arm/mach-qcom/scm.c
index ec37b037e69c..a05cad3fa1c5 100644
--- a/arch/arm/mach-qcom/scm.c
+++ b/arch/arm/mach-qcom/scm.c
@@ -286,6 +286,79 @@ out:
 }
 EXPORT_SYMBOL(scm_call);
 
+#define SCM_CLASS_REGISTER	(0x2 << 8)
+#define SCM_MASK_IRQS		BIT(5)
+#define SCM_ATOMIC(svc, cmd, n) (((((svc) << 10)|((cmd) & 0x3ff)) << 12) | \
+				SCM_CLASS_REGISTER | \
+				SCM_MASK_IRQS | \
+				(n & 0xf))
+
+/**
+ * scm_call_atomic1() - Send an atomic SCM command with one argument
+ * @svc_id: service identifier
+ * @cmd_id: command identifier
+ * @arg1: first argument
+ *
+ * This shall only be used with commands that are guaranteed to be
+ * uninterruptable, atomic and SMP safe.
+ */
+s32 scm_call_atomic1(u32 svc, u32 cmd, u32 arg1)
+{
+	int context_id;
+	register u32 r0 asm("r0") = SCM_ATOMIC(svc, cmd, 1);
+	register u32 r1 asm("r1") = (u32)&context_id;
+	register u32 r2 asm("r2") = arg1;
+
+	asm volatile(
+		__asmeq("%0", "r0")
+		__asmeq("%1", "r0")
+		__asmeq("%2", "r1")
+		__asmeq("%3", "r2")
+#ifdef REQUIRES_SEC
+			".arch_extension sec\n"
+#endif
+		"smc	#0	@ switch to secure world\n"
+		: "=r" (r0)
+		: "r" (r0), "r" (r1), "r" (r2)
+		: "r3");
+	return r0;
+}
+EXPORT_SYMBOL(scm_call_atomic1);
+
+/**
+ * scm_call_atomic2() - Send an atomic SCM command with two arguments
+ * @svc_id: service identifier
+ * @cmd_id: command identifier
+ * @arg1: first argument
+ * @arg2: second argument
+ *
+ * This shall only be used with commands that are guaranteed to be
+ * uninterruptable, atomic and SMP safe.
+ */
+s32 scm_call_atomic2(u32 svc, u32 cmd, u32 arg1, u32 arg2)
+{
+	int context_id;
+	register u32 r0 asm("r0") = SCM_ATOMIC(svc, cmd, 2);
+	register u32 r1 asm("r1") = (u32)&context_id;
+	register u32 r2 asm("r2") = arg1;
+	register u32 r3 asm("r3") = arg2;
+
+	asm volatile(
+		__asmeq("%0", "r0")
+		__asmeq("%1", "r0")
+		__asmeq("%2", "r1")
+		__asmeq("%3", "r2")
+		__asmeq("%4", "r3")
+#ifdef REQUIRES_SEC
+			".arch_extension sec\n"
+#endif
+		"smc	#0	@ switch to secure world\n"
+		: "=r" (r0)
+		: "r" (r0), "r" (r1), "r" (r2), "r" (r3));
+	return r0;
+}
+EXPORT_SYMBOL(scm_call_atomic2);
+
 u32 scm_get_version(void)
 {
 	int context_id;
diff --git a/arch/arm/mach-qcom/scm.h b/arch/arm/mach-qcom/scm.h
index 00b31ea58f29..1f0f0180e767 100644
--- a/arch/arm/mach-qcom/scm.h
+++ b/arch/arm/mach-qcom/scm.h
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010-2014, The Linux Foundation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
@@ -18,6 +18,9 @@
 extern int scm_call(u32 svc_id, u32 cmd_id, const void *cmd_buf, size_t cmd_len,
 		void *resp_buf, size_t resp_len);
 
+extern s32 scm_call_atomic1(u32 svc, u32 cmd, u32 arg1);
+extern s32 scm_call_atomic2(u32 svc, u32 cmd, u32 arg1, u32 arg2);
+
 #define SCM_VERSION(major, minor) (((major) << 16) | ((minor) & 0xFF))
 
 extern u32 scm_get_version(void);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

