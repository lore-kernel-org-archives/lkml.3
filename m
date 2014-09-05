Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbaIERLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:11:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44411 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaIERLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:11:21 -0400
Date: Fri, 5 Sep 2014 17:10:45 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] fuse: Translate pids passed to userspace into pid
 namespaces
Message-ID: <20140905171045.GJ16450@ubuntumail>
References: <1409672696-15847-1-git-send-email-seth.forshee@canonical.com>
 <1409672696-15847-3-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409672696-15847-3-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Seth Forshee (seth.forshee@canonical.com):
> If the process reading on the fuse fd is executing in a pid
> namespace then giving it the global pid of the process making
> a request doesn't make sense. Instead, capture the pid namespace
> when the filesystem is first mounted and translate pids into this
> namespace before passing them to userspace.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> ---
>  fs/fuse/dev.c    | 9 +++++----
>  fs/fuse/fuse_i.h | 4 ++++
>  fs/fuse/inode.c  | 3 +++
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index ca887314aba9..839caebd34f1 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -20,6 +20,7 @@
>  #include <linux/swap.h>
>  #include <linux/splice.h>
>  #include <linux/aio.h>
> +#include <linux/sched.h>
>  
>  MODULE_ALIAS_MISCDEV(FUSE_MINOR);
>  MODULE_ALIAS("devname:fuse");
> @@ -124,11 +125,11 @@ static void __fuse_put_request(struct fuse_req *req)
>  	atomic_dec(&req->count);
>  }
>  
> -static void fuse_req_init_context(struct fuse_req *req)
> +static void fuse_req_init_context(struct fuse_conn *fc, struct fuse_req *req)
>  {
>  	req->in.h.uid = from_kuid_munged(&init_user_ns, current_fsuid());
>  	req->in.h.gid = from_kgid_munged(&init_user_ns, current_fsgid());
> -	req->in.h.pid = current->pid;
> +	req->in.h.pid = pid_nr_ns(task_pid(current), fc->pid_ns);
>  }
>  
>  static bool fuse_block_alloc(struct fuse_conn *fc, bool for_background)
> @@ -168,7 +169,7 @@ static struct fuse_req *__fuse_get_req(struct fuse_conn *fc, unsigned npages,
>  		goto out;
>  	}
>  
> -	fuse_req_init_context(req);
> +	fuse_req_init_context(fc, req);
>  	req->waiting = 1;
>  	req->background = for_background;
>  	return req;
> @@ -257,7 +258,7 @@ struct fuse_req *fuse_get_req_nofail_nopages(struct fuse_conn *fc,
>  	if (!req)
>  		req = get_reserved_req(fc, file);
>  
> -	fuse_req_init_context(req);
> +	fuse_req_init_context(fc, req);
>  	req->waiting = 1;
>  	req->background = 0;
>  	return req;
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index e8e47a6ab518..a3ded071e2c6 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -22,6 +22,7 @@
>  #include <linux/rbtree.h>
>  #include <linux/poll.h>
>  #include <linux/workqueue.h>
> +#include <linux/pid_namespace.h>
>  
>  /** Max number of pages that can be used in a single read request */
>  #define FUSE_MAX_PAGES_PER_REQ 32
> @@ -386,6 +387,9 @@ struct fuse_conn {
>  	/** The group id for this mount */
>  	kgid_t group_id;
>  
> +	/** The pid namespace for this mount */
> +	struct pid_namespace *pid_ns;
> +
>  	/** The fuse mount flags for this mount */
>  	unsigned flags;
>  
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 03246cd9d47a..c6d8473b1a80 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -20,6 +20,7 @@
>  #include <linux/random.h>
>  #include <linux/sched.h>
>  #include <linux/exportfs.h>
> +#include <linux/pid_namespace.h>
>  
>  MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
>  MODULE_DESCRIPTION("Filesystem in Userspace");
> @@ -616,6 +617,7 @@ void fuse_conn_init(struct fuse_conn *fc)
>  	fc->initialized = 0;
>  	fc->attr_version = 1;
>  	get_random_bytes(&fc->scramble_key, sizeof(fc->scramble_key));
> +	fc->pid_ns = get_pid_ns(task_active_pid_ns(current));
>  }
>  EXPORT_SYMBOL_GPL(fuse_conn_init);
>  
> @@ -953,6 +955,7 @@ static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
>  
>  static void fuse_free_conn(struct fuse_conn *fc)
>  {
> +	put_pid_ns(fc->pid_ns);
>  	kfree_rcu(fc, rcu);
>  }
>  
> -- 
> 1.9.1
> 
