Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbaIUFQP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 01:16:15 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:46240 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaIUFQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 01:16:14 -0400
To: tj@kernel.org, lizefan@huawei.com, miaox@cn.fujitsu.com
Cc: peterz@infradead.org, mingo@redhat.com, akpm@linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        fernando_b1@lab.ntt.co.jp
Subject: Re: Racy manipulation of task_struct->flags in cgroups code causes hard to reproduce kernel panics
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201409192053.IHJ35462.JLOMOSOFFVtQFH@I-love.SAKURA.ne.jp>
	<541D16EA.70407@huawei.com>
	<20140920172819.GD3681@htj.dyndns.org>
In-Reply-To: <20140920172819.GD3681@htj.dyndns.org>
Message-Id: <201409211415.GJG26578.MFQOHtSFVJLOOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 21 Sep 2014 14:15:11 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> On Sat, Sep 20, 2014 at 01:55:54PM +0800, Zefan Li wrote:
> > > Then, what made current->flags to unexpectedly preserve PF_USED_MATH flag?
> > > The user is running cgrulesengd process in order to utilize cpuset cgroup.
> > > Thus, cpuset_update_task_spread_flag() is called when cgrulesengd process
> > > writes someone's pid to /cgroup/cpuset/$group/tasks interface.
> > > 
> > > cpuset_update_task_spread_flag() is updating other thread's
> > > "struct task_struct"->flags without exclusion control or atomic
> > > operations!
> > > 
> > > ---------- linux-2.6.32-358.23.2.el6/kernel/cpuset.c ----------
> > > 300:/*
> > > 301: * update task's spread flag if cpuset's page/slab spread flag is set
> > > 302: *
> > > 303: * Called with callback_mutex/cgroup_mutex held
> > > 304: */
> > > 305:static void cpuset_update_task_spread_flag(struct cpuset *cs,
> > > 306:                                    struct task_struct *tsk)
> > > 307:{
> > > 308:    if (is_spread_page(cs))
> > > 309:            tsk->flags |= PF_SPREAD_PAGE;
> > > 310:    else
> > > 311:            tsk->flags &= ~PF_SPREAD_PAGE;
> > > 312:    if (is_spread_slab(cs))
> > > 313:            tsk->flags |= PF_SPREAD_SLAB;
> > > 314:    else
> > > 315:            tsk->flags &= ~PF_SPREAD_SLAB;
> > > 316:}
> > 
> > We should make the updating of this flag atomic.
> 
> Ugh, why do we even implement that in cpuset.  This should be handled
> by MPOL_INTERLEAVE.  It feels like people have been using cpuset as
> the dumpsite that people used w/o thinking much.  Going forward, let's
> please confine cpuset to collective cpu and memory affinity
> configuration.  It really shouldn't be implementing novel features for
> scheduler or mm.
> 
> Anyways, yeah, the patch looks correct to me.  Can you please send a
> version w/ proper description and sob?
> 

This race condition exists since commit 950592f7b991 ("cpusets: update
tasks' page/slab spread flags in time") (i.e. Linux 2.6.31 and later)
but "struct task_struct"->atomic_flags was added in Linux 3.17.

If use of ->atomic_flags for cpuset is acceptable, how should we fix
older kernels? Backport ->atomic_flags?

> Thanks.
> 
> -- 
> tejun
> 
