Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab3EAQEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 12:04:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889Ab3EAQEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 12:04:13 -0400
Date: Wed, 1 May 2013 11:03:35 -0500
From: Clark Williams <williams@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: create include/sched/lockup.h for softlockup
 prototypes
Message-ID: <20130501110335.4d0cd417@riff.lan>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/N5hZyzB7r5C3gVlci5Jp17X"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/N5hZyzB7r5C3gVlci5Jp17X
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Move the softlockup watchdog and related prototypes into a separate
header and update source that requires them.

Done against tip/master.

Tested against x86_64 allmodconfig.


Signed-off-by: Clark Williams <clark.williams@gmail.com>
---
 arch/x86/xen/smp.c              |  2 ++
 drivers/ide/ide-iops.c          |  1 +
 drivers/ide/ide-taskfile.c      |  2 +-
 drivers/mtd/nand/nand_base.c    |  2 +-
 drivers/video/nvidia/nv_accel.c |  1 +
 include/linux/sched.h           | 24 ------------------------
 include/linux/sched/lockup.h    | 29 +++++++++++++++++++++++++++++
 init/main.c                     |  2 +-
 kernel/debug/debug_core.c       |  2 +-
 kernel/panic.c                  |  2 +-
 kernel/power/hibernate.c        |  1 +
 kernel/sched/clock.c            |  1 +
 kernel/sched/sched.h            |  1 +
 kernel/sysctl.c                 |  1 +
 kernel/time/tick-sched.c        |  2 +-
 kernel/time/timekeeping.c       |  1 +
 16 files changed, 44 insertions(+), 30 deletions(-)
 create mode 100644 include/linux/sched/lockup.h

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 73642e9..ee214bc9 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -12,7 +12,9 @@
  * result, all CPUs are treated as if they're single-core and
  * single-threaded.
  */
+
 #include <linux/sched.h>
+#include <linux/sched/lockup.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 376f2dc..9bd4365 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -21,6 +21,7 @@
 #include <linux/ide.h>
 #include <linux/bitops.h>
 #include <linux/nmi.h>
+#include <linux/sched/lockup.h>
=20
 #include <asm/byteorder.h>
 #include <asm/irq.h>
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 729428e..448fab3 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -12,7 +12,7 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
-#include <linux/sched.h>
+#include <linux/sched/lockup.h>
 #include <linux/interrupt.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 42c6392..ef1da72 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -36,7 +36,7 @@
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/err.h>
-#include <linux/sched.h>
+#include <linux/sched/lockup.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/mtd/mtd.h>
diff --git a/drivers/video/nvidia/nv_accel.c b/drivers/video/nvidia/nv_acce=
l.c
index ad6472a..2a7e475 100644
--- a/drivers/video/nvidia/nv_accel.c
+++ b/drivers/video/nvidia/nv_accel.c
@@ -48,6 +48,7 @@
  */
=20
 #include <linux/fb.h>
+#include <linux/sched/lockup.h>
 #include "nv_type.h"
 #include "nv_proto.h"
 #include "nv_dma.h"
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 802a751..0e856f1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -269,30 +269,6 @@ extern void scheduler_tick(void);
=20
 extern void sched_show_task(struct task_struct *p);
=20
-#ifdef CONFIG_LOCKUP_DETECTOR
-extern void touch_softlockup_watchdog(void);
-extern void touch_softlockup_watchdog_sync(void);
-extern void touch_all_softlockup_watchdogs(void);
-extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
-				  void __user *buffer,
-				  size_t *lenp, loff_t *ppos);
-extern unsigned int  softlockup_panic;
-void lockup_detector_init(void);
-#else
-static inline void touch_softlockup_watchdog(void)
-{
-}
-static inline void touch_softlockup_watchdog_sync(void)
-{
-}
-static inline void touch_all_softlockup_watchdogs(void)
-{
-}
-static inline void lockup_detector_init(void)
-{
-}
-#endif
-
 /* Attach to any functions which should be ignored in wchan output. */
 #define __sched		__attribute__((__section__(".sched.text")))
