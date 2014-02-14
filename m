Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaBNDuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 22:50:35 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:20892 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbaBNDud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 22:50:33 -0500
Message-ID: <52FD9256.1080801@huawei.com>
Date: Fri, 14 Feb 2014 11:49:42 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH cgroup/for-3.14-fixes] cgroup: update cgroup_enable_task_cg_lists()
 to grab siglock
References: <20140213182931.GB17608@htj.dyndns.org>
In-Reply-To: <20140213182931.GB17608@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/14 2:29, Tejun Heo wrote:
> Currently, there's nothing preventing cgroup_enable_task_cg_lists()
> from missing set PF_EXITING and race against cgroup_exit().  Depending
> on the timing, cgroup_exit() may finish with the task still linked on
> css_set leading to list corruption.  Fix it by grabbing siglock in
> cgroup_enable_task_cg_lists() so that PF_EXITING is guaranteed to be
> visible.
> 
> This whole on-demand cg_list optimization is extremely fragile and has
> ample possibility to lead to bugs which can cause things like
> once-a-year oops during boot.

I added the PF_EXITING check years ago:

commit 0e04388f0189fa1f6812a8e1cb6172136eada87e
Author: Li Zefan <lizf@cn.fujitsu.com>
Date:   Thu Apr 17 11:37:15 2008 +0800

    cgroup: fix a race condition in manipulating tsk->cg_list

Now the only race I see is caused by checking tsk->cg_list without locking
in cgroup_exit():

cgroup_enable_task_cg_lists()
  ...
  if (!p->flags & PF_EXITING) && list_empty(p->cg_list))
								exit_signal(tsk)  <-- set PF_EXTING;
								...
								if (!list_empty(&tsk->cg_list)) {
								        down_write(&css_set_rwsem);
								        if (!list_empty(&tsk->cg_list))
								                list_del_init(&tsk->cg_list);
								        up_write(&css_set_rwsem);
								}
  	list_add(p->cg_list, ...);

Your patch can fix this race, but after diving into the code I don't think
the race exists, because exit_mm() locks&unlocks task_lock, and exit_mm()
is called after exit_signal() and before cgroup_exit(), and task_lock is
also taken by cgroup_enable_task_cg_lists().

I totally agree the code is fragile and we should take your patch. I just
want to make it clear if the bug exists in real life or not, and then we
can write better changelog and decide to queue the patch for 3.14 or 3.15
and decide to mark it for stable or not.

> I'm wondering whether the better
> approach would be just adding "cgroup_disable=all" handling which
> disables the whole cgroup rather than tempting fate with this
> on-demand craziness.
> 

:)

> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  kernel/cgroup.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 68d8710..105f273 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2905,9 +2905,14 @@ static void cgroup_enable_task_cg_lists(void)
>  		 * We should check if the process is exiting, otherwise
>  		 * it will race with cgroup_exit() in that the list
>  		 * entry won't be deleted though the process has exited.
> +		 * Do it while holding siglock so that we don't end up
> +		 * racing against cgroup_exit().
>  		 */
> +		spin_lock_irq(&p->sighand->siglock);
>  		if (!(p->flags & PF_EXITING) && list_empty(&p->cg_list))
>  			list_add(&p->cg_list, &task_css_set(p)->tasks);
> +		spin_unlock_irq(&p->sighand->siglock);
> +
>  		task_unlock(p);
>  	} while_each_thread(g, p);
>  	read_unlock(&tasklist_lock);
> 

