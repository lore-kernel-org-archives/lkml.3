Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbaENCx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 22:53:57 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:8717 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbaENCxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 22:53:55 -0400
Message-ID: <5372DABB.4040908@huawei.com>
Date: Wed, 14 May 2014 10:53:47 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] cgroup: use restart_syscall() for mount retries
References: <1399670015-23463-1-git-send-email-tj@kernel.org> <1399670015-23463-2-git-send-email-tj@kernel.org>
In-Reply-To: <1399670015-23463-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/10 5:13, Tejun Heo wrote:
> cgroup_mount() uses dumb delay-and-retry logic to wait for cgroup_root
> which is being destroyed.  The retry currently loops inside
> cgroup_mount() proper.  This patch makes it return with
> restart_syscall() instead so that retry travels out to userland
> boundary.
> 
> This slightly simplifies the logic and more importantly makes the
> retry logic behave better when the wait for some reason becomes
> lengthy or infinite by allowing the operation to be suspended or
> terminated from userland.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/cgroup.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 3083c5a..2755f33 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1681,7 +1681,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
>  	ret = parse_cgroupfs_options(data, &opts);
>  	if (ret)
>  		goto out_unlock;
> -retry:
> +
>  	/* look for a matching existing root */
>  	if (!opts.subsys_mask && !opts.none && !opts.name) {
>  		cgrp_dfl_root_visible = true;
> @@ -1740,8 +1740,7 @@ retry:
>  		if (!atomic_inc_not_zero(&root->cgrp.refcnt)) {
>  			mutex_unlock(&cgroup_mutex);
>  			msleep(10);
> -			mutex_lock(&cgroup_mutex);
> -			goto retry;
> +			return ERR_PTR(restart_syscall());

We leak memory allocated in parse_cgroupfs_options().

