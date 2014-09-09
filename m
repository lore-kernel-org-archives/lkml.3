Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaIIXRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 19:17:18 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:55641
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaIIXRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 19:17:17 -0400
Date: Wed, 10 Sep 2014 01:17:15 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 1/3] procfs: check uniq proc_dir_entry subdir name
Message-ID: <20140909231715.GA25668@mail.hallyn.com>
References: <1409740200-26461-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <1409740200-26461-2-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409740200-26461-2-git-send-email-chenhanxiao@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chen Hanxiao (chenhanxiao@cn.fujitsu.com):
> Check whether a proc dir has a subdir
> with a specific name.
> Will be used in a later patch.
> 
> Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
> ---
>  fs/proc/generic.c       | 15 +++++++++++++++
>  include/linux/proc_fs.h |  3 +++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index b7f268e..4d576c2 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -173,6 +173,21 @@ static const struct inode_operations proc_link_inode_operations = {
>  	.follow_link	= proc_follow_link,
>  };
>  
> +/* check whether dir has @name member */
> +struct proc_dir_entry *proc_uniq_dir(struct proc_dir_entry *de, char *name)
> +{
> +	spin_lock(&proc_subdir_lock);
> +	for (de = de->subdir; de ; de = de->next) {
> +		if (!strcmp(de->name, name)) {

Should you pde_get(de) here?

> +			spin_unlock(&proc_subdir_lock);
> +			return de;
> +		}
> +	}
> +	spin_unlock(&proc_subdir_lock);
> +	return NULL;
> +}
> +EXPORT_SYMBOL(proc_uniq_dir);
> +
>  /*
>   * Don't create negative dentries here, return -ENOENT by hand
>   * instead.
> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index 9d117f6..38e87aa 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -41,6 +41,7 @@ extern void *proc_get_parent_data(const struct inode *);
>  extern void proc_remove(struct proc_dir_entry *);
>  extern void remove_proc_entry(const char *, struct proc_dir_entry *);
>  extern int remove_proc_subtree(const char *, struct proc_dir_entry *);
> +extern struct proc_dir_entry *proc_uniq_dir(struct proc_dir_entry *, char *);
>  
>  #else /* CONFIG_PROC_FS */
>  
> @@ -71,6 +72,8 @@ static inline void *proc_get_parent_data(const struct inode *inode) { BUG(); ret
>  static inline void proc_remove(struct proc_dir_entry *de) {}
>  #define remove_proc_entry(name, parent) do {} while (0)
>  static inline int remove_proc_subtree(const char *name, struct proc_dir_entry *parent) { return 0; }
> +static inline struct proc_dir_entry *proc_uniq_dir(struct proc_dir_entry *,
> +	char *) {return 0; }
>  
>  #endif /* CONFIG_PROC_FS */
>  
> -- 
> 1.9.0
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
