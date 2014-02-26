Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaBZTBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:01:34 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:65327 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbaBZS7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 13:59:35 -0500
MIME-Version: 1.0
In-Reply-To: <20140226132852.GB30956@twins.programming.kicks-ass.net>
References: <1392767811-28916-1-git-send-email-george.mccollister@gmail.com>
	<20140226132852.GB30956@twins.programming.kicks-ass.net>
Date: Wed, 26 Feb 2014 12:59:35 -0600
Message-ID: <CAFSKS=MAKpmBhMi3A_BJvWQ-hQTyqiXQGt_heXKt3DLZHozDzQ@mail.gmail.com>
Subject: Re: [PATCH] sched: fix double normalization of vruntime
From: George McCollister <george.mccollister@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 7:28 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Feb 18, 2014 at 05:56:51PM -0600, George McCollister wrote:
>> dequeue_entity() is called when p->on_rq and sets se->on_rq = 0
>> which appears to guarentee that the !se->on_rq condition is met.
>> If the task has done set_current_state(TASK_INTERRUPTIBLE) without
>> schedule() the second condition will be met and vruntime will be
>> incorrectly adjusted twice.
>>
>> In certain cases this can result in the task's vruntime never increasing
>> past the vruntime of other tasks on the CFS' run queue, starving them of
>> CPU time.
>>
>> This patch changes switched_from_fair() to use !p->on_rq instead of
>> !se->on_rq.
>>
>> I'm able to cause a task with a priority of 120 to starve all other
>> tasks with the same priority on an ARM platform running 3.2.51-rt72
>> PREEMPT RT by writing one character at time to a serial tty (16550 UART)
>> in a tight loop. I'm also able to verify making this change corrects the
>> problem on that platform and kernel version.
>>
>> I haven't and not sure I will have an opportunity to get a newer kernel
>> version running on the platform mentioned above and have yet to
>> reproduce the problem on another platform.
>
> Yes, I think you're quite right. Another way to look at this is that
> p->on_rq is the one matching p->state.
Yes, correct

>
> Can I have (or add) your Signed-off-by for this patch?

Go ahead and add my sign off. I didn't want to add it before
discussing the issue with someone.

Thanks,
George McCollister
