Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab3FNSOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 14:14:08 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:59930 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3FNSOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 14:14:06 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: ralf@linux-mips.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: [PATCH v2] smp.h: Use local_irq_{save,restore}() in !SMP version of on_each_cpu().
Date: Fri, 14 Jun 2013 11:13:59 -0700
Message-Id: <1371233639-9244-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Thanks to commit f91eb62f71b (init: scream bloody murder if interrupts
are enabled too early), "bloody murder" is now being screamed.

With a MIPS OCTEON config, we use on_each_cpu() in our
irq_chip.irq_bus_sync_unlock() function.  This gets called in early as
a result of the time_init() call.  Because the !SMP version of
on_each_cpu() unconditionally enables irqs, we get:

------------[ cut here ]------------
WARNING: at init/main.c:560 start_kernel+0x250/0x410()
Interrupts were enabled early
Modules linked in:
CPU: 0 PID: 0 Comm: swapper Not tainted 3.10.0-rc5-Cavium-Octeon+ #801
Stack : 0000000000000046 ffffffff808e0000 0000000000000006 0000000000000004
	  0000000000000001 0000000000000000 0000000000000046 0000000000000000
	  ffffffff80a90000 ffffffff8015c020 0000000000000000 ffffffff8015c020
	  ffffffff80a79f70 ffffffff80a80000 ffffffff8072b9c0 ffffffff808a7d77
	  ffffffff80a79f70 ffffffff808a8168 0000000000000000 00000004178a9948
	  0000000417801230 ffffffff805f7610 0000000010000078 ffffffff805fa01c
	  ffffffff8089bd18 ffffffff801595fc ffffffff8089bd28 ffffffff8015d384
	  ffffffff808a7e80 ffffffff8089bc30 0000000000000000 ffffffff80159710
	  0000000000000000 0000000000000000 0000000000000000 0000000000000000
	  0000000000000000 ffffffff80139520 0000000000000000 0000000000000009
	  ...
Call Trace:
[<ffffffff80139520>] show_stack+0x68/0x80
[<ffffffff80159710>] warn_slowpath_common+0x78/0xb0
[<ffffffff801597e8>] warn_slowpath_fmt+0x38/0x48
[<ffffffff8092b768>] start_kernel+0x250/0x410

---[ end trace 139ce121c98e96c9 ]---

Suggested fix: Do what we already do in the SMP version of
on_each_cpu(), and use local_irq_save/local_irq_restore.  Because we
need a flags variable, make it a static inline to avoid name space
issues.

Signed-off-by: David Daney <david.daney@cavium.com>
---

Change from v1: Convert on_each_cpu to a static inline function, add
#include <linux/irqflags.h> to avoid build breakage on some files.

on_each_cpu_mask() and on_each_cpu_cond() suffer the same problem as
on_each_cpu(), but they are not causing !SMP bugs for me, so I will
defer changing them to a less urgent patch.

Thanks,
David Daney

 include/linux/smp.h | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index e6564c1..c848876 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -11,6 +11,7 @@
 #include <linux/list.h>
 #include <linux/cpumask.h>
 #include <linux/init.h>
+#include <linux/irqflags.h>
 
 extern void cpu_idle(void);
 
@@ -139,13 +140,17 @@ static inline int up_smp_call_function(smp_call_func_t func, void *info)
 }
 #define smp_call_function(func, info, wait) \
 			(up_smp_call_function(func, info))
-#define on_each_cpu(func,info,wait)		\
-	({					\
-		local_irq_disable();		\
-		func(info);			\
-		local_irq_enable();		\
-		0;				\
-	})
+
+static inline int on_each_cpu(smp_call_func_t func, void *info, int wait)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	func(info);
+	local_irq_restore(flags);
+	return 0;
+}
+
 /*
  * Note we still need to test the mask even for UP
  * because we actually can get an empty mask from
-- 
1.7.11.7

