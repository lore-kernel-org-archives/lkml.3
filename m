Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbaEPRzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:55:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756948AbaEPRzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:55:13 -0400
Message-ID: <537650BD.8050105@redhat.com>
Date: Fri, 16 May 2014 13:54:05 -0400
From: "Carlos O'Donell" <carlos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@linux.intel.com>,
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
References: <20140512190438.314125476@linutronix.de> <20140513035404.GA68181@dvhart-mac01.local> <537313FD.4000306@redhat.com> <20140514092203.GE30445@twins.programming.kicks-ass.net> <5373DD6F.40506@redhat.com> <alpine.DEB.2.02.1405150055470.6261@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1405150055470.6261@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 07:11 PM, Thomas Gleixner wrote:
> On Wed, 14 May 2014, Carlos O'Donell wrote:
>> On 05/14/2014 05:22 AM, Peter Zijlstra wrote:
>>>>> I believe the thinking goes that if we get to here, then the lock is in an
>>>>> inconsistent state (between kernel and userspace). I don't have an answer for
>>>>> why pausing forever would be preferable to returning an error however...
>>>>
>>>> What error would we return?
>>>
>>> EDEADLK is a valid user return for pthread_mutex_lock() as per:
>>>
>>>   http://pubs.opengroup.org/onlinepubs/009695399/functions/pthread_mutex_lock.html
>>
>> How is that correct? It isn't a deadlock we've detected but inconsistent
>> state between glibc and the kernel. In this case glibc should assert.
>> Delaying indefinitely with pause() never seems correct (despite that being
>> what we do today).
> 
> If there is inconsistent state detected then the kernel will return
> -EPERM or -EINVAL. So lets put inconsistent state aside.

OK.
 
> In glibc you only can detect the simple AA dead lock, i.e lock owner
> tries to lock the lock it owns again. Trivial, right ?

Agreed.

> But glibc has no idea which lock chains are involved and might lead to
> a dead lock caused by nested locking, simplest and most popular being
> ABBA.

OK.

> The kernel can (if the implementation is fixed, patch is available
> already) very well detect ABBA and even more complex nested lock
> deadlocks. So it rightfully returns -EDEADLK and that is completely
> correct versus the spec and the call site can do something about it.

OK.

> And that's not different from the glibc detected AA deadlock at
> all. It's just detected by a different mechanism.

OK.

> On kernel side we currently provide this service only for the PI
> futexes because we have a kernel side state representation as long as
> the user space state is not corrupted.

OK.

> Back then when it was implemented the dead lock detection actually
> worked and was agreed on by both sides - kernel and glibc - to be
> usefull and essential to the whole endavour.

I agree that ignoring the situation of corrupted or inconsistent
state we should be returning EDEADLK to userspace.

We'll cleanup glibc.

Cheers,
Carlos.

