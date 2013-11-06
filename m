Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab3KFUFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:05:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab3KFUFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:05:32 -0500
Date: Wed, 6 Nov 2013 21:06:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        Brad Spengler <spender@grsecurity.net>,
        Christian Seiler <christian@iwakd.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Lxc development list <lxc-devel@lists.sourceforge.net>
Subject: Re: CLONE_PARENT after setns(CLONE_NEWPID)
Message-ID: <20131106200650.GA20212@redhat.com>
References: <20131106180232.GA8980@ac100> <20131106193311.GA18720@redhat.com> <CALCETrV=G30_4bVQbRF0Z9kzYpP8V+aUf-uZES+qVD5MXEAWZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV=G30_4bVQbRF0Z9kzYpP8V+aUf-uZES+qVD5MXEAWZQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06, Andy Lutomirski wrote:
>
> On Wed, Nov 6, 2013 at 11:33 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > Hi Serge,
> >
> > On 11/06, Serge Hallyn wrote:
> >>
> >> Hi Oleg,
> >>
> >> commit 40a0d32d1eaffe6aac7324ca92604b6b3977eb0e :
> >> "fork: unify and tighten up CLONE_NEWUSER/CLONE_NEWPID checks"
> >> breaks lxc-attach in 3.12.  That code forks a child which does
> >> setns() and then does a clone(CLONE_PARENT).  That way the
> >> grandchild can be in the right namespaces (which the child was
> >> not) and be a child of the original task, which is the monitor.
> >
> > Thanks...
> >
> > Yes, this is what 40a0d32d1ea explicitly tries to disallow.
> >
> >> Is there a real danger in allowing CLONE_PARENT
> >> when current->nsproxy->pidns_for_children is not our pidns,
> >> or was this done out of an "over-abundance of caution"?
> >
> > I am not sure... This all was based on the long discussion, and
> > it was decided that the CLONE_PARENT check should be consistent
> > wrt CLONE_NEWPID and pidns_for_children != task_active_pid_ns().
> >
> >> Can we
> >> safely revert that new extra check?
> >
> > Well, usually we do not break user-space, but I am not sure about
> > this case...
>
> Presumably if we allow this, then we should also allow
> clone(CLONE_NEWPID | CLONE_PARENT).

Yes, agreed. but this means another change, this was forbidden even
before this commit.

> This seems a little odd, but off
> the top of my head it doesn't seem obviously dangerous.

I do not see any "strong" reason too. At least right now... But I would
say that it would be better to not allow to abuse ->real_parent, it
doesn't event know about the new child (if CLONE_PARENT).

> (Why were we worried about this in the first place?  The comment says
> that we don't want signal handlers or thread groups to span
> namespaces, but CLONE_PARENT has nothing to do with that.)

it also says "or parent" ;)

> I feel like I'm rehashing something ancient, but shouldn't that code just be:
>
> if (clone_flags & CLONE_VM) {
>   // check for unsharing namespaces

No, this will break vfork().

And note that CLONE_SIGHAND was disallowed "just in case" and because
do_fork() had a similar check. Sharing the signal handlers is fine afaics.

>From e79f525e:

	We could probably even drop CLONE_SIGHAND and use CLONE_THREAD, but it
	would be safer to not do this.  The current check denies CLONE_SIGHAND
	implicitely and there is no reason to change this.

And I disagree with

	Eric said "CLONE_SIGHAND is fine.  CLONE_THREAD would be even better.
	Having shared signal handling between two different pid namespaces is
	the case that we are fundamentally guarding against."

added during the merging ;) Or perhaps I misunderstood the text above. But this
all is off-topic.

Oleg.

