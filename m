Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751040Ab3HSSkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 14:40:53 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:47908 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab3HSSkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 14:40:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130819183319.GA24846@redhat.com>
References: <20130819172524.GA22268@redhat.com> <CALCETrW+dEwR38ERQhx25-aw1dhsCE6X+9BQZJhusO88aUxN1A@mail.gmail.com>
 <20130819183319.GA24846@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 19 Aug 2013 11:40:31 -0700
Message-ID: <CALCETrWrpNszRGCRRMLgiOopcSdDShB3Mck6gRPco=dAZeX3pQ@mail.gmail.com>
Subject: Re: PATCH? fix unshare(NEWPID) && vfork()
To: Oleg Nesterov <oleg@redhat.com>
Cc: Brad Spengler <spender@grsecurity.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Walters <walters@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 11:33 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/19, Andy Lutomirski wrote:
>>
>> On Mon, Aug 19, 2013 at 10:25 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> > Hello.
>> >
>> > Colin reports that vfork() doesn't work after unshare(PIDNS). The
>> > reason is trivial, copy_process() does:
>> >
>> >         /*
>> >          * If the new process will be in a different pid namespace
>> >          * don't allow the creation of threads.
>> >          */
>> >         if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
>> >             (task_active_pid_ns(current) != current->nsproxy->pid_ns))
>> >                 return ERR_PTR(-EINVAL);
>> >
>> > and CLONE_VM obviously nacks vfork(). So perhaps we can relax
>> > this check to CLONE_THREAD? Or should we really nack CLONE_VM
>> > by security reasons?
>> >
>> > OTOH. Perhaps we should also deny CLONE_PARENT in this case?
>> >
>> > In short. So far I am thinking about the patch below but I got
>> > lost and totally confused. Will try to think more tomorrow, but
>> > I would like to see the fix from someone who still understands
>> > this all.
>> >
>> > Oleg.
>>
>> By way of (partial) explanation:
>>
>> http://marc.info/?l=linux-kernel&m=135545831607095
>
> Thanks... too late for me to even try to read this discussion today.
>
> and I am a bit confused,
>
>> (tl;dr: I think that CLONE_VM is irrelevant here, but there may be
>> other issues lurking around.)
>
> So do you think this change is fine or not (ignoring the fact it needs
> cleanups) ?

I think that removing the CLONE_VM check is fine (although there are
some other ones that should probably be removed as well), but I'm not
sure if that check needs replacing with something else.

--Andy
