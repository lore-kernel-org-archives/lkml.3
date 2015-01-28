Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430AbbA2Bql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:46:41 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:63704 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbbA2Bqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:46:39 -0500
From: Paul Moore <paul@paul-moore.com>
To: Imre Palik <imrep.amz@gmail.com>
Cc: linux-audit@redhat.com, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, "Palik, Imre" <imrep@amazon.de>,
        Matt Wilson <msw@amazon.com>
Subject: Re: [RFC PATCH v3] audit: move the tree pruning to a dedicated thread
Date: Wed, 28 Jan 2015 16:40:39 -0500
Message-ID: <4828238.7JGSA0NNE9@sifl>
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1421324870-15070-1-git-send-email-imrep.amz@gmail.com>
References: <1421324870-15070-1-git-send-email-imrep.amz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 15, 2015 01:27:50 PM Imre Palik wrote:
> From: "Palik, Imre" <imrep@amazon.de>
> 
> When file auditing is enabled, during a low memory situation, a memory
> allocation with __GFP_FS can lead to pruning the inode cache.  Which can,
> in turn lead to audit_tree_freeing_mark() being called.  This can call
> audit_schedule_prune(), that tries to fork a pruning thread, and
> waits until the thread is created.  But forking needs memory, and the
> memory allocations there are done with __GFP_FS.
> 
> So we are waiting merrily for some __GFP_FS memory allocations to complete,
> while holding some filesystem locks.  This can take a while ...
> 
> This patch creates a single thread for pruning the tree from
> audit_add_tree_rule(), and thus avoids the deadlock that the on-demand
> thread creation can cause.
> 
> Reported-by: Matt Wilson <msw@amazon.com>
> Cc: Matt Wilson <msw@amazon.com>
> Signed-off-by: Imre Palik <imrep@amazon.de>

...

> diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
> index 2e0c974..4883b6e 100644
> --- a/kernel/audit_tree.c
> +++ b/kernel/audit_tree.c
> @@ -37,6 +37,7 @@ struct audit_chunk {
> 
>  static LIST_HEAD(tree_list);
>  static LIST_HEAD(prune_list);
> +static struct task_struct *prune_thread;
> 
>  /*
>   * One struct chunk is attached to each inode of interest.
> @@ -651,6 +652,55 @@ static int tag_mount(struct vfsmount *mnt, void *arg)
>  	return tag_chunk(mnt->mnt_root->d_inode, arg);
>  }
> 
> +/*
> + * That gets run when evict_chunk() ends up needing to kill audit_tree.
> + * Runs from a separate thread.
> + */
> +static int prune_tree_thread(void *unused)
> +{
> +	for (;;) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		if (list_empty(&prune_list))
> +			schedule();
> +		__set_current_state(TASK_RUNNING);
> +
> +		mutex_lock(&audit_cmd_mutex);
> +		mutex_lock(&audit_filter_mutex);
> +
> +		while (!list_empty(&prune_list)) {
> +			struct audit_tree *victim;
> +
> +			victim = list_entry(prune_list.next,
> +					struct audit_tree, list);
> +			list_del_init(&victim->list);
> +
> +			mutex_unlock(&audit_filter_mutex);
> +
> +			prune_one(victim);
> +
> +			mutex_lock(&audit_filter_mutex);
> +		}
> +
> +		mutex_unlock(&audit_filter_mutex);
> +		mutex_unlock(&audit_cmd_mutex);
> +	}
> +	return 0;
> +}
> +
> +static int launch_prune_thread(void)
> +{
> +	prune_thread = kthread_create(prune_tree_thread, NULL,
> +				"audit_prune_tree");
> +	if (IS_ERR(prune_thread)) {
> +		pr_err("cannot start thread audit_prune_tree");
> +		prune_thread = NULL;
> +		return -ENOMEM;
> +	} else {
> +		wake_up_process(prune_thread);
> +		return 0;
> +	}
> +}

Before trying to create a new instance of prune_tree_thread, should we check 
to see if one exists?  I know you have a check for this in 
audit_add_tree_rule() but I would rather it be in the function above to help 
prevent accidental misuse in the future.

Also, how about we rename this to audit_launch_prune() so are naming is more 
consistent, see audit_schedule_prune()?

-- 
paul moore
www.paul-moore.com

