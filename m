Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab3EUWKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:10:46 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:54318 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751604Ab3EUWKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:10:45 -0400
Message-ID: <519BF0DB.6040108@hurleysoftware.com>
Date: Tue, 21 May 2013 18:10:35 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, stephan.gatzka@gmail.com,
        Tejun Heo <tj@kernel.org>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: function call fw_iso_resource_mange(..) (core-iso.c) does not
 return
References: <8ac7ca3200325ddf85ba57aa6d000f70@gatzka.org> <519BA6AC.1080600@hurleysoftware.com> <62922216e6007f9ef83956e0ca202644@gatzka.org> <20130521235329.48ba65e2@stein>
In-Reply-To: <20130521235329.48ba65e2@stein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 05:53 PM, Stefan Richter wrote:
> On May 21 Stephan Gatzka wrote:
>> Hi all!
>>
>>>> The deadlock occurs mainly because the firewire workqueue is allocated
>>>> with WQ_MEM_RECLAIM. That's why a so called rescuer thread is started
>>>> while allocating the wq.
>>>                        ^^^^^^
>>> Are there other conditions which contribute?  For example, Ralf
>>> reported that
>>> having the bus_reset_work on its own wq delayed but did not eliminate
>>> the
>>> deadlock.
>>>
>>
>> The worker threads are independant from the workqueues. New worker
>> thread are only allocated if all current worker threads are sleeping and
>> are making no progress. Right now I don't know if Ralfs separate queue
>> for bus_reset_work was allocated with MEM_RECLAIM. Buf even if it has
>> it's own rescuer thread, that should not block because there is no other
>> work in that queue. No, right now I have no explanation for that.
>
> Indeed.  Ralf wrote he had given bus_reset_work its own workqueue (which
> reduced the probability of the bug but did not eliminate it), and then
> there can only three things happen (from my perspective as a mere API
> user):
>    a) The ohci->bus_reset_work instance is queued while the wq is empty.
>       Which is the trivial case and presumably works.
>       queue_work() returns nonzero.
>
>    b) The instance is queued while the very same instance has already been
>       queued but is not yet being executed.  Sounds trivial too:  These two
>       or more queuing attempts before execution should in total lead to the
>       work be executed once.
>       queue_work() returns zero in this case.
>       Ralf observed this condition to coincide with the hang.

An important note with case b) is that Ralf (the original reporter) was
running 3.4.something.  I'm aware that some work has gone into workqueue
locks in 3.9 and 3.10. I asked Ralf if he could reproduce on a more
recent kernel but never heard back. Maybe these are two different problems
(ie, a failure to guarantee forward progress on a single workqueue and
a straightforward deadlock when using two wqs)?

Stephan Gatzka,
what kernel version did you instrument and reproduce this with?

>    c) The instance is queued while it is being executed.  In this case,
>       the work must be put into the queue but must not be started until its
>       present execution finished.  (We have a non-reentrant workqueue which
>       is meant to guarantee that one and the same worklet instance is
>       executed at most once at any time, systemwide.)
>       queue_work() returns nonzero in this case.
>       Whether this condition is involved in the problem or not is not clear
>       to me.  Maybe one occurrence of condition c initiates the problem,
>       and the occurrences of b which had been observed are only a
>       by-product.  Or the trouble starts in condition b only...?
>
> Well, a few further conditions can happen if there are several OHCI-1394
> LLCs in the system and all fw_ohci instances share a single workqueue.
> But since there is no dependency between different ohci->bus_reset_work
> instances (in contrast to firewire-core worklets and upper layer worklets
> whose progress depends on firewire-ohci worklets' progress), the only
> effect of such sharing would be that conditions b and c are somewhat more
> likely to occur, especially if bus resets on the different buses are
> correlated.
>
>>>> This rescuer thread is responsible to keep the queue working even
>>>> under high memory pressure so that a memory allocation might sleep. If
>>>> that happens, all work of that workqueue is designated to that
>>>> particular rescuer thread. The work in this rescuer thread is done
>>>> strictly sequential. Now we have the situation that the rescuer thread
>>>> runs fw_device_init->read_config_rom->read_rom->fw_run_transaction.
>>>> fw_run_transaction blocks waiting for the completion object. This
>>>> completion object will be completed in bus_reset_work, but this work
>>>> will never executed in the rescuer thread.
>>>
>>> Interesting.
>>>
>>> Tejun, is this workqueue behavior as designed?  Ie., that a workqueue
>>> used
>>> as a domain for forward progress guarantees collapses under certain
>>> conditions,
>>> such as scheduler overhead and no longer ensures forward progress?
>>>
>>>
>>> I've observed the string of bus resets on startup as well and I think
>>> it has to do
>>> with failing to ack the interrupt promptly because the log printk()
>>> takes too long (>50us).
>>> The point being that I don't think this is contributing to the
>>> create_worker() +10ms
>>> delay.
>>
>> That depends on. The console on embedded systems (like ours) often runs
>> on a serial port with 115200 baud. We measured the cost of a printk and
>> dependent of the length and parameters that might easily go up to
>> several ms. So dependent on the console level set you might run into
>> trouble.
>>
>> Regards,
>>
>> Stephan
>

