Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaELTmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 15:42:52 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:35513 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaELTmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 15:42:50 -0400
Message-ID: <53712434.2060705@gmail.com>
Date: Mon, 12 May 2014 21:42:44 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mtk.manpages@gmail.com, Juri Lelli <juri.lelli@gmail.com>,
        Dario Faggioli <raistlin@linux.it>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>
Subject: Re: SCHED_DEADLINE, sched_getscheduler(), and sched_getparam()
References: <CAKgNAkiA23kAFyXQkFV4z0aUE+y5K7AFNwRW+4LqwAyVj=tQtQ@mail.gmail.com> <20140512122452.GB13467@laptop.programming.kicks-ass.net> <CAKgNAkjsEjGM+Znu4iXa7yA-ruDHCDx9SvFow2wn3z2=zAHqCQ@mail.gmail.com> <20140512152536.GR30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140512152536.GR30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 05:25 PM, Peter Zijlstra wrote:
> On Mon, May 12, 2014 at 02:33:42PM +0200, Michael Kerrisk (man-pages) wrote:
>>> I'm a proponent of fail hard instead of fail silently and muddle on.
>>> And while we can fully and correctly return sched_getscheduler() we
>>> cannot do so for sched_getparam().
>>>
>>> Returning sched_param::sched_priority == 0 for DEADLINE would also break
>>> the symmetry between sched_setparam() and sched_getparam(), both will
>>> fail for SCHED_DEADLINE.
>>
>> Maybe. But there seems to me to be a problem with your logic here.
>> (And the symmetry argument seems a weak one to me.)
>>
>> I mean, applications that are currently using sched_getscheduler()
>> will now get back a new policy (SCHED_DEADLINE) that they may not
>> understand, and so they may break.
>>
>> On the other hand, applications that call sched_getparam() will fail
>> with EINVAL, even though sched_priority has no meaning for
>> SCHED_DEADLINE (as for the non-real-time policies), and so it would
>> seem to be harmless to succeed and return a sched_priority of 0 in
>> this case. It seems to break user-space needlessly, IMHO.
>>
>> If anything, I'd have said it would have made more sense to have the
>> sched_getscheduler() case fail, while having the sched_getparam() case
>> succeed. (But, I can see the argument for having _both_ cases
>> succeed.)
> 
> Hmm,.. maybe. Can we still change this? Again, maybe, there's not really
> that much userspace that relies on this.

I think the sched_getparam() change is worthwhile (and the patches 
could (should?) be marked for -stable). I suspect there's no user
space that relies on the current SCHED_DEADLINE behavior, and it's 
worth avoiding the above breakage for sched_getparam(). I'd be 
inclined to leave sched_getscheduler() as is: there's arguments 
either way for how it should behave.

> In any case, the way I read the little there is on getparam() it seems
> to imply the only case where it does make sense to call it at all is
> when sched_getscheduler() returns either SCHED_FIFO or SCHED_RR.

(Yes, that's my understanding too.)

> And in that sense I suppose the precedent for all other currently
> available classes to not fail the param call but return 0 should be
> extended.

Yes.

> If only we'd started out with sched_yield()/sched_getparam() etc failing
> when not !SCHED_FIFO/RR :-)

Here, I think we're just following POSIX.

Cheers,

Michael

 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
