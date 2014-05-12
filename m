Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbaELMeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 08:34:05 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:38068 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbaELMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 08:34:04 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20140512122452.GB13467@laptop.programming.kicks-ass.net>
References: <CAKgNAkiA23kAFyXQkFV4z0aUE+y5K7AFNwRW+4LqwAyVj=tQtQ@mail.gmail.com>
 <20140512122452.GB13467@laptop.programming.kicks-ass.net>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 12 May 2014 14:33:42 +0200
Message-ID: <CAKgNAkjsEjGM+Znu4iXa7yA-ruDHCDx9SvFow2wn3z2=zAHqCQ@mail.gmail.com>
Subject: Re: SCHED_DEADLINE, sched_getscheduler(), and sched_getparam()
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 2:24 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, May 12, 2014 at 02:09:58PM +0200, Michael Kerrisk (man-pages) wrote:
>> Hi Peter,
>>
>> Looking at the code of sched_getparam() and sched_setscheduler() (to
>> see what might need to land in the man pagea with respect to
>> SCHED_DEADLINE changes), I see that the former fails (EINVAL) if the
>> target is a SCHED_DEADLINE process, while the latter succeeds
>> (returning SCHED_DEADLINE).
>>
>> The sched_setscheduler() seems fine, but what's the rationale for
>> having sched_getparam() fail in this case, rather than just returning
>> a sched_priority of zero (since sched_priority is in any case unused,
>> as for SCHED_OTHER, right)? My point is that the change seems to
>> needlessly break applications that employ sched_getparam(). Maybe I am
>> missing something...
>
> s/setscheduler/getscheduler/ ?

Yes, sorry.

> I'm a proponent of fail hard instead of fail silently and muddle on.
> And while we can fully and correctly return sched_getscheduler() we
> cannot do so for sched_getparam().
>
> Returning sched_param::sched_priority == 0 for DEADLINE would also break
> the symmetry between sched_setparam() and sched_getparam(), both will
> fail for SCHED_DEADLINE.

Maybe. But there seems to me to be a problem with your logic here.
(And the symmetry argument seems a weak one to me.)

I mean, applications that are currently using sched_getscheduler()
will now get back a new policy (SCHED_DEADLINE) that they may not
understand, and so they may break.

On the other hand, applications that call sched_getparam() will fail
with EINVAL, even though sched_priority has no meaning for
SCHED_DEADLINE (as for the non-real-time policies), and so it would
seem to be harmless to succeed and return a sched_priority of 0 in
this case. It seems to break user-space needlessly, IMHO.

If anything, I'd have said it would have made more sense to have the
sched_getscheduler() case fail, while having the sched_getparam() case
succeed. (But, I can see the argument for having _both_ cases
succeed.)

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
