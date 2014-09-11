Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbaIKNIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:08:52 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:57290 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556AbaIKNIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:08:48 -0400
Date: Thu, 11 Sep 2014 15:08:40 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140911130840.GH22042@dhcp22.suse.cz>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <20140909160625.GC4851@dhcp22.suse.cz>
 <20140909164658.GB11748@mtj.dyndns.org>
 <2008100.1EF7gjK5Z6@vostro.rjw.lan>
 <20140910132417.GF25219@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910132417.GF25219@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 10-09-14 15:24:17, Michal Hocko wrote:
> On Tue 09-09-14 22:53:32, Rafael J. Wysocki wrote:
> > On Wednesday, September 10, 2014 01:46:58 AM Tejun Heo wrote:
> > > Hello,
> > > 
> > > On Tue, Sep 09, 2014 at 06:06:25PM +0200, Michal Hocko wrote:
> > > > > Even for userland tasks, try_to_freeze() can currently be anywhere in
> > > > > the kernel.  The frequently used ones are few but there are some odd
> > > > 
> > > > I always thought that user space tasks can be in the fridge only on the
> > > > way out from the kernel (get_signal_to_deliver). I have quickly greped
> > > 
> > > It *can* be anywhere.  We used to have some deep in nfs.  They got
> > > removed later due to deadlocks but in theory they still can be
> > > anywhere.
> > 
> > Well, it would be good to determine the difference between theory and practice
> > in this particular respect, because if in practice it can't be anywhere,
> > we can just set an "every new instance of try_to_freeze() has to be documented"
> > rule (which may not be a bad idea anyway) and disallow people to break things.
> 
> What do you think about this way to help distinguish kernel threads and
> user processes and keep the future maintenance of freezer saner?

This is not enough. I have completely missed freezer_count... Will have
to think about this. There is quite large base of callers of this... It
won't be trivial to check whether all of them are safe. Especially after
467de1fc67d1b which made the functionality usable for !user tasks as
well. Btw. is this even desirable? The follow up patch (33e638b9070b)
have (ab)used freezer_{do_not_}count just to be reverted later by
72081624d5ad3. I haven't checked other kernel thread users which might be
added later. Don't rather put try_to_freeze_user_task into freezer_count
to reflect the original intention (assuming that a separate API for user
and kthread is desirable of course).

> ---
> From 0a28200a4439283753c10acabd1bcd7cc5989aae Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Wed, 10 Sep 2014 11:04:40 +0200
> Subject: [PATCH] freezer: make freezing of user tasks and kernel threads clear
> 
> There are slightly different requirements for kernel threads and user
> tasks freezing. User tasks might get killed while they are in the fridge
> (e.g. by OOM killer) and we have to make sure that such a task will die
> as soon as possible. This means that try_to_freeze cannot be called from
> an arbitrary code path.
> 
> The obviously safe place is on the way out from the kernel. We have two
> such places currently, get_signal_to_deliver which is the main point
> for user tasks freezing called on the way to userspace and lguest which
> expedites return to the userspace as well when signals are pending.
> 
> Any new caller should be added with extreme caution and proper
> justification. This is quite hard right now because both kernel threads
> and user tasks context are calling the same function. This patch
> keeps the old try_to_freeze only for kernel threads and adds a new
> try_to_freeze_user_task which is aimed at user tasks. Both check process
> flag and warn about improper usage.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  drivers/lguest/core.c   |  2 +-
>  include/linux/freezer.h | 28 +++++++++++++++++++++++++++-
>  kernel/signal.c         |  2 +-
>  3 files changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/lguest/core.c b/drivers/lguest/core.c
> index 6590558d1d31..d8eb5ec8bcc7 100644
> --- a/drivers/lguest/core.c
> +++ b/drivers/lguest/core.c
> @@ -239,7 +239,7 @@ int run_guest(struct lg_cpu *cpu, unsigned long __user *user)
>  		 * thing called the freezer.  If the Host is trying to suspend,
>  		 * it stops us.
>  		 */
> -		try_to_freeze();
> +		try_to_freeze_user_task();
>  
>  		/* Check for signals */
>  		if (signal_pending(current))
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index 7fd81b8c4897..2683ad5fdfe8 100644
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -59,13 +59,39 @@ static inline bool try_to_freeze_unsafe(void)
>  	return __refrigerator(false);
>  }
>  
> -static inline bool try_to_freeze(void)
> +/* A helper function. Do not use directly. */
> +static inline bool __try_to_freeze(void)
>  {
>  	if (!(current->flags & PF_NOFREEZE))
>  		debug_check_no_locks_held();
>  	return try_to_freeze_unsafe();
>  }
>  
> +/*
> + * Only kernel threads are allowed to call try_to_freeze.
> + */
> +static inline bool try_to_freeze(void)
> +{
> +	WARN_ON(!(current->flags & PF_KTHREAD));
> +
> +	return __try_to_freeze();
> +}
> +
> +/*
> + * User tasks might get frozen only on specific places
> + * where we know they will get to user space or die on
> + * signal very quickly.
> + *
> + * Every new user of this function has to be consulted with
> + * PM/freezer maintainers.
> + */
> +static inline bool try_to_freeze_user_task(void)
> +{
> +	WARN_ON(current->flags & PF_KTHREAD);
> +
> +	return __try_to_freeze();
> +}
> +
>  extern bool freeze_task(struct task_struct *p);
>  extern bool set_freezable(void);
>  
> diff --git a/kernel/signal.c b/kernel/signal.c
> index a4077e90f19f..c1860564a74d 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2184,7 +2184,7 @@ int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
>  	 * do_signal_stop() and ptrace_stop() do freezable_schedule() and
>  	 * thus do not need another check after return.
>  	 */
> -	try_to_freeze();
> +	try_to_freeze_user_task();
>  
>  relock:
>  	spin_lock_irq(&sighand->siglock);
> -- 
> 2.1.0
> 
> -- 
> Michal Hocko
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
