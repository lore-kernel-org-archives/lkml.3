Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaAIXps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 18:45:48 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:46954 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaAIXpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:45:46 -0500
Date: Thu, 9 Jan 2014 15:45:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, "Theodore Ts'o" <tytso@mit.edu>,
        Eric Paris <eparis@parisplace.org>, stable <stable@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>, LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vfs: Fix possible NULL pointer dereference in
 inode_permission()
Message-ID: <20140109234537.GR10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140109162731.12500986@gandalf.local.home>
 <20140109214239.GD29910@parisc-linux.org>
 <20140109165012.391db81e@gandalf.local.home>
 <20140109223127.GM10323@ZenIV.linux.org.uk>
 <CA+55aFzCTPYEQCPnLBi1CwmMTocVqCFiCuJ391HkVx1CMw61ug@mail.gmail.com>
 <20140109182523.5b50131f@gandalf.local.home>
 <20140109182756.17abaaa8@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109182756.17abaaa8@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010923-8236-0000-0000-000005E00297
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 06:27:56PM -0500, Steven Rostedt wrote:
> On Thu, 9 Jan 2014 18:25:23 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Fri, 10 Jan 2014 06:41:03 +0800
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > I think the sane short term fix is to make the kfree() of the i_security
> > > member be a rcu free, and not clear the member.
> > 
> > You mean my first patch?
> > 
> > https://lkml.org/lkml/2014/1/9/349
> > 
> 
> Oh wait, you said not to clear the member. Thus, the patch would look
> like this:
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Index: linux-trace.git/security/selinux/hooks.c
> ===================================================================
> --- linux-trace.git.orig/security/selinux/hooks.c
> +++ linux-trace.git/security/selinux/hooks.c
> @@ -234,6 +234,14 @@ static int inode_alloc_security(struct i
>  	return 0;
>  }
> 
> +static void inode_free_rcu(struct rcu_head *head)
> +{
> +	struct inode_security_struct *isec;
> +
> +	isec = container_of(head, struct inode_security_struct, rcu);
> +	kmem_cache_free(sel_inode_cache, isec);
> +}
> +
>  static void inode_free_security(struct inode *inode)
>  {
>  	struct inode_security_struct *isec = inode->i_security;
> @@ -244,8 +252,7 @@ static void inode_free_security(struct i
>  		list_del_init(&isec->list);
>  	spin_unlock(&sbsec->isec_lock);
> 
> -	inode->i_security = NULL;
> -	kmem_cache_free(sel_inode_cache, isec);
> +	call_rcu(&isec->rcu, inode_free_rcu);

Does not clearing ->i_security mean that RCU readers can traverse
this pointer after the invocation of call_rcu()?  If so, this is
problematic.  (If something else already prevents readers from getting
here, no problem.)

							Thanx, Paul

>  }
> 
>  static int file_alloc_security(struct file *file)
> Index: linux-trace.git/security/selinux/include/objsec.h
> ===================================================================
> --- linux-trace.git.orig/security/selinux/include/objsec.h
> +++ linux-trace.git/security/selinux/include/objsec.h
> @@ -38,7 +38,10 @@ struct task_security_struct {
> 
>  struct inode_security_struct {
>  	struct inode *inode;	/* back pointer to inode object */
> -	struct list_head list;	/* list of inode_security_struct */
> +	union {
> +		struct list_head list;	/* list of inode_security_struct */
> +		struct rcu_head rcu;	/* for freeing the inode_security_struct */
> +	};
>  	u32 task_sid;		/* SID of creating task */
>  	u32 sid;		/* SID of this object */
>  	u16 sclass;		/* security class of this object */
> 

