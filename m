Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbaAIVuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 16:50:17 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:16929 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756638AbaAIVuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 16:50:14 -0500
Date: Thu, 9 Jan 2014 16:50:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@parisplace.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Dave Chinner <david@fromorbit.com>,
        James Morris <james.l.morris@oracle.com>,
        Paul Moore <paul@paul-moore.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] vfs: Fix possible NULL pointer dereference in
 inode_permission()
Message-ID: <20140109165012.391db81e@gandalf.local.home>
In-Reply-To: <20140109214239.GD29910@parisc-linux.org>
References: <20140109162731.12500986@gandalf.local.home>
	<20140109214239.GD29910@parisc-linux.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jan 2014 14:42:39 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> On Thu, Jan 09, 2014 at 04:27:31PM -0500, Steven Rostedt wrote:
> > Note, the crash came from stressing the deletion and reading of debugfs
> > files. I was not able to recreate this via normal files. But I'm not
> > sure they are safe. It may just be that the race window is much harder
> > to hit.
> 
> But "normal" files have a 'destroy_inode' method.  So you've basically
> only fixed it for debugfs (and maybe a few other unusual filesystems).
> Why doesn't the code look like this:

Because I thought of that after I sent the email ;-)

Well, that's not really true. I don't know the semantics of the
destroy_inode() call. But I should have asked that in my change log.

> 
> static void i_callback(struct rcu_head *head)
> {
> 	struct inode *inode = container_of(head, struct inode, i_rcu);
> 	__destroy_inode(inode);
> 	if (inode->i_sb->s_op->destroy_inode)
> 		inode->i_sb->s_op->destroy_inode(inode);
> 	else
> 		kmem_cache_free(inode_cachep, inode);
> }
> 
> static void destroy_inode(struct inode *inode)
> {
> 	BUG_ON(!list_empty(&inode->i_lru));
> 	call_rcu(&inode->i_rcu, i_callback);
> }
> 
> We'd then have to get rid of all the call_rcu() invocations in individual
> filesystems' destroy_inode methods, but that doesn't sound like a bad
> thing to me.
> 

Which is another reason that I didn't do it, as I didn't know all the
happenings inside the ->destroy_inode() calls. But yeah, I agree with
this.

Also, can iput() sleep? If not then we are OK. Otherwise, we need to be
careful about any mutex being grabbed in those call backs, as the
rcu_callback can't sleep either.

-- Steve
