Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbaAKAiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 19:38:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaAKAiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 19:38:05 -0500
Date: Fri, 10 Jan 2014 16:38:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>, hughd@google.com,
        "'Minchan Kim'" <minchan@kernel.org>, shli@fusionio.com,
        "'Bob Liu'" <bob.liu@oracle.com>, k.kozlowski@samsung.com,
        stable@vger.kernel.org, weijie.yang.kh@gmail.com
Subject: Re: [PATCH] mm/swap: fix race on swap_info reuse between swapoff
 and swapon
Message-Id: <20140110163803.430c8ab05eca9fee19fa7991@linux-foundation.org>
In-Reply-To: <000001cf0cfd$6d251640$476f42c0$%yang@samsung.com>
References: <000001cf0cfd$6d251640$476f42c0$%yang@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Jan 2014 13:39:55 +0800 Weijie Yang <weijie.yang@samsung.com> wrote:

> swapoff clear swap_info's SWP_USED flag prematurely and free its resources
> after that. A concurrent swapon will reuse this swap_info while its previous
> resources are not cleared completely.
> 
> These late freed resources are:
> - p->percpu_cluster
> - swap_cgroup_ctrl[type]
> - block_device setting
> - inode->i_flags &= ~S_SWAPFILE
> 
> This patch clear SWP_USED flag after all its resources freed, so that swapon
> can reuse this swap_info by alloc_swap_info() safely.
> 
> ...
>
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1922,7 +1922,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  	p->swap_map = NULL;
>  	cluster_info = p->cluster_info;
>  	p->cluster_info = NULL;
> -	p->flags = 0;
>  	frontswap_map = frontswap_map_get(p);
>  	spin_unlock(&p->lock);
>  	spin_unlock(&swap_lock);
> @@ -1948,6 +1947,16 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  		mutex_unlock(&inode->i_mutex);
>  	}
>  	filp_close(swap_file, NULL);
> +
> +	/*
> +	* clear SWP_USED flag after all resources freed
> +	* so that swapon can reuse this swap_info in alloc_swap_info() safely
> +	* it is ok to not hold p->lock after we cleared its SWP_WRITEOK
> +	*/
> +	spin_lock(&swap_lock);
> +	p->flags = 0;
> +	spin_unlock(&swap_lock);
> +
>  	err = 0;
>  	atomic_inc(&proc_poll_event);
>  	wake_up_interruptible(&proc_poll_wait);

I'm scratching my head over the swap_lock use here.  Is it being used
appropriately, is it the correct lock, etc.

swap_start() and friends are playing with SWP_USED, but they're using
swapon_mutex.  I wonder if a well-timed read of /proc/swaps could cause
problems.

The swapfile.c code does not make for pleasant reading :(
