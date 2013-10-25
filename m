Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab3JYPTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:19:44 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47660 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab3JYPTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:19:43 -0400
X-Originating-IP: 77.221.165.98
Date: Fri, 25 Oct 2013 16:19:37 +0100
From: Josh Triplett <josh@joshtriplett.org>
To: Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] lglock: Map to spinlock when !CONFIG_SMP
Message-ID: <20131025151930.GA9742@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the system has only one CPU, lglock is effectively a spinlock; map
it directly to spinlock to eliminate the indirection and duplicate code.

In addition to removing overhead, this drops 1.6k of code with a defconfig
modified to have !CONFIG_SMP, and 1.1k with a minimal config.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/lglock.h | 16 ++++++++++++++++
 kernel/Makefile        |  4 ++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/linux/lglock.h b/include/linux/lglock.h
index 0d24e93..6561b1c 100644
--- a/include/linux/lglock.h
+++ b/include/linux/lglock.h
@@ -35,6 +35,8 @@
 #define DEFINE_BRLOCK(name)		DEFINE_LGLOCK(name)
 #define DEFINE_STATIC_BRLOCK(name)	DEFINE_STATIC_LGLOCK(name)
 
+#ifdef CONFIG_SMP
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #define LOCKDEP_INIT_MAP lockdep_init_map
 #else
@@ -67,4 +69,18 @@ void lg_local_unlock_cpu(struct lglock *lg, int cpu);
 void lg_global_lock(struct lglock *lg);
 void lg_global_unlock(struct lglock *lg);
 
+#else
+/* When !CONFIG_SMP, map lglock to spinlock */
+#define lglock spinlock
+#define DEFINE_LGLOCK(name) DEFINE_SPINLOCK(name)
+#define DEFINE_STATIC_LGLOCK(name) static DEFINE_SPINLOCK(name)
+#define lg_lock_init(lg, name) spin_lock_init(lg)
+#define lg_local_lock spin_lock
+#define lg_local_unlock spin_unlock
+#define lg_local_lock_cpu(lg, cpu) spin_lock(lg)
+#define lg_local_unlock_cpu(lg, cpu) spin_unlock(lg)
+#define lg_global_lock spin_lock
+#define lg_global_unlock spin_unlock
+#endif
+
 #endif
diff --git a/kernel/Makefile b/kernel/Makefile
index 1ce4755..84a89f7 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = fork.o exec_domain.o panic.o \
 	    kthread.o wait.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
-	    async.o range.o groups.o lglock.o smpboot.o
+	    async.o range.o groups.o smpboot.o
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace debug files and internal ftrace files
@@ -50,7 +50,7 @@ obj-$(CONFIG_SMP) += smp.o
 ifneq ($(CONFIG_SMP),y)
 obj-y += up.o
 endif
-obj-$(CONFIG_SMP) += spinlock.o
+obj-$(CONFIG_SMP) += lglock.o spinlock.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_UID16) += uid16.o
-- 
1.8.4.rc3

