Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaATSVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 13:21:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbaATSU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 13:20:27 -0500
Date: Mon, 20 Jan 2014 19:20:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] lockdep: pack subclass/trylock/read/check into a
	single argument
Message-ID: <20140120182019.GA26515@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120181942.GA20783@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lock_acquire() takes 7 arguments, we can pack 4 "short" enums into
the single "unsigned long acqf" to help the callers which mostly
use the constant values of subclass/trylock/read/check,

		$ size vmlinux
		   text	   data	    bss	    dec	    hex	filename
	-	5262832	2970280	10125312	18358424	1182098	vmlinux
	+	5255131	2974376	10125312	18354819	1181283	vmlinux

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/lockdep.h  |   29 ++++++++++++++++++++++++++---
 kernel/locking/lockdep.c |   17 +++++++++++++----
 2 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 060e513..23a8af3 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -329,9 +329,32 @@ static inline int lockdep_match_key(struct lockdep_map *lock,
  *   0: simple checks (freeing, held-at-exit-time, etc.)
  *   1: full validation
  */
-extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
-			 int trylock, int read, int check,
-			 struct lockdep_map *nest_lock, unsigned long ip);
+#define ACQF_SUBCLASS_SHIFT	0
+#define ACQF_SUBCLASS_BITS	3
+
+#define ACQF_TRYLOCK_SHIFT	(ACQF_SUBCLASS_SHIFT + ACQF_SUBCLASS_BITS)
+#define ACQF_TRYLOCK_BITS	1
+
+#define ACQF_READ_SHIFT		(ACQF_TRYLOCK_SHIFT + ACQF_TRYLOCK_BITS)
+#define ACQF_READ_BITS		2
+
+#define ACQF_CHECK_SHIFT	(ACQF_READ_SHIFT + ACQF_READ_BITS)
+#define ACQF_CHECK_BITS		1
+
+extern void do_lock_acquire(struct lockdep_map *lock, unsigned long acqf,
+			struct lockdep_map *nest_lock, unsigned long ip);
+
+static inline void lock_acquire(struct lockdep_map *lock,
+		unsigned int subclass, int trylock, int read, int check,
+		struct lockdep_map *nest_lock, unsigned long ip)
+{
+	unsigned long acqf =	(subclass	<< ACQF_SUBCLASS_SHIFT) |
+				(trylock	<< ACQF_TRYLOCK_SHIFT) |
+				(read		<< ACQF_READ_SHIFT) |
+				(check		<< ACQF_CHECK_SHIFT);
+
+	do_lock_acquire(lock, acqf, nest_lock, ip);
+}
 
 extern void lock_release(struct lockdep_map *lock, int nested,
 			 unsigned long ip);
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 28e41c0..8826557 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3581,10 +3581,19 @@ EXPORT_SYMBOL_GPL(lock_set_class);
  * We are not always called with irqs disabled - do that here,
  * and also avoid lockdep recursion:
  */
-void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
-			  int trylock, int read, int check,
-			  struct lockdep_map *nest_lock, unsigned long ip)
+void do_lock_acquire(struct lockdep_map *lock, unsigned long acqf,
+			struct lockdep_map *nest_lock, unsigned long ip)
 {
+	#define ACQF(bits, what)	\
+		((bits >> ACQF_ ## what ## _SHIFT) &	\
+		 ((1 << ACQF_ ## what ## _BITS) - 1))
+
+	unsigned int subclass = ACQF(acqf, SUBCLASS);
+	unsigned int trylock = ACQF(acqf, TRYLOCK);
+	unsigned int read = ACQF(acqf, READ);
+	unsigned int check = ACQF(acqf, CHECK);
+	#undef ACQF
+
 	unsigned long flags;
 
 	if (unlikely(current->lockdep_recursion))
@@ -3600,7 +3609,7 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(lock_acquire);
+EXPORT_SYMBOL_GPL(do_lock_acquire);
 
 void lock_release(struct lockdep_map *lock, int nested,
 			  unsigned long ip)
-- 
1.5.5.1

