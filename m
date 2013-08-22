Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab3HVSVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 14:21:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab3HVSVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 14:21:31 -0400
Date: Thu, 22 Aug 2013 20:15:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Brad Spengler <spender@grsecurity.net>,
        Colin Walters <walters@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] fork: unify and tighten up
	CLONE_NEWUSER/CLONE_NEWPID checks
Message-ID: <20130822181536.GA22995@redhat.com>
References: <20130822170939.GA20296@redhat.com> <20130822171004.GA20324@redhat.com> <CALCETrU9D59MqxPm2SNegPFH_+gpPfoQJkD2E2Q8zjJ94QhLDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU9D59MqxPm2SNegPFH_+gpPfoQJkD2E2Q8zjJ94QhLDg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22, Andy Lutomirski wrote:
>
> On Thu, Aug 22, 2013 at 10:10 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > do_fork() denies CLONE_THREAD | CLONE_PARENT if NEWUSER | NEWPID.
> >
> > Then later copy_process() denies CLONE_SIGHAND if the new process
> > will be in a different pid namespace (task_active_pid_ns() doesn't
> > match current->nsproxy->pid_ns).
> >
> > This looks confusing and inconsistent. CLONE_NEWPID is very similar
> > to the case when ->pid_ns was already unshared, we want the same
> > restrictions so copy_process() should also nack CLONE_PARENT.
> >
> > And it would be better to deny CLONE_NEWUSER && CLONE_SIGHAND as
> > well just for consistency.
> >
> > Kill the "CLONE_NEWUSER | CLONE_NEWPID" check in do_fork() and
> > change copy_process() to the same check along with nsproxy->pid_ns
> > we already have.
>
> Did the old code actually prevent clone(CLONE_PARENT | CLONE_NEWPID)?
> The new code explicitly does, and that looks like a good thing.


Yes. Before this patch do_fork() did:

	if (clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) {
		if (clone_flags & (CLONE_THREAD|CLONE_PARENT))
			return -EINVAL;
	}

however, let me repeat, CLONE_PARENT after unshare(CLONE_NEWPID) was
allowed. With this patch CLONE_PARENT is nacked in both cases.

Oleg.

