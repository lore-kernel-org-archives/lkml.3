Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbaCSX1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 19:27:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759400AbaCSX1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 19:27:32 -0400
Date: Wed, 19 Mar 2014 16:27:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
Subject: Re: linux-next: manual merge of the akpm-current tree with the tip
 tree
Message-Id: <20140319162729.9b9f322b171140548b25c7af@linux-foundation.org>
In-Reply-To: <20140317093602.GY27965@twins.programming.kicks-ass.net>
References: <20140317203124.3b947e0799cc8142df5e4a2e@canb.auug.org.au>
	<20140317093602.GY27965@twins.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2014 10:36:02 +0100 Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, Mar 17, 2014 at 08:31:24PM +1100, Stephen Rothwell wrote:
> > Hi Andrew,
> > 
> > Today's linux-next merge of the akpm-current tree got a conflict in
> > kernel/locking/Makefile between commit fb0527bd5ea9 ("locking/mutexes:
> > Introduce cancelable MCS lock for adaptive spinning") from the  tree and
> > commit 4dc0fe493027 ("lglock: map to spinlock when !CONFIG_SMP") from the
> > akpm-current tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary (no action
> > is required).
> 
> I'm a bit sad of not having seen that lglock patch at all.

Here 'tis:

From: Josh Triplett <josh@joshtriplett.org>
Subject: lglock: map to spinlock when !CONFIG_SMP

When the system has only one CPU, lglock is effectively a spinlock; map it
directly to spinlock to eliminate the indirection and duplicate code.

In addition to removing overhead, this drops 1.6k of code with a defconfig
modified to have !CONFIG_SMP, and 1.1k with a minimal config.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lglock.h  |   16 ++++++++++++++++
 kernel/locking/Makefile |    3 ++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff -puN include/linux/lglock.h~lglock-map-to-spinlock-when-config_smp include/linux/lglock.h
--- a/include/linux/lglock.h~lglock-map-to-spinlock-when-config_smp
+++ a/include/linux/lglock.h
@@ -25,6 +25,8 @@
 #include <linux/cpu.h>
 #include <linux/notifier.h>
 
+#ifdef CONFIG_SMP
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #define LOCKDEP_INIT_MAP lockdep_init_map
 #else
@@ -57,4 +59,18 @@ void lg_local_unlock_cpu(struct lglock *
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
diff -puN kernel/locking/Makefile~lglock-map-to-spinlock-when-config_smp kernel/locking/Makefile
--- a/kernel/locking/Makefile~lglock-map-to-spinlock-when-config_smp
+++ a/kernel/locking/Makefile
@@ -1,5 +1,5 @@
 
-obj-y += mutex.o semaphore.o rwsem.o lglock.o mcs_spinlock.o
+obj-y += mutex.o semaphore.o rwsem.o mcs_spinlock.o
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_lockdep.o = -pg
@@ -14,6 +14,7 @@ ifeq ($(CONFIG_PROC_FS),y)
 obj-$(CONFIG_LOCKDEP) += lockdep_proc.o
 endif
 obj-$(CONFIG_SMP) += spinlock.o
+obj-$(CONFIG_SMP) += lglock.o
 obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
 obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
_

