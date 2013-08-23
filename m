Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab3HWOma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 10:42:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755311Ab3HWOm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 10:42:29 -0400
Date: Fri, 23 Aug 2013 15:59:23 +0200
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
Message-ID: <20130823135923.GA16773@redhat.com>
References: <20130822170939.GA20296@redhat.com> <20130822171004.GA20324@redhat.com> <CALCETrU9D59MqxPm2SNegPFH_+gpPfoQJkD2E2Q8zjJ94QhLDg@mail.gmail.com> <20130822181536.GA22995@redhat.com> <CALCETrW3gnXjUqvm-jNZq6k_qSnTN5=VNRCp+gNC+t2YtBBMYQ@mail.gmail.com> <20130822183250.GA23769@redhat.com> <CALCETrVT4r3G9tQpt4y22iB+y-fw5piH93OOn9wfvSd8xQdDBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVT4r3G9tQpt4y22iB+y-fw5piH93OOn9wfvSd8xQdDBw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22, Andy Lutomirski wrote:
>
> On Thu, Aug 22, 2013 at 11:32 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 08/22, Andy Lutomirski wrote:
> >>
> >> On Thu, Aug 22, 2013 at 11:15 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >> >
> >> > Yes. Before this patch do_fork() did:
> >> >
> >> >         if (clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) {
> >> >                 if (clone_flags & (CLONE_THREAD|CLONE_PARENT))
> >> >                         return -EINVAL;
> >> >         }
> >> >
> >> > however, let me repeat, CLONE_PARENT after unshare(CLONE_NEWPID) was
> >> > allowed. With this patch CLONE_PARENT is nacked in both cases.
> >>
> >> Is this -stable-worthy?
> >
> > Honestly, I do not know. I do not want to abuse -stable, and I will
> > sleep better if this patch won't go into the stable trees ;)
> >
> > OTOH, I think that at least 1/3 is probably -stable material... Since
> > I am going to send v2, I would not mind to add stable@vger.kernel.org
> > if both you and Eric agree.
>
> This may allow creation of a process with tgid and pid in different
> pid namespaces.  If so, I have no idea what the consequences would be.

and share the parent with the creator.

Not good. But probably not too bad, one can abuse ->pidns_install()
anyway, create a child in another ns, exit. Like it or not but pid_ns
is "special" and you even sent the patch to reflect this sad^W fact.

Anyway. The main point of this patch is the consistency (plus imho it
cleanups/simplifies the code). Both CLONE_NEWPID and
"task_active_pid_ns() != pid_ns" create a task in another namespace,
we should use the same restrictions.

And you seem to agree with this change, can I take it as your ack ?
I am going to preserve your acks in 1-2 and resend.

Oleg.

