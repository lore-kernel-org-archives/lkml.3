Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbaCYUbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:31:25 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43999 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbaCYUbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:31:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, oleg@redhat.com, gnomes@lxorguk.ukuu.org.uk,
        riel@redhat.com, snorcht@gmail.com, dhowells@redhat.com,
        luto@amacapital.net, daeseok.youn@gmail.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
	<1395767870-28053-1-git-send-email-khalid.aziz@oracle.com>
	<8761n25ckg.fsf@x220.int.ebiederm.org> <5331D5DD.5090105@oracle.com>
Date: Tue, 25 Mar 2014 13:31:04 -0700
In-Reply-To: <5331D5DD.5090105@oracle.com> (Khalid Aziz's message of "Tue, 25
	Mar 2014 13:15:41 -0600")
Message-ID: <87y4zyrpfb.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19687fDLIC6vTL+7Jd2AeLZimSmcVPQqtU=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4959]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Khalid Aziz <khalid.aziz@oracle.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2] Pre-emption control for userspace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Khalid Aziz <khalid.aziz@oracle.com> writes:

> On 03/25/2014 12:59 PM, ebiederm@xmission.com wrote:
>> Khalid Aziz <khalid.aziz@oracle.com> writes:
>>
>>> This patch adds a way for a thread to request additional timeslice from
>>> the scheduler if it is about to be preempted, so it could complete any
>>> critical task it is in the middle of. .......
>>
>>
>> Let me see if I understand the problem.  Your simulated application has
>> a ridiculous number of threads (1000) all contending for a single lock
>> with fairly long lock hold times between 600 and 20000 clocks assuming
>> no cache line misses.  So 1000 threads contending for about 10usec or
>> 1/100 of a tick when HZ=1000.  Giving  you something like 1 chance in
>> 100 of being preempted while holding the lock.  With 1000 threads
>> those sound like pretty bad odds.
>
> This problem does not happen because threads are holding the lock for too long,
> rather it happens when a thread does a large number of things in its loop and
> one small part of it requires it to hold a lock. So it holds the lock for a very
> short time but what can happen is thread is executing in non-critical section of
> its loop, it finally gets to the critical section just as its timeslice is about
> to end, it grabs the lock and is pre-empted right away. Now we start building a
> convoy of threads that want the same lock. This problem can be avoided if the
> locking thread could be given additional time to complete its critical section,
> release the lock and yield the processor if it indeed was granted amnesty by the
> scheduler.

I would dearly like to see the math that shows such a change will make
actually significantly change the propbabilities of this hitting.  It
seems more likely that this will just be a way for threads to cheat and
get larger time slices.

>> Maybe if this was limited to a cooperating set of userspace
>> tasks/threads this might not be too bad.  As this exists I have users
>> who would hunt me down with malicious intent if this code ever showed up
>> on our servers, because it would make life for every other application
>> on the server worse.
>>
>
> Yes, it is indeed limited to a cooperating set of userspace
> tasks/threads. Tasks/threads will explicitly choose to use this feature. It is a
> no-op for every one else.

It is absolutely not a no-op for me if my task can't be scheduled soon
enough because your task executed sched-prempt.

It means my latency goes up and the *random bad thing* will happen
because I missed my deadline because I was not scheduled fast enough.

>> or (b) limiting this to just a small
>> cooperating set of threads in a single cgroup.
>
> and that is almost what this patch does. It is not limited to a cgroup, rather
> to the tasks/threads that ask to use this feature.

Except you do not appear to be considering what could be scheduled in
your tasks place.

You allow any task to extend it's timeslice.

Which means I will get the question why does why does
really_important_job only miss it's latency guarantees when running on
the same box as sched_preempt_using_job?

Your change appears to have extremely difficult to debug non-local
effects.

Eric

