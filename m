Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966037Ab3E2MeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 08:34:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965855Ab3E2MeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 08:34:08 -0400
Date: Wed, 29 May 2013 14:30:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Sergey Dyasly <dserrg@gmail.com>,
        Sha Zhengju <handai.szj@taobao.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] proc: first_tid: fix the potential use-after-free
Message-ID: <20130529123009.GA5741@redhat.com>
References: <20130527202816.GA19277@redhat.com> <877gii2zt3.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gii2zt3.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > proc_task_readdir() verifies that the result of get_proc_task()
> > is pid_alive() and thus its ->group_leader is fine too. However
> > this is not necessarily true after rcu_read_unlock(), we need
> > to recheck this after first_tid() does rcu_read_lock() again.
>
> I agree with you but you are missing something critical from your
> explanation.  If a process has been passed through __unhash_process
> then task->thread_group.next (aka next_thread) returns a pointer to the
> process that was it's next thread in the thread group.  Importantly
> that pointer is only guaranteed to point to valid memory until the rcu
> grace period expires.

I tried to explain this below, in 1-4 steps... But OK, agreed, this
should be explained more clearly.

I'll update the changelog.

> > Note that we need 2. and 3. only because of get_nr_threads() check,
> > and this check was supposed to be optimization only.
>
> An optimization and denial of service attack prevention.  It keeps us
> spinning for nearly unbounded amounts of time in the rcu critical
> section.

I do not really think we need this check to prevent the DoS attacks.

The main loop does while_each_thread(), so it will stop after
nr_threads iterations. And a user can always do llseek to trigger
the "full" scan.

But this is off-topic, and

> But I agree it should not be needed from this part of
> correctness.

Yes.

> >
> > -	/* If nr exceeds the number of threads there is nothing todo */
> >  	pos = NULL;
> > +	/* If nr exceeds the number of threads there is nothing todo */
>
> Moving the comment is just noise and makes for confusing reading of your
> patch.

Well, I think this makes the code look a bit better. Without this change
the code will be

        /* If nr exceeds the number of threads there is nothing todo */
        pos = NULL;
        if (nr && nr >= get_nr_threads(leader))
                goto out;
        /* It could be unhashed before we take rcu lock */
        if (!pid_alive(leader))
                goto out;

and the comments explaining the checks are not "simmetrical". But I won't
argue, I'll update the patch and remove it. 3/3 changes this code anyway.

Oleg.

