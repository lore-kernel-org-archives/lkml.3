Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaKVA0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 19:26:37 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:19229 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752382AbaKVA0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 19:26:36 -0500
Date: Fri, 21 Nov 2014 19:26:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Jiri Kosina <jkosina@suse.cz>
Subject: [for-next][PATCH] printk/percpu: Define printk_func when printk is
 not defined
Message-ID: <20141121192634.5fcbe9b7@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 04b74b27c2941e5d62120f6fee3a0a9388a30613


Steven Rostedt (Red Hat) (1):
      printk/percpu: Define printk_func when printk is not defined

----
 include/linux/percpu.h | 1 +
 include/linux/printk.h | 4 ++--
 kernel/printk/printk.c | 3 +++
 3 files changed, 6 insertions(+), 2 deletions(-)
---------------------------
commit 04b74b27c2941e5d62120f6fee3a0a9388a30613
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Fri Nov 21 09:16:58 2014 -0500

    printk/percpu: Define printk_func when printk is not defined
    
    To avoid include hell, the per_cpu variable printk_func was declared
    in percpu.h. But it is only defined if printk is defined.
    
    As users of printk may also use the printk_func variable, it needs to
    be defined even if CONFIG_PRINTK is not.
    
    Also add a printk.h include in percpu.h just to be safe.
    
    Link: http://lkml.kernel.org/r/20141121183215.01ba539c@canb.auug.org.au
    
    Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index ba2e85a0ff5b..caebf2a758dc 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -5,6 +5,7 @@
 #include <linux/preempt.h>
 #include <linux/smp.h>
 #include <linux/cpumask.h>
+#include <linux/printk.h>
 #include <linux/pfn.h>
 #include <linux/init.h>
 
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 3bbd979d32fb..c69be9ee8f48 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -124,6 +124,8 @@ static inline __printf(1, 2) __cold
 void early_printk(const char *s, ...) { }
 #endif
 
+typedef int(*printk_func_t)(const char *fmt, va_list args);
+
 #ifdef CONFIG_PRINTK
 asmlinkage __printf(5, 0)
 int vprintk_emit(int facility, int level,
@@ -162,8 +164,6 @@ extern int kptr_restrict;
 
 extern void wake_up_klogd(void);
 
-typedef int(*printk_func_t)(const char *fmt, va_list args);
-
 void log_buf_kexec_setup(void);
 void __init setup_log_buf(int early);
 void dump_stack_set_arch_desc(const char *fmt, ...);
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index f7b723f98cb9..5af2b8bc88f0 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1896,6 +1896,9 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 			     bool syslog, char *buf, size_t size) { return 0; }
 static size_t cont_print_text(char *text, size_t size) { return 0; }
 
+/* Still needs to be defined for users */
+DEFINE_PER_CPU(printk_func_t, printk_func);
+
 #endif /* CONFIG_PRINTK */
 
 #ifdef CONFIG_EARLY_PRINTK
