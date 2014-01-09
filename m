Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbaAIX7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 18:59:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:43448 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751751AbaAIX7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:59:10 -0500
Date: Thu, 9 Jan 2014 18:59:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
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
Message-ID: <20140109185907.20cddb57@gandalf.local.home>
In-Reply-To: <20140109234537.GR10038@linux.vnet.ibm.com>
References: <20140109162731.12500986@gandalf.local.home>
	<20140109214239.GD29910@parisc-linux.org>
	<20140109165012.391db81e@gandalf.local.home>
	<20140109223127.GM10323@ZenIV.linux.org.uk>
	<CA+55aFzCTPYEQCPnLBi1CwmMTocVqCFiCuJ391HkVx1CMw61ug@mail.gmail.com>
	<20140109182523.5b50131f@gandalf.local.home>
	<20140109182756.17abaaa8@gandalf.local.home>
	<20140109234537.GR10038@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jan 2014 15:45:37 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> >  static void inode_free_security(struct inode *inode)
> >  {
> >  	struct inode_security_struct *isec = inode->i_security;
> > @@ -244,8 +252,7 @@ static void inode_free_security(struct i
> >  		list_del_init(&isec->list);
> >  	spin_unlock(&sbsec->isec_lock);
> > 
> > -	inode->i_security = NULL;
> > -	kmem_cache_free(sel_inode_cache, isec);
> > +	call_rcu(&isec->rcu, inode_free_rcu);
> 
> Does not clearing ->i_security mean that RCU readers can traverse
> this pointer after the invocation of call_rcu()?  If so, this is
> problematic.  (If something else already prevents readers from getting
> here, no problem.)

This is called when we are about to free the inode. Look at
destroy_inode(). Basically, this is the same as doing:

	call_rcu(&isec->rcu, inode_free_rcu);
	call_rcu(&inode->i_rcu, i_callback);

Where i_callback() does the free of the inode.

If you can access inode->i_security, after a call_rcu, then you can
also access the inode itself that has just been freed.

Yes, technically, having two separate call_rcu(), the first grace
period can end before the second, but everything to remove the inode
from sight has already been set up before that first call_rcu() is
made. That means when the first call_rcu() is executed, the inode
should already be invisible to the readers.


- Steve

> 
> 							Thanx, Paul
> 
> >  }
> > 
