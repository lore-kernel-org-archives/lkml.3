Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaENVSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:18:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbaENVSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:18:32 -0400
Message-ID: <5373DD6F.40506@redhat.com>
Date: Wed, 14 May 2014 17:17:35 -0400
From: "Carlos O'Donell" <carlos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Darren Hart <dvhart@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <darren@dvhart.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 0/3] futex/rtmutex: Fix issues exposed by trinity
References: <20140512190438.314125476@linutronix.de> <20140513035404.GA68181@dvhart-mac01.local> <537313FD.4000306@redhat.com> <20140514092203.GE30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140514092203.GE30445@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 05:22 AM, Peter Zijlstra wrote:
>>> I believe the thinking goes that if we get to here, then the lock is in an
>>> inconsistent state (between kernel and userspace). I don't have an answer for
>>> why pausing forever would be preferable to returning an error however...
>>
>> What error would we return?
> 
> EDEADLK is a valid user return for pthread_mutex_lock() as per:
> 
>   http://pubs.opengroup.org/onlinepubs/009695399/functions/pthread_mutex_lock.html

How is that correct? It isn't a deadlock we've detected but inconsistent
state between glibc and the kernel. In this case glibc should assert.
Delaying indefinitely with pause() never seems correct (despite that being
what we do today).
 
>> This particular case is a serious error for which we have no good error code
>> to return to userspace. It's an implementation defect, a bug, we should probably
>> assert instead of pausing.
> 
> No, its perfectly fine to have a lock sequence abort with -EDEADLK.
> Userspace should release its locks and re-attempt.

I agree. If I can prove that it's actually a deadlock, and
that unlock/relock will work to fix it, then we can arrange for glibc
to return EDEADLK.

> You can implement usable locking schemes using this error, like
> wound/wait locking.

Agreed.

>> We can't cancel the stuck thread because pthread_mutex_lock is not a cancellation
>> point.
>>
>> In practice the rest of the application can make forward progress with a single
>> thread stuck. You can attach the debugger and inspect state, so it's useful
>> from that perspective.
> 
> That's just totally braindead. Return EDEADLK to userspace already, let
> the user deal with it.

Not all cases where EDEADLK returns is it such a case that the user
can make forward progress, it might be a corrupt state, in which case
if we detect the corrupt state I would assert. Otherwise, yes, we can
return EDEADLK and let the user figure it out.

Does that make sense?

Cheers,
Carlos.

