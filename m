Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbaJEKYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 06:24:45 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:44847 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaJEKYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 06:24:43 -0400
Date: Sun, 5 Oct 2014 05:24:38 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: John de la Garza <john@jjdev.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: use kfree_rcu instead of i_callback
Message-ID: <20141005052438.289cc37f@as>
In-Reply-To: <20141005030040.GA830@vega.jjdev.com>
References: <20141005030040.GA830@vega.jjdev.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Oct 2014 23:00:42 -0400
John de la Garza <john@jjdev.com> wrote:

> Since the callback is doing nothing more than calling kfree() we can
> use kfree_rcu() instead of having to use a callback.
> 
> Signed-off-by: John de la Garza <john@jjdev.com>
> ---
>  fs/inode.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 26753ba..51deccd 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -250,12 +250,6 @@ void __destroy_inode(struct inode *inode)
>  }
>  EXPORT_SYMBOL(__destroy_inode);
>  
> -static void i_callback(struct rcu_head *head)
> -{
> -	struct inode *inode = container_of(head, struct inode, i_rcu);
> -	kmem_cache_free(inode_cachep, inode);
> -}
> -
>  static void destroy_inode(struct inode *inode)
>  {
>  	BUG_ON(!list_empty(&inode->i_lru));
> @@ -263,7 +257,7 @@ static void destroy_inode(struct inode *inode)
>  	if (inode->i_sb->s_op->destroy_inode)
>  		inode->i_sb->s_op->destroy_inode(inode);
>  	else
> -		call_rcu(&inode->i_rcu, i_callback);
> +		kfree(inode, i_rcu);

Your description says "use kfree_rcu()" but that is kfree(). This won't
even compile.

And as Al pointed out, kfree() is not the same as kmem_cache_free().
So you'd need to invent kmem_cache_free_rcu() also. Not sure that
would have any value elsewhere.

>  }
>  
>  /**

