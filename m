Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbaJQRWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 13:22:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbaJQRWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 13:22:23 -0400
Date: Fri, 17 Oct 2014 19:19:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Michal Hocko <mhocko@suse.cz>, Cong Wang <xiyou.wangcong@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: + oom-pm-oom-killed-task-cannot-escape-pm-suspend.patch added
	to -mm tree
Message-ID: <20141017171904.GA12263@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, I am not really arguing with this patch, but since you are going
(iiuc) to resend it anyway let me ask a couple of questions.

> This, however, still keeps
> a window open when a killed task didn't manage to die by the time
> freeze_processes finishes.

Sure,

> Fix this race by checking all tasks after OOM killer has been disabled.

But this doesn't close the race entirely? please see below.

>  int freeze_processes(void)
>  {
>  	int error;
> +	int oom_kills_saved;
>
>  	error = __usermodehelper_disable(UMH_FREEZING);
>  	if (error)
> @@ -132,12 +133,40 @@ int freeze_processes(void)
>  	pm_wakeup_clear();
>  	printk("Freezing user space processes ... ");
>  	pm_freezing = true;
> +	oom_kills_saved = oom_kills_count();
>  	error = try_to_freeze_tasks(true);
>  	if (!error) {
> -		printk("done.");
>  		__usermodehelper_set_disable_depth(UMH_DISABLED);
>  		oom_killer_disable();
> +
> +		/*
> +		 * There was a OOM kill while we were freezing tasks
> +		 * and the killed task might be still on the way out
> +		 * so we have to double check for race.
> +		 */
> +		if (oom_kills_count() != oom_kills_saved) {

OK, I agree, this makes the things better, but perhaps we should document
(at least in the changelog) that this is still racy. oom_killer_disable()
obviously can stop the already called out_of_memory(), it can kill a frozen
task right after this check or even after the loop before.

> +			struct task_struct *g, *p;
> +
> +			read_lock(&tasklist_lock);
> +			do_each_thread(g, p) {
> +				if (p == current || freezer_should_skip(p) ||
> +				    frozen(p))
> +					continue;
> +				error = -EBUSY;
> +				break;
> +			} while_each_thread(g, p);

Please use for_each_process_thread(), do/while_each_thread is deprecated.

> +/*
> + * Number of OOM killer invocations (including memcg OOM killer).
> + * Primarily used by PM freezer to check for potential races with
> + * OOM killed frozen task.
> + */
> +static atomic_t oom_kills = ATOMIC_INIT(0);
> +
> +int oom_kills_count(void)
> +{
> +	return atomic_read(&oom_kills);
> +}
> +
>  #define K(x) ((x) << (PAGE_SHIFT-10))
>  /*
>   * Must be called while holding a reference to p, which will be released upon
> @@ -504,11 +516,13 @@ void oom_kill_process(struct task_struct
>  			pr_err("Kill process %d (%s) sharing same memory\n",
>  				task_pid_nr(p), p->comm);
>  			task_unlock(p);
> +			atomic_inc(&oom_kills);

Do we really need this? Can't freeze_processes() (ab)use oom_notify_list?

Yes, we can have more false positives this way, but probably this doesn't
matter? This is unlikely case anyway.

Oleg.

