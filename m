Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab3EXWVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 18:21:39 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:37626 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332Ab3EXWVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 18:21:37 -0400
Message-ID: <1369434096.2138.24.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 04/11] ipc: move locking out of ipcctl_pre_down_nolock
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, riel@redhat.com,
        linux-kernel@vger.kernel.org
Date: Fri, 24 May 2013 15:21:36 -0700
In-Reply-To: <20130524131652.e21bff6b6c6a214b19b299a9@linux-foundation.org>
References: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
	 <1368666490-29055-5-git-send-email-davidlohr.bueso@hp.com>
	 <20130524131652.e21bff6b6c6a214b19b299a9@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-24 at 13:16 -0700, Andrew Morton wrote:
> On Wed, 15 May 2013 18:08:03 -0700 Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> 
> > This function currently acquires both the rw_mutex and the rcu lock on
> > successful lookups, leaving the callers to explicitly unlock them, creating
> > another two level locking situation.
> > 
> > Make the callers (including those that still use ipcctl_pre_down()) explicitly
> > lock and unlock the rwsem and rcu lock.
> > 
> > ...
> >
> > @@ -409,31 +409,38 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
> >  			return -EFAULT;
> >  	}
> >  
> > +	down_write(&msg_ids(ns).rw_mutex);
> > +	rcu_read_lock();
> > +
> >  	ipcp = ipcctl_pre_down(ns, &msg_ids(ns), msqid, cmd,
> >  			       &msqid64.msg_perm, msqid64.msg_qbytes);
> > -	if (IS_ERR(ipcp))
> > -		return PTR_ERR(ipcp);
> > +	if (IS_ERR(ipcp)) {
> > +		err = PTR_ERR(ipcp);
> > +		/* the ipc lock is not held upon failure */
> 
> Terms like "the ipc lock" are unnecessarily vague.  It's better to
> identify the lock by name, eg msg_queue.q_perm.lock.

Ok, I can send a patch to rephrase that to perm.lock when I send the shm
patchset (which will be very similar to this one).

> 
> Where should readers go to understand the overall locking scheme?  A
> description of the overall object hierarchy and the role which the
> various locks play?

That can be done, how about something like
Documentation/ipc-locking.txt?

> 
> Have you done any performance testing of this patchset?  Just from
> squinting at it, I'd expect the effects to be small...
> 

Right, I don't expect much performance benefits. (a) unlike sems, I
haven't seen mqueues ever show up as any source of contention, and (b) I
think sysv mqueues have mostly been replaced by posix ones...

For testing, I did run these patches with ipccmd
(http://code.google.com/p/ipcmd/), pgbench, aim7 and Oracle on large
machines - no regressions but nothing new in terms of performance.

I suspect that shm could have a little more impact, but haven't looked
too much into it.

Thanks,
Davidlohr

