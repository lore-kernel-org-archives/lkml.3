Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaAILuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:50:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58588 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaAILuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:50:14 -0500
Date: Thu, 9 Jan 2014 12:49:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] lockdep: Introduce wait-type checks
Message-ID: <20140109114958.GB8224@laptop.programming.kicks-ass.net>
References: <20140109111516.GE7572@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109111516.GE7572@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 12:15:16PM +0100, Peter Zijlstra wrote:
> @@ -276,8 +292,14 @@ extern void lockdep_on(void);
>   * to lockdep:
>   */
>  
> -extern void lockdep_init_map(struct lockdep_map *lock, const char *name,
> -			     struct lock_class_key *key, int subclass);
> +extern void lockdep_init_map_wait(struct lockdep_map *lock, const char *name,
> +		struct lock_class_key *key, int subclass, short inner);
> +
> +static inline void lockdep_init_map(struct lockdep_map *lock, const char *name,
> +			     struct lock_class_key *key, int subclass)
> +{
> +	lockdep_init_map_wait(lock, name, key, subclass, LD_WAIT_INV);
> +}
>  
>  /*
>   * To initialize a lockdep_map statically use this macro.

Realized that the above destroys existing wait types for
lockdep_set_*(), so update those to preserve the wait_types.

At which point a trylock triggered a wait_type violation which is of
course a validation mistake, so ignore trylocks.

--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -314,15 +314,21 @@ static inline void lockdep_init_map(stru
  * of dependencies wrong: they are either too broad (they need a class-split)
  * or they are too narrow (they suffer from a false class-split):
  */
-#define lockdep_set_class(lock, key) \
-		lockdep_init_map(&(lock)->dep_map, #key, key, 0)
-#define lockdep_set_class_and_name(lock, key, name) \
-		lockdep_init_map(&(lock)->dep_map, name, key, 0)
-#define lockdep_set_class_and_subclass(lock, key, sub) \
-		lockdep_init_map(&(lock)->dep_map, #key, key, sub)
-#define lockdep_set_subclass(lock, sub)	\
-		lockdep_init_map(&(lock)->dep_map, #lock, \
-				 (lock)->dep_map.key, sub)
+#define lockdep_set_class(lock, key)				\
+	lockdep_init_map_wait(&(lock)->dep_map, #key, key, 0,	\
+			      (lock)->dep_map.wait_type_inner)
+
+#define lockdep_set_class_and_name(lock, key, name)		\
+	lockdep_init_map_wait(&(lock)->dep_map, name, key, 0,	\
+			      (lock)->dep_map.wait_type_inner)
+
+#define lockdep_set_class_and_subclass(lock, key, sub)		\
+	lockdep_init_map_wait(&(lock)->dep_map, #key, key, sub,	\
+			      (lock)->dep_map.wait_type_inner)
+
+#define lockdep_set_subclass(lock, sub)						\
+	lockdep_init_map_wait(&(lock)->dep_map, #lock, (lock)->dep_map.key, sub,\
+			      (lock)->dep_map.wait_type_inner)
 
 #define lockdep_set_novalidate_class(lock) \
 	lockdep_set_class(lock, &__lockdep_no_validate__)
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3092,14 +3092,14 @@ print_lock_invalid_wait_context(struct t
  * Therefore we must look for the strictest environment in the lock stack and
  * compare that to the lock we're trying to acquire.
  */
-static int check_context(struct task_struct *curr, struct held_lock *next)
+static int check_wait_context(struct task_struct *curr, struct held_lock *next)
 {
 	short next_inner = hlock_class(next)->wait_type_inner;
 	short next_outer = hlock_class(next)->wait_type_outer;
 	short curr_inner = LD_WAIT_MAX;
 	int depth;
 
-	if (!curr->lockdep_depth || !next_inner)
+	if (!curr->lockdep_depth || !next_inner || next->trylock)
 		return 0;
 
 	if (!next_outer)
@@ -3111,8 +3111,10 @@ static int check_context(struct task_str
 
 		if (prev_inner) {
 			/*
-			 * we can have a bigger inner than a previous one
+			 * We can have a bigger inner than a previous one
 			 * when outer is smaller than inner, as with RCU.
+			 *
+			 * Also due to trylocks.
 			 */
 			curr_inner = min(curr_inner, prev_inner);
 		}
@@ -3226,7 +3228,7 @@ static int __lock_acquire(struct lockdep
 	hlock->holdtime_stamp = lockstat_clock();
 #endif
 
-	if (check_context(curr, hlock))
+	if (check_wait_context(curr, hlock))
 		return 0;
 
 	if (check == 2 && !mark_irqflags(curr, hlock))
