Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaBOCL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 21:11:56 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:51278 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaBOCLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 21:11:55 -0500
Message-ID: <52FECCE3.1010707@huawei.com>
Date: Sat, 15 Feb 2014 10:11:47 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 cgroup/for-3.15] cgroup: make cgroup_enable_task_cg_lists()
 to grab siglock
References: <20140213182931.GB17608@htj.dyndns.org> <20140214204709.GB2851@mtj.dyndns.org>
In-Reply-To: <20140214204709.GB2851@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/15 4:47, Tejun Heo wrote:
> Currently, there's nothing explicitly preventing
> cgroup_enable_task_cg_lists() from missing set PF_EXITING and race
> against cgroup_exit(), and, depending on the timing, cgroup_exit()
> seemingly may finish with the task still linked on css_set leading to
> list corruption because cgroup_enable_task_cg_lists() can end up
> linking it after list_empty(&tsk->cg_list) test in cgroup_exit().
> 
> This can't really happen because exit_mm() grabs and release
> task_lock() between setting of PF_EXITING and cgroup_exit(), and
> cgroup_enable_task_cg_lists() synchronizes against task_lock too;
> however, this is fragile and more of a happy accident.  Let's make the
> synchronization explicit by making cgroup_enable_task_cg_lists() grab
> siglock around PF_EXITING testing.
> 
> This whole on-demand cg_list optimization is extremely fragile and has
> ample possibility to lead to bugs which can cause things like
> once-a-year oops during boot.  I'm wondering whether the better
> approach would be just adding "cgroup_disable=all" handling which
> disables the whole cgroup rather than tempting fate with this dynamic
> optimization craziness.
> 
> v2: Li pointed out that the race condition can't actually happen due
>     to task_lock locking in exit_mm().  Updated the patch description
>     accordingly and dropped -stable cc.
> 

I realise exit_mm() is a no-op for threads... There're quite a few places
task_lock is used between exit_signal() and cgroup_exit(), but they're
all conditional, so I think your original changelog stands!

