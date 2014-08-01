Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaHANuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:50:08 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:37912 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaHANuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:50:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140801132754.GI19379@twins.programming.kicks-ass.net>
References: <1406801797-20139-1-git-send-email-ilya.dryomov@inktank.com>
	<20140731115759.GS19379@twins.programming.kicks-ass.net>
	<CALFYKtBGQpxaZ0EFXbdvuEHeDeASeU-7XxQ_1a6ZDM=aJS651w@mail.gmail.com>
	<20140731131331.GT19379@twins.programming.kicks-ass.net>
	<1406817052.17194.12.camel@marge.simpson.net>
	<20140731143946.GV19379@twins.programming.kicks-ass.net>
	<CALFYKtBnK4uaq-37O3gWVQLuQZ9Vrs8oNhdvcUWEPqgpge-pdw@mail.gmail.com>
	<20140801132754.GI19379@twins.programming.kicks-ass.net>
Date: Fri, 1 Aug 2014 17:50:05 +0400
Message-ID: <CALFYKtDDnebBbQSXBOGwabJ5cNga8b_MFq8bREJ+Qnw2f4eYmw@mail.gmail.com>
Subject: Re: [PATCH] locking/mutexes: Revert "locking/mutexes: Add extra
 reschedule point"
From: Ilya Dryomov <ilya.dryomov@inktank.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>, davidlohr@hp.com,
        jason.low2@hp.com, axboe@kernel.dk,
        Kent Overstreet <kmo@daterainc.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2014 at 5:27 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Aug 01, 2014 at 04:56:27PM +0400, Ilya Dryomov wrote:
>> I'm going to fix up rbd_request_fn(), but I want to make sure
>> I understand this in full.
>>
>> - Previously the danger of calling blocking primitives on the way to
>>   schedule(), i.e. with task->state != TASK_RUNNING, was that if the
>>   blocking primitive was indeed to block the task state would be set
>>   back to TASK_RUNNING and the schedule() that that task was on the way
>>   to wouldn't have any effect.  Your "Add extra reschedule point" patch
>>   essentially made calling mutex_lock() and probably others much more
>>   wrong that it used to be, because mutex_lock() may now reschedule
>>   when the task is not on the mutex wait queue.
>
> Right and in general we cannot allow spurious wakeups (although we try
> very hard to deal with them in generic code, which is why things more or
> less worked).
>
> But if you do a patch that 'randomly' ignores ->state on schedule (I did
> one) stuff comes apart _real_ quick.
>
> Therefore you should very much not destroy ->state on the way to
> schedule.
>
>> - There is nothing wrong with releasing queue_lock and reenabling IRQs
>>   in rbd_request_fn() as long as it doesn't block and I remember to
>>   disable IRQs and take queue_lock back on return.
>
> Releasing queue_lock might be ok, dunno about the blk locking, however
> reenabling IRQs it is actually wrong as per blk_flush_plug_list() since
> that uses local_irq_save()/restore() which means it can be called from
> contexts which cannot deal with enabling IRQs, and then your
> ->request_fn() goes and does that.
>
> Now maybe blk_flush_plug_list() is overly paranoid and it could use
> local_irq_disable()/enable() instead, I don't know. But until it does, a
> request_fn() should never reenable IRQs.
>
>> I'm asking because rbd_request_fn() is probably not the only broken in
>> this way code path.  I poked around and found read_events() in aio.c,
>> it seems to have been written with the "danger" assumption that
>> I outlined above and there is even a comment to it.
>
> I'm fairly sure there's more broken stuff, I didn't dare looking.
>
>> Does that above make sense or am I missing something?
>
> I think that's about it.

Thanks for clarifying things.  CC'ing Kent to draw attention to
read_events().

                Ilya
