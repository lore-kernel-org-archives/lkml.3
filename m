Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaBCXxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:53:10 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:48095 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaBCXxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:53:08 -0500
Date: Mon, 3 Feb 2014 15:53:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cl@linux-foundation.org,
        penberg@kernel.org, mpm@selenic.com, peterz@infradead.org
Subject: Re: [PATCH] Fix lockdep false positive in add_full()
Message-ID: <20140203235302.GK4333@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140203225725.GA4069@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402031531160.7643@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402031531160.7643@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020323-1344-0000-0000-0000056A3E12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 03:31:40PM -0800, David Rientjes wrote:
> On Mon, 3 Feb 2014, Paul E. McKenney wrote:
> 
> > Hello!
> > 
> > The add_full() function currently has a lockdep_assert_held() requiring
> > that the kmem_cache_node structure's ->list_lock be held.  However,
> > this lock is not acquired by add_full()'s caller deactivate_slab()
> > in the full-node case unless debugging is enabled.  Because full nodes
> > are accessed only by debugging code, this state of affairs results in
> > lockdep false-positive splats like the following:
> > 
> > [   43.942868] WARNING: CPU: 0 PID: 698 at /home/paulmck/public_git/linux-rcu/mm/slub.c:1007 deactivate_slab+0x509/0x720()
> > [   43.943016] Modules linked in:
> > [   43.943016] CPU: 0 PID: 698 Comm: torture_onoff Not tainted 3.14.0-rc1+ #1
> > [   43.943016] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> > [   43.943016]  00000000000003ef ffff88001e3f5ba8 ffffffff818952ec 0000000000000046
> > [   43.943016]  0000000000000000 ffff88001e3f5be8 ffffffff81049517 ffffea0000784e00
> > [   43.943016]  0000000000000000 ffffea00007a9000 0000000000000002 0000000000000000
> > [   43.943016] Call Trace:
> > [   43.943016]  [<ffffffff818952ec>] dump_stack+0x46/0x58
> > [   43.943016]  [<ffffffff81049517>] warn_slowpath_common+0x87/0xb0
> > [   43.943016]  [<ffffffff81049555>] warn_slowpath_null+0x15/0x20
> > [   43.943016]  [<ffffffff8116e679>] deactivate_slab+0x509/0x720
> > [   43.943016]  [<ffffffff8116eebb>] ? slab_cpuup_callback+0x3b/0x100
> > [   43.943016]  [<ffffffff8116ef52>] ? slab_cpuup_callback+0xd2/0x100
> > [   43.943016]  [<ffffffff8116ef24>] slab_cpuup_callback+0xa4/0x100
> > [   43.943016]  [<ffffffff818a4c14>] notifier_call_chain+0x54/0x110
> > [   43.943016]  [<ffffffff81075b79>] __raw_notifier_call_chain+0x9/0x10
> > [   43.943016]  [<ffffffff8104963b>] __cpu_notify+0x1b/0x30
> > [   43.943016]  [<ffffffff81049720>] cpu_notify_nofail+0x10/0x20
> > [   43.943016]  [<ffffffff8188cc5d>] _cpu_down+0x10d/0x2e0
> > [   43.943016]  [<ffffffff8188ce60>] cpu_down+0x30/0x50
> > [   43.943016]  [<ffffffff811205f3>] torture_onoff+0xd3/0x3c0
> > [   43.943016]  [<ffffffff81120520>] ? torture_onoff_stats+0x90/0x90
> > [   43.943016]  [<ffffffff810710df>] kthread+0xdf/0x100
> > [   43.943016]  [<ffffffff818a09cb>] ? _raw_spin_unlock_irq+0x2b/0x40
> > [   43.943016]  [<ffffffff81071000>] ? flush_kthread_worker+0x130/0x130
> > [   43.943016]  [<ffffffff818a983c>] ret_from_fork+0x7c/0xb0
> > [   43.943016]  [<ffffffff81071000>] ? flush_kthread_worker+0x130/0x130
> > 
> > This commit therefore does the lockdep check only if debuggging is
> > enabled, thus avoiding the false positives.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> This was discussed in http://marc.info/?t=139145791300002, what do you 
> think about the patch in that thread instead?

Looks fine to me!  I also tried it out and it avoided the splats, as noted
in my mail in the other thread, so please feel free to add my Tested-by.

							Thanx, Paul

