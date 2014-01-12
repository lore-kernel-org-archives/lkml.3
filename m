Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbaALU6Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 15:58:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39109 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaALU6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 15:58:23 -0500
Date: Sun, 12 Jan 2014 21:58:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: check && lockdep_no_validate (Was: lockdep: Introduce wait-type
 checks)
Message-ID: <20140112205814.GP7572@laptop.programming.kicks-ass.net>
References: <20140109111516.GE7572@laptop.programming.kicks-ass.net>
 <20140109163120.GA8038@redhat.com>
 <20140109170823.GF7572@laptop.programming.kicks-ass.net>
 <20140109175448.GA17673@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109175448.GA17673@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 06:54:48PM +0100, Oleg Nesterov wrote:
> But this connects to lockdep_no_validate. Not sure I understand what
> this class should actually do, but consider this code:
> 
> 	DEFINE_MUTEX(m1);
> 	DEFINE_MUTEX(m2);
> 	DEFINE_MUTEX(mx);
> 
> 	void lockdep_should_complain(void)
> 	{
> 		lockdep_set_novalidate_class(&mx);
> 
> 		// m1 -> mx -> m2
> 		mutex_lock(&m1);
> 		mutex_lock(&mx);
> 		mutex_lock(&m2);
> 		mutex_unlock(&m2);
> 		mutex_unlock(&mx);
> 		mutex_unlock(&m1);
> 
> 
> 		// m2 -> m1 ; should trigger the warning
> 		mutex_lock(&m2);
> 		mutex_lock(&m1);
> 		mutex_unlock(&m1);
> 		mutex_unlock(&m2);
> 	}
> 
> lockdep doesn't not detect the trivial possible deadlock.
> 
> The patch below seems to work but most probably it is not right, and
> I forgot everything (not too much) I knew about lockdep internals.
> 
> Oleg.
> 
> --- a/kernel/locking/lockdep.c
> +++ b/kernel/locking/lockdep.c
> @@ -1939,7 +1939,8 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
>  		 * Only non-recursive-read entries get new dependencies
>  		 * added:
>  		 */
> -		if (hlock->read != 2) {
> +		if (hlock->read != 2 &&
> +		    hlock->instance->key != &__lockdep_no_validate__) {
>  			if (!check_prev_add(curr, hlock, next,
>  						distance, trylock_loop))
>  				return 0;
> 

Hmm, you are quite right indeed; although I would write it like:

  if (hlock->read != 2 && hlock->check == 2)

because the __lockdep_no_validate__ thing forces the ->check value to 1.
