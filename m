Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaFDXdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:33:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbaFDXYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:24:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org, linux-metag@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>
Subject: [PATCH 3.10 082/103] metag: Reduce maximum stack size to 256MB
Date: Wed,  4 Jun 2014 16:25:45 -0700
Message-Id: <20140604232549.490369214@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232546.704156131@linuxfoundation.org>
References: <20140604232546.704156131@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Hogan <james.hogan@imgtec.com>

commit d71f290b4e98a39f49f2595a13be3b4d5ce8e1f1 upstream.

Specify the maximum stack size for arches where the stack grows upward
(parisc and metag) in asm/processor.h rather than hard coding in
fs/exec.c so that metag can specify a smaller value of 256MB rather than
1GB.

This fixes a BUG on metag if the RLIMIT_STACK hard limit is increased
beyond a safe value by root. E.g. when starting a process after running
"ulimit -H -s unlimited" it will then attempt to use a stack size of the
maximum 1GB which is far too big for metag's limited user virtual
address space (stack_top is usually 0x3ffff000):

BUG: failure at fs/exec.c:589/shift_arg_pages()!

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: linux-parisc@vger.kernel.org
Cc: linux-metag@vger.kernel.org
Cc: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/metag/include/asm/processor.h  |    2 ++
 arch/parisc/include/asm/processor.h |    2 ++
 fs/exec.c                           |    6 +++---
 3 files changed, 7 insertions(+), 3 deletions(-)

--- a/arch/metag/include/asm/processor.h
+++ b/arch/metag/include/asm/processor.h
@@ -22,6 +22,8 @@
 /* Add an extra page of padding at the top of the stack for the guard page. */
 #define STACK_TOP	(TASK_SIZE - PAGE_SIZE)
 #define STACK_TOP_MAX	STACK_TOP
+/* Maximum virtual space for stack */
+#define STACK_SIZE_MAX	(1 << 28)	/* 256 MB */
 
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
--- a/arch/parisc/include/asm/processor.h
+++ b/arch/parisc/include/asm/processor.h
@@ -53,6 +53,8 @@
 #define STACK_TOP	TASK_SIZE
 #define STACK_TOP_MAX	DEFAULT_TASK_SIZE
 
+#define STACK_SIZE_MAX	(1 << 30)	/* 1 GB */
+
 #endif
 
 #ifndef __ASSEMBLY__
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -654,10 +654,10 @@ int setup_arg_pages(struct linux_binprm
 	unsigned long rlim_stack;
 
 #ifdef CONFIG_STACK_GROWSUP
-	/* Limit stack size to 1GB */
+	/* Limit stack size */
 	stack_base = rlimit_max(RLIMIT_STACK);
-	if (stack_base > (1 << 30))
-		stack_base = 1 << 30;
+	if (stack_base > STACK_SIZE_MAX)
+		stack_base = STACK_SIZE_MAX;
 
 	/* Make sure we didn't let the argument array grow too large. */
 	if (vma->vm_end - vma->vm_start > stack_base)


