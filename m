Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab3LNPQp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 10:16:45 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:42908 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab3LNPQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 10:16:43 -0500
MIME-Version: 1.0
X-Originating-IP: [76.119.162.148]
In-Reply-To: <20131206144735.GA2674@redhat.com>
References: <20131205165953.GA24844@redhat.com>
	<2222358.CI2sulrSvj@sifl>
	<20131206144735.GA2674@redhat.com>
Date: Sat, 14 Dec 2013 10:16:43 -0500
Message-ID: <CAHC9VhQPn-aZ79BcO=Ljvn2V2fW9QdQ964M_yppJWoaQ-9_GLg@mail.gmail.com>
Subject: Re: [PATCH] selinux: selinux_setprocattr()->ptrace_parent() needs rcu_read_lock()
From: Paul Moore <paul@paul-moore.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>, Evan McNabb <emcnabb@redhat.com>,
        Jan Stancek <jstancek@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 6, 2013 at 9:47 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 12/05, Paul Moore wrote:
>> On Thursday, December 05, 2013 05:59:53 PM Oleg Nesterov wrote:
>> >
>> > Note: perhaps we should simply kill ptrace_parent(), it buys
>> > almost nothing and it is obviously racy. Or perhaps we should
>> > change it to ensure it can't wrongly return the natural parent
>> > if it races with ptrace_detach.
>>
>> Can you elaborate on "kill ptrace_parent()"?  If the process is being traced
>> we do need to fetch the tracer's task_struct for use in the SELinux access
>> check at this bottom of the diff below.  If you have something better in mind
>> than ptrace_parent() it would be helpful to share that ...
>
> Sorry for confusion.
>
> I meant that the code like
>
>         tracer = ptrace_parent(p);
>         if (tracer)
>                 do_something(tracer);
>
> doesn't look better than just
>
>         if (p->ptrace)
>                 do_something(p->parent);
>
> but this is subjective of course.

First, my apologizes for such a late reply, I got stuck working on
some other bugs and this fell on the back burner for a bit.

I understand your point, but I still think there is some value in
keeping the call to ptrace_parent() rather than fetching the ptrace
pointer on our own.  Not only does it insulate the SELinux code from
any future changes in the task_struct (unlikely, but still ...) it
also helps act as a warning if something significant changes, e.g.
ptrace_parent() goes away for some reason.  As you say, it's largely
subjective, but I still see some objective value in sticking with the
ptrace_parent() call for the time being.

However, that said, I think we should try and do something about the
"suspicious RCU usage" you mentioned in your original posting.  Adding
the RCU read locks as you do in your patch seems reasonable to me, but
I'm curious about the removal of the task lock; shouldn't week keep
the task lock in place?

> And perhaps I am wrong. Because otoh the usage of ->ptrace should be
> avoided outside of the core kernel code.

Not to muddy things up, but one could argue that this particular
LSM/SELinux hook should be regarded as part of the "core" kernel code.
 However, I'm not sure that the distinction is really important here.

> Mostly it annoys me because it is racy, without tasklist_lock it can
> return ->real_parent (which never traced its child) if it races with
> attach or detach, and I do not see a simple fix.

Neither do I, and I'm fairly certain I haven't looked at this as long
as others have.

-- 
paul moore
www.paul-moore.com
