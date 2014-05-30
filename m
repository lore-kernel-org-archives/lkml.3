Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964777AbaE3PNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:13:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44180 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452AbaE3PNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:13:14 -0400
Date: Fri, 30 May 2014 08:13:02 -0700
From: tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-adb9d526e98268b647a74726346e1c40e6a37d2e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1401387164-43416-13-git-send-email-fenghua.yu@intel.com>
References: <1401387164-43416-13-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86/xsaves:
  Add xsaves and xrstors support for booting time
Git-Commit-ID: adb9d526e98268b647a74726346e1c40e6a37d2e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  adb9d526e98268b647a74726346e1c40e6a37d2e
Gitweb:     http://git.kernel.org/tip/adb9d526e98268b647a74726346e1c40e6a37d2e
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 29 May 2014 11:12:40 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 May 2014 14:33:02 -0700

x86/xsaves: Add xsaves and xrstors support for booting time

Since boot_cpu_data and cpu capabilities are not enabled yet during early
booting time, alternative can not be used in some functions to access xsave
area. Therefore, we define two new functions xrstor_state_booting() and
xsave_state_booting() to access xsave area just during early booting time.

xrstor_state_booting restores xstate from xsave area during early booting time.
xsave_state_booting saves xstate to xsave area during early booting time.

The two functions are similar to xrstor_state and xsave_state respectively.
But the two functions don't use alternatives because alternatives are not
enabled when they are called in such early booting time.

xrstor_state_booting is called only by functions defined as __init. So it's
defined as __init and will be removed from memory after booting time. There
is no extra memory cost caused by this function during running time.

But because xsave_state_booting can be called by run-time function __save_fpu(),
it's not defined as __init and will stay in memory during running time although
it will not be called anymore during running time. It is not ideal to
have this function stay in memory during running time. But it's a pretty small
function and the memory cost will be small. By doing in this way, we can
avoid to change a lot of code to just remove this small function and save a
bit memory for running time.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1401387164-43416-13-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/xsave.h | 60 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 0d15231..aa3ff0c 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -66,6 +66,66 @@ extern int init_fpu(struct task_struct *child);
 			: [err] "=r" (err)
 
 /*
+ * This function is called only during boot time when x86 caps are not set
+ * up and alternative can not be used yet.
+ */
+static int xsave_state_booting(struct xsave_struct *fx, u64 mask)
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
 static inline int xsave_state(struct xsave_struct *fx, u64 mask)
