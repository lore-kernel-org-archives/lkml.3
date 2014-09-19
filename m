Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbaISWqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 18:46:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:43785 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949AbaISWqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 18:46:16 -0400
Date: Sat, 20 Sep 2014 00:21:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: mingo@redhat.com, tj@kernel.org, akpm@linux-foundation.org,
        lizefan@huawei.com, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, fernando_b1@lab.ntt.co.jp
Subject: Re: Racy manipulation of task_struct->flags in cgroups code causes
 hard to reproduce kernel panics
Message-ID: <20140919222103.GH2832@worktop.localdomain>
References: <201409192053.IHJ35462.JLOMOSOFFVtQFH@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201409192053.IHJ35462.JLOMOSOFFVtQFH@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 08:53:33PM +0900, Tetsuo Handa wrote:
> cpuset_update_task_spread_flag() is updating other thread's
> "struct task_struct"->flags without exclusion control or atomic
> operations!
> 
> ---------- linux-2.6.32-358.23.2.el6/kernel/cpuset.c ----------
> 300:/*
> 301: * update task's spread flag if cpuset's page/slab spread flag is set
> 302: *
> 303: * Called with callback_mutex/cgroup_mutex held
> 304: */
> 305:static void cpuset_update_task_spread_flag(struct cpuset *cs,
> 306:                                    struct task_struct *tsk)
> 307:{
> 308:    if (is_spread_page(cs))
> 309:            tsk->flags |= PF_SPREAD_PAGE;
> 310:    else
> 311:            tsk->flags &= ~PF_SPREAD_PAGE;
> 312:    if (is_spread_slab(cs))
> 313:            tsk->flags |= PF_SPREAD_SLAB;
> 314:    else
> 315:            tsk->flags &= ~PF_SPREAD_SLAB;
> 316:}

So that is indeed clearly buggy and should not be done. One should only
every change current->flags.

Most sites do indeed do that, with exceptions:

 fork.c: some assignments are done before the new task is visible - safe
 __kthread_bind: requires that the task is sleeping - safe
 workqueue/worker: same as __kthread_bind, the task is asleep - safe
 workqueue/rescue: is current - safe

Which does indeed leave this cpuset exception which is clearly and
obviously broken.

The 'simple' solution would be to force 'suspend/freeze' the task while
poking at its ->flags.


