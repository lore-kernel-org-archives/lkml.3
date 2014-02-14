Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaBNLPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:15:32 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:51142 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaBNLPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:15:30 -0500
Message-ID: <52FDFAC6.1080802@gmail.com>
Date: Fri, 14 Feb 2014 19:15:18 +0800
From: Li Zefan <lizf.kern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: fix top cgroup refcnt leak
References: <52FDE393.6050607@huawei.com>
In-Reply-To: <52FDE393.6050607@huawei.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2014年02月14日 17:36, Li Zefan 写道:
> If we mount the same cgroupfs in serveral mount points, and then
> umount all of them, kill_sb() will be called only once.
> 
> Therefore it's wrong to increment top_cgroup's refcnt when we find
> an existing cgroup_root.
> 
> Try:
> 	# mount -t cgroup -o cpuacct xxx /cgroup
> 	# mount -t cgroup -o cpuacct xxx /cgroup2
> 	# cat /proc/cgroups | grep cpuacct
> 	cpuacct 2       1       1
> 	# umount /cgroup
> 	# umount /cgroup2
> 	# cat /proc/cgroups | grep cpuacct
> 	cpuacct 2       1       1
> 
> You'll see cgroupfs will never be freed.
> 
> Also move this chunk of code upwards.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
>  kernel/cgroup.c | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 37d94a2..5bfe738 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1498,6 +1498,22 @@ retry:
>  		bool name_match = false;
>  
>  		/*
> +		 * A root's lifetime is governed by its top cgroup.  Zero
> +		 * ref indicate that the root is being destroyed.  Wait for
> +		 * destruction to complete so that the subsystems are free.
> +		 * We can use wait_queue for the wait but this path is
> +		 * super cold.  Let's just sleep for a bit and retry.
> +		 */
> +		if (!atomic_read(&root->top_cgroup.refcnt)) {

oops, this fix is wrong. We call kernfs_mount() without cgroup locks and it
drops cgroup refcnt if failed.

I guess we need to bump the refcnt and then drop it after kernfs_mount().
