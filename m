Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaJJQ0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 12:26:46 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:44303 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751622AbaJJQ0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 12:26:43 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Peter Hurley <peter@hurleysoftware.com>, Rabin Vincent <rabin@rab.in>
Subject: [PATCH] arm: Blacklist gcc 4.8.[012] and 4.9.0 with CONFIG_FRAME_POINTER
Date: Fri, 10 Oct 2014 12:26:14 -0400
Message-Id: <1412958374-16090-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc versions 4.8.[012] and 4.9.0 generates code that prematurely
adjusts the stack pointer such that still-to-be-referenced locals
are below the stack pointer, which allows them to be overwritten
by interrupts.

On 10/09/2014 04:41 PM, Rabin Vincent wrote:
>   4.8.1 and 4.8.2 are known to miscompile the ARM kernel and these
>   find_get_entry() crashes with 0xffffffff involved smell a lot like the
>   earlier reports from kernels build with those compilers:
>
>   https://lkml.org/lkml/2014/6/25/456
>   https://lkml.org/lkml/2014/6/30/375
>   https://lkml.org/lkml/2014/6/30/660
>   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58854
>   https://lkml.org/lkml/2014/5/9/330
>
> Also, I didn't see any public email making a definitive link between GCC
> PR 58854 that Nathan pointed out in https://lkml.org/lkml/2014/6/30/660
> and the earlier find_get_entry() crashes, but I just built GCC 4.8.1 and
> an ARM kernel with that, and the GCC bug is clearly seen in
> radix_tree_lookup_slot() which returns the pointer which
> find_get_entry() is dereferencing:
>
>   <radix_tree_lookup_slot>:
>    e1a0c00d  mov     ip, sp
>    e92dd800  push    {fp, ip, lr, pc}
>    e24cb004  sub     fp, ip, #4
>    e24dd008  sub     sp, sp, #8
>    e3a02000  mov     r2, #0
>    e24b3010  sub     r3, fp, #16
>    ebffffc5  bl      c0176ab8 <__radix_tree_lookup>
>    e24bd00c  sub     sp, fp, #12		<--- sp moved up
>    e3500000  cmp     r0, #0
>    151b0010  ldrne   r0, [fp, #-16]		<--- load from under sp
>    e89da800  ldm     sp, {fp, sp, pc}
>

See gcc PR 58854, https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58854

Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reported-by: Felipe Balbi <balbi@ti.com>
Cc: Rabin Vincent <rabin@rab.in>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/linux/compiler-gcc4.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 2507fd2..4069fb2 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -86,3 +86,17 @@
 #define __HAVE_BUILTIN_BSWAP16__
 #endif
 #endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP */
+
+/*
+ * For ARCH=arm, gcc versions 4.8.[012] and 4.9.0 generate code that closes
+ * the stack frame prematurely which allows still-in-use locals to be
+ * overwritten by interrupts
+ *
+ * see PR 58854, https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58854
+ */
+#ifdef __KERNEL__
+# if ((GCC_VERSION >= 40800 && GCC_VERSION <= 40802) || GCC_VERSION == 40900) \
+	&& defined(__arm__) && defined(CONFIG_FRAME_POINTER)
+#  error Your version of gcc miscompiles stack frames
+# endif
+#endif
-- 
2.1.1

