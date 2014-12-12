Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaLLXM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 18:12:27 -0500
Received: from mail-wg0-f67.google.com ([74.125.82.67]:62664 "EHLO
	mail-wg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaLLXMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 18:12:24 -0500
From: AH <najdrozszy@gmail.com>
X-Google-Original-From: AH <andrzej.hajda@gmail.com>
Message-ID: <548B7653.7020004@gmail.com>
Date: Sat, 13 Dec 2014 00:12:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Andrzej Hajda <a.hajda@samsung.com>
CC: open list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        ARM/CLKDEV SUPPORT <linux-arm-kernel@lists.infradead.org>,
        GPIO SUBSYSTEM <linux-gpio@vger.kernel.org>,
        DRM PANEL DRIVERS <dri-devel@lists.freedesktop.org>,
        "ARM/S5P EXYNOS AR..." <linux-samsung-soc@vger.kernel.org>,
        "OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [RFC 01/15] drivers/base: add track framework
References: <1418226513-14105-2-git-send-email-a.hajda@samsung.com> <20141212163653.GO11764@sirena.org.uk>
In-Reply-To: <20141212163653.GO11764@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thanks for review.

Mark Brown wrote on 12.12.2014 17:36:
> On Wed, Dec 10, 2014 at 04:48:19PM +0100, Andrzej Hajda wrote:
>> track is a generic framework for safe tracking presence of any kernel objects
>> having an id. There are no special requirements about type of object or its
>> id. Id shall be unique.
>
> This is pretty confusing, when it talks about "kernel objects" that
> sounds like it means struct kobject but in fact there's no connection
> with that or any of the other kernel object stuff.  Perhaps it makes
> sense but it should be addressed.
>

OK

>> Typical usage of the framework by consumer looks as follow:
>> 1. Consumer registers notifier callback for objects with given id.
>
> This is also a custom thing not connected with the notifier mechanism
> implemented by struct notifier_block.  Again this should probably be
> addressed, even if it's just used internally it seems like there should
> be some opportunity for code reuse here.

I though about using notfier_block, but beside the struct itself there 
wouldn't be too much code to reuse. In my previous attempt of this 
framework more arguments were passed to the callback so I have dropped
this idea completely, but now after simplifying the callback it fits better.

>
>> +	case track_task_up:
>> +		node = track_get_node(track, task->type, task->id, true);
>> +
>> +		node->up = true;
>> +		node->data = task->data;
>> +		list_for_each_entry_safe(itb, node->itb_next, &node->itb_head,
>> +					 list)
>> +			itb->callback(itb, node->data, true);
>> +		return;
>> +	case track_task_down:
>
> I'm not sure the up and down naming is the most obvious naming for
> users.  It's obviously inspired by semaphores but it's not entirely
> obvious that this is going to make things clear and meaningful for
> someone trying to understand the interface.

In my 1st attempt I have called the framework interface_tracker, so it 
was named ifup/ifdown after unix commands:) Now it is less obvious.
Finding good names is always painful, anyway I will think about it.

>
>> +static int track_process_queue(struct tracker *track)
>> +{
>> +	struct track_task *task, *ptask = NULL;
>> +	unsigned long flags;
>> +	bool empty;
>> +
>> +	/* Queue non-emptiness is used as a sentinel to prevent processing
>> +	 * by multiple threads, so we cannot delete entry from the queue
>> +	 * until it is processed.
>> +	 */
>> +	while (true) {
>> +		spin_lock_irqsave(&track->queue_lock, flags);
>> +
>> +		if (ptask)
>> +			list_del(&ptask->list);
>> +		task = list_first_entry(&track->queue,
>> +					struct track_task, list);
>> +
>> +		empty = list_empty(&track->queue);
>> +		if (empty)
>> +			complete_all(&track->queue_empty);
>> +
>> +		spin_unlock_irqrestore(&track->queue_lock, flags);
>
> Here we get a task from the head of the list and drop the lock, leaving
> the task on the list...

Yes and it is explained in the comment few lines above.

>
>> +		kfree(ptask);
>> +
>> +		if (empty)
>> +			break;
>> +
>> +		track_process_task(track, task);
>
> ...we then go and do some other stuff, including processing that task,
> without the lock or or any other means I can see of excluding other
> users before going round and removing the task.  This seems to leave us
> vulnerable to double execution.

No, if you look at track_add_task function you will see that the queue 
is processed only if it is initially empty, otherwise the task is only 
added to the queue, so it will be processed after processing earlier tasks.
So the rule is that if someone add task to the queue it checks if the 
queue is empty, in such case it process all tasks from the queue until
the queue becomes empty, even the tasks added by other processed.
This way all tasks are serialized.


> I *think* this is supposed to be
> handled by your comment "Provider should take care of calling
> notifications synchronously in proper order" in the changelog but that's
> a bit obscure, it's not specific about what the requirements are (or
> what the limits are supposed to be on the notification callbacks).

No, this comment is just to avoid advertising object (ie calling 
track_up) that can be just removed by concurrent thread.


>
> I'm also unclear what is supposed to happen if adding a notification
> races with removing the thing being watched.
>

The sequence should be always as follows:
1. create thing, then call track_up(thing).
...
2. call track_down(thing) then remove thing.

If we put 1 into probe and 2 into remove callback of the driver it will 
be safe - we are synchronised by device_lock. But if, for some reason, 
we want to create object after probe we should do own synchronization or 
just put device_lock around 1. The same applies if we want to remove
object earlier. This is the comment above about. I will expand it to 
more verbose explanation.

Regards
Andrzej




