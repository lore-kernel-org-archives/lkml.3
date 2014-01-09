Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaAIP5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 10:57:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaAIP5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 10:57:22 -0500
Message-ID: <1389283030.15209.56.camel@localhost>
Subject: Re: [PATCH] SELinux: Fix possible NULL pointer dereference in
 selinux_inode_permission()
From: Eric Paris <eparis@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Paul Moore <paul@paul-moore.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>
Date: Thu, 09 Jan 2014 10:57:10 -0500
In-Reply-To: <20140109105114.5c409fef@gandalf.local.home>
References: <20140109101932.0508dec7@gandalf.local.home>
	 <CACLa4pv+EUGHO+MKj8ckhmi8YKiTNVL9pSM+DDsjg+0jbjOCcA@mail.gmail.com>
	 <20140109105114.5c409fef@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-09 at 10:51 -0500, Steven Rostedt wrote:
> On Thu, 9 Jan 2014 10:31:55 -0500
> Eric Paris <eparis@parisplace.org> wrote:
> 
> > Didn't Al find this/something very similar.  I really hate this
> 
> I'm not involved with the vfs, so I'm unaware of other solutions
> presented. I just hit this now and solving bugs is where I get a chance
> to learn about other aspects of the kernel. ;-)
> 
> > solution.  Why should every LSM try to understand the intimate
> > lifetime rules of the parent subsystems?  The real problem is that
> > inode_free_security() is being called while the inode is still in use.
> >  While I agree with the assessment, I disagree with the solution.  Let
> > me try to find where Al and Christoph talked about this....
> > 
> 
> The other obvious solution (but not as trivial to implement) is to call
> the security_inode_free() and friends (probably __destroy_inode()
> itself) after a synchronize_rcu().
> 
> Perhaps something like this?

I can't for the life of me find that conversation!  Maybe I'm just
making it all up...  Usually I forget conversations, not remember ones
that didn't happen...

Assuming the VFS guys say that delaying __destroy_inode() is safe like
that, I like it better.  It also means that this is fixed for all LSMs,
not just SELinux...

-Eric

> 
> -- Steve
> 
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


