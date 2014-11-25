Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaKYS7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:59:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbaKYS71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:59:27 -0500
Date: Tue, 25 Nov 2014 19:59:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] exit: pidns: alloc_pid() leaks pid_namespace if
	child_reaper is exiting
Message-ID: <20141125185919.GA1779@redhat.com>
References: <20141124200629.GA21009@redhat.com> <87vbm4ff0r.fsf@x220.int.ebiederm.org> <20141125170718.GA29360@redhat.com> <87lhmzb24c.fsf@x220.int.ebiederm.org> <20141125181521.GA31963@redhat.com> <87wq6j9l4s.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wq6j9l4s.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > On 11/25, Eric W. Biederman wrote:
> >>
> >> My concern is exposing a half initialized struct pid to the world via an
> >> rcu data structure.  In particular could one of the rcu users get into
> >> trouble because we haven't called get_pid_ns yet?  That is unclear to me.
> >
> > They can't. This pid was fully initialized, in particular
> > pid->numbers[pid->level].ns == ns has a reference.
> >
> > Just it is not ready for put_pid() which will be called by the "owner" of
> > this pid, the caller or the new child. So in this sense it doesn't matter
> > when we call get_pid_ns(), just we need to do this before return.
>
> Or by someone calling find_get_pid() ... put_pid().
>
> Now the reference count should not hit zero in that case

Yes. this get_pid_ns() connects to atomic_set(&pid->count, 1) set by us.

> but I hate to
> think of that case separately.

OK.

> At this point, and especially since we need to Cc stable and get this
> fix backported to who knows how many kernel releases having something
> that is trivial to validate is correct is important.

OK. I'll send V2 with -stable cc'ed.

Oleg.

