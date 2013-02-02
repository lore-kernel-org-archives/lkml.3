Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab3BBP53 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 10:57:29 -0500
Received: from shutemov.name ([204.155.152.216]:37768 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757880Ab3BBP5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 10:57:25 -0500
Date: Sat, 2 Feb 2013 17:59:09 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Aaron Durbin <adurbin@google.com>, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH 2/4] cgroup: fix cgroup_rmdir() vs close(eventfd) race
Message-ID: <20130202155909.GA12939@shutemov.name>
References: <510CB733.2080904@huawei.com>
 <510CB763.3020700@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510CB763.3020700@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2013 at 02:51:15PM +0800, Li Zefan wrote:
> commit 205a872bd6f9a9a09ef035ef1e90185a8245cc58 ("cgroup: fix lockdep
> warning for event_control") sovled a deadlock by introducing a new
> bug.
> 
> We can't access @event without event_list_lock, otherwise we'll race
> with cgroup_event_wake() called when closing the eventfd, and then
> both threads will try to free the same @event.
> 
> CPU0                                  CPU1
> ---------------------------           -----------------------------
> cgroup_rmdir()                        close(eventfd)
>   list_for_each_entry()                 cgroup_event_wake()
>                                           list_del(event)
>     list_del(event)
>     cgroup_event_remove(event)
>                                           cgroup_event_remove(event)
> 
> To fix this, use the new eventfd_signal_hangup() to notify userspace
> cgroup is removed.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
>  kernel/cgroup.c | 31 +++++++++++++++++++------------
>  1 file changed, 19 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 3d21adf..a3d361b 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -4302,9 +4302,9 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
>  	struct dentry *d = cgrp->dentry;
>  	struct cgroup *parent = cgrp->parent;
>  	DEFINE_WAIT(wait);
> -	struct cgroup_event *event, *tmp;
> +	struct eventfd_ctx *ctx;
> +	struct cgroup_event *event;
>  	struct cgroup_subsys *ss;
> -	LIST_HEAD(tmp_list);
>  
>  	lockdep_assert_held(&d->d_inode->i_mutex);
>  	lockdep_assert_held(&cgroup_mutex);
> @@ -4359,20 +4359,27 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
>  	/*
>  	 * Unregister events and notify userspace.
>  	 * Notify userspace about cgroup removing only after rmdir of cgroup
> +	 * directory to avoid race between userspace and kernelspace. Since
>  	 * cgroup_event_wake() is called with the wait queue head locked,
> +	 * eventfd_signal() cannot be called while holding event_list_lock.
>  	 */
>  	spin_lock(&cgrp->event_list_lock);
> -	list_splice_init(&cgrp->event_list, &tmp_list);
> -	spin_unlock(&cgrp->event_list_lock);
> -	list_for_each_entry_safe(event, tmp, &tmp_list, list) {
> -		list_del_init(&event->list);
> -		remove_wait_queue(event->wqh, &event->wait);
> -		eventfd_signal(event->eventfd, 1);
> -		schedule_work(&event->remove);
> +	while (true) {
> +		if (list_empty(&cgrp->event_list))
> +			break;

while (!list_empty(&cgrp->event_list)) ?

Otherwise:
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>

> +
> +		event = list_first_entry(&cgrp->event_list,
> +					 struct cgroup_event, list);
> +		ctx = eventfd_ctx_get(event->eventfd);
> +		spin_unlock(&cgrp->event_list_lock);
> +
> +		eventfd_signal(ctx, 1);
> +		eventfd_signal_hangup(ctx);
> +		eventfd_ctx_put(ctx);
> +
> +		spin_lock(&cgrp->event_list_lock);
>  	}
> +	spin_unlock(&cgrp->event_list_lock);
>  
>  	return 0;
>  }
> -- 
> 1.8.0.2
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
 Kirill A. Shutemov
