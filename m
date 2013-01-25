Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab3AYH0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 02:26:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58878 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab3AYH0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 02:26:38 -0500
Date: Fri, 25 Jan 2013 07:26:33 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] cpuset: fix cpuset_print_task_mems_allowed() vs rename()
 race
Message-ID: <20130125072633.GD4503@ZenIV.linux.org.uk>
References: <51022FBC.2020705@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51022FBC.2020705@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 03:09:48PM +0800, Li Zefan wrote:
> rename() will change dentry->d_name. The result of this race can
> be worse than seeing partially rewritten name, but we might access
> a stale pointer because rename() will re-allocate memory to hold
> a longer name.
> 
> It's safe in the protection of dentry->d_lock.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
>  kernel/cpuset.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 16be7c9..b2476c2 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -2606,8 +2606,12 @@ void cpuset_print_task_mems_allowed(struct task_struct *tsk)
>  
>  	dentry = task_cs(tsk)->css.cgroup->dentry;
>  	spin_lock(&cpuset_buffer_lock);
> +
> +	spin_lock(&dentry->d_lock);
>  	snprintf(cpuset_name, CPUSET_NAME_LEN,
>  		 dentry ? (const char *)dentry->d_name.name : "/");

Ahem...  Can dentry actually be NULL here?  If not, this conditional
is bogus; otherwise, spin_lock(&dentry->d_lock) is going to blow up...
