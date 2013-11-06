Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab3KFLV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:21:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47581 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab3KFLVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:21:25 -0500
Date: Wed, 6 Nov 2013 03:20:57 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-g0kynfh5feriwc6p3h6kpbw6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking: Move the rwsem code to kernel/locking
 /
Git-Commit-ID: ed428bfc3caaa4b1e6cd15ea12c90c30291903f0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 03:21:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed428bfc3caaa4b1e6cd15ea12c90c30291903f0
Gitweb:     http://git.kernel.org/tip/ed428bfc3caaa4b1e6cd15ea12c90c30291903f0
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 31 Oct 2013 18:19:28 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 09:24:18 +0100

locking: Move the rwsem code to kernel/locking/

Notably: changed lib/rwsem* targets from lib- to obj-, no idea about
the ramifications of that.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-g0kynfh5feriwc6p3h6kpbw6@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/Makefile                            | 2 +-
 kernel/locking/Makefile                    | 4 +++-
 {lib => kernel/locking}/rwsem-spinlock.c   | 0
 lib/rwsem.c => kernel/locking/rwsem-xadd.c | 0
 kernel/{ => locking}/rwsem.c               | 0
 lib/Makefile                               | 2 --
 6 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 9c2ad18..1aef002 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -8,7 +8,7 @@ obj-y     = fork.o exec_domain.o panic.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o task_work.o \
 	    extable.o params.o posix-timers.o \
 	    kthread.o sys_ni.o posix-cpu-timers.o \
-	    hrtimer.o rwsem.o nsproxy.o \
+	    hrtimer.o nsproxy.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
 	    async.o range.o groups.o lglock.o smpboot.o
 
diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
index 59f66de..b0e0d73 100644
--- a/kernel/locking/Makefile
+++ b/kernel/locking/Makefile
@@ -1,5 +1,5 @@
 
-obj-y += mutex.o semaphore.o
+obj-y += mutex.o semaphore.o rwsem.o
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_lockdep.o = -pg
@@ -20,3 +20,5 @@ obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock_debug.o
+obj-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
+obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem-xadd.o
\ No newline at end of file
diff --git a/lib/rwsem-spinlock.c b/kernel/locking/rwsem-spinlock.c
similarity index 100%
rename from lib/rwsem-spinlock.c
rename to kernel/locking/rwsem-spinlock.c
diff --git a/lib/rwsem.c b/kernel/locking/rwsem-xadd.c
similarity index 100%
rename from lib/rwsem.c
rename to kernel/locking/rwsem-xadd.c
diff --git a/kernel/rwsem.c b/kernel/locking/rwsem.c
similarity index 100%
rename from kernel/rwsem.c
rename to kernel/locking/rwsem.c
diff --git a/lib/Makefile b/lib/Makefile
index bee27e1..ca8cadc 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -42,8 +42,6 @@ obj-$(CONFIG_GENERIC_PCI_IOMAP) += pci_iomap.o
 obj-$(CONFIG_HAS_IOMEM) += iomap_copy.o devres.o
 obj-$(CONFIG_CHECK_SIGNATURE) += check_signature.o
 obj-$(CONFIG_DEBUG_LOCKING_API_SELFTESTS) += locking-selftest.o
-lib-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
-lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_PERCPU_RWSEM) += percpu-rwsem.o
 
 CFLAGS_hweight.o = $(subst $(quote),,$(CONFIG_ARCH_HWEIGHT_CFLAGS))
