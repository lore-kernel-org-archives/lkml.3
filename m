Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbaG3EGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 00:06:07 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:42433 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaG3EGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 00:06:04 -0400
MIME-Version: 1.0
In-Reply-To: <87vbqhp4hf.fsf@x220.int.ebiederm.org>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
 <1406296033-32693-12-git-send-email-drysdale@google.com> <CALCETrVJX4+-6vkRaDj4kV_bXiYL5fj_PtO53g9fRf=i4X2Tww@mail.gmail.com>
 <CAGXu5jJZ7mhmq1BrdTP5Ww15+C2iLQKjLy1Xh0=9qZvVK5E9Cw@mail.gmail.com>
 <CALCETrVChObsQpL6dt-ByiCjbPrtpXAXQgy_apBY-OpGQHaPjg@mail.gmail.com> <87vbqhp4hf.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 29 Jul 2014 21:05:42 -0700
Message-ID: <CALCETrWaUsi1Ea3YTXLN6BFqcoHnbFTuMvcNncS5rq0nSgOatA@mail.gmail.com>
Subject: Re: [PATCH 11/11] seccomp: Add tgid and tid into seccomp_data
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>, Julien Tinnes <jln@google.com>,
        David Drysdale <drysdale@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Paolo Bonzini <pbonzini@redhat.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>,
        James Morris <james.l.morris@oracle.com>,
        Linux API <linux-api@vger.kernel.org>,
        Meredydd Luff <meredydd@senatehouse.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 2:18 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>
>> [cc: Eric Biederman]
>>
>
>> Can we do one better and add a flag to prevent any non-self pid
>> lookups?  This might actually be easy on top of the pid namespace work
>> (e.g. we could change the way that find_task_by_vpid works).
>>
>> It's far from just being signals.  There's access_process_vm, ptrace,
>> all the signal functions, clock_gettime (see CPUCLOCK_PID -- yes, this
>> is ridiculous), and probably some others that I've forgotten about or
>> never noticed in the first place.
>
> So here is the practical question.
>
> Are these processes that only can send signals to their thread group
> allowed to call fork()?
>
>
> If fork is allowed and all pid lookups are restricted to their own
> thread group that wait, waitpid, and all of the rest of the wait family
> will never return the pids of their children, and zombies will
> accumulate.  Aka the semantics are fundamentally broken.

Good point.

I can imagine at least three ways that fork() could continue working, though:

1. Allow lookups of immediate children, too.  (I don't love this one.)
2. Allow non-self pids to be translated in but not out.  This way
P_ALL will continue working.
3. Have the kernel treat any PID-restricted process as though it were NOCLDWAIT.

I think I like #3.  Thoughts?

>
> If fork is not allowed pid namespaces already solve this problem.

PID namespaces are fairly heavyweight.  Julien pointed out that using
PID namespaces requires a bunch of dummy PID 1 processes.

--Andy
