Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaJTOvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:51:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbaJTOvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:51:36 -0400
Date: Mon, 20 Oct 2014 16:47:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH v3] sched/numa: fix unsafe get_task_struct() in
	task_numa_assign()
Message-ID: <20141020144757.GA10939@redhat.com>
References: <1413800145.19914.23.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413800145.19914.23.camel@tkhai>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill,

I leave this to you and Peter, but...

On 10/20, Kirill Tkhai wrote:
>
> @@ -259,10 +259,15 @@ void __init fork_init(unsigned long mempages)
>  #ifndef ARCH_MIN_TASKALIGN
>  #define ARCH_MIN_TASKALIGN	L1_CACHE_BYTES
>  #endif
> -	/* create a slab on which task_structs can be allocated */
> +	/*
> +	 * Create a slab on which task_structs can be allocated.
> +	 * Note, we need SLAB_DESTROY_BY_RCU flag, when we access
> +	 * rq::curr under RCU read lock. See scheduler code.
> +	 */
>  	task_struct_cachep =
>  		kmem_cache_create("task_struct", sizeof(struct task_struct),
> -			ARCH_MIN_TASKALIGN, SLAB_PANIC | SLAB_NOTRACK, NULL);
> +			ARCH_MIN_TASKALIGN,
> +			SLAB_PANIC | SLAB_NOTRACK | SLAB_DESTROY_BY_RCU, NULL);

to me this change needs more justification.

Again, perhaps we will need to change the lifetime rules for task_struct
anyway, if we have more problems like this. But until then this looks like
an overkill to me. Plus rq_curr_if_not_put() looks too subtle, and it is
not generic.

May be we should start with something simple and stupid?

(it seems we can remove rcu_read_lock() with this patch, but I am not
 sure).

Oleg.


--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1087,9 +1087,6 @@ static void task_numa_assign(struct task_numa_env *env,
 {
 	if (env->best_task)
 		put_task_struct(env->best_task);
-	if (p)
-		get_task_struct(p);
-
 	env->best_task = p;
 	env->best_imp = imp;
 	env->best_cpu = env->dst_cpu;
@@ -1139,6 +1136,18 @@ static bool load_too_imbalanced(long src_load, long dst_load,
 	return (imb > old_imb);
 }
 
+struct task_struct *get_rq_curr(struct rq *rq)
+{
+	struct task_struct *curr;
+
+	raw_spin_lock_irq(&rq->lock);
+	curr = rq->curr;
+	get_task_struct(curr);
+	raw_spin_unlock_irq(&rq->lock);
+
+	return curr;
+}
+
 /*
  * This checks if the overall compute and NUMA accesses of the system would
  * be improved if the source tasks was migrated to the target dst_cpu taking
@@ -1156,11 +1165,9 @@ static void task_numa_compare(struct task_numa_env *env,
 	long imp = env->p->numa_group ? groupimp : taskimp;
 	long moveimp = imp;
 
-	rcu_read_lock();
-	cur = ACCESS_ONCE(dst_rq->curr);
-	if (cur->pid == 0) /* idle */
-		cur = NULL;
+	cur = get_rq_curr(dst_rq);
 
+	rcu_read_lock();
 	/*
 	 * "imp" is the fault differential for the source task between the
 	 * source and destination node. Calculate the total differential for
@@ -1235,6 +1242,7 @@ balance:
 		 */
 		if (!load_too_imbalanced(src_load, dst_load, env)) {
 			imp = moveimp - 1;
+			put_task_struct(cur);
 			cur = NULL;
 			goto assign;
 		}
@@ -1254,8 +1262,12 @@ balance:
 
 assign:
 	task_numa_assign(env, cur, imp);
+	cur = NULL;
 unlock:
 	rcu_read_unlock();
+
+	if (cur)
+		put_task_struct(cur);
 }
 
 static void task_numa_find_cpu(struct task_numa_env *env,