=20
diff --git a/include/linux/sched/lockup.h b/include/linux/sched/lockup.h
new file mode 100644
index 0000000..a23c12c
--- /dev/null
+++ b/include/linux/sched/lockup.h
@@ -0,0 +1,29 @@
+#ifndef _SCHED_LOCKUP_H
+#define _SCHED_LOCKUP_H
+
+#ifdef CONFIG_LOCKUP_DETECTOR
+#include <linux/sysctl.h>
+extern void touch_softlockup_watchdog(void);
+extern void touch_softlockup_watchdog_sync(void);
+extern void touch_all_softlockup_watchdogs(void);
+extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
+				  void __user *buffer,
+				  size_t *lenp, loff_t *ppos);
+extern unsigned int  softlockup_panic;
+void lockup_detector_init(void);
+#else
+static inline void touch_softlockup_watchdog(void)
+{
+}
+static inline void touch_softlockup_watchdog_sync(void)
+{
+}
+static inline void touch_all_softlockup_watchdogs(void)
+{
+}
+static inline void lockup_detector_init(void)
+{
+}
+#endif
+
+#endif /* _SCHED_LOCKUP_H */
diff --git a/init/main.c b/init/main.c
index a2393be..3a6673d 100644
--- a/init/main.c
+++ b/init/main.c
@@ -57,7 +57,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/device.h>
 #include <linux/kthread.h>
-#include <linux/sched.h>
+#include <linux/sched/lockup.h>
 #include <linux/signal.h>
 #include <linux/idr.h>
 #include <linux/kgdb.h>
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index c26278f..0d3fcbd 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -40,7 +40,7 @@
 #include <linux/ptrace.h>
 #include <linux/string.h>
 #include <linux/delay.h>
-#include <linux/sched.h>
+#include <linux/sched/lockup.h>
 #include <linux/sysrq.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
diff --git a/kernel/panic.c b/kernel/panic.c
index 7c57cc9..b9213d9 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -18,7 +18,7 @@
 #include <linux/reboot.h>
 #include <linux/delay.h>
 #include <linux/kexec.h>
-#include <linux/sched.h>
+#include <linux/sched/lockup.h>
 #include <linux/sysrq.h>
 #include <linux/init.h>
 #include <linux/nmi.h>
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index b26f5f1..a8711f3 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -28,6 +28,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/ctype.h>
 #include <linux/genhd.h>
+#include <linux/sched/lockup.h>
=20
 #include "power.h"
=20
diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index c3ae144..acdfb71 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -66,6 +66,7 @@
 #include <linux/percpu.h>
 #include <linux/ktime.h>
 #include <linux/sched.h>
+#include <linux/sched/lockup.h>
=20
 /*
  * Scheduler clock - returns current time in nanosec units.
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 24dc298..56a8fd2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2,6 +2,7 @@
 #include <linux/sched.h>
 #include <linux/sched/sysctl.h>
 #include <linux/sched/rt.h>
+#include <linux/sched/lockup.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/stop_machine.h>
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index afc1dc6..c79271b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -62,6 +62,7 @@
 #include <linux/capability.h>
 #include <linux/binfmts.h>
 #include <linux/sched/sysctl.h>
+#include <linux/sched/lockup.h>
=20
 #include <asm/uaccess.h>
 #include <asm/processor.h>
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 5e3b3a3..7d0263a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -18,7 +18,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/percpu.h>
 #include <linux/profile.h>
-#include <linux/sched.h>
+#include <linux/sched/lockup.h>
 #include <linux/module.h>
 #include <linux/irq_work.h>
 #include <linux/posix-timers.h>
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 98cd470..712f527 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
+#include <linux/sched/lockup.h>
 #include <linux/syscore_ops.h>
 #include <linux/clocksource.h>
 #include <linux/jiffies.h>
--=20
1.8.1.4


--Sig_/N5hZyzB7r5C3gVlci5Jp17X
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlGBPN4ACgkQHyuj/+TTEp01MgCfXWRbuuK7NMQkH37Q/kU7tbTG
yj4AoNTnRTMlK18vn5XBRfsEq2bxn4nz
=oF7+
-----END PGP SIGNATURE-----

--Sig_/N5hZyzB7r5C3gVlci5Jp17X--
