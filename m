Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaBDKO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 05:14:57 -0500
Received: from www84.your-server.de ([213.133.104.84]:38156 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaBDKOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 05:14:42 -0500
From: stefani@seibold.net
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH v11 7/9] introduce VVAR marco for vdso32
Date: Tue,  4 Feb 2014 11:15:06 +0100
Message-Id: <1391508908-32239-8-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391508908-32239-1-git-send-email-stefani@seibold.net>
References: <1391508908-32239-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This patch revamp the vvar.h for introduce the VVAR macro for vdso32.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/include/asm/vvar.h | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/vvar.h b/arch/x86/include/asm/vvar.h
index 7cd69af..bf13dc5 100644
--- a/arch/x86/include/asm/vvar.h
+++ b/arch/x86/include/asm/vvar.h
@@ -16,15 +16,6 @@
  * you mess up, the linker will catch it.)
  */
 
-/* Base address of vvars.  This is not ABI. */
-#ifdef CONFIG_X86_64
-#define VVAR_ADDRESS (-10*1024*1024 - 4096)
-#else
-extern char __vvar_page;
-
-#define VVAR_ADDRESS (&__vvar_page)
-#endif
-
 #if defined(__VVAR_KERNEL_LDS)
 
 /* The kernel linker script defines its own magic to put vvars in the
@@ -35,16 +26,35 @@ extern char __vvar_page;
 
 #else
 
+#ifdef BUILD_VDSO32
+
+#define DECLARE_VVAR(offset, type, name)				\
+	extern type vvar_ ## name __attribute__((visibility("hidden")));
+
+#define VVAR(name) (vvar_ ## name)
+
+#else
+
+/* Base address of vvars.  This is not ABI. */
+#ifdef CONFIG_X86_64
+#define VVAR_ADDRESS (-10*1024*1024 - 4096)
+#else
+extern char __vvar_page;
+
+#define VVAR_ADDRESS (&__vvar_page)
+#endif
+
 #define DECLARE_VVAR(offset, type, name)				\
 	static type const * const vvaraddr_ ## name =			\
 		(void *)(VVAR_ADDRESS + (offset));
 
+#define VVAR(name) (*vvaraddr_ ## name)
+#endif
+
 #define DEFINE_VVAR(type, name)						\
 	type name							\
 	__attribute__((section(".vvar_" #name), aligned(16))) __visible
 
-#define VVAR(name) (*vvaraddr_ ## name)
-
 #endif
 
 /* DECLARE_VVAR(offset, type, name) */
-- 
1.8.5.3

