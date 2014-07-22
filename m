Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaGVJmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:42:05 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:45425 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbaGVJmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:42:02 -0400
MIME-Version: 1.0
In-Reply-To: <53CD4644.4010907@citrix.com>
References: <1405688346-7349-1-git-send-email-jonathan.davies@citrix.com>
	<20140718140821.GD20603@laptop.programming.kicks-ass.net>
	<53CD4644.4010907@citrix.com>
Date: Tue, 22 Jul 2014 17:35:48 +0800
Message-ID: <CAJd=RBBjLh2VLyGLCY=+5xwCZw7vmfrOi9xhuX52w7TQTxG-_g@mail.gmail.com>
Subject: Re: [PATCH RFC] sched/core: Make idle_cpu return 0 if doing softirq work
From: Hillf Danton <dhillf@gmail.com>
To: Jonathan Davies <jonathan.davies@citrix.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan

On Tue, Jul 22, 2014 at 12:56 AM, Jonathan Davies
<jonathan.davies@citrix.com> wrote:
>
>
> On 18/07/14 15:08, Peter Zijlstra wrote:
>>
>> On Fri, Jul 18, 2014 at 01:59:06PM +0100, Jonathan Davies wrote:
>>>
>>> The current implementation of idle_cpu only considers tasks that might be
>>> in the
>>> CPU's runqueue. If there's nothing in the specified CPU's runqueue, it
>>> will
>>> return 1. But if the CPU is doing work in the softirq context, it is
>>> wrong for
>>> idle_cpu to return 1. This patch makes it return 0.
>>>
>>> I observed this to be a problem with a device driver kicking a kthread by
>>> executing wake_up from softirq context. The Completely Fair Scheduler's
>>> select_task_rq_fair was looking for an "idle sibling" of the CPU
>>> executing it by
>>> calling select_idle_sibling, passing the executing CPU as the 'target'
>>> parameter. The first thing that select_idle_sibling does is to check
>>> whether the
>>> 'target' CPU is idle, using idle_cpu, and to return that CPU if so.
>>> Despite the
>>> executing CPU being busy in softirq context, idle_cpu was returning 1,
>>> meaning
>>> that the scheduler would consistently try to run the kthread on the same
>>> CPU as
>>> the kick came from. Given that the softirq work was on-going, this led to
>>> a
>>> multi-millisecond delay before the scheduler eventually realised it
>>> should
>>> migrate the kthread to a different CPU.
>>
>>
>> If your softirq takes _that_ long its broken anyhow.
>
>
> Modern NICs can sustain 40 Gb/s of traffic. For network device drivers that
> use NAPI, polling is done in softirq context. At this data-rate, the
> per-packet processing overhead means means that a lot of CPU time is spent
> in softirq.
>
Perhaps fcoe_percpu_receive_thread (linux/drivers/scsi/fcoe/fcoe.c)
can help you.

Hillf
