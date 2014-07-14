Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbaGNKb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:31:28 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:21576 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbaGNKbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:31:19 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-85-53c3b175eb37
Message-id: <53C3B02C.2070709@samsung.com>
Date: Mon, 14 Jul 2014 14:25:48 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: sched, timers: use after free in __lock_task_sighand when exiting
 a process
References: <53C2FF4D.3020606@oracle.com> <53C31A34.8030500@oracle.com>
 <20140714090449.GL9918@twins.programming.kicks-ass.net>
 <53C3A430.9090508@samsung.com>
 <20140714095802.GQ9918@twins.programming.kicks-ass.net>
In-reply-to: <20140714095802.GQ9918@twins.programming.kicks-ass.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xq7qlGw8HG8y5x2Wx5XoTk8XM191M
	Fmd+61pc3jWHzWL1v1OMFlv3tzJaHO89wGSx+MhtZovNm6YyO3B67Jx1l91j8wotj02rOtk8
	7lzbw+bx7tw5do+PT2+xeLzfd5XN4/MmuQCOKC6blNSczLLUIn27BK6ML9s+Mhes46xYsv8F
	awPjRfYuRk4OCQETif5/+6FsMYkL99azdTFycQgJLGWUmPzmBzNIQkigmUli4jU+EJtXQEvi
	4f93YHEWAVWJOfMfMILYbAJ6Ev9mbWcDsUUFIiQO9D1jhagXlPgx+R4LiC0ioCmxsu0+2AJm
	gZVMEm2rpoANEhaIkji1+gTU5juMEsdungM7iVPARWLS4utgRcwCOhL7W6exQdjyEpvXvGWe
	wCgwC8mSWUjKZiEpW8DIvIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJC6+7GBcfMzqEKMA
	B6MSD2+F2OFgIdbEsuLK3EOMEhzMSiK8UuuAQrwpiZVVqUX58UWlOanFhxiZODilGhjzum6v
	ET229KHQip3uXL+W3bQX0siUfK2lb3Bc2+RwYah0268HM3znemy5p37OJSXKiVN+R6+aWKOT
	vP2FzFNHs2cpfCu6X3zcY2+RzbwVSnwLOBv+PV66q0tw9pUry9677Fu5e829T4oRTrrLGdc+
	O5Q69/Z+pUivZ/8fi774mMSUV+B99c1EJZbijERDLeai4kQAZ2LoJ2kCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/14 13:58, Peter Zijlstra wrote:
> On Mon, Jul 14, 2014 at 01:34:40PM +0400, Andrey Ryabinin wrote:
>> On 07/14/14 13:04, Peter Zijlstra wrote:
>>> On Sun, Jul 13, 2014 at 07:45:56PM -0400, Sasha Levin wrote:
>>>> On 07/13/2014 05:51 PM, Sasha Levin wrote:
>>>>> Hi all,
>>>>>
>>>>> While fuzzing with trinity inside a KVM tools guest running the latest -next
>>>>> kernel with the KASAN patchset, I've stumbled on the following spew:
>>>
>>> WTH is a KASAN?
>>>
>>
>> It's dynamic memory checker, detects use after free, out of bounds accesses - https://lkml.org/lkml/2014/7/9/990
> 
> How is it better/different from the existing use after free stuff? That
> email fails to tell me.
> 

DEBUG_PAGEALLOC works on page-granularity level, kasan can do checks at sub-page granularity (for slab objects).

SLUB_DEBUG(poisoning, etc.) doesn't guarantee that you will catch use-after-free.
For example if you are only reading and checking a single bit in some already free object. Kasan will catch this.

KASAN is very similar to kmemcheck, but definitely faster.
The only thing that currently kasan can't catch, while kmemcheck can - is reads of uninitialized memory.
