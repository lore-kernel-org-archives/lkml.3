Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaIVCQA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 22:16:00 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:56061 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaIVCP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 22:15:58 -0400
Message-ID: <541F8656.2030409@huawei.com>
Date: Mon, 22 Sep 2014 10:15:50 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: <tj@kernel.org>, <miaox@cn.fujitsu.com>, <peterz@infradead.org>,
        <mingo@redhat.com>, <akpm@linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <fernando_b1@lab.ntt.co.jp>
Subject: Re: Racy manipulation of task_struct->flags in cgroups code causes
 hard to reproduce kernel panics
References: <201409192053.IHJ35462.JLOMOSOFFVtQFH@I-love.SAKURA.ne.jp> <541D16EA.70407@huawei.com> <20140920172819.GD3681@htj.dyndns.org> <201409211415.GJG26578.MFQOHtSFVJLOOF@I-love.SAKURA.ne.jp>
In-Reply-To: <201409211415.GJG26578.MFQOHtSFVJLOOF@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A02020A.541F865C.0012,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: f6858d4d5a31bcf4f0500124000c849d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Sat, Sep 20, 2014 at 01:55:54PM +0800, Zefan Li wrote:
>>>> Then, what made current->flags to unexpectedly preserve PF_USED_MATH flag?
>>>> The user is running cgrulesengd process in order to utilize cpuset cgroup.
>>>> Thus, cpuset_update_task_spread_flag() is called when cgrulesengd process
>>>> writes someone's pid to /cgroup/cpuset/$group/tasks interface.
>>>>
>>>> cpuset_update_task_spread_flag() is updating other thread's
>>>> "struct task_struct"->flags without exclusion control or atomic
>>>> operations!
>>>>
>>>> ---------- linux-2.6.32-358.23.2.el6/kernel/cpuset.c ----------
>>>> 300:/*
>>>> 301: * update task's spread flag if cpuset's page/slab spread flag is set
>>>> 302: *
>>>> 303: * Called with callback_mutex/cgroup_mutex held
>>>> 304: */
>>>> 305:static void cpuset_update_task_spread_flag(struct cpuset *cs,
>>>> 306:                                    struct task_struct *tsk)
>>>> 307:{
>>>> 308:    if (is_spread_page(cs))
>>>> 309:            tsk->flags |= PF_SPREAD_PAGE;
>>>> 310:    else
>>>> 311:            tsk->flags &= ~PF_SPREAD_PAGE;
>>>> 312:    if (is_spread_slab(cs))
>>>> 313:            tsk->flags |= PF_SPREAD_SLAB;
>>>> 314:    else
>>>> 315:            tsk->flags &= ~PF_SPREAD_SLAB;
>>>> 316:}
>>>
>>> We should make the updating of this flag atomic.
>>
>> Ugh, why do we even implement that in cpuset.  This should be handled
>> by MPOL_INTERLEAVE.  It feels like people have been using cpuset as
>> the dumpsite that people used w/o thinking much.  Going forward, let's
>> please confine cpuset to collective cpu and memory affinity
>> configuration.  It really shouldn't be implementing novel features for
>> scheduler or mm.
>>
>> Anyways, yeah, the patch looks correct to me.  Can you please send a
>> version w/ proper description and sob?
>>
> 
> This race condition exists since commit 950592f7b991 ("cpusets: update
> tasks' page/slab spread flags in time") (i.e. Linux 2.6.31 and later)
> but "struct task_struct"->atomic_flags was added in Linux 3.17.
> 
> If use of ->atomic_flags for cpuset is acceptable, how should we fix
> older kernels? Backport ->atomic_flags?
> 

Yeah, we'll just add tsk->atomic_flags to struct task_struct when
backporting this patch for stable trees.

