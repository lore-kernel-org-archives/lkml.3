Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab3ALDdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 22:33:52 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:61126 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab3ALDdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 22:33:51 -0500
Date: Fri, 11 Jan 2013 19:33:46 -0800
From: Michel Lespinasse <walken@google.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>, Salman Qazi <sqazi@google.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rwlock_t unfairness and tasklist_lock
Message-ID: <20130112033346.GA11712@google.com>
References: <CANN689HRmVTLCjNL9c=JqhWy5F5vwr=A7coo3TVKLZGSVUpQjw@mail.gmail.com>
 <alpine.LFD.2.02.1301111522150.7475@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1301111522150.7475@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 03:34:41PM +0100, Thomas Gleixner wrote:
> On Tue, 8 Jan 2013, Michel Lespinasse wrote:
> > - Does anyone know of any current work towards removing the
> > tasklist_lock use of rwlock_t ? Thomas Gleixner mentioned 3 years ago
> > that he'd give it a shot (https://lwn.net/Articles/364601/), did he
> > encounter some unforeseen difficulty that we should learn from ?
> 
> I converted quite a bunch of the read side instances to rcu
> protection, but got distracted. There was no fundamental difficulty,
> just lack of time.

All right. Thanks for explaining here and offline; it looks like the
problem is not as intractable as I had thought initially.

> > - Would there be any fundamental objection to implementing a fair
> > rwlock_t and dealing with the reentrancy issues in tasklist_lock ? My
> > proposal there would be along the lines of:
> > 
> > 1- implement a fair rwlock_t - the ticket based idea from David
> > Howells seems quite appropriate to me
> 
> Nah. Lets get it killed. Most of the stuff can be converted to RCU and
> the remaining bits and pieces are the write lock sides which then can
> be converted to a big standard spinlock. There might be a few more
> complex ones, but Oleg said back then that those should be solved by
> locking the process instead of locking the whole tasklist.

So I looked again at getpriority() since that's what I had used for my
DOS test code, and it looks like everything there is already protected
by RCU or smaller granularity locks and refcounts. Patch attached to
remove this tasklist_lock usage.

Since I'm new to this, I would like someone to double check me.
Also, what is the proper tree to send such patches to so they'll get
some testing before making it into Linus's tree ?

--------------------------------8<-----------------------------

remove use of tasklist_lock in getpriority / setpriority syscalls

I can't see anything in these syscalls that isn't already protected
by RCU (for the task/thread iterations and for mapping pids to tasks)
or by smaller granularity locks (for set_one_prio()) or refcounts
(for find_user()). So, it looks like we can just remove the use of
tasklist_lock...

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 kernel/sys.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 265b37690421..5df66d4b118f 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -189,7 +189,6 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 		niceval = 19;
 
 	rcu_read_lock();
-	read_lock(&tasklist_lock);
 	switch (which) {
 		case PRIO_PROCESS:
 			if (who)
@@ -226,7 +225,6 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 			break;
 	}
 out_unlock:
-	read_unlock(&tasklist_lock);
 	rcu_read_unlock();
 out:
 	return error;
@@ -251,7 +249,6 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 		return -EINVAL;
 
 	rcu_read_lock();
-	read_lock(&tasklist_lock);
 	switch (which) {
 		case PRIO_PROCESS:
 			if (who)
@@ -296,7 +293,6 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 			break;
 	}
 out_unlock:
-	read_unlock(&tasklist_lock);
 	rcu_read_unlock();
 
 	return retval;

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
