Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaILCl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 22:41:27 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:61917 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaILCl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 22:41:26 -0400
Date: Fri, 12 Sep 2014 04:41:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Deadlock in vtime_account_user() vs itself across a page fault
Message-ID: <20140912024120.GA4200@lerouge>
References: <26020.1410476074@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26020.1410476074@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 11:54:34PM +0100, David Howells wrote:
> 
> Whilst trying to use docker, I'm occasionally seeing the attached deadlock in
> user time accounting, with a page fault in the middle.  The relevant lines
> from the pre-fault bits of stack:
> 
> 	[<ffffffff8106d954>] ? cpuacct_account_field+0x65/0x9a
> 	(gdb) i li *0xffffffff8106d954
> 	Line 272 of "../kernel/sched/cpuacct.c"
> 
> 		kcpustat->cpustat[index] += val;
> 
> 	[<ffffffff81060d41>] account_user_time+0x62/0x95
> 	(gdb) i li *0xffffffff81060d41
> 	Line 151 of "../kernel/sched/cputime.c"
> 
> 		acct_account_cputime(p);
> 
> 	[<ffffffff81061254>] vtime_account_user+0x62/0x8d
> 	(gdb) i li *0xffffffff81061254
> 	Line 264 of "../include/linux/seqlock.h"
> 
> 		in write_seqcount_end():
> 		seqcount_release(&s->dep_map, 1, _RET_IP_);
> 
> I can't see any particular reason there should be a page fault occurring,
> except that there's a duff kernel pointer, but I don't get to find out because
> the page fault handling doesn't get that far:-/
> 
> David
> ---
> =============================================
> [ INFO: possible recursive locking detected ]
> 3.17.0-rc4-fsdevel+ #706 Tainted: G        W     
> ---------------------------------------------
> NetworkManager/2305 is trying to acquire lock:
>  (&(&(&p->vtime_seqlock)->lock)->rlock){-.-.-.}, at: [<ffffffff8106120d>] vtime_account_user+0x1b/0x8d
> 
> but task is already holding lock:
>  (&(&(&p->vtime_seqlock)->lock)->rlock){-.-.-.}, at: [<ffffffff8106120d>] vtime_account_user+0x1b/0x8d
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(&(&(&p->vtime_seqlock)->lock)->rlock);
>   lock(&(&(&p->vtime_seqlock)->lock)->rlock);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
> 
> 3 locks held by NetworkManager/2305:
>  #0:  (&(&(&p->vtime_seqlock)->lock)->rlock){-.-.-.}, at: [<ffffffff8106120d>] vtime_account_user+0x1b/0x8d
>  #1:  (&(&p->vtime_seqlock)->seqcount){-----.}, at: [<ffffffff810df2f9>] context_tracking_user_exit+0x54/0xb7
>  #2:  (rcu_read_lock){......}, at: [<ffffffff8106d8ef>] cpuacct_account_field+0x0/0x9a
> 
> stack backtrace:
> CPU: 0 PID: 2305 Comm: NetworkManager Tainted: G        W      3.17.0-rc4-fsdevel+ #706
> Hardware name:                  /DG965RY, BIOS MQ96510J.86A.0816.2006.0716.2308 07/16/2006
>  0000000000000000 ffff8800389bfbe0 ffffffff815063fd ffffffff8235c880
>  ffff8800389bfcc0 ffffffff810717f5 ffff8800389bfcd0 ffffffff81071a90
>  0000000000000000 ffffffff8106d85d 0000000000000001 ffffffff81061200
> Call Trace:
>  [<ffffffff815063fd>] dump_stack+0x4d/0x66
>  [<ffffffff810717f5>] __lock_acquire+0x7d7/0x1a2a
>  [<ffffffff81071a90>] ? __lock_acquire+0xa72/0x1a2a
>  [<ffffffff8106d85d>] ? cpuacct_css_alloc+0x93/0x93
>  [<ffffffff81061200>] ? vtime_account_user+0xe/0x8d
>  [<ffffffff81071a90>] ? __lock_acquire+0xa72/0x1a2a
>  [<ffffffff810730fc>] lock_acquire+0x8b/0x101
>  [<ffffffff810730fc>] ? lock_acquire+0x8b/0x101
>  [<ffffffff8106120d>] ? vtime_account_user+0x1b/0x8d
>  [<ffffffff8150bc4b>] _raw_spin_lock+0x2b/0x3a
>  [<ffffffff8106120d>] ? vtime_account_user+0x1b/0x8d
>  [<ffffffff8106120d>] vtime_account_user+0x1b/0x8d
>  [<ffffffff810df2f9>] context_tracking_user_exit+0x54/0xb7
>  [<ffffffff81030682>] do_page_fault+0x3a/0x54
>  [<ffffffff8150e462>] page_fault+0x22/0x30
>  [<ffffffff8106d954>] ? cpuacct_account_field+0x65/0x9a

vmalloc'ed areas can fault due to lazy mapping.
That would be an excellent candidate here because cpuacct_account_field()
accesses per cpu stats that are allocated with alloc_percpu() which
uses...vmalloc().

vmalloc() faults have always been a PITA. Especially with per cpu allocation,
basically it means that the kernel can fault about anywhere.

So the only solution I see right now is to move task_group_account_field()
outside the lock. It doesn't need it, but that means I need to split up
account_user_time() and have less common code between tickless and tick time accounting.

In the hope that the other accounting code (acct, group accounting, ...) doesn't
access more percpu allocated stuffs.

Ah, I could also have a recursion detection in the vtime_account_*()
functions. Yeah that would be much safer. The recursive call could simply
ignore and let the first caller do the accounting. But that means we could
account exception time into user time.

We could also do both and let the recursive call warn.

BTW I should check if I can turn the seqlock into a seqcount, not that it
would fix anything here though. It looks like it's only ever updated locally.
