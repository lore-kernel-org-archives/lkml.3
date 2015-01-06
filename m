Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbbAFHyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 02:54:00 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:52206 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbbAFHx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 02:53:58 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: Ley Foon Tan <lftan@altera.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: Switch to asm-generic/futex.h
Date: Tue,  6 Jan 2015 08:53:55 +0100
Message-Id: <1420530835-8123-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit 00f634bc522dedc8 ("asm-generic: add generic futex for
!CONFIG_SMP") asm-generic follows the m68k futex implementation.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/Kbuild  |  1 +
 arch/m68k/include/asm/futex.h | 94 -------------------------------------------
 2 files changed, 1 insertion(+), 94 deletions(-)
 delete mode 100644 arch/m68k/include/asm/futex.h

diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index 9b6c691874bd5d4f..1517ed1c64711028 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -6,6 +6,7 @@ generic-y += device.h
 generic-y += emergency-restart.h
 generic-y += errno.h
 generic-y += exec.h
+generic-y += futex.h
 generic-y += hw_irq.h
 generic-y += ioctl.h
 generic-y += ipcbuf.h
diff --git a/arch/m68k/include/asm/futex.h b/arch/m68k/include/asm/futex.h
deleted file mode 100644
index bc868af10c965269..0000000000000000
--- a/arch/m68k/include/asm/futex.h
+++ /dev/null
@@ -1,94 +0,0 @@
-#ifndef _ASM_M68K_FUTEX_H
-#define _ASM_M68K_FUTEX_H
-
-#ifdef __KERNEL__
-#if !defined(CONFIG_MMU)
-#include <asm-generic/futex.h>
-#else	/* CONFIG_MMU */
-
-#include <linux/futex.h>
-#include <linux/uaccess.h>
-#include <asm/errno.h>
-
-static inline int
-futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
-			      u32 oldval, u32 newval)
-{
-	u32 val;
-
-	if (unlikely(get_user(val, uaddr) != 0))
-		return -EFAULT;
-
-	if (val == oldval && unlikely(put_user(newval, uaddr) != 0))
-		return -EFAULT;
-
-	*uval = val;
-
-	return 0;
-}
-
-static inline int
-futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
-{
-	int op = (encoded_op >> 28) & 7;
-	int cmp = (encoded_op >> 24) & 15;
-	int oparg = (encoded_op << 8) >> 20;
-	int cmparg = (encoded_op << 20) >> 20;
-	int oldval, ret;
-	u32 tmp;
-
-	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
-		oparg = 1 << oparg;
-
-	pagefault_disable();	/* implies preempt_disable() */
-
-	ret = -EFAULT;
-	if (unlikely(get_user(oldval, uaddr) != 0))
-		goto out_pagefault_enable;
-
-	ret = 0;
-	tmp = oldval;
-
-	switch (op) {
-	case FUTEX_OP_SET:
-		tmp = oparg;
-		break;
-	case FUTEX_OP_ADD:
-		tmp += oparg;
-		break;
-	case FUTEX_OP_OR:
-		tmp |= oparg;
-		break;
-	case FUTEX_OP_ANDN:
-		tmp &= ~oparg;
-		break;
-	case FUTEX_OP_XOR:
-		tmp ^= oparg;
-		break;
-	default:
-		ret = -ENOSYS;
-	}
-
-	if (ret == 0 && unlikely(put_user(tmp, uaddr) != 0))
-		ret = -EFAULT;
-
-out_pagefault_enable:
-	pagefault_enable();	/* subsumes preempt_enable() */
-
-	if (ret == 0) {
-		switch (cmp) {
-		case FUTEX_OP_CMP_EQ: ret = (oldval == cmparg); break;
-		case FUTEX_OP_CMP_NE: ret = (oldval != cmparg); break;
-		case FUTEX_OP_CMP_LT: ret = (oldval < cmparg); break;
-		case FUTEX_OP_CMP_GE: ret = (oldval >= cmparg); break;
-		case FUTEX_OP_CMP_LE: ret = (oldval <= cmparg); break;
-		case FUTEX_OP_CMP_GT: ret = (oldval > cmparg); break;
-		default: ret = -ENOSYS;
-		}
-	}
-	return ret;
-}
-
-#endif /* CONFIG_MMU */
-#endif /* __KERNEL__ */
-#endif /* _ASM_M68K_FUTEX_H */
-- 
1.9.1

