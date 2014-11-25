Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbaKYRH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:07:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbaKYRH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:07:26 -0500
Date: Tue, 25 Nov 2014 18:07:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] exit: pidns: alloc_pid() leaks pid_namespace if
	child_reaper is exiting
Message-ID: <20141125170718.GA29360@redhat.com>
References: <20141124200629.GA21009@redhat.com> <87vbm4ff0r.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vbm4ff0r.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > --- a/kernel/pid.c
> > +++ b/kernel/pid.c
> > @@ -320,7 +320,6 @@ struct pid *alloc_pid(struct pid_namespace *ns)
> >  			goto out_free;
> >  	}
> >
> > -	get_pid_ns(ns);
> >  	atomic_set(&pid->count, 1);
> >  	for (type = 0; type < PIDTYPE_MAX; ++type)
> >  		INIT_HLIST_HEAD(&pid->tasks[type]);
> > @@ -336,7 +335,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
> >  	}
> >  	spin_unlock_irq(&pidmap_lock);
> >
> > -out:
> > +	get_pid_ns(ns);
>
> Moving the label and changing the goto out logic is gratuitous confusing
> and I think it probably even generates worse code.
>
> Furthermore multiple exits make adding debugging code more difficult.

Oh, I strongly disagree but I am not going to argue ;) cleanups are
always subjective, and I do believe in "maintainer is always right"
mantra. I can make v2 without this change.

> Moving get_pid_ns down does close a leak in the error handling path.

OK, good.

> However at the moment my I can't figure out if it is safe to move
> get_pid_ns elow hlist_add_head_rcu.  Because once we are on the rcu list
> the pid is findable, and being publicly visible with a bad refcount could cause
> problems.

The caller has a reference, this ns can't go away. Obviously, otherwise
get_pid_ns(ns) is not safe.

We need this get_pid_ns() to balance put_pid()->put_pid_ns() which obviously
won't be called until we return this pid, otherwise everything is wrong.

So I think this should be safe?

Oleg.

