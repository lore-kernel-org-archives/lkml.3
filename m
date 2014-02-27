Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaB0Kcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 05:32:42 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:2951 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaB0Kck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 05:32:40 -0500
Message-ID: <530F1392.2090407@huawei.com>
Date: Thu, 27 Feb 2014 18:29:38 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 1/2] cpuset: fix a locking issue in cpuset_migrate_mm()
References: <530F1117.1020605@huawei.com>
In-Reply-To: <530F1117.1020605@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/27 18:19, Li Zefan wrote:
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

I meant it won't prevent a task from migrating to another cpuset.

> it won't prevent the original task->cgroup from destroying during this
> change.


