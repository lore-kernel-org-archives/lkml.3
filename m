Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaBQXFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 18:05:21 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:51128 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbaBQXFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 18:05:19 -0500
Date: Mon, 17 Feb 2014 15:05:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH tip/core/rcu 09/12] fs: Substitute rcu_access_pointer()
 for rcu_dereference_raw()
Message-ID: <20140217230511.GP4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140217213533.GA5387@linux.vnet.ibm.com>
 <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1392672959-6386-9-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140217220014.GH7941@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140217220014.GH7941@thin>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021723-9332-0000-0000-000003231700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 02:00:15PM -0800, Josh Triplett wrote:
> On Mon, Feb 17, 2014 at 01:35:56PM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > (Trivial patch.)
> > 
> > If the code is looking at the RCU-protected pointer itself, but not
> > dereferencing it, the rcu_dereference() functions can be downgraded to
> > rcu_access_pointer().  This commit makes this downgrade in __alloc_fd(),
> > which simply compares the RCU-protected pointer against NULL with no
> > dereferencing.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Cc: linux-fsdevel@vger.kernel.org
> 
> I'm beginning to wonder if this common pattern ought to have an
> rcu_pointer_is_null(), which would not return the pointer, only the
> boolean.

Or perhaps an rcu_compare_pointer() to also handle the various cases like:

	if (rcu_dereference_raw(foop) == barp) ...

I added the problem to the RCU cleanup list on the OPW site, and
your solution or my elaboration of it might be the right thing to do.
(Inspected all 1300 uses of members of the rcu_dereference() family of
functions last week, and was feeling a bit buggy-eyed at the end...)

							Thanx, Paul

> Regardless, for this patch:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> >  fs/file.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/file.c b/fs/file.c
> > index db25c2bdfe46..18f7d27855c4 100644
> > --- a/fs/file.c
> > +++ b/fs/file.c
> > @@ -497,7 +497,7 @@ repeat:
> >  	error = fd;
> >  #if 1
> >  	/* Sanity check */
> > -	if (rcu_dereference_raw(fdt->fd[fd]) != NULL) {
> > +	if (rcu_access_pointer(fdt->fd[fd]) != NULL) {
> >  		printk(KERN_WARNING "alloc_fd: slot %d not NULL!\n", fd);
> >  		rcu_assign_pointer(fdt->fd[fd], NULL);
> >  	}
> > -- 
> > 1.8.1.5
> > 
> 

