Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaBNEbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:31:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48153 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaBNEbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:31:05 -0500
Date: Thu, 13 Feb 2014 20:30:47 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-ef1b893c29d0dba778f67ad97b554b37f9108dcc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hubicka@ucw.cz, hpa@zytor.com,
        mingo@kernel.org, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, hubicka@ucw.cz,
        linux-kernel@vger.kernel.org, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1391846481-31491-4-git-send-email-ak@linux.intel.com>
References: <1391846481-31491-4-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] lto, workaround:
  Add workaround for initcall reordering
Git-Commit-ID: ef1b893c29d0dba778f67ad97b554b37f9108dcc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 20:30:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef1b893c29d0dba778f67ad97b554b37f9108dcc
Gitweb:     http://git.kernel.org/tip/ef1b893c29d0dba778f67ad97b554b37f9108dcc
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 09:01:08 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 20:24:13 -0800

lto, workaround: Add workaround for initcall reordering

Work around a LTO gcc problem: when there is no reference to a variable
in a module it will be moved to the end of the program. This causes
reordering of initcalls which the kernel does not like.
Add a dummy reference function to avoid this. The function is
deleted by the linker.

This replaces a previous much slower workaround.

Thanks to Jan "Honza" Hubička for suggesting this technique.

Suggested-by: Jan Hubička <hubicka@ucw.cz>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391846481-31491-4-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/linux/init.h | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index e168880..a3ba270 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -163,6 +163,23 @@ extern bool initcall_debug;
 
 #ifndef __ASSEMBLY__
 
+#ifdef CONFIG_LTO
+/* Work around a LTO gcc problem: when there is no reference to a variable
+ * in a module it will be moved to the end of the program. This causes
+ * reordering of initcalls which the kernel does not like.
+ * Add a dummy reference function to avoid this. The function is
+ * deleted by the linker.
+ */
+#define LTO_REFERENCE_INITCALL(x) \
+	; /* yes this is needed */			\
+	static __used __exit void *reference_##x(void)	\
+	{						\
+		return &x;				\
+	}
+#else
+#define LTO_REFERENCE_INITCALL(x)
+#endif
+
 /* initcalls are now grouped by functionality into separate 
  * subsections. Ordering inside the subsections is determined
  * by link order. 
@@ -175,7 +192,8 @@ extern bool initcall_debug;
 
 #define __define_initcall(fn, id) \
 	static initcall_t __initcall_##fn##id __used \
-	__attribute__((__section__(".initcall" #id ".init"))) = fn
+	__attribute__((__section__(".initcall" #id ".init"))) = fn; \
+	LTO_REFERENCE_INITCALL(__initcall_##fn##id)
 
 /*
  * Early initcalls run before initializing SMP.
