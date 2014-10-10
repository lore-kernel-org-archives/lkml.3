Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaJJT3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 15:29:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbaJJT3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 15:29:16 -0400
Message-ID: <1412969354.15099.6.camel@redhat.com>
Subject: Re: [PATCH 4/7] audit: optimize add to parent skipping needless
 search and consuming parent ref
From: Eric Paris <eparis@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, sgrubb@redhat.com,
        aviro@redhat.com, pmoore@redhat.com
Date: Fri, 10 Oct 2014 15:29:14 -0400
In-Reply-To: <077ffe7272ccf13b8125300d6f39b58bd470a7eb.1412285491.git.rgb@redhat.com>
References: <cover.1412285491.git.rgb@redhat.com>
	 <077ffe7272ccf13b8125300d6f39b58bd470a7eb.1412285491.git.rgb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 22:05 -0400, Richard Guy Briggs wrote:
> When parent has just been created there is no need to search for the parent in
> the list.  Add a parameter to skip the search

Since the parent was just allocated, and thus has an empty list, this
"search" is just as fast as the check against 'new' and doesn't
complicate things...

>  and consume the parent reference
> no matter what happens.

Now the refcnt change...    I guess it's personal taste, but I don't
like it at all.  If in audit_add_watch() I always get a reference to
parent it makes the code a whole lot easier to read if we always put
that refcnt in the same function.  I don't like sub functions that
consume my ref...   Especially since that makes it a whole lot less
obvious in audit_add_watch when I'm allowed to use parent and when I'm
not...

So I'm not going to apply this patch.  I don't believe it improves
things...

> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  kernel/audit_watch.c |   23 +++++++++++++++--------
>  1 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
> index ad9c168..f209448 100644
> --- a/kernel/audit_watch.c
> +++ b/kernel/audit_watch.c
> @@ -372,15 +372,20 @@ static int audit_get_nd(struct audit_watch *watch, struct path *parent)
>  }
>  
>  /* Associate the given rule with an existing parent.
> - * Caller must hold audit_filter_mutex. */
> + * Caller must hold audit_filter_mutex.
> + * Consumes parent reference. */
>  static void audit_add_to_parent(struct audit_krule *krule,
> -				struct audit_parent *parent)
> +				struct audit_parent *parent,
> +				int new)
>  {
>  	struct audit_watch *w, *watch = krule->watch;
>  	int watch_found = 0;
>  
>  	BUG_ON(!mutex_is_locked(&audit_filter_mutex));
>  
> +	if (new)
> +		goto not_found;
> +
>  	list_for_each_entry(w, &parent->watches, wlist) {
>  		if (strcmp(watch->path, w->path))
>  			continue;
> @@ -396,12 +401,15 @@ static void audit_add_to_parent(struct audit_krule *krule,
>  		break;
>  	}
>  
> +not_found:
>  	if (!watch_found) {
> -		audit_get_parent(parent);
>  		watch->parent = parent;
>  
>  		list_add(&watch->wlist, &parent->watches);
> -	}
> +	} else
> +		/* match get in audit_find_parent or audit_init_parent */
> +		audit_put_parent(parent);
> +
>  	list_add(&krule->rlist, &watch->rules);
>  }
>  
> @@ -413,6 +421,7 @@ int audit_add_watch(struct audit_krule *krule, struct list_head **list)
>  	struct audit_parent *parent;
>  	struct path parent_path;
>  	int h, ret = 0;
> +	int new = 0;
>  
>  	mutex_unlock(&audit_filter_mutex);
>  
> @@ -433,12 +442,10 @@ int audit_add_watch(struct audit_krule *krule, struct list_head **list)
>  			ret = PTR_ERR(parent);
>  			goto error;
>  		}
> +		new = 1;
>  	}
>  
> -	audit_add_to_parent(krule, parent);
> -
> -	/* match get in audit_find_parent or audit_init_parent */
> -	audit_put_parent(parent);
> +	audit_add_to_parent(krule, parent, new);
>  
>  	h = audit_hash_ino((u32)watch->ino);
>  	*list = &audit_inode_hash[h];


