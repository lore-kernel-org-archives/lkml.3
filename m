Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbaA2EQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 23:16:55 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:15458 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaA2EQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 23:16:53 -0500
Message-ID: <52E880A6.4040902@huawei.com>
Date: Wed, 29 Jan 2014 12:16:38 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] cgroup: drop module support
References: <1390952641-15950-1-git-send-email-tj@kernel.org> <1390952641-15950-3-git-send-email-tj@kernel.org>
In-Reply-To: <1390952641-15950-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  /**
> - * for_each_subsys - iterate all loaded cgroup subsystems
> + * for_each_subsys - iterate all enabled cgroup subsystems
>   * @ss: the iteration cursor
>   * @ssid: the index of @ss, CGROUP_SUBSYS_COUNT after reaching the end
> - *
> - * Iterates through all loaded subsystems.  Should be called under
> - * cgroup_mutex or cgroup_root_mutex.
>   */
>  #define for_each_subsys(ss, ssid)					\
> -	for (({ cgroup_assert_mutex_or_root_locked(); (ssid) = 0; });	\
> -	     (ssid) < CGROUP_SUBSYS_COUNT; (ssid)++)			\
> -		if (!((ss) = cgroup_subsys[(ssid)])) { }		\
> -		else
> -
> -/**
> - * for_each_builtin_subsys - iterate all built-in cgroup subsystems
> - * @ss: the iteration cursor
> - * @i: the index of @ss, CGROUP_BUILTIN_SUBSYS_COUNT after reaching the end
> - *
> - * Bulit-in subsystems are always present and iteration itself doesn't
> - * require any synchronization.
> - */
> -#define for_each_builtin_subsys(ss, i)					\
> -	for ((i) = 0; (i) < CGROUP_BUILTIN_SUBSYS_COUNT &&		\
> -	     (((ss) = cgroup_subsys[i]) || true); (i)++)
> +	for ((ssid) = 0; (ssid) < CGROUP_SUBSYS_COUNT &&		\
> +	     (((ss) = cgroup_subsys[ssid]) || true); (ssid)++)

Now cgroup_subsys[i] won't be NULL, so we can drop "|| true".

>  
>  /* iterate across the active hierarchies */
>  #define for_each_active_root(root)					\
> @@ -975,50 +951,24 @@ static void cgroup_d_remove_dir(struct dentry *dentry)
>  	remove_dir(dentry);
>  }
>  

...

> -	if (need_forkexit_callback) {
> -		/*
> -		 * fork/exit callbacks are supported only for builtin
> -		 * subsystems, and the builtin section of the subsys
> -		 * array is immutable, so we don't need to lock the
> -		 * subsys array here. On the other hand, modular section
> -		 * of the array can be freed at module unload, so we
> -		 * can't touch that.
> -		 */
> -		for_each_builtin_subsys(ss, i)
> +	if (need_forkexit_callback)
> +		for_each_subsys(ss, i)
>  			if (ss->fork)
>  				ss->fork(child);
> -	}

This looks a bit ugly. How about leaving the parentheses for the
outmost if statement?

if (need_forkexit_callback) {
	for_each_subsys(ss, i)
		if (ss->fork)
			ss->fork(child);
}


