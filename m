Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbaFZTVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:21:24 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45723 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaFZTVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:21:22 -0400
Date: Thu, 26 Jun 2014 12:21:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] rcu: uninline rcu_lock_acquire() and
 rcu_lock_release()
Message-ID: <20140626192117.GW4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140626170116.GA28558@redhat.com>
 <20140626170143.GA28565@redhat.com>
 <20140626173327.GA1001@redhat.com>
 <20140626183657.GA18550@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140626183657.GA18550@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062619-9332-0000-0000-00000135C041
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 08:36:57PM +0200, Oleg Nesterov wrote:
> On 06/26, Oleg Nesterov wrote:
> >
> > On 06/26, Oleg Nesterov wrote:
> > >
> > > +static void rcu_release_map(struct lockdep_map *map, unsigned long ip)
> > > +{
> > > +	rcu_lockdep_assert_watching();
> > > +	__rcu_lock_release(&rcu_lock_map, ip);
> >                             ^^^^^^^^^^^^
> > OOPS. This should be "map". Please see v2 below.
> 
> Argh. Probably you should simply ignore me.

My day has been a bit like that as well.  I can only be thankful
for source-code control systems such as git...

> > +static void rcu_release_map(struct lockdep_map *map, unsigned long ip)
> > +{
> > +	rcu_lockdep_assert_watching();
> > +	__rcu_lock_release(&map, ip);
> 
> "map", not "&map". I fixed this before I sent v2, but apparently forgot to
> -add before --amend.
> 
> Sorry for noise.

Not a problem!  Looks generally sane, but with a bit of adjustment
still needed.

I got some test failures on v2:

o	Build breakage if built with CONFIG_DEBUG_LOCK_ALLOC=n.  I believe
	that the best way to fix this is to #ifdef out the bodies of
	__rcu_lock_acquire() and __rcu_lock_release(), but maybe you
	have something else in mind.

o	Lockdep splat as follows, which might well be due to the
	"&map" that you noted above:

	[    0.000000] =====================================
	[    0.000000] [ BUG: bad unlock balance detected! ]
	[    0.000000] 3.16.0-rc1+ #1 Not tainted
	[    0.000000] -------------------------------------
	[    0.000000] swapper/0 is trying to release lock (X?à<81>ÿÿÿÿ<97>^Sò<81>ÿÿÿÿX?à<81>ÿÿÿÿ{±ò<81>@B^O) at:
	[    0.000000] [<ffffffff8107cb61>] init_idle+0xc1/0x150
	[    0.000000] but there are no more locks to release!

And a few other things noted below.

							Thanx, Paul

> -------------------------------------------------------------------------------
> Subject: [PATCH v3 1/1] rcu: uninline rcu_lock_acquire() and rcu_lock_release()
> 
> Uninline rcu_lock_acquire() and rcu_lock_release() to shrink .text/data.
> The difference in "size vmlinux" looks good,
> 
> with CONFIG_DEBUG_LOCK_ALLOC
> 
> 	- 5377829 3018320 14757888 23154037
> 	+ 5352229 3010160 14757888 23120277
> 
> 33760 bytes saved.
> 
> with CONFIG_DEBUG_LOCK_ALLOC + CONFIG_PROVE_RCU + CONFIG_TREE_RCU_TRACE
> 
> 	- 5682283 3022936 14757888 23463107
> 	+ 5578667 3026776 14757888 23363331
> 
> saves 99776 bytes.

Nice savings!

> However, this obviously means that the "warn once" logic is moved from
> the current callers of rcu_lockdep_assert(rcu_is_watching()) to update.c.

Which should be fine.

> Also, with this patch we do not bother to report which function abused
> rcu_is_watching(), this should be clear from dump_stack().

Which also should be fine.  I was going to suggest a macro wrapper, but
that would of course bloat the kernel with the function names...

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  include/linux/rcupdate.h |   55 ++++++++++++++++++++++---------------------
>  include/linux/srcu.h     |    4 +-
>  kernel/rcu/rcu.h         |    6 ++--
>  kernel/rcu/update.c      |   57 ++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 90 insertions(+), 32 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 5a75d19..a5b1631 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -379,18 +379,34 @@ static inline bool rcu_lockdep_current_cpu_online(void)
>  }
>  #endif /* #else #if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU) */
> 
> -#ifdef CONFIG_DEBUG_LOCK_ALLOC
> -
> -static inline void rcu_lock_acquire(struct lockdep_map *map)
> +static inline void __rcu_lock_acquire(struct lockdep_map *map, unsigned long ip)
>  {
> -	lock_acquire(map, 0, 0, 2, 0, NULL, _THIS_IP_);
> +	lock_acquire(map, 0, 0, 2, 0, NULL, ip);

I believe that the above line of code needs to be under #ifdef
CONFIG_DEBUG_LOCK_ALLOC, otherwise we get build failures due to
accesses to #ifdefed-out structure members and variables.

>  }
> 
> -static inline void rcu_lock_release(struct lockdep_map *map)
> +static inline void __rcu_lock_release(struct lockdep_map *map, unsigned long ip)
>  {
> -	lock_release(map, 1, _THIS_IP_);
> +	lock_release(map, 1, ip);

Ditto.

>  }
> 
> +#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_PROVE_RCU)

"#ifdef CONFIG_DEBUG_LOCK_ALLOC" should suffice here.  If CONFIG_PROVE_RCU
is set, then CONFIG_DEBUG_LOCK_ALLOC is guaranteed to also be set.

> +extern void rcu_lock_acquire(void);
> +extern void rcu_lock_release(void);
> +extern void rcu_lock_acquire_bh(void);
> +extern void rcu_lock_release_bh(void);
> +extern void rcu_lock_acquire_sched(void);
> +extern void rcu_lock_release_sched(void);
> +#else
> +#define rcu_lock_acquire()		do { } while (0)
> +#define rcu_lock_release()		do { } while (0)
> +#define rcu_lock_acquire_bh()		do { } while (0)
> +#define rcu_lock_release_bh()		do { } while (0)
> +#define rcu_lock_acquire_sched()	do { } while (0)
> +#define rcu_lock_release_sched()	do { } while (0)
> +#endif
> +
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +
>  extern struct lockdep_map rcu_lock_map;
>  extern struct lockdep_map rcu_bh_lock_map;
>  extern struct lockdep_map rcu_sched_lock_map;
> @@ -489,9 +505,6 @@ static inline int rcu_read_lock_sched_held(void)
> 
>  #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
> 
> -# define rcu_lock_acquire(a)		do { } while (0)
> -# define rcu_lock_release(a)		do { } while (0)
> -
>  static inline int rcu_read_lock_held(void)
>  {
>  	return 1;
> @@ -866,9 +879,7 @@ static inline void rcu_read_lock(void)
>  {
>  	__rcu_read_lock();
>  	__acquire(RCU);
> -	rcu_lock_acquire(&rcu_lock_map);
> -	rcu_lockdep_assert(rcu_is_watching(),
> -			   "rcu_read_lock() used illegally while idle");
> +	rcu_lock_acquire();
>  }
> 
>  /*
> @@ -888,9 +899,7 @@ static inline void rcu_read_lock(void)
>   */
>  static inline void rcu_read_unlock(void)
>  {
> -	rcu_lockdep_assert(rcu_is_watching(),
> -			   "rcu_read_unlock() used illegally while idle");
> -	rcu_lock_release(&rcu_lock_map);
> +	rcu_lock_release();
>  	__release(RCU);
>  	__rcu_read_unlock();
>  }
> @@ -916,9 +925,7 @@ static inline void rcu_read_lock_bh(void)
>  {
>  	local_bh_disable();
>  	__acquire(RCU_BH);
> -	rcu_lock_acquire(&rcu_bh_lock_map);
> -	rcu_lockdep_assert(rcu_is_watching(),
> -			   "rcu_read_lock_bh() used illegally while idle");
> +	rcu_lock_acquire_bh();
>  }
> 
>  /*
> @@ -928,9 +935,7 @@ static inline void rcu_read_lock_bh(void)
>   */
>  static inline void rcu_read_unlock_bh(void)
>  {
> -	rcu_lockdep_assert(rcu_is_watching(),
> -			   "rcu_read_unlock_bh() used illegally while idle");
> -	rcu_lock_release(&rcu_bh_lock_map);
> +	rcu_lock_release_bh();
>  	__release(RCU_BH);
>  	local_bh_enable();
>  }
> @@ -952,9 +957,7 @@ static inline void rcu_read_lock_sched(void)
>  {
>  	preempt_disable();
>  	__acquire(RCU_SCHED);
> -	rcu_lock_acquire(&rcu_sched_lock_map);
> -	rcu_lockdep_assert(rcu_is_watching(),
> -			   "rcu_read_lock_sched() used illegally while idle");
> +	rcu_lock_acquire_sched();
>  }
> 
>  /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
> @@ -971,9 +974,7 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
>   */
>  static inline void rcu_read_unlock_sched(void)
>  {
> -	rcu_lockdep_assert(rcu_is_watching(),
> -			   "rcu_read_unlock_sched() used illegally while idle");
> -	rcu_lock_release(&rcu_sched_lock_map);
> +	rcu_lock_release_sched();
>  	__release(RCU_SCHED);
>  	preempt_enable();
>  }
> diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> index a2783cb..5c06289 100644
> --- a/include/linux/srcu.h
> +++ b/include/linux/srcu.h
> @@ -219,7 +219,7 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
>  {
>  	int retval = __srcu_read_lock(sp);
> 
> -	rcu_lock_acquire(&(sp)->dep_map);
> +	__rcu_lock_acquire(&(sp)->dep_map, _THIS_IP_);
>  	return retval;
>  }
> 
> @@ -233,7 +233,7 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
>  static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
>  	__releases(sp)
>  {
> -	rcu_lock_release(&(sp)->dep_map);
> +	__rcu_lock_release(&(sp)->dep_map, _THIS_IP_);
>  	__srcu_read_unlock(sp, idx);
>  }
> 
> diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
> index bfda272..5702910 100644
> --- a/kernel/rcu/rcu.h
> +++ b/kernel/rcu/rcu.h
> @@ -103,16 +103,16 @@ static inline bool __rcu_reclaim(const char *rn, struct rcu_head *head)
>  {
>  	unsigned long offset = (unsigned long)head->func;
> 
> -	rcu_lock_acquire(&rcu_callback_map);
> +	__rcu_lock_acquire(&rcu_callback_map, _THIS_IP_);
>  	if (__is_kfree_rcu_offset(offset)) {
>  		RCU_TRACE(trace_rcu_invoke_kfree_callback(rn, head, offset));
>  		kfree((void *)head - offset);
> -		rcu_lock_release(&rcu_callback_map);
> +		__rcu_lock_release(&rcu_callback_map, _THIS_IP_);
>  		return 1;

Commit 08c11a77e8 in my -rcu tree chose a particularly bad time to
change this to "true" and the "0" below to "false".  Could you
please rebase on top of that commit?  (Easy enough for me to
hand-edit the patch, but the way today is going, I will probably
mess it up.)

>  	} else {
>  		RCU_TRACE(trace_rcu_invoke_callback(rn, head));
>  		head->func(head);
> -		rcu_lock_release(&rcu_callback_map);
> +		__rcu_lock_release(&rcu_callback_map, _THIS_IP_);
>  		return 0;
>  	}
>  }
> diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> index a2aeb4d..9cbdf52 100644
> --- a/kernel/rcu/update.c
> +++ b/kernel/rcu/update.c
> @@ -168,6 +168,63 @@ EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
> 
>  #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
> 
> +#if defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_PROVE_RCU)
> +
> +static void rcu_lockdep_assert_watching(void)
> +{
> +	rcu_lockdep_assert(rcu_is_watching(), "RCU used illegally while idle");
> +}
> +
> +static void rcu_acquire_map(struct lockdep_map *map, unsigned long ip)
> +{
> +	__rcu_lock_acquire(map, ip);
> +	rcu_lockdep_assert_watching();
> +}
> +
> +static void rcu_release_map(struct lockdep_map *map, unsigned long ip)
> +{
> +	rcu_lockdep_assert_watching();
> +	__rcu_lock_release(map, ip);
> +}
> +
> +void rcu_lock_acquire(void)
> +{
> +	rcu_acquire_map(&rcu_lock_map, _RET_IP_);
> +}
> +EXPORT_SYMBOL(rcu_lock_acquire);
> +
> +void rcu_lock_release(void)
> +{
> +	rcu_release_map(&rcu_lock_map, _RET_IP_);
> +}
> +EXPORT_SYMBOL(rcu_lock_release);
> +
> +void rcu_lock_acquire_bh(void)
> +{
> +	rcu_acquire_map(&rcu_bh_lock_map, _RET_IP_);
> +}
> +EXPORT_SYMBOL(rcu_lock_acquire_bh);
> +
> +void rcu_lock_release_bh(void)
> +{
> +	rcu_release_map(&rcu_bh_lock_map, _RET_IP_);
> +}
> +EXPORT_SYMBOL(rcu_lock_release_bh);
> +
> +void rcu_lock_acquire_sched(void)
> +{
> +	rcu_acquire_map(&rcu_sched_lock_map, _RET_IP_);
> +}
> +EXPORT_SYMBOL(rcu_lock_acquire_sched);
> +
> +void rcu_lock_release_sched(void)
> +{
> +	rcu_release_map(&rcu_sched_lock_map, _RET_IP_);
> +}
> +EXPORT_SYMBOL(rcu_lock_release_sched);
> +
> +#endif
> +
>  struct rcu_synchronize {
>  	struct rcu_head head;
>  	struct completion completion;
> -- 
> 1.5.5.1
> 
> 

