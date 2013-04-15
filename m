Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab3DORpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:45:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45773 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753196Ab3DORpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:45:39 -0400
Message-ID: <1366047938.31131.6.camel@joe-AO722>
Subject: Re: [Patch -v3 3/4] checkpatch.pl the new kernel/reboot.c file.
From: Joe Perches <joe@perches.com>
To: Robin Holt <holt@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Russ Anderson <rja@sgi.com>,
        Shawn Guo <shawn.guo@linaro.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 15 Apr 2013 10:45:38 -0700
In-Reply-To: <20130415171603.GH3672@sgi.com>
References: <20130415171225.GC3658@sgi.com> <20130415171603.GH3672@sgi.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 12:16 -0500, Robin Holt wrote:
> I did allow the remaining 81 character line behind.  It did not seem
> like it was worth changing.  Otherwise, it now passes checkpatch.pl.

trivia:

I'd make these changes on top of your patch:

o Additional OOM messages aren't necessary as a dump_stack is done
o Add pr_fmt to prefix logging messages with "reboot: "
o Remove periods from logging messages
o Argument alignment
o Rename file prefix to "reboot.c"
o Add #include <linux/suspend.h> so it compiles

---
 kernel/reboot.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/kernel/reboot.c b/kernel/reboot.c
index 187a0d8..7adba53 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -1,14 +1,17 @@
 /*
- *  linux/kernel/sys.c
+ *  linux/kernel/reboot.c
  *
  *  Copyright (C) 2013  Linus Torvalds
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/export.h>
 #include <linux/kexec.h>
 #include <linux/kmod.h>
 #include <linux/kmsg_dump.h>
 #include <linux/reboot.h>
+#include <linux/suspend.h>
 #include <linux/syscalls.h>
 #include <linux/syscore_ops.h>
 
@@ -96,9 +99,9 @@ void kernel_restart(char *cmd)
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	if (!cmd)
-		pr_emerg("Restarting system.\n");
+		pr_emerg("Restarting system\n");
 	else
-		pr_emerg("Restarting system with command '%s'.\n", cmd);
+		pr_emerg("Restarting system with command '%s'\n", cmd);
 	kmsg_dump(KMSG_DUMP_RESTART);
 	machine_restart(cmd);
 }
@@ -107,7 +110,8 @@ EXPORT_SYMBOL_GPL(kernel_restart);
 static void kernel_shutdown_prepare(enum system_states state)
 {
 	blocking_notifier_call_chain(&reboot_notifier_list,
-		(state == SYSTEM_HALT) ? SYS_HALT : SYS_POWER_OFF, NULL);
+				     state == SYSTEM_HALT ? SYS_HALT : SYS_POWER_OFF,
+				     NULL);
 	system_state = state;
 	usermodehelper_disable();
 	device_shutdown();
@@ -122,7 +126,7 @@ void kernel_halt(void)
 	kernel_shutdown_prepare(SYSTEM_HALT);
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
-	pr_emerg("System halted.\n");
+	pr_emerg("System halted\n");
 	kmsg_dump(KMSG_DUMP_HALT);
 	machine_halt();
 }
@@ -140,7 +144,7 @@ void kernel_power_off(void)
 		pm_power_off_prepare();
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
-	pr_emerg("Power down.\n");
+	pr_emerg("Power down\n");
 	kmsg_dump(KMSG_DUMP_POWEROFF);
 	machine_power_off();
 }
@@ -169,10 +173,10 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 
 	/* For safety, we require "magic" arguments. */
 	if (magic1 != LINUX_REBOOT_MAGIC1 ||
-			(magic2 != LINUX_REBOOT_MAGIC2 &&
-			magic2 != LINUX_REBOOT_MAGIC2A &&
-			magic2 != LINUX_REBOOT_MAGIC2B &&
-			magic2 != LINUX_REBOOT_MAGIC2C))
+	    (magic2 != LINUX_REBOOT_MAGIC2 &&
+	     magic2 != LINUX_REBOOT_MAGIC2A &&
+	     magic2 != LINUX_REBOOT_MAGIC2B &&
+	     magic2 != LINUX_REBOOT_MAGIC2C))
 		return -EINVAL;
 
 	/*
@@ -281,8 +285,6 @@ static int __orderly_poweroff(bool force)
 		ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
 		argv_free(argv);
 	} else {
-		pr_warn("%s failed to allocate memory for \"%s\"\n",
-					 __func__, poweroff_cmd);
 		ret = -ENOMEM;
 	}
 


