Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab3CZRz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:55:59 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47617 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab3CZRz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:55:57 -0400
Date: Tue, 26 Mar 2013 10:55:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Rik van Riel <riel@surriel.com>, torvalds@linux-foundation.org,
        davidlohr.bueso@hp.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        walken@google.com, lwoodman@redhat.com, chegu_vinod@hp.com
Subject: Re: ipc,sem: sysv semaphore scalability
Message-ID: <20130326175534.GO4379@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
 <5151DBD3.6080201@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5151DBD3.6080201@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032617-5806-0000-0000-0000207C04CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 01:33:07PM -0400, Sasha Levin wrote:
> On 03/20/2013 03:55 PM, Rik van Riel wrote:
> > This series makes the sysv semaphore code more scalable,
> > by reducing the time the semaphore lock is held, and making
> > the locking more scalable for semaphore arrays with multiple
> > semaphores.
> 
> Hi Rik,
> 
> Another issue that came up is:
> 
> [   96.347341] ================================================
> [   96.348085] [ BUG: lock held when returning to user space! ]
> [   96.348834] 3.9.0-rc4-next-20130326-sasha-00011-gbcb2313 #318 Tainted: G        W
> [   96.360300] ------------------------------------------------
> [   96.361084] trinity-child9/7583 is leaving the kernel with locks still held!
> [   96.362019] 1 lock held by trinity-child9/7583:
> [   96.362610]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff8192eafb>] SYSC_semtimedop+0x1fb/0xec0
> 
> It seems that we can leave semtimedop without releasing the rcu read lock.
> 
> I'm a bit confused by what's going on in semtimedop with regards to rcu read lock, it
> seems that this behaviour is actually intentional?
> 
>         rcu_read_lock();
>         sma = sem_obtain_object_check(ns, semid);
>         if (IS_ERR(sma)) {
>                 if (un)
>                         rcu_read_unlock();
>                 error = PTR_ERR(sma);
>                 goto out_free;
>         }
> 
> When I've looked at that it seems that not releasing the read lock was (very)
> intentional.
> 
> After that, the only code path that would release the lock starts with:
> 
>         if (un) {
> 		...
> 
> So we won't release the lock at all if un is NULL?

Intentions notwithstanding, it is absolutely required to exit any and
all RCU read-side critical sections prior to going into user mode.

I suggest removing the "if (un)".

							Thanx, Paul

