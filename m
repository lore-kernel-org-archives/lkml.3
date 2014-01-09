Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaAIWRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 17:17:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39602 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaAIWRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 17:17:13 -0500
Date: Thu, 9 Jan 2014 22:17:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Paris <eparis@parisplace.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Paul Moore <paul@paul-moore.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] SELinux: Fix possible NULL pointer dereference in
 selinux_inode_permission()
Message-ID: <20140109221711.GJ10323@ZenIV.linux.org.uk>
References: <20140109101932.0508dec7@gandalf.local.home>
 <CACLa4pv+EUGHO+MKj8ckhmi8YKiTNVL9pSM+DDsjg+0jbjOCcA@mail.gmail.com>
 <20140109105114.5c409fef@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109105114.5c409fef@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 10:51:14AM -0500, Steven Rostedt wrote:

> diff --git a/fs/inode.c b/fs/inode.c
> index 4bcdad3..a8f3b88 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -252,16 +252,17 @@ EXPORT_SYMBOL(__destroy_inode);
>  static void i_callback(struct rcu_head *head)
>  {
>  	struct inode *inode = container_of(head, struct inode, i_rcu);
> +	__destroy_inode(inode);
>  	kmem_cache_free(inode_cachep, inode);
>  }
>  
>  static void destroy_inode(struct inode *inode)
>  {
>  	BUG_ON(!list_empty(&inode->i_lru));
> -	__destroy_inode(inode);
> -	if (inode->i_sb->s_op->destroy_inode)
> +	if (inode->i_sb->s_op->destroy_inode) {
> +		__destroy_inode(inode);
>  		inode->i_sb->s_op->destroy_inode(inode);
> -	else
> +	} else
>  		call_rcu(&inode->i_rcu, i_callback);
>  }
>  
No go - idiotify and friends grab mutexes from fsnotify_inode_delete().
Can't do that from rcu callbacks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
