Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbaAIVmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 16:42:54 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:54027 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbaAIVmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 16:42:43 -0500
Date: Thu, 9 Jan 2014 14:42:39 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Steven Rostedt <rostedt@goodmis.org>
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
Message-ID: <20140109214239.GD29910@parisc-linux.org>
References: <20140109162731.12500986@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109162731.12500986@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 04:27:31PM -0500, Steven Rostedt wrote:
> Note, the crash came from stressing the deletion and reading of debugfs
> files. I was not able to recreate this via normal files. But I'm not
> sure they are safe. It may just be that the race window is much harder
> to hit.

But "normal" files have a 'destroy_inode' method.  So you've basically
only fixed it for debugfs (and maybe a few other unusual filesystems).
Why doesn't the code look like this:

static void i_callback(struct rcu_head *head)
{
	struct inode *inode = container_of(head, struct inode, i_rcu);
	__destroy_inode(inode);
	if (inode->i_sb->s_op->destroy_inode)
		inode->i_sb->s_op->destroy_inode(inode);
	else
		kmem_cache_free(inode_cachep, inode);
}

static void destroy_inode(struct inode *inode)
{
	BUG_ON(!list_empty(&inode->i_lru));
	call_rcu(&inode->i_rcu, i_callback);
}

We'd then have to get rid of all the call_rcu() invocations in individual
filesystems' destroy_inode methods, but that doesn't sound like a bad
thing to me.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
