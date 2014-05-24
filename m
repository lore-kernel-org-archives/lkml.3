Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaEXHEO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:04:14 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:38626 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaEXHCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:02:25 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 06/24] Allow for some signal structures to be the same between a 32bit ABI and the 64bit ABI.
Date: Sat, 24 May 2014 00:02:01 -0700
Message-Id: <1400914939-9708-7-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400914939-9708-1-git-send-email-apinski@cavium.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
To: linux-arch@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ARM64, we want to allow the signal related structures to be same between the 32bit (ILP32) and the 64bit ABIs (LP64).  We still want to use the generic include files so we need some new defines that are used in UAPI; they default to the same as it is before.

Thanks,
Andrew Pinski

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 include/uapi/asm-generic/siginfo.h |   17 +++++++++++++----
 include/uapi/asm-generic/signal.h  |   27 +++++++++++++++++++++++----
 2 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
index ba5be7f..553aca9 100644
--- a/include/uapi/asm-generic/siginfo.h
+++ b/include/uapi/asm-generic/siginfo.h
@@ -4,9 +4,17 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 
+#ifndef __SIGINFO_VOIDPOINTER
+#define __SIGINFO_VOIDPOINTER(field) void __user *field
+#endif
+
+#ifndef __SIGINFO_BAND
+#define __SIGINFO_BAND(field) __ARCH_SI_BAND_T field
+#endif
+
 typedef union sigval {
 	int sival_int;
-	void __user *sival_ptr;
+	__SIGINFO_VOIDPOINTER(sival_ptr);
 } sigval_t;
 
 /*
@@ -86,7 +94,7 @@ typedef struct siginfo {
 
 		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
 		struct {
-			void __user *_addr; /* faulting insn/memory ref. */
+			__SIGINFO_VOIDPOINTER(_addr); /* faulting insn/memory ref. */
 #ifdef __ARCH_SI_TRAPNO
 			int _trapno;	/* TRAP # which caused the signal */
 #endif
@@ -95,13 +103,13 @@ typedef struct siginfo {
 
 		/* SIGPOLL */
 		struct {
-			__ARCH_SI_BAND_T _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
+			__SIGINFO_BAND(_band);	/* POLL_IN, POLL_OUT, POLL_MSG */
 			int _fd;
 		} _sigpoll;
 
 		/* SIGSYS */
 		struct {
-			void __user *_call_addr; /* calling user insn */
+			__SIGINFO_VOIDPOINTER(_call_addr); /* calling user insn */
 			int _syscall;	/* triggering system call number */
 			unsigned int _arch;	/* AUDIT_ARCH_* of syscall */
 		} _sigsys;
@@ -283,6 +291,7 @@ typedef struct sigevent {
 		int _pad[SIGEV_PAD_SIZE];
 		 int _tid;
 
+		/* Note these two are handled only in userspace */
 		struct {
 			void (*_function)(sigval_t);
 			void *_attribute;	/* really pthread_attr_t */
diff --git a/include/uapi/asm-generic/signal.h b/include/uapi/asm-generic/signal.h
index 9df61f1..c4ce238 100644
--- a/include/uapi/asm-generic/signal.h
+++ b/include/uapi/asm-generic/signal.h
@@ -4,7 +4,9 @@
 #include <linux/types.h>
 
 #define _NSIG		64
+#ifndef _NSIG_BPW
 #define _NSIG_BPW	__BITS_PER_LONG
+#endif
 #define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
 
 #define SIGHUP		 1
@@ -83,9 +85,13 @@
 #define MINSIGSTKSZ	2048
 #define SIGSTKSZ	8192
 
+#ifndef __SIGSET_INNER_TYPE
+#define __SIGSET_INNER_TYPE unsigned long
+#endif
+
 #ifndef __ASSEMBLY__
 typedef struct {
-	unsigned long sig[_NSIG_WORDS];
+	__SIGSET_INNER_TYPE sig[_NSIG_WORDS];
 } sigset_t;
 
 /* not actually used, but required for linux/syscalls.h */
@@ -98,11 +104,24 @@ typedef unsigned long old_sigset_t;
 #endif
 
 #ifndef __KERNEL__
+
+#ifndef __SIGACTION_HANDLER
+#define __SIGACTION_HANDLER(field)	__sighandler_t field
+#endif
+
+#ifndef __SIGACTION_FLAGS
+#define __SIGACTION_FLAGS(field)	unsigned long field
+#endif
+
+#ifndef __SIGACTION_RESTORER
+#define __SIGACTION_RESTORER(field)	__sigrestore_t field
+#endif
+
 struct sigaction {
-	__sighandler_t sa_handler;
-	unsigned long sa_flags;
+	__SIGACTION_HANDLER(sa_handler);
+	__SIGACTION_FLAGS(sa_flags);
 #ifdef SA_RESTORER
-	__sigrestore_t sa_restorer;
+	__SIGACTION_RESTORER(sa_restorer);
 #endif
 	sigset_t sa_mask;		/* mask last for extensibility */
 };
-- 
1.7.2.5

