Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbbAHVxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 16:53:13 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:34409 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbbAHVxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 16:53:11 -0500
From: Paul Moore <paul@paul-moore.com>
To: Imre Palik <imrep.amz@gmail.com>
Cc: linux-audit@redhat.com, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, "Palik, Imre" <imrep@amazon.de>,
        Matt Wilson <msw@amazon.com>
Subject: Re: [PATCH RFC] audit: move the tree pruning to a dedicated thread
Date: Thu, 08 Jan 2015 16:53:06 -0500
Message-ID: <12579290.YG49FVpphz@sifl>
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1420555880-4328-1-git-send-email-imrep.amz@gmail.com>
References: <1420555880-4328-1-git-send-email-imrep.amz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 06, 2015 03:51:20 PM Imre Palik wrote:
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

Thanks for sticking with this and posting a revised patch, my comments are 
inline with the patch below ... also as a FYI, when sending a revised patch it 
is often helpful to put a revision indicator in the subject line, as an 
example:

  "[RFC PATCH v2] audit: make audit less awful"

It's not strictly necessary, but it makes my life just a little bit easier.

> diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
> index 0caf1f8..0ada577 100644
> --- a/kernel/audit_tree.c
> +++ b/kernel/audit_tree.c

...

> +static int launch_prune_thread(void)
> +{
> +	prune_thread = kthread_create(prune_tree_thread, NULL,
> +				"audit_prune_tree");
> +	if (IS_ERR(prune_thread)) {
> +		audit_panic("cannot start thread audit_prune_tree");

I'm not certain audit_panic() is warranted here, pr_err() might be a better 
choice.  What is the harm if the thread doesn't start and we return an error 
code?

> +		prune_thread = NULL;
> +		return -ENOSYS;

Out of curiosity, why ENOSYS?

> +	} else {
> +		wake_up_process(prune_thread);
> +		return 0;
> +	}
> +}

See my comments below in audit_schedule_prune().

>  /* called with audit_filter_mutex */
>  int audit_add_tree_rule(struct audit_krule *rule)
>  {
> @@ -663,6 +713,12 @@ int audit_add_tree_rule(struct audit_krule *rule)
>  	/* do not set rule->tree yet */
>  	mutex_unlock(&audit_filter_mutex);
> 
> +	if (unlikely(!prune_thread)) {
> +		err = launch_prune_thread();
> +		if (err)
> +			goto Err;
> +	}
> +

Why not put this at the top of audit_add_tree_rule()?

>  	err = kern_path(tree->pathname, 0, &path);
>  	if (err)
>  		goto Err;
> @@ -713,6 +769,9 @@ int audit_tag_tree(char *old, char *new)
>  	struct vfsmount *tagged;
>  	int err;
> 
> +	if (!prune_thread)
> +		return -ENOSYS;

Help me out - why?

>  	err = kern_path(new, 0, &path2);
>  	if (err)
>  		return err;
> @@ -800,36 +859,11 @@ int audit_tag_tree(char *old, char *new)
>  	return failed;
>  }
> 
> -/*
> - * That gets run when evict_chunk() ends up needing to kill audit_tree.
> - * Runs from a separate thread.
> - */
> -static int prune_tree_thread(void *unused)
> -{
> -	mutex_lock(&audit_cmd_mutex);
> -	mutex_lock(&audit_filter_mutex);
> -
> -	while (!list_empty(&prune_list)) {
> -		struct audit_tree *victim;
> -
> -		victim = list_entry(prune_list.next, struct audit_tree, list);
> -		list_del_init(&victim->list);
> -
> -		mutex_unlock(&audit_filter_mutex);
> -
> -		prune_one(victim);
> -
> -		mutex_lock(&audit_filter_mutex);
> -	}
> -
> -	mutex_unlock(&audit_filter_mutex);
> -	mutex_unlock(&audit_cmd_mutex);
> -	return 0;
> -}
> 
>  static void audit_schedule_prune(void)
>  {
> -	kthread_run(prune_tree_thread, NULL, "audit_prune_tree");
> +	BUG_ON(!prune_thread);
> +	wake_up_process(prune_thread);
>  }

First, I probably wasn't clear last time so I'll be more clear now: no 
BUG_ON() here, handle the error.

Second, and closely related to the last sentence, perhaps the right approach 
is to merge the launch_prune_thread() code with audit_schedule_prune() such 
that we only have one function which starts the thread if it isn't present, 
and wakes it up if it is, something like the following:

	static int audit_schedule_prune(void)
	{
		if (!prune_thread) {
			prune_thread = kthread_create(...);
			if (IS_ERR(prune_thread)) {
				pr_err("cannot start thread audit_prune_tree");
				prune_thread = NULL;
				return -ENOSYS;
			}
		}

		wake_up_process(prune_thread);
		return 0;
	}

>  /*
> @@ -896,9 +930,10 @@ static void evict_chunk(struct audit_chunk *chunk)
>  	for (n = 0; n < chunk->count; n++)
>  		list_del_init(&chunk->owners[n].list);
>  	spin_unlock(&hash_lock);
> +	mutex_unlock(&audit_filter_mutex);
>  	if (need_prune)
>  		audit_schedule_prune();
> -	mutex_unlock(&audit_filter_mutex);
> +
>  }

Remove that trailing empty vertical whitespace please.  If you aren't using it 
already, you should look into scripts/checkpatch.pl to sanity check your 
patches before sending.

-- 
paul moore
www.paul-moore.com

