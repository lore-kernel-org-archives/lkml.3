Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaJPQHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:07:40 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:49707
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbaJPQHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:07:38 -0400
Date: Thu, 16 Oct 2014 18:07:36 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aditya Kali <adityakali@google.com>
Cc: tj@kernel.org, lizefan@huawei.com, serge.hallyn@ubuntu.com,
        luto@amacapital.net, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        mingo@redhat.com, containers@lists.linux-foundation.org
Subject: Re: [PATCHv1 1/8] kernfs: Add API to generate relative kernfs path
Message-ID: <20141016160736.GA1392@mail.hallyn.com>
References: <adityakali-cgroupns>
 <1413235430-22944-1-git-send-email-adityakali@google.com>
 <1413235430-22944-2-git-send-email-adityakali@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413235430-22944-2-git-send-email-adityakali@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aditya Kali (adityakali@google.com):
> The new function kernfs_path_from_node() generates and returns
> kernfs path of a given kernfs_node relative to a given parent
> kernfs_node.
> 
> Signed-off-by: Aditya Kali <adityakali@google.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

(with or without my comment below taken)

> ---
>  fs/kernfs/dir.c        | 53 ++++++++++++++++++++++++++++++++++++++++----------
>  include/linux/kernfs.h |  3 +++
>  2 files changed, 46 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
> index a693f5b..8655485 100644
> --- a/fs/kernfs/dir.c
> +++ b/fs/kernfs/dir.c
> @@ -44,14 +44,24 @@ static int kernfs_name_locked(struct kernfs_node *kn, char *buf, size_t buflen)
>  	return strlcpy(buf, kn->parent ? kn->name : "/", buflen);
>  }
>  
> -static char * __must_check kernfs_path_locked(struct kernfs_node *kn, char *buf,
> -					      size_t buflen)
> +static char * __must_check kernfs_path_from_node_locked(
> +	struct kernfs_node *kn_root,
> +	struct kernfs_node *kn,
> +	char *buf,
> +	size_t buflen)
>  {
>  	char *p = buf + buflen;
>  	int len;
>  
> +	BUG_ON(!buflen);
> +
>  	*--p = '\0';
>  
> +	if (kn == kn_root) {
> +		*--p = '/';
> +		return p;
> +	}
> +
>  	do {
>  		len = strlen(kn->name);
>  		if (p - buf < len + 1) {
> @@ -63,6 +73,8 @@ static char * __must_check kernfs_path_locked(struct kernfs_node *kn, char *buf,
>  		memcpy(p, kn->name, len);
>  		*--p = '/';
>  		kn = kn->parent;
> +		if (kn == kn_root)
> +			break;

I wonder if it would be clearer if you instead changed the while condition, i.e.

	} while (kn && kn != kn_root && kn_parent);

i.e .it's not a special condition, just a part of the expected flow.

>  	} while (kn && kn->parent);
>  
>  	return p;
> @@ -92,26 +104,47 @@ int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen)
>  }
>  
>  /**
> - * kernfs_path - build full path of a given node
> + * kernfs_path_from_node - build path of node @kn relative to @kn_root.
> + * @kn_root: parent kernfs_node relative to which we need to build the path
>   * @kn: kernfs_node of interest
> - * @buf: buffer to copy @kn's name into
> + * @buf: buffer to copy @kn's path into
>   * @buflen: size of @buf
>   *
> - * Builds and returns the full path of @kn in @buf of @buflen bytes.  The
> - * path is built from the end of @buf so the returned pointer usually
> + * Builds and returns @kn's path relative to @kn_root. @kn_root is expected to
> + * be parent of @kn at some level. If this is not true or if @kn_root is NULL,
> + * then full path of @kn is returned.
> + * The path is built from the end of @buf so the returned pointer usually
>   * doesn't match @buf.  If @buf isn't long enough, @buf is nul terminated
>   * and %NULL is returned.
>   */
> -char *kernfs_path(struct kernfs_node *kn, char *buf, size_t buflen)
> +char *kernfs_path_from_node(struct kernfs_node *kn_root, struct kernfs_node *kn,
> +			    char *buf, size_t buflen)
>  {
>  	unsigned long flags;
>  	char *p;
>  
>  	spin_lock_irqsave(&kernfs_rename_lock, flags);
> -	p = kernfs_path_locked(kn, buf, buflen);
> +	p = kernfs_path_from_node_locked(kn_root, kn, buf, buflen);
>  	spin_unlock_irqrestore(&kernfs_rename_lock, flags);
>  	return p;
>  }
> +EXPORT_SYMBOL_GPL(kernfs_path_from_node);
> +
> +/**
> + * kernfs_path - build full path of a given node
> + * @kn: kernfs_node of interest
> + * @buf: buffer to copy @kn's name into
> + * @buflen: size of @buf
> + *
> + * Builds and returns the full path of @kn in @buf of @buflen bytes.  The
> + * path is built from the end of @buf so the returned pointer usually
> + * doesn't match @buf.  If @buf isn't long enough, @buf is nul terminated
> + * and %NULL is returned.
> + */
> +char *kernfs_path(struct kernfs_node *kn, char *buf, size_t buflen)
> +{
> +	return kernfs_path_from_node(NULL, kn, buf, buflen);
> +}
>  EXPORT_SYMBOL_GPL(kernfs_path);
>  
>  /**
> @@ -145,8 +178,8 @@ void pr_cont_kernfs_path(struct kernfs_node *kn)
>  
>  	spin_lock_irqsave(&kernfs_rename_lock, flags);
>  
> -	p = kernfs_path_locked(kn, kernfs_pr_cont_buf,
> -			       sizeof(kernfs_pr_cont_buf));
> +	p = kernfs_path_from_node_locked(NULL, kn, kernfs_pr_cont_buf,
> +					 sizeof(kernfs_pr_cont_buf));
>  	if (p)
>  		pr_cont("%s", p);
>  	else
> diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> index 30faf79..3c2be75 100644
> --- a/include/linux/kernfs.h
> +++ b/include/linux/kernfs.h
> @@ -258,6 +258,9 @@ static inline bool kernfs_ns_enabled(struct kernfs_node *kn)
>  }
>  
>  int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen);
> +char * __must_check kernfs_path_from_node(struct kernfs_node *root_kn,
> +					  struct kernfs_node *kn, char *buf,
> +					  size_t buflen);
>  char * __must_check kernfs_path(struct kernfs_node *kn, char *buf,
>  				size_t buflen);
>  void pr_cont_kernfs_name(struct kernfs_node *kn);
> -- 
> 2.1.0.rc2.206.gedb03e5
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
