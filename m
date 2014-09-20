Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbaITR2Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 13:28:24 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:57377 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665AbaITR2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 13:28:22 -0400
Date: Sat, 20 Sep 2014 13:28:19 -0400
From: Tejun Heo <tj@kernel.org>
To: Zefan Li <lizefan@huawei.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, peterz@infradead.org,
        mingo@redhat.com, akpm@linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, fernando_b1@lab.ntt.co.jp
Subject: Re: Racy manipulation of task_struct->flags in cgroups code causes
 hard to reproduce kernel panics
Message-ID: <20140920172819.GD3681@htj.dyndns.org>
References: <201409192053.IHJ35462.JLOMOSOFFVtQFH@I-love.SAKURA.ne.jp>
 <541D16EA.70407@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541D16EA.70407@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Sep 20, 2014 at 01:55:54PM +0800, Zefan Li wrote:
> > Then, what made current->flags to unexpectedly preserve PF_USED_MATH flag?
> > The user is running cgrulesengd process in order to utilize cpuset cgroup.
> > Thus, cpuset_update_task_spread_flag() is called when cgrulesengd process
> > writes someone's pid to /cgroup/cpuset/$group/tasks interface.
> > 
> > cpuset_update_task_spread_flag() is updating other thread's
> > "struct task_struct"->flags without exclusion control or atomic
> > operations!
> > 
> > ---------- linux-2.6.32-358.23.2.el6/kernel/cpuset.c ----------
> > 300:/*
> > 301: * update task's spread flag if cpuset's page/slab spread flag is set
> > 302: *
> > 303: * Called with callback_mutex/cgroup_mutex held
> > 304: */
> > 305:static void cpuset_update_task_spread_flag(struct cpuset *cs,
> > 306:                                    struct task_struct *tsk)
> > 307:{
> > 308:    if (is_spread_page(cs))
> > 309:            tsk->flags |= PF_SPREAD_PAGE;
> > 310:    else
> > 311:            tsk->flags &= ~PF_SPREAD_PAGE;
> > 312:    if (is_spread_slab(cs))
> > 313:            tsk->flags |= PF_SPREAD_SLAB;
> > 314:    else
> > 315:            tsk->flags &= ~PF_SPREAD_SLAB;
> > 316:}
> 
> We should make the updating of this flag atomic.

Ugh, why do we even implement that in cpuset.  This should be handled
by MPOL_INTERLEAVE.  It feels like people have been using cpuset as
the dumpsite that people used w/o thinking much.  Going forward, let's
please confine cpuset to collective cpu and memory affinity
configuration.  It really shouldn't be implementing novel features for
scheduler or mm.

Anyways, yeah, the patch looks correct to me.  Can you please send a
version w/ proper description and sob?

Thanks.

-- 
tejun
