Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab3CSPBD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:01:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab3CSPBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:01:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] Fix breakage in MIPS siginfo handling
To: viro@ZenIV.linux.org.uk
From: David Howells <dhowells@redhat.com>
Cc: linux-mips@linux-mips.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date: Tue, 19 Mar 2013 15:00:53 +0000
Message-ID: <20130319150053.32135.61438.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MIPS's siginfo handling has been broken since this commit:

	commit 574c4866e33d648520a8bd5bf6f573ea6e554e88
	Author: Al Viro <viro@zeniv.linux.org.uk>
	Date:   Sun Nov 25 22:24:19 2012 -0500
	consolidate kernel-side struct sigaction declarations

for 64-bit BE MIPS CPUs.

The UAPI variant looks like this:

	struct sigaction {
		unsigned int	sa_flags;
		__sighandler_t	sa_handler;
		sigset_t	sa_mask;
	};

but the core kernel's variant looks like this:

	struct sigaction {
	#ifndef __ARCH_HAS_ODD_SIGACTION
		__sighandler_t	sa_handler;
		unsigned long	sa_flags;
	#else
		unsigned long	sa_flags;
		__sighandler_t	sa_handler;
	#endif
	#ifdef __ARCH_HAS_SA_RESTORER
		__sigrestore_t sa_restorer;
	#endif
		sigset_t	sa_mask;
	};

The problem is that sa_flags has been changed from an unsigned int to an
unsigned long.

Fix this by making sa_flags unsigned int if __ARCH_HAS_ODD_SIGACTION is
defined.

Whilst we're at it, rename __ARCH_HAS_ODD_SIGACTION to
__ARCH_HAS_IRIX_SIGACTION.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>
cc: Ralf Baechle <ralf@linux-mips.org>
cc: linux-mips@linux-mips.org
cc: stable@vger.kernel.org
---

 arch/mips/include/asm/signal.h |    2 +-
 include/linux/compat.h         |    4 ++--
 include/linux/signal.h         |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/mips/include/asm/signal.h b/arch/mips/include/asm/signal.h
index 197f636..8efe5a9 100644
--- a/arch/mips/include/asm/signal.h
+++ b/arch/mips/include/asm/signal.h
@@ -21,6 +21,6 @@
 #include <asm/sigcontext.h>
 #include <asm/siginfo.h>
 
-#define __ARCH_HAS_ODD_SIGACTION
+#define __ARCH_HAS_IRIX_SIGACTION
 
 #endif /* _ASM_SIGNAL_H */
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 76a87fb..377cd8c 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -141,11 +141,11 @@ typedef struct {
 } compat_sigset_t;
 
 struct compat_sigaction {
-#ifndef __ARCH_HAS_ODD_SIGACTION
+#ifndef __ARCH_HAS_IRIX_SIGACTION
 	compat_uptr_t			sa_handler;
 	compat_ulong_t			sa_flags;
 #else
-	compat_ulong_t			sa_flags;
+	compat_uint_t			sa_flags;
 	compat_uptr_t			sa_handler;
 #endif
 #ifdef __ARCH_HAS_SA_RESTORER
diff --git a/include/linux/signal.h b/include/linux/signal.h
index a2dcb94..9475c5c 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -250,11 +250,11 @@ extern int show_unhandled_signals;
 extern int sigsuspend(sigset_t *);
 
 struct sigaction {
-#ifndef __ARCH_HAS_ODD_SIGACTION
+#ifndef __ARCH_HAS_IRIX_SIGACTION
 	__sighandler_t	sa_handler;
 	unsigned long	sa_flags;
 #else
-	unsigned long	sa_flags;
+	unsigned int	sa_flags;
 	__sighandler_t	sa_handler;
 #endif
 #ifdef __ARCH_HAS_SA_RESTORER

