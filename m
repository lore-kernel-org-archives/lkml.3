Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbaL3Awq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 19:52:46 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:49444 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaL3Awo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 19:52:44 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3.19 3/3] x86, mpx: Change the MPX enable/disable API to arch_prctl
Date: Mon, 29 Dec 2014 16:52:27 -0800
Message-Id: <d5efe02b133f6d9fb4cb9d03e0f0b9e17211c06f.1419900414.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1419900414.git.luto@amacapital.net>
References: <cover.1419900414.git.luto@amacapital.net>
In-Reply-To: <cover.1419900414.git.luto@amacapital.net>
References: <cover.1419900414.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling and disabling kernel assistance for MPX is as arch-specific
as it gets.  Update the API to use arch_prctl.

This has the benefit the it avoids cluttering prctl with more
arch-specific functionality.  The down side is that arch_prctl will
need to be wired up as a 32-bit syscall to add 32-bit support for
MPX.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/uapi/asm/prctl.h | 15 +++++++++++----
 arch/x86/kernel/process_64.c      | 10 ++++++++++
 include/uapi/linux/prctl.h        |  6 ------
 kernel/sys.c                      | 12 ------------
 4 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/uapi/asm/prctl.h b/arch/x86/include/uapi/asm/prctl.h
index 3ac5032fae09..a39aef96a922 100644
--- a/arch/x86/include/uapi/asm/prctl.h
+++ b/arch/x86/include/uapi/asm/prctl.h
@@ -1,9 +1,16 @@
 #ifndef _ASM_X86_PRCTL_H
 #define _ASM_X86_PRCTL_H
 
-#define ARCH_SET_GS 0x1001
-#define ARCH_SET_FS 0x1002
-#define ARCH_GET_FS 0x1003
-#define ARCH_GET_GS 0x1004
+#define ARCH_SET_GS		0x1001
+#define ARCH_SET_FS		0x1002
+#define ARCH_GET_FS		0x1003
+#define ARCH_GET_GS		0x1004
+
+/*
+ * Tell the kernel to start/stop helping userspace manage bounds tables.
+ * For both of these functions, addr must be zero.
+ */
+#define ARCH_ENABLE_MPX		0x1005
+#define ARCH_DISABLE_MPX	0x1006
 
 #endif /* _ASM_X86_PRCTL_H */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 5a2c02913af3..d11355668e58 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -586,6 +586,16 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
 		ret = put_user(base, (unsigned long __user *)addr);
 		break;
 	}
+	case ARCH_ENABLE_MPX: {
+		if (addr != 0)
+			return -EINVAL;
+		ret = mpx_enable_management(task);
+	}
+	case ARCH_DISABLE_MPX: {
+		if (addr != 0)
+			return -EINVAL;
+		ret = mpx_disable_management(task);
+	}
 
 	default:
 		ret = -EINVAL;
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 89f63503f903..513df75d0fc9 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -179,10 +179,4 @@ struct prctl_mm_map {
 #define PR_SET_THP_DISABLE	41
 #define PR_GET_THP_DISABLE	42
 
-/*
- * Tell the kernel to start/stop helping userspace manage bounds tables.
- */
-#define PR_MPX_ENABLE_MANAGEMENT  43
-#define PR_MPX_DISABLE_MANAGEMENT 44
-
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index a8c9f5a7dda6..1eaa2f0b0246 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -91,12 +91,6 @@
 #ifndef SET_TSC_CTL
 # define SET_TSC_CTL(a)		(-EINVAL)
 #endif
-#ifndef MPX_ENABLE_MANAGEMENT
-# define MPX_ENABLE_MANAGEMENT(a)	(-EINVAL)
-#endif
-#ifndef MPX_DISABLE_MANAGEMENT
-# define MPX_DISABLE_MANAGEMENT(a)	(-EINVAL)
-#endif
 
 /*
  * this is where the system-wide overflow UID and GID are defined, for
@@ -2209,12 +2203,6 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			me->mm->def_flags &= ~VM_NOHUGEPAGE;
 		up_write(&me->mm->mmap_sem);
 		break;
-	case PR_MPX_ENABLE_MANAGEMENT:
-		error = MPX_ENABLE_MANAGEMENT(me);
-		break;
-	case PR_MPX_DISABLE_MANAGEMENT:
-		error = MPX_DISABLE_MANAGEMENT(me);
-		break;
 	default:
 		error = -EINVAL;
 		break;
-- 
2.1.0

