Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbaAUOLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:11:03 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56331 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbaAUOLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:11:00 -0500
Date: Tue, 21 Jan 2014 15:10:22 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] lockdep: pack subclass/trylock/read/check into a
 single argument
Message-ID: <20140121141022.GX31570@twins.programming.kicks-ass.net>
References: <20140120181942.GA20783@redhat.com>
 <20140120182019.GA26515@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120182019.GA26515@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I tried the below but filed to see my vmlinux shrink, maybe I'm just not
building the right kernel, or otherwise GCC is stupid.

---
 include/linux/lockdep.h  |   33 ++++++++++++++++++++++++++++++---
 kernel/locking/lockdep.c |   11 +++++++----
 2 files changed, 32 insertions(+), 7 deletions(-)

--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -329,9 +329,31 @@ static inline int lockdep_match_key(stru
  *   0: simple checks (freeing, held-at-exit-time, etc.)
  *   1: full validation
  */
-extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
-			 int trylock, int read, int check,
-			 struct lockdep_map *nest_lock, unsigned long ip);
+struct lockdep_acquire_flags {
+	unsigned long subclass : 3;
+	unsigned long trylock  : 1;
+	unsigned long read     : 2;
+	unsigned long check    : 1;
+};
+
+extern void do_lock_acquire(struct lockdep_map *lock,
+			    struct lockdep_acquire_flags acqf,
+			    struct lockdep_map *nest_lock,
+			    unsigned long ip);
+
+static inline void lock_acquire(struct lockdep_map *lock,
+		unsigned int subclass, int trylock, int read, int check,
+		struct lockdep_map *nest_lock, unsigned long ip)
+{
+	struct lockdep_acquire_flags acqf = {
+		.subclass = subclass,
+		.trylock = trylock,
+		.read = read,
+		.check = check,
+	};
+
+	do_lock_acquire(lock, acqf, nest_lock, ip);
+}
 
 extern void lock_release(struct lockdep_map *lock, int nested,
 			 unsigned long ip);
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3583,10 +3583,13 @@ EXPORT_SYMBOL_GPL(lock_set_class);
  * We are not always called with irqs disabled - do that here,
  * and also avoid lockdep recursion:
  */
-void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
-			  int trylock, int read, int check,
-			  struct lockdep_map *nest_lock, unsigned long ip)
+void do_lock_acquire(struct lockdep_map *lock, struct lockdep_acquire_flags acqf,
+			struct lockdep_map *nest_lock, unsigned long ip)
 {
+	unsigned int subclass = acqf.subclass;
+	unsigned int trylock = acqf.trylock;
+	unsigned int read = acqf.read;
+	unsigned int check = acqf.check;
 	unsigned long flags;
 
 	if (unlikely(current->lockdep_recursion))
@@ -3602,7 +3605,7 @@ void lock_acquire(struct lockdep_map *lo
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(lock_acquire);
+EXPORT_SYMBOL_GPL(do_lock_acquire);
 
 void lock_release(struct lockdep_map *lock, int nested,
 			  unsigned long ip)
