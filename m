Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaBVTD5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 14:03:57 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:38884 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751466AbaBVTDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 14:03:55 -0500
Message-ID: <5308F48C.8080609@hurleysoftware.com>
Date: Sat, 22 Feb 2014 14:03:40 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Tejun Heo <tj@kernel.org>, laijs@cn.fujitsu.com,
        linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
References: <1392929071-16555-5-git-send-email-tj@kernel.org>		 <5306AF8E.3080006@hurleysoftware.com>		 <20140221015935.GF6897@htj.dyndns.org>		 <5306B4DF.4000901@hurleysoftware.com>		 <20140221021341.GG6897@htj.dyndns.org>		 <5306E06C.5020805@hurleysoftware.com>		 <20140221100301.GA14653@mtj.dyndns.org>		 <53074BE4.1020307@hurleysoftware.com>		 <20140221130614.GH6897@htj.dyndns.org>		 <5307849A.9050209@hurleysoftware.com>		 <20140221165730.GA10929@htj.dyndns.org>		 <5307DAC9.2020103@hurleysoftware.com>	 <1393094608.11497.1.camel@dabdike.int.hansenpartnership.com>	 <5308F0E2.3030804@hurleysoftware.com> <1393095138.11497.5.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1393095138.11497.5.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2014 01:52 PM, James Bottomley wrote:
> On Sat, 2014-02-22 at 13:48 -0500, Peter Hurley wrote:
>> On 02/22/2014 01:43 PM, James Bottomley wrote:
>>>
>>> On Fri, 2014-02-21 at 18:01 -0500, Peter Hurley wrote:
>>>> On 02/21/2014 11:57 AM, Tejun Heo wrote:
>>>>> Yo,
>>>>>
>>>>> On Fri, Feb 21, 2014 at 11:53:46AM -0500, Peter Hurley wrote:
>>>>>> Ok, I can do that. But AFAIK it'll have to be an smp_rmb(); there is
>>>>>> no mb__after unlock.
>>>>>
>>>>> We do have smp_mb__after_unlock_lock().
>>>>>
>>>>>> [ After thinking about it some, I don't think preventing speculative
>>>>>>      writes before clearing PENDING if useful or necessary, so that's
>>>>>>      why I'm suggesting only the rmb. ]
>>>>>
>>>>> But smp_mb__after_unlock_lock() would be cheaper on most popular
>>>>> archs, I think.
>>>>
>>>> smp_mb__after_unlock_lock() is only for ordering memory operations
>>>> between two spin-locked sections on either the same lock or by
>>>> the same task/cpu. Like:
>>>>
>>>>       i = 1
>>>>       spin_unlock(lock1)
>>>>       spin_lock(lock2)
>>>>       smp_mb__after_unlock_lock()
>>>>       j = 1
>>>>
>>>> This guarantees that the store to j happens after the store to i.
>>>> Without it, a cpu can
>>>>
>>>>       spin_lock(lock2)
>>>>       j = 1
>>>>       i = 1
>>>>       spin_unlock(lock1)
>>>
>>> No the CPU cannot.  If the CPU were allowed to reorder locking
>>> sequences, we'd get speculation induced ABBA deadlocks.  The rules are
>>> quite simple: loads and stores cannot speculate out of critical
>>> sections.
>>
>> If you look carefully, you'll notice that the stores have not been
>> moved from their respective critical sections; simply that the two
>> critical sections overlap because they use different locks.
>
> You didn't look carefully enough at what I wrote.  You may not reorder
> critical sections so they overlap regardless of whether the locks are
> independent or not.  This is because we'd get ABBA deadlocks due to
> speculation (A represents lock1 and B lock 2 in your example).

On 11/26/2013 02:00 PM, Linus Torvalds wrote:
 > On Tue, Nov 26, 2013 at 1:59 AM, Peter Zijlstra <peterz@infradead.org> wrote:
 >>
 >> If you now want to weaken this definition, then that needs consideration
 >> because we actually rely on things like
 >>
 >> spin_unlock(l1);
 >> spin_lock(l2);
 >>
 >> being full barriers.
 >
 > Btw, maybe we should just stop that assumption. The complexity of this
 > discussion makes me go "maybe we should stop with subtle assumptions
 > that happen to be obviously true on x86 due to historical
 > implementations, but aren't obviously true even *there* any more with
 > the MCS lock".
 >
 > We already have a concept of
 >
 >          smp_mb__before_spinlock();
 >          spin_lock():
 >
 > for sequences where we *know* we need to make getting a spin-lock be a
 > full memory barrier. It's free on x86 (and remains so even with the
 > MCS lock, regardless of any subtle issues, if only because even the
 > MCS lock starts out with a locked atomic, never mind the contention
 > slow-case). Of course, that macro is only used inside the scheduler,
 > and is actually documented to not really be a full memory barrier, but
 > it handles the case we actually care about.
 >
 > IOW, where do we really care about the "unlock+lock" is a memory
 > barrier? And could we make those places explicit, and then do
 > something similar to the above to them?
 >
 >                         Linus
 >

http://www.spinics.net/lists/linux-mm/msg65653.html

and the resultant text from Documentation/memory-barriers.txt

An ACQUIRE followed by a RELEASE may not be assumed to be full memory barrier
because it is possible for an access preceding the ACQUIRE to happen after the
ACQUIRE, and an access following the RELEASE to happen before the RELEASE, and
the two accesses can themselves then cross:

	*A = a;
	ACQUIRE M
	RELEASE M
	*B = b;

may occur as:

	ACQUIRE M, STORE *B, STORE *A, RELEASE M

This same reordering can of course occur if the lock's ACQUIRE and RELEASE are
to the same lock variable, but only from the perspective of another CPU not
holding that lock.

In short, a RELEASE followed by an ACQUIRE may -not- be assumed to be a full
memory barrier because it is possible for a preceding RELEASE to pass a
later ACQUIRE from the viewpoint of the CPU, but not from the viewpoint
of the compiler.  Note that deadlocks cannot be introduced by this
interchange because if such a deadlock threatened, the RELEASE would
simply complete.

If it is necessary for a RELEASE-ACQUIRE pair to produce a full barrier, the
ACQUIRE can be followed by an smp_mb__after_unlock_lock() invocation.  This
will produce a full barrier if either (a) the RELEASE and the ACQUIRE are
executed by the same CPU or task, or (b) the RELEASE and ACQUIRE act on the
same variable.  The smp_mb__after_unlock_lock() primitive is free on many
architectures.  Without smp_mb__after_unlock_lock(), the critical sections
corresponding to the RELEASE and the ACQUIRE can cross:

	*A = a;
	RELEASE M
	ACQUIRE N
	*B = b;

could occur as:

	ACQUIRE N, STORE *B, STORE *A, RELEASE M

With smp_mb__after_unlock_lock(), they cannot, so that:

	*A = a;
	RELEASE M
	ACQUIRE N
	smp_mb__after_unlock_lock();
	*B = b;

will always occur as either of the following:

	STORE *A, RELEASE, ACQUIRE, STORE *B
	STORE *A, ACQUIRE, RELEASE, STORE *B

If the RELEASE and ACQUIRE were instead both operating on the same lock
variable, only the first of these two alternatives can occur.

Regards,
Peter Hurley


