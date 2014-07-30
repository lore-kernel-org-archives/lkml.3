Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbaG3Ona (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:43:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbaG3On3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:43:29 -0400
Date: Wed, 30 Jul 2014 16:41:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Kirill Tkhai <tkhai@yandex.ru>,
        linux-kernel@vger.kernel.org, nicolas.pitre@linaro.org, pjt@google.com,
        rostedt@goodmis.org, umgwanakikbuti@gmail.com,
        tim.c.chen@linux.intel.com, mingo@kernel.org
Subject: Re: [PATCH v2 2/5] sched: Teach scheduler to understand
	ONRQ_MIGRATING state
Message-ID: <20140730144101.GA19337@redhat.com>
References: <20140726145508.6308.69121.stgit@localhost> <20140726145912.6308.32554.stgit@localhost> <20140728080122.GL6758@twins.programming.kicks-ass.net> <1406538338.23175.12.camel@tkhai> <1406627582.3600.9.camel@tkhai> <20140729161928.GA31298@redhat.com> <1406707485.3600.32.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406707485.3600.32.camel@tkhai>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30, Kirill Tkhai wrote:
>
> В Вт, 29/07/2014 в 18:19 +0200, Oleg Nesterov пишет:
> > On 07/29, Kirill Tkhai wrote:
> > >
> > > How about this? Everything is inside task_rq_lock() now. The patch
> > > became much less.
> >
> > And with this change task_migrating() is not possible under
> > task_rq_lock() or __task_rq_lock(). This means that 1/5 can be simplified
> > too.
>
> It seems to me it won't be useless anyway. In every place we underline
> that a task is exactly queued or dequeued, so it's not necessary to remember
> whether it is migrating or not. This is a cleanup, though it's big.

But, otoh, when you read the code which does "if (task_queued())" it is not
clear whether this code knows that task_migrating() is not possible, or we
should treat the task_migrating() state specially.

But I agree, this is subjective, I leave this to you and Peter.

> > __migrate_swap_task() is probably the notable exception...
> >
> > Off-topic, but it takes 2 ->pi_lock's. This means it can deadlock with
> > try_to_wake_up_local() (if a 3rd process does ttwu() and waits for
> > ->on_cpu == 0). But I guess __migrate_swap_task() should not play with
> > PF_WQ_WORKER threads.
>
> Hmm.. I'm surprised, PF_WQ_WORKER threads may be unbound. But it seems
> we still can't pass them to try_to_wake_up_local.

Why? See wq_worker_sleeping/try_to_wake_up_local in __schedule().

But perhaps I misunderstood you, and probably I was not clear. If
wq_worker_sleeping() returns !NULL then both task should be local, surely
we do not want to migrate them.

Oleg.

