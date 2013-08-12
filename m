Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab3HLOnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:43:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57076 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab3HLOnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:43:22 -0400
Date: Mon, 12 Aug 2013 16:43:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lei Wen <adrian.wenl@gmail.com>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, leiwen@marvell.com
Subject: Re: false nr_running check in load balance?
Message-ID: <20130812144309.GK27162@twins.programming.kicks-ass.net>
References: <CALZhoSQgw_-UaF0VOMjMqRJC8D4oQTBp4Bv=zJS+x0Wu97f2FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALZhoSQgw_-UaF0VOMjMqRJC8D4oQTBp4Bv=zJS+x0Wu97f2FQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 09:23:46PM +0800, Lei Wen wrote:
> Hi Paul,
> 
> I notice in load_balance function, it would check busiest->nr_running
> to decide whether to perform the real task movement.
> 
> But in some case, I saw the nr_running is not matching with
> the task in the queue, which seems make scheduler to do many redundant
> checking.
> What I means is like there is only one task in the queue, but nr_running
> shows it has two. So if that task cannot be moved, it would be still checked
> for twice.
> 
> With further checking, I find there is one patch you submit before:
> commit 953bfcd10e6f3697233e8e5128c611d275da39c1
> Author: Paul Turner <pjt@google.com>
> Date:   Thu Jul 21 09:43:27 2011 -0700
> 
>     sched: Implement hierarchical task accounting for SCHED_OTHER
> 
> In this patch, you increase nr_running when enqueue enqueue_task_stop,
> which is the reason nr_running is increase while task not be increased.
> It is true at that time, the stopper has been waken up and enqueue again
> into cpu, and do the migration job. So the logic should be right there.
> 
> My question is whether we could change the judgment into cfs_rq->nr_running?
> Since the load_balance is only for cfs, right?
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index bb456f4..ffc0d35 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5096,7 +5096,7 @@ redo:
>         schedstat_add(sd, lb_imbalance[idle], env.imbalance);
> 
>         ld_moved = 0;
> -       if (busiest->nr_running > 1) {
> +       if (busiest->cfs.nr_running > 1) {
>                 /*
>                  * Attempt to move tasks. If find_busiest_group has found
>                  * an imbalance but busiest->nr_running <= 1, the group is
> 

Not quite right; I think you need busiest->cfs.h_nr_running.
cfs.nr_running is the number of entries running in this 'group'. If
you've got nested groups like:

 'root'
   \
   'A'
   / \
  t1 t2

root.nr_running := 1 'A', even though you've got multiple running tasks.


