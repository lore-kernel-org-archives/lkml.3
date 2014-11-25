Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750984AbaKYSPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:15:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaKYSPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:15:30 -0500
Date: Tue, 25 Nov 2014 19:15:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] exit: pidns: alloc_pid() leaks pid_namespace if
	child_reaper is exiting
Message-ID: <20141125181521.GA31963@redhat.com>
References: <20141124200629.GA21009@redhat.com> <87vbm4ff0r.fsf@x220.int.ebiederm.org> <20141125170718.GA29360@redhat.com> <87lhmzb24c.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lhmzb24c.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > On 11/24, Eric W. Biederman wrote:
> >>
> >> However at the moment my I can't figure out if it is safe to move
> >> get_pid_ns elow hlist_add_head_rcu.  Because once we are on the rcu list
> >> the pid is findable, and being publicly visible with a bad refcount could cause
> >> problems.
> >
> > The caller has a reference, this ns can't go away. Obviously, otherwise
> > get_pid_ns(ns) is not safe.
> >
> > We need this get_pid_ns() to balance put_pid()->put_pid_ns() which obviously
> > won't be called until we return this pid, otherwise everything is wrong.
> >
> > So I think this should be safe?
>
> My concern is exposing a half initialized struct pid to the world via an
> rcu data structure.  In particular could one of the rcu users get into
> trouble because we haven't called get_pid_ns yet?  That is unclear to me.

They can't. This pid was fully initialized, in particular
pid->numbers[pid->level].ns == ns has a reference.

Just it is not ready for put_pid() which will be called by the "owner" of
this pid, the caller or the new child. So in this sense it doesn't matter
when we call get_pid_ns(), just we need to do this before return.

> That is one of those weird nasty races I would rather not have to
> consider and moving the get_pid_ns after hlist_add requires that we
> think about it.
>
> To fix the error handling and avoid thinking about the races we have two
> choices:
> - In the error path that is currently called out_unlock we can drop the
>   extra references.
> - Immediately after we perform the test that on error jumps to out_unlock
>   we call get_pid_ns.
>
> My preference would be the first, as it is a trivially correct one line
> change.
>
> Aka I think this is the obviously correct trivial fix.
>
>  out_unlock:
>  	spin_unlock_irq(&pidmap_lock);
> +	put_pid_ns(ns);

Sure, initially I was going to do this. But this is sub-optimal imo, I mainly
mean less clear (imho).

But again, I won't argue. I'll send V2 once we finish the discussion about 2/2.

Oleg.

