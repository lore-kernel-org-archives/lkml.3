Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161805Ab3DEHbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 03:31:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:23801 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab3DEHbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 03:31:33 -0400
X-IronPort-AV: E=Sophos;i="4.87,413,1363104000"; 
   d="scan'208";a="7001523"
Message-ID: <515E7E7F.1000606@cn.fujitsu.com>
Date: Fri, 05 Apr 2013 15:34:23 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>, Eric Paris <eparis@parisplace.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Naohiro Aota <naota@elisp.net>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 7/9] fsnotify: use existed call_srcu()
References: <1363366257-4886-1-git-send-email-laijs@cn.fujitsu.com> <1363366257-4886-8-git-send-email-laijs@cn.fujitsu.com>
In-Reply-To: <1363366257-4886-8-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/05 15:30:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/05 15:30:29,
	Serialize complete at 2013/04/05 15:30:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ping]

Hi, Eric Paris

Could you review this patch?

Thanks,
Lai

On 03/16/2013 12:50 AM, Lai Jiangshan wrote:
> fsnotify implements its own call_srcu() by:
> 	dedicated thread + synchronize_srcu()
> 
> But srcu provides call_srcu() now, so we should convert them to use
> existed call_srcu() and remove the thread.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Eric Paris <eparis@parisplace.org>
> ---
>  fs/notify/mark.c                 |   59 ++++++-------------------------------
>  include/linux/fsnotify_backend.h |    2 +-
>  2 files changed, 11 insertions(+), 50 deletions(-)
> 
> diff --git a/fs/notify/mark.c b/fs/notify/mark.c
> index aeededc..af5f0e1 100644
> --- a/fs/notify/mark.c
> +++ b/fs/notify/mark.c
> @@ -98,9 +98,6 @@
>  #include "fsnotify.h"
>  
>  DEFINE_SRCU(fsnotify_mark_srcu);
> -static DEFINE_SPINLOCK(destroy_lock);
> -static LIST_HEAD(destroy_list);
> -static DECLARE_WAIT_QUEUE_HEAD(destroy_waitq);
>  
>  void fsnotify_get_mark(struct fsnotify_mark *mark)
>  {
> @@ -116,6 +113,14 @@ void fsnotify_put_mark(struct fsnotify_mark *mark)
>  	}
>  }
>  
> +static void fsnotify_destroy_mark_rcu(struct rcu_head *rcu)
> +{
> +	struct fsnotify_mark *mark;
> +
> +	mark = container_of(rcu, struct fsnotify_mark, rcu);
> +	fsnotify_put_mark(mark);
> +}
> +
>  /*
>   * Any time a mark is getting freed we end up here.
>   * The caller had better be holding a reference to this mark so we don't actually
> @@ -155,10 +160,7 @@ void fsnotify_destroy_mark_locked(struct fsnotify_mark *mark,
>  	/* release lock temporarily */
>  	mutex_unlock(&group->mark_mutex);
>  
> -	spin_lock(&destroy_lock);
> -	list_add(&mark->destroy_list, &destroy_list);
> -	spin_unlock(&destroy_lock);
> -	wake_up(&destroy_waitq);
> +	call_srcu(&fsnotify_mark_srcu, &mark->rcu, fsnotify_destroy_mark_rcu);
>  	/*
>  	 * We don't necessarily have a ref on mark from caller so the above destroy
>  	 * may have actually freed it, unless this group provides a 'freeing_mark'
> @@ -273,11 +275,7 @@ err:
>  	atomic_dec(&group->num_marks);
>  
>  	spin_unlock(&mark->lock);
> -
> -	spin_lock(&destroy_lock);
> -	list_add(&mark->destroy_list, &destroy_list);
> -	spin_unlock(&destroy_lock);
> -	wake_up(&destroy_waitq);
> +	call_srcu(&fsnotify_mark_srcu, &mark->rcu, fsnotify_destroy_mark_rcu);
>  
>  	return ret;
>  }
> @@ -342,40 +340,3 @@ void fsnotify_init_mark(struct fsnotify_mark *mark,
>  	atomic_set(&mark->refcnt, 1);
>  	mark->free_mark = free_mark;
>  }
> -
> -static int fsnotify_mark_destroy(void *ignored)
> -{
> -	struct fsnotify_mark *mark, *next;
> -	LIST_HEAD(private_destroy_list);
> -
> -	for (;;) {
> -		spin_lock(&destroy_lock);
> -		/* exchange the list head */
> -		list_replace_init(&destroy_list, &private_destroy_list);
> -		spin_unlock(&destroy_lock);
> -
> -		synchronize_srcu(&fsnotify_mark_srcu);
> -
> -		list_for_each_entry_safe(mark, next, &private_destroy_list, destroy_list) {
> -			list_del_init(&mark->destroy_list);
> -			fsnotify_put_mark(mark);
> -		}
> -
> -		wait_event_interruptible(destroy_waitq, !list_empty(&destroy_list));
> -	}
> -
> -	return 0;
> -}
> -
> -static int __init fsnotify_mark_init(void)
> -{
> -	struct task_struct *thread;
> -
> -	thread = kthread_run(fsnotify_mark_destroy, NULL,
> -			     "fsnotify_mark");
> -	if (IS_ERR(thread))
> -		panic("unable to start fsnotify mark destruction thread.");
> -
> -	return 0;
> -}
> -device_initcall(fsnotify_mark_init);
> diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
> index d5b0910..3d435eb 100644
> --- a/include/linux/fsnotify_backend.h
> +++ b/include/linux/fsnotify_backend.h
> @@ -296,7 +296,7 @@ struct fsnotify_mark {
>  #define FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY	0x08
>  #define FSNOTIFY_MARK_FLAG_ALIVE		0x10
>  	unsigned int flags;		/* vfsmount or inode mark? */
> -	struct list_head destroy_list;
> +	struct rcu_head rcu;
>  	void (*free_mark)(struct fsnotify_mark *mark); /* called on final put+free */
>  };
>  

