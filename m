Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab3GJLTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:19:22 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:47227 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3GJLTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:19:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130710111128.GB15989@e103687>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
	<1373385338-12983-2-git-send-email-morten.rasmussen@arm.com>
	<51DCC287.40808@linux.intel.com>
	<20130710111128.GB15989@e103687>
Date: Wed, 10 Jul 2013 13:19:18 +0200
Message-ID: <CAKfTPtDAHBT1==WGL+7ULAB0VR1Pv5a6aPrgGPuQk6HE4hXTFw@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/9] sched: Introduce power scheduler
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 July 2013 13:11, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> On Wed, Jul 10, 2013 at 03:10:15AM +0100, Arjan van de Ven wrote:
>> On 7/9/2013 8:55 AM, Morten Rasmussen wrote:
>> > +   mod_delayed_work_on(schedule_cpu(), system_wq, &dwork,
>> > +                           msecs_to_jiffies(INTERVAL));
>>
>> so thinking about this more, this really really should not be a work queue.
>> a work queue will cause a large number of context switches for no reason
>> (on Intel and AMD you can switch P state from interrupt context, and I'm pretty sure
>> that holds for many ARM as well)
>
> Agree. I should have made it clear this is only a temporary solution. I
> would prefer to tie the power scheduler to the existing scheduler tick
> instead so we don't wake up cpus unnecessarily. nohz may be able handle
> that for us. Also, currently the power scheduler updates all cpus.
> Going forward this would change to per cpu updates and partial updates
> of the global view to improve scalability.

For the packing tasks patches, we are using the periodic load balance
sequence to update the activity like it is done for the cpu_power. I
have planned to update the packing patches to see how it can cooperate
with Morten patches as it has similar needs.

>
>>
>> and in addition, it causes some really nasty cases, especially around real time tasks.
>> Your workqueue will schedule a kernel thread, which will run
>> BEHIND real time tasks, and such real time task will then never be able to start running at a higher performance.
>>
>> (and with the delta between lowest and highest performance sometimes being 10x or more,
>> the real time task will be running SLOW... quite possible longer than several milliseconds)
>>
>> and all for no good reason; a normal timer running in irq context would be much better for this kind of thing!
>>
>>
>
