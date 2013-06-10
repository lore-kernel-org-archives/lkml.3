Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab3FJW4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:56:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab3FJW4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:56:45 -0400
Date: Mon, 10 Jun 2013 15:56:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
Subject: Re: [IPC] INFO: suspicious RCU usage.
Message-Id: <20130610155643.89b890cb55e118a19dcb9dec@linux-foundation.org>
In-Reply-To: <1370540122.1724.3.camel@buesod1.americas.hpqcorp.net>
References: <20130606132522.GA18959@localhost>
	<1370540122.1724.3.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Jun 2013 10:35:22 -0700 Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:

> > [   51.524946] 
> > [   51.525983] ===============================
> > [   51.532875] [ INFO: suspicious RCU usage. ]
> > [   51.535385] 3.10.0-rc4-next-20130606 #6 Not tainted
> > [   51.538304] -------------------------------
> > [   51.540937] /c/kernel-tests/src/stable/include/linux/rcupdate.h:471 Illegal context switch in RCU read-side critical section!
> > [   51.548110] 
> > [   51.548110] other info that might help us debug this:
> > [   51.548110] 
> > [   51.553055] 
> > [   51.553055] rcu_scheduler_active = 1, debug_locks = 1
> > [   51.557199] 2 locks held by trinity/1107:
> > [   51.560168]  #0:  (&ids->rw_mutex){+.+.+.}, at: [<ffffffff811e15ee>] ipcget+0x38/0x2b3
> > [   51.566465]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff811e7698>] newseg+0x19d/0x3fd
> > [   51.572413] 
> > [   51.572413] stack backtrace:
> > [   51.574761] CPU: 0 PID: 1107 Comm: trinity Not tainted 3.10.0-rc4-next-20130606 #6
> > [   51.579331] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> > [   51.583068]  0000000000000001 ffff880004a07d88 ffffffff817b1f5c ffff880004a07db8
> > [   51.592119]  ffffffff810f2f1d ffffffff81b78569 00000000000001a8 0000000000000000
> > [   51.596726]  0000000000000000 ffff880004a07de8 ffffffff810ded5e ffff880004a07fd8
> > [   51.605189] Call Trace:
> > [   51.606409]  [<ffffffff817b1f5c>] dump_stack+0x19/0x1b
> > [   51.609632]  [<ffffffff810f2f1d>] lockdep_rcu_suspicious+0xeb/0xf4
> > [   51.612905]  [<ffffffff810ded5e>] __might_sleep+0x59/0x1dc
> > [   51.618614]  [<ffffffff81238623>] idr_preload+0x9b/0x142
> > [   51.621939]  [<ffffffff811e0e56>] ipc_addid+0x3d/0x193
> > [   51.624373]  [<ffffffff811e771c>] newseg+0x221/0x3fd
> > [   51.626596]  [<ffffffff811e7698>] ? newseg+0x19d/0x3fd
> > [   51.630177]  [<ffffffff811e1774>] ipcget+0x1be/0x2b3
> > [   51.633174]  [<ffffffff817bc094>] ? retint_swapgs+0x13/0x1b
> > [   51.636356]  [<ffffffff811e7a5a>] SyS_shmget+0x59/0x5d
> > [   51.639576]  [<ffffffff811e74fb>] ? shm_try_destroy_orphaned+0xbf/0xbf
> > [   51.643673]  [<ffffffff811e6ce5>] ? shm_get_unmapped_area+0x20/0x20
> > [   51.647321]  [<ffffffff811e6cf0>] ? shm_security+0xb/0xb
> > [   51.650831]  [<ffffffff817bcb27>] system_call_fastpath+0x16/0x1b
> 
> I suspect this is caused because now we call idr_preload() in ipc_addid
> with the rcu lock held by the caller. So, we can either have a two level
> rcu locking or a two level idr_preload/idr_preload_end.

I'm not sure what to suggest really, apart from the use of explosives.

ipc_addid():

	spin_lock_init(&new->lock);
	new->deleted = 0;
	spin_lock(&new->lock);

this makes no sense.  If we can run spin_lock_init() against a lock
then it had darn well better be the case that no other thread is able
to access that lock.  And if no other thread can access that lock then
there's no need to lock it!

Presumably at some point in the future, other threads can look up this
object and then the lock becomes useful.  Perhaps that's the
rcu_read_unlock() after a successful idr_alloc() - it's unclear from a
quick read.


Also, ipc_addid() undoes its caller's rcu_read_lock() if idr_alloc()
failed.  This is strange from an interface point of view, is not
documented in the ipc_addid() interface description and will cause
newseg() (at least) to perform a double rcu_read_unlock().


As for this particular trace: I'd view the putting of rcu_read_lock()
around the ipc_addid() call as being the core mistake.  By its very
nature, ipc_addid() allocates memory and hence should be called in
GFP_KERNEL context.
