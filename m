Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaEZQ65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:58:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:20367 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbaEZQ56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:57:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,914,1392192000"; 
   d="scan'208";a="545122344"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 11/15] x86/xsaves: Add xsaves and xrstors support for booting time
Date: Mon, 26 May 2014 10:01:18 -0700
Message-Id: <1401123682-5384-12-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
References: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Since cpu caps are not enabled yet during early booting time, alternative
can not be used in functions to access xsave area. Therefore, we define
two new functions xrstor_state_booting and xsave_state_booting to access
xsave area during early booting time.

Because xsave_state_booting() can be called by run-time function __save_fpu(),
it's not defined as __init and will stay in memory during running time. But
it's a small function and the memory cost is small.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/xsave.h | 60 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index a8f31d0..0de695d 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -66,6 +66,66 @@ extern int init_fpu(struct task_struct *child);
 			: [err] "=r" (err)
 
 /*
+ * This function is called only during boot time when x86 caps are not set
+ * up and alternative can not be used yet.
+ */
+static void xsave_state_booting(struct xsave_struct *fx, u64 mask)
+{
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+	int err = 0;
+
+	WARN_ON(system_state != SYSTEM_BOOTING);
+
+	if (boot_cpu_has(X86_FEATURE_XSAVES))
+		asm volatile("1:"XSAVES"\n\t"
+			"2:\n\t"
+			: : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+			:   "memory");
+	else
+		asm volatile("1:"XSAVE"\n\t"
+			"2:\n\t"
+			: : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+			:   "memory");
+
+	asm volatile(xstate_fault
+		     : "0" (0)
+		     : "memory");
+
+	return err;
+}
+
+/*
+ * This function is called only during boot time when x86 caps are not set
+ * up and alternative can not be used yet.
+ */
+static inline int xrstor_state_booting(struct xsave_struct *fx, u64 mask)
+{
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+	int err = 0;
+
+	WARN_ON(system_state != SYSTEM_BOOTING);
+
+	if (boot_cpu_has(X86_FEATURE_XSAVES))
+		asm volatile("1:"XRSTORS"\n\t"
+			"2:\n\t"
+			: : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+			:   "memory");
+	else
+		asm volatile("1:"XRSTOR"\n\t"
+			"2:\n\t"
+			: : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+			:   "memory");
+
+	asm volatile(xstate_fault
+		     : "0" (0)
+		     : "memory");
+
+	return err;
+}
+
+/*
  * Save processor xstate to xsave area.
  */
 static inline void xsave_state(struct xsave_struct *fx, u64 mask)
-- 
1.8.1.2

