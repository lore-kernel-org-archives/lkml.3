Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab3E2EIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 00:08:44 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46660 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3E2EIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 00:08:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Sergey Dyasly <dserrg@gmail.com>,
        Sha Zhengju <handai.szj@taobao.com>, linux-kernel@vger.kernel.org
References: <20130527202816.GA19277@redhat.com>
Date: Tue, 28 May 2013 21:08:24 -0700
In-Reply-To: <20130527202816.GA19277@redhat.com> (Oleg Nesterov's message of
	"Mon, 27 May 2013 22:28:16 +0200")
Message-ID: <877gii2zt3.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19csMe3kbC+PkDwuVFXqfheOOjMOvu45ew=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2610]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/3] proc: first_tid: fix the potential use-after-free
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> proc_task_readdir() verifies that the result of get_proc_task()
> is pid_alive() and thus its ->group_leader is fine too. However
> this is not necessarily true after rcu_read_unlock(), we need
> to recheck this after first_tid() does rcu_read_lock() again.

I agree with you but you are missing something critical from your
explanation.  If a process has been passed through __unhash_process
then task->thread_group.next (aka next_thread) returns a pointer to the
process that was it's next thread in the thread group.  Importantly
that pointer is only guaranteed to point to valid memory until the rcu
grace period expires.

Which means that starting a walk of a thread list with a task that
could have been unhashed before the current rcu critical section
began is invalid, and can lead to following an invalid pointer.

> The race is subtle and unlikely, but still it is possible afaics.
> To simplify lets ignore the "likely" case when tid != 0, f_version
> can be cleared by proc_task_operations->llseek().
>
> Suppose we have a main thread M and its subthread T. Suppose that
> f_pos == 3, iow first_tid() should return T. Now suppose that the
> following happens between rcu_read_unlock() and rcu_read_lock():
>
> 	1. T execs and becomes the new leader. This removes M from
> 	    ->thread_group but next_thread(M) is still T.
>
> 	2. T creates another thread X which does exec as well, T
> 	   goes away.
>
> 	3. X creates another subthread, this increments nr_threads.
>
> 	4. first_tid() does next_thread(M) and returns the already
> 	   dead T.
>
> Note that we need 2. and 3. only because of get_nr_threads() check,
> and this check was supposed to be optimization only.

An optimization and denial of service attack prevention.  It keeps us
spinning for nearly unbounded amounts of time in the rcu critical
section.  But I agree it should not be needed from this part of
correctness.

> Note: I think that proc_task_readdir/first_tid interaction can be
> simplified, but this needs another patch. proc_task_readdir() should
> not play with ->group_leader at all. See the next patches.

That sounds right.  I seem to recall that there was a purpose in keeping
the leader pinned but it looks like that purpose is long since gone.

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  fs/proc/base.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index dd51e50..c939c9f 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -3186,10 +3186,13 @@ static struct task_struct *first_tid(struct task_struct *leader,
>  			goto found;
>  	}
>  
> -	/* If nr exceeds the number of threads there is nothing todo */
>  	pos = NULL;
> +	/* If nr exceeds the number of threads there is nothing todo */

Moving the comment is just noise and makes for confusing reading of your
patch.

>  	if (nr && nr >= get_nr_threads(leader))
>  		goto out;
> +	/* It could be unhashed before we take rcu lock */
> +	if (!pid_alive(leader))
> +		goto out;
>  
>  	/* If we haven't found our starting place yet start
>  	 * with the leader and walk nr threads forward.
