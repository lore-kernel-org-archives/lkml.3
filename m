Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaBKPgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:36:35 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:65404 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaBKPgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:36:33 -0500
Date: Tue, 11 Feb 2014 10:36:30 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: protect modifications to cgroup_idr with
 cgroup_mutex
Message-ID: <20140211153630.GB24490@htj.dyndns.org>
References: <52F9D9DA.7040108@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F9D9DA.7040108@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 04:05:46PM +0800, Li Zefan wrote:
> Setup cgroupfs like this:
>   # mount -t cgroup -o cpuacct xxx /cgroup
>   # mkdir /cgroup/sub1
>   # mkdir /cgroup/sub2
> 
> Then run these two commands:
>   # for ((; ;)) { mkdir /cgroup/sub1/tmp && rmdir /mnt/sub1/tmp; } &
>   # for ((; ;)) { mkdir /cgroup/sub2/tmp && rmdir /mnt/sub2/tmp; } &
> 
> After seconds you may see this warning:
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 25243 at lib/idr.c:527 sub_remove+0x87/0x1b0()
> idr_remove called for id=6 which is not allocated.
> ...
> Call Trace:
>  [<ffffffff8156063c>] dump_stack+0x7a/0x96
>  [<ffffffff810591ac>] warn_slowpath_common+0x8c/0xc0
>  [<ffffffff81059296>] warn_slowpath_fmt+0x46/0x50
>  [<ffffffff81300aa7>] sub_remove+0x87/0x1b0
>  [<ffffffff810f3f02>] ? css_killed_work_fn+0x32/0x1b0
>  [<ffffffff81300bf5>] idr_remove+0x25/0xd0
>  [<ffffffff810f2bab>] cgroup_destroy_css_killed+0x5b/0xc0
>  [<ffffffff810f4000>] css_killed_work_fn+0x130/0x1b0
>  [<ffffffff8107cdbc>] process_one_work+0x26c/0x550
>  [<ffffffff8107eefe>] worker_thread+0x12e/0x3b0
>  [<ffffffff81085f96>] kthread+0xe6/0xf0
>  [<ffffffff81570bac>] ret_from_fork+0x7c/0xb0
> ---[ end trace 2d1577ec10cf80d0 ]---
> 
> It's because allocating/removing cgroup ID is not properly synchronized.
> 
> The bug was introduced when we converted cgroup_ida to cgroup_idr.
> While synchronization is already done inside ida_simple_{get,remove}(),
> users are responsible for concurrent calls to idr_{alloc,remove}().
> 
> Fixes: 4e96ee8e981b ("cgroup: convert cgroup_ida to cgroup_idr")
> Cc: <stable@vger.kernel.org> #3.12+
> Reported-by: Michal Hocko <mhocko@suse.cz>
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Jesus, you're right.  I missed that completely.  It conflicts with the
return value fix in cgroup/for-3.14-fixes but easy to fix up.
Applying to cgroup/for-3.14-fixes.

Thanks!

-- 
tejun
