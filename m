Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaB0Ohn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:37:43 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:59884 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbaB0Ohl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:37:41 -0500
Date: Thu, 27 Feb 2014 09:37:37 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 1/2] cpuset: fix a locking issue in cpuset_migrate_mm()
Message-ID: <20140227143737.GA19178@htj.dyndns.org>
References: <530F1117.1020605@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530F1117.1020605@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 06:19:03PM +0800, Li Zefan wrote:
> I can trigger a lockdep warning:
> 
>   # mount -t cgroup -o cpuset xxx /cgroup
>   # mkdir /cgroup/cpuset
>   # mkdir /cgroup/tmp
>   # echo 0 > /cgroup/tmp/cpuset.cpus
>   # echo 0 > /cgroup/tmp/cpuset.mems
>   # echo 1 > /cgroup/tmp/cpuset.memory_migrate
>   # echo $$ > /cgroup/tmp/tasks
>   # echo 1 > /cgruop/tmp/cpuset.mems
> 
>   ===============================
>   [ INFO: suspicious RCU usage. ]
>   3.14.0-rc1-0.1-default+ #32 Not tainted
>   -------------------------------
>   include/linux/cgroup.h:682 suspicious rcu_dereference_check() usage!
>   ...
>     [<ffffffff81582174>] dump_stack+0x72/0x86
>     [<ffffffff810b8f01>] lockdep_rcu_suspicious+0x101/0x140
>     [<ffffffff81105ba1>] cpuset_migrate_mm+0xb1/0xe0
>   ...
> 
> We used to hold cgroup_mutex when calling cpuset_migrate_mm(), but now
> we hold cpuset_mutex, which causes task_css() to complain.
> 
> This is not a false-positive but a real issue.
> 
> Holding cpuset_mutex won't prevent a task's cpuset from changing, and
> it won't prevent the original task->cgroup from destroying during this
> change.
> 
> Fixes: 5d21cc2db040 (cpuset: replace cgroup_mutex locking with cpuset internal locking)
> Cc: <stable@vger.kernel.org> # 3.9+
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.14-fixes.

Thanks.

-- 
tejun
