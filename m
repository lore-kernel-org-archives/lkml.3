Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab3FSFOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 01:14:20 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:50142 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab3FSFOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 01:14:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130618095533.GI3204@twins.programming.kicks-ass.net>
References: <CALZhoSSEfXyojD70cannzG9NxvqXTw6r_L5bxT9Ew+JbFhuxKg@mail.gmail.com>
	<20130618095533.GI3204@twins.programming.kicks-ass.net>
Date: Wed, 19 Jun 2013 13:14:16 +0800
Message-ID: <CALZhoSQszasaynP+Cy66vMUz+2-jRYpQ3eqLFdaC8Y9oZSQfbw@mail.gmail.com>
Subject: Re: Question regarding put_prev_task in preempted condition
From: Lei Wen <adrian.wenl@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tue, Jun 18, 2013 at 5:55 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sun, Jun 09, 2013 at 11:59:36PM +0800, Lei Wen wrote:
>> Hi Peter,
>>
>> While I am checking the preempt related code, I find a interesting part.
>> That is when preempt_schedule is called, for its preempt_count be added
>> PREEMPT_ACTIVE, so in __schedule() it could not be dequeued from rq
>> by deactivate_task.
>>
>> Thus in put_prev_task, which is called a little later in __schedule(), it
>> would call put_prev_task_fair, which finally calls put_prev_entity.
>> For current task is not dequeued from rq, so in this function, it would
>> enqueue it again to the rq by __enqueue_entity.
>>
>> Is there any reason to do like this, since entity already is over rq,
>> why need to queue it again?
>
> Because we keep the current running task outside of the actual queue
> structure. This is because every time we update the runtime
> (__update_curr) the key on which the tree is sorted (vruntime) is
> changed and we'd need to dequeue + enqueue to keep the tree in sync.

I see... I didn't notice for this difference...

>
> By not having the actively running task in the tree we can avoid this;
> at the cost of having to dequeue on switching to the task and enqueue
> when switching from the task.
>
>> And if current rq's vruntime distribution like below, and vruntime with 8
>> is the task that would be get preempted. So in __enqueue_entity,
>> its rb_left/rb_right would be set as NULL and reinserted into this RB tree.
>> Then seems to me now, the entity with vruntime of 3 would be disappeared
>> from the RB tree.
>>             13
>>            /  \
>>          8    19
>>         /  \
>>       3    11
>>
>> I am not sure whether I understand the whole process correctly...
>> Would the example as above happen in our real life?
>
> No, the RB tree code will ensure we'll not loose 3. I suppose you're
> confused by rb_link_node() which does indeed clear the left and right
> node of the entity we're about to link.

Yep, since 8 is not over rq, NULL its two child would lose any info.
Thanks for detailed explanation! :)

Thanks,
Lei

>
> However, we link the previously unlinked entity as a leaf node. So your
> example is flawed; before insertion the tree would look something like:
>
>
>          13
>         /  \
>        11  19
>       /
>      3
>
> Then the lookup in __enqueue_entity would find the place to insert 8 and
> would select the right sibling of 3:
>
>          13
>         /  \
>        11  19
>       /
>      3
>       \
>        (8)
>
> We'd then link 8 as a child leaf of 3; which will indeed have NULL
> leafs. rb_insert_color() will then fix up the tree so we conform to the
> RB constraints. Please read lib/rbtree.c:__rb_insert() the code is quite
> readable.
>
