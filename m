Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaFDOrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:47:19 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:34424 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbaFDOrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:47:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140604075324.GI30445@twins.programming.kicks-ass.net>
References: <cover.1401841482.git.luto@amacapital.net> <ad9dcf321a5b74e72a1b63a0d59c8ddc68509c0f.1401841482.git.luto@amacapital.net>
 <20140604075324.GI30445@twins.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 4 Jun 2014 07:46:54 -0700
Message-ID: <CALCETrUysDCxNTBJ1tkxjDLD+xV56kh-SYCyM8MLgvo9PdXk7Q@mail.gmail.com>
Subject: Re: [PATCH 4/6] sched,idle: Clear polling before descheduling the
 idle thread
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, nicolas.pitre@linaro.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 12:53 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jun 03, 2014 at 05:29:50PM -0700, Andy Lutomirski wrote:
>> @@ -229,6 +234,8 @@ static void cpu_idle_loop(void)
>>                */
>>               preempt_set_need_resched();
>>               tick_nohz_idle_exit();
>> +             __current_clr_polling();
>> +             smp_mb__after_clear_bit();
>
> barriers always need a comment, and I'm not entirely sure why you put
> this one here.

Will do.

I actually suspect that the barrier isn't needed in this patch, but it
will be needed one patch later when there's a sched_ttwu_pending after
the barrier.  I'll move this to the next patch and add a comment.

The reason that the barrier is needed is that polling needs to be
visibly cleared before checking for queued ttwu tasks, because
otherwise another CPU could queue a ttwu task, do set_nr_if_polling,
and get a true return value *after* sched_ttwu_pending because the CPU
decided to defer the clear_bit.

--Andy
