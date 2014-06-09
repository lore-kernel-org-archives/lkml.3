Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936372AbaFIJ10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:27:26 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932283AbaFIJ1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:27:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org, linux-metag@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 111/146] metag: Reduce maximum stack size to 256MB
Date: Mon,  9 Jun 2014 10:50:46 +0200
Message-Id: <c4ecb4801dcfb0666b4ada6c6dfb10c8ba03a45a.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Hogan <james.hogan@imgtec.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/metag/include/asm/processor.h  | 2 ++
 arch/parisc/include/asm/processor.h | 2 ++
 fs/exec.c                           | 6 +++---
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/metag/include/asm/processor.h b/arch/metag/include/asm/processor.h
index f16477d1f571..3be8581af495 100644
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
diff --git a/arch/parisc/include/asm/processor.h b/arch/parisc/include/asm/processor.h
index cc2290a3cace..c6ee86542fec 100644
--- a/arch/parisc/include/asm/processor.h
+++ b/arch/parisc/include/asm/processor.h
@@ -53,6 +53,8 @@
 #define STACK_TOP	TASK_SIZE
 #define STACK_TOP_MAX	DEFAULT_TASK_SIZE
 
+#define STACK_SIZE_MAX	(1 << 30)	/* 1 GB */
+
 #endif
 
 #ifndef __ASSEMBLY__
diff --git a/fs/exec.c b/fs/exec.c
index bb8afc1d1df4..95eef54de2b6 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -657,10 +657,10 @@ int setup_arg_pages(struct linux_binprm *bprm,
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
-- 
1.9.3

