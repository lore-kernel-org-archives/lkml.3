Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbaBRAEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 19:04:50 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:52658 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbaBRAEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 19:04:48 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 17 Feb 2014 16:04:31 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH tip/core/rcu 09/12] fs: Substitute rcu_access_pointer()
 for rcu_dereference_raw()
Message-ID: <20140218000431.GB19929@thin>
References: <20140217213533.GA5387@linux.vnet.ibm.com>
 <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1392672959-6386-9-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140217220014.GH7941@thin>
 <20140217230511.GP4250@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140217230511.GP4250@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 03:05:11PM -0800, Paul E. McKenney wrote:
> On Mon, Feb 17, 2014 at 02:00:15PM -0800, Josh Triplett wrote:
> > On Mon, Feb 17, 2014 at 01:35:56PM -0800, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > 
> > > (Trivial patch.)
> > > 
> > > If the code is looking at the RCU-protected pointer itself, but not
> > > dereferencing it, the rcu_dereference() functions can be downgraded to
> > > rcu_access_pointer().  This commit makes this downgrade in __alloc_fd(),
> > > which simply compares the RCU-protected pointer against NULL with no
> > > dereferencing.
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > > Cc: linux-fsdevel@vger.kernel.org
> > 
> > I'm beginning to wonder if this common pattern ought to have an
> > rcu_pointer_is_null(), which would not return the pointer, only the
> > boolean.
> 
> Or perhaps an rcu_compare_pointer() to also handle the various cases like:
> 
> 	if (rcu_dereference_raw(foop) == barp) ...
> 
> I added the problem to the RCU cleanup list on the OPW site, and
> your solution or my elaboration of it might be the right thing to do.
> (Inspected all 1300 uses of members of the rcu_dereference() family of
> functions last week, and was feeling a bit buggy-eyed at the end...)

rcu_pointer_eq and/or rcu_pointer_neq might make sense, yeah, as
self-documenting versions of the most sensible way to do the operation,
to steer people away from rcu_dereference or rcu_dereference_raw.

- Jsoh Triplett

> 							Thanx, Paul
> 
> > Regardless, for this patch:
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > 
> > >  fs/file.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/file.c b/fs/file.c
> > > index db25c2bdfe46..18f7d27855c4 100644
> > > --- a/fs/file.c
> > > +++ b/fs/file.c
> > > @@ -497,7 +497,7 @@ repeat:
> > >  	error = fd;
> > >  #if 1
> > >  	/* Sanity check */
> > > -	if (rcu_dereference_raw(fdt->fd[fd]) != NULL) {
> > > +	if (rcu_access_pointer(fdt->fd[fd]) != NULL) {
> > >  		printk(KERN_WARNING "alloc_fd: slot %d not NULL!\n", fd);
> > >  		rcu_assign_pointer(fdt->fd[fd], NULL);
> > >  	}
> > > -- 
> > > 1.8.1.5
> > > 
> > 
> 
