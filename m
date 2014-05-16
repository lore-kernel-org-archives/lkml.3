Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbaEPSWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 14:22:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032AbaEPSV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 14:21:59 -0400
Message-ID: <53765721.8090602@redhat.com>
Date: Fri, 16 May 2014 14:21:21 -0400
From: "Carlos O'Donell" <carlos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhart@linux.intel.com>,
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
References: <20140512190438.314125476@linutronix.de> <20140513035404.GA68181@dvhart-mac01.local> <alpine.DEB.2.02.1405131100510.6261@ionos.tec.linutronix.de> <53731608.3010803@redhat.com> <alpine.DEB.2.02.1405141155260.6261@ionos.tec.linutronix.de> <5373D94E.5030800@redhat.com> <20140515082507.GC30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140515082507.GC30445@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 04:25 AM, Peter Zijlstra wrote:
> On Wed, May 14, 2014 at 04:59:58PM -0400, Carlos O'Donell wrote:
>> I will make my personal opinion clear:
>>
>> - Internal defects should raise immediate assertions.
>>
>> - Real problems like resource availability, deadlocks, and
>>   other recoverable errors should result in the API returning
>>   an appropriate error code that must not diverge from the POSIX
>>   definitions for those codes (when such a definition exists).
>>
>> I'm not a believer in "only the hot path matters", there are such
>> things as robustness and error detection, and they matter.
> 
> Awesome. In case of doubt though, I would prefer a return to an assert,
> just in case userspace actually does know wtf its doing ;-)

No. In that case the person who knows attaches a debugger to determine
why the internal state is inconsistent. That may require kernel or glibc
debugging and asserting as close to the point of corruption is the only
useful behaviour. I know it's painful, but the number of people who know
what they are doing is vanishingly small compared to the other set.

> Granted, that seems to be very rare, but still, its entirely annoying
> for those few people who do care to get dead programs.
> 
> Alternatively, we could have something like you have for the allocator
> (which is, afaik, also considered a hot path) these env variables like
> MALLOC_CHECK_ to influence this edge behaviour.

We are considering a runtime tunnables framework to unify all of these
kinds of tweaks into a stable API. Given that asserting or not asserting
does not impact the standards conformance we could make that a tunnable
with the default being to assert. The tunnables framework is still pie
in the sky because we need a low-overhead framework to check the global
tunnables. However, we need them, as I've mentioned before as an example
we have an ancient 40MB stack cache in glibc for thread stack reuse that
nobody remembers why it was tuned to that value. Magic.

Cheers,
Carlos.

