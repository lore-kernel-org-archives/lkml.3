Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946079AbaD3V0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:26:11 -0400
Received: from mout.gmx.net ([212.227.15.18]:50774 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945936AbaD3V0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:26:08 -0400
Date: Wed, 30 Apr 2014 23:26:02 +0200
From: Helge Deller <deller@gmx.de>
To: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        John David Anglin <dave.anglin@bell.net>, linux-metag@vger.kernel.org
Subject: [PATCH] parisc,metag: Do not hardcode maximum userspace stack size
Message-ID: <20140430212602.GA20601@p100.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:a43vjX6Y+4T+8b8d4mq8IPy4GtYS6XioEe2jgNQdxL0jAaEGt8X
 baVXqGyo66IpKGWy9nCwb9XgfLYqQPUqKAbqr7JdD/917PQ3RqZS0v/FdkqjJQDJkGhytQp
 x8CRFEOmIeezdQ1pli3A1eE0rq+XLMKq0B48+AWA7SUbAVDf5UBq9ryTGNfbYWoPc9jWd6C
 jaTujPsnrCrUcSVO+5DPQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch affects only architectures where the stack grows upwards
(currently parisc and metag only). On those do not hardcode the maximum
initial stack size to 1GB, but make it configurable via a config option.

The main problem with the hardcoded stack size is, that we have two
memory regions which grow upwards: stack and heap. To keep most of the
memory available for heap in a flexmap memoy layout, it makes no sense
to hard allocate up to 1GB of the memory for stack which can't be used
as heap then.

This patch makes the stack size configurable and uses 80MB as default
value which has been in use during the last few years on parisc and
which didn't showed any problems yet.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Cc: linux-metag@vger.kernel.org
Cc: John David Anglin <dave.anglin@bell.net>

diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index 7d8cbd1..9118f01 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -72,10 +72,10 @@ static unsigned long mmap_upper_limit(void)
 {
 	unsigned long stack_base;
 
-	/* Limit stack size to 1GB - see setup_arg_pages() in fs/exec.c */
+	/* Limit stack size - see setup_arg_pages() in fs/exec.c */
 	stack_base = rlimit_max(RLIMIT_STACK);
-	if (stack_base > (1 << 30))
-		stack_base = 1 << 30;
+	if (stack_base > CONFIG_MAX_STACK_SIZE_MB*1024*1024)
+		stack_base = CONFIG_MAX_STACK_SIZE_MB*1024*1024;
 
 	return PAGE_ALIGN(STACK_TOP - stack_base);
 }
diff --git a/fs/exec.c b/fs/exec.c
index 476f3eb..994108c 100644
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
+	if (stack_base > CONFIG_MAX_STACK_SIZE_MB*1024*1024)
+		stack_base = CONFIG_MAX_STACK_SIZE_MB*1024*1024;
 
 	/* Make sure we didn't let the argument array grow too large. */
 	if (vma->vm_end - vma->vm_start > stack_base)
diff --git a/init/Kconfig b/init/Kconfig
index 9d3585b..436e479 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1862,6 +1862,17 @@ config STOP_MACHINE
 	help
 	  Need stop_machine() primitive.
 
+config MAX_STACK_SIZE_MB
+	int "Default initial maximum stack size"
+	default 80
+	range 8 2048
+	depends on STACK_GROWSUP
+	help
+	  This is the default initial stack size in Megabytes in the VM layout of user
+	  processes when the stack grows upwards (currently only on parisc and matag
+	  arch).  The stack will be located at the highest memory address minus the
+	  given value. A sane initial value is 80 MB.
+
 source "block/Kconfig"
 
 config PREEMPT_NOTIFIERS
