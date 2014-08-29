Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaH2G6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 02:58:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:34165 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbaH2G6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 02:58:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,423,1406617200"; 
   d="scan'208";a="473717537"
Message-ID: <540023BE.90902@intel.com>
Date: Fri, 29 Aug 2014 14:54:54 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
CC: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH RFC tip/core/rcu] Eliminate deadlock between CPU hotplug
 and expedited grace periods
References: <20140828194745.GA3761@linux.vnet.ibm.com>
In-Reply-To: <20140828194745.GA3761@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年08月29日 03:47, Paul E. McKenney wrote:
> Currently, the expedited grace-period primitives do get_online_cpus().
> This greatly simplifies their implementation, but means that calls to
> them holding locks that are acquired by CPU-hotplug notifiers (to say
> nothing of calls to these primitives from CPU-hotplug notifiers) can
> deadlock.  But this is starting to become inconvenient:
> https://lkml.org/lkml/2014/8/5/754
> 
> This commit avoids the deadlock and retains the simplicity by creating
> a try_get_online_cpus(), which returns false if the get_online_cpus()
> reference count could not immediately be incremented.  If a call to
> try_get_online_cpus() returns true, the expedited primitives operate
> as before.  If a call returns false, the expedited primitives fall back
> to normal grace-period operations.  This falling back of course results
> in increased grace-period latency, but only during times when CPU
> hotplug operations are actually in flight.  The effect should therefore
> be negligible during normal operation.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Lan Tianyu <tianyu.lan@intel.com>
> 

Hi Paul:
	I tested this patch and it fixes my issue. Thanks.

Tested-by: Lan Tianyu <tianyu.lan@intel.com>

> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
> index 95978ad7fcdd..b2d9a43012b2 100644
> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -213,6 +213,7 @@ extern struct bus_type cpu_subsys;
>  extern void cpu_hotplug_begin(void);
>  extern void cpu_hotplug_done(void);
>  extern void get_online_cpus(void);
> +extern bool try_get_online_cpus(void);
>  extern void put_online_cpus(void);
>  extern void cpu_hotplug_disable(void);
>  extern void cpu_hotplug_enable(void);
> @@ -230,6 +231,7 @@ int cpu_down(unsigned int cpu);
>  static inline void cpu_hotplug_begin(void) {}
>  static inline void cpu_hotplug_done(void) {}
>  #define get_online_cpus()	do { } while (0)
> +#define try_get_online_cpus()	true
>  #define put_online_cpus()	do { } while (0)
>  #define cpu_hotplug_disable()	do { } while (0)
>  #define cpu_hotplug_enable()	do { } while (0)
> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index 008388f920d7..4f86465cc317 100644
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -505,6 +505,7 @@ static inline void print_irqtrace_events(struct task_struct *curr)
>  
>  #define lock_map_acquire(l)			lock_acquire_exclusive(l, 0, 0, NULL, _THIS_IP_)
>  #define lock_map_acquire_read(l)		lock_acquire_shared_recursive(l, 0, 0, NULL, _THIS_IP_)
> +#define lock_map_acquire_tryread(l)		lock_acquire_shared_recursive(l, 0, 1, NULL, _THIS_IP_)
>  #define lock_map_release(l)			lock_release(l, 1, _THIS_IP_)
>  
>  #ifdef CONFIG_PROVE_LOCKING
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 81e2a388a0f6..356450f09c1f 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -79,6 +79,8 @@ static struct {
>  
>  /* Lockdep annotations for get/put_online_cpus() and cpu_hotplug_begin/end() */
>  #define cpuhp_lock_acquire_read() lock_map_acquire_read(&cpu_hotplug.dep_map)
> +#define cpuhp_lock_acquire_tryread() \
> +				  lock_map_acquire_tryread(&cpu_hotplug.dep_map)
>  #define cpuhp_lock_acquire()      lock_map_acquire(&cpu_hotplug.dep_map)
>  #define cpuhp_lock_release()      lock_map_release(&cpu_hotplug.dep_map)
>  
> @@ -91,10 +93,22 @@ void get_online_cpus(void)
>  	mutex_lock(&cpu_hotplug.lock);
>  	cpu_hotplug.refcount++;
>  	mutex_unlock(&cpu_hotplug.lock);
> -
>  }
>  EXPORT_SYMBOL_GPL(get_online_cpus);
>  
> +bool try_get_online_cpus(void)
> +{
> +	if (cpu_hotplug.active_writer == current)
> +		return true;
> +	if (!mutex_trylock(&cpu_hotplug.lock))
> +		return false;
> +	cpuhp_lock_acquire_tryread();
> +	cpu_hotplug.refcount++;
> +	mutex_unlock(&cpu_hotplug.lock);
> +	return true;
> +}
> +EXPORT_SYMBOL_GPL(try_get_online_cpus);
> +
>  void put_online_cpus(void)
>  {
>  	if (cpu_hotplug.active_writer == current)
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index d7a3b13bc94c..04558f0c9d64 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -2940,11 +2940,6 @@ static int synchronize_sched_expedited_cpu_stop(void *data)
>   * restructure your code to batch your updates, and then use a single
>   * synchronize_sched() instead.
>   *
> - * Note that it is illegal to call this function while holding any lock
> - * that is acquired by a CPU-hotplug notifier.  And yes, it is also illegal
> - * to call this function from a CPU-hotplug notifier.  Failing to observe
> - * these restriction will result in deadlock.
> - *
>   * This implementation can be thought of as an application of ticket
>   * locking to RCU, with sync_sched_expedited_started and
>   * sync_sched_expedited_done taking on the roles of the halves
> @@ -2994,7 +2989,12 @@ void synchronize_sched_expedited(void)
>  	 */
>  	snap = atomic_long_inc_return(&rsp->expedited_start);
>  	firstsnap = snap;
> -	get_online_cpus();
> +	if (!try_get_online_cpus()) {
> +		/* CPU hotplug operation in flight, fall back to normal GP. */
> +		wait_rcu_gp(call_rcu_sched);
> +		atomic_long_inc(&rsp->expedited_normal);
> +		return;
> +	}
>  	WARN_ON_ONCE(cpu_is_offline(raw_smp_processor_id()));
>  
>  	/*
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index fb833811c2f6..821dcf9a3b94 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -793,11 +793,6 @@ sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
>   * In fact, if you are using synchronize_rcu_expedited() in a loop,
>   * please restructure your code to batch your updates, and then Use a
>   * single synchronize_rcu() instead.
> - *
> - * Note that it is illegal to call this function while holding any lock
> - * that is acquired by a CPU-hotplug notifier.  And yes, it is also illegal
> - * to call this function from a CPU-hotplug notifier.  Failing to observe
> - * these restriction will result in deadlock.
>   */
>  void synchronize_rcu_expedited(void)
>  {
> @@ -819,7 +814,11 @@ void synchronize_rcu_expedited(void)
>  	 * being boosted.  This simplifies the process of moving tasks
>  	 * from leaf to root rcu_node structures.
>  	 */
> -	get_online_cpus();
> +	if (!try_get_online_cpus()) {
> +		/* CPU-hotplug operation in flight, fall back to normal GP. */
> +		wait_rcu_gp(call_rcu);
> +		return;
> +	}
>  
>  	/*
>  	 * Acquire lock, falling back to synchronize_rcu() if too many
> 


-- 
Best regards
Tianyu Lan
