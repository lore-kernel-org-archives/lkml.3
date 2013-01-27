Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab3A0ONR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 09:13:17 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:56624 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab3A0ONM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 09:13:12 -0500
Date: Sun, 27 Jan 2013 22:12:53 +0800
From: Shaohua Li <shli@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shli@fusionio.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: boot warnings due to swap: make each swap partition have one
 address_space
Message-ID: <20130127141253.GA27019@kernel.org>
References: <5101FFF5.6030503@oracle.com>
 <20130125042512.GA32017@kernel.org>
 <alpine.LNX.2.00.1301261754530.7300@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1301261754530.7300@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 06:16:05PM -0800, Hugh Dickins wrote:
> On Fri, 25 Jan 2013, Shaohua Li wrote:
> > On Thu, Jan 24, 2013 at 10:45:57PM -0500, Sasha Levin wrote:
> > > Hi folks,
> > > 
> > > Commit "swap: make each swap partition have one address_space" is triggering
> > > a series of warnings on boot:
> > > 
> > > [    3.446071] ------------[ cut here ]------------
> > > [    3.446664] WARNING: at lib/debugobjects.c:261 debug_print_object+0x8e/0xb0()
> > > [    3.447715] ODEBUG: init active (active state 0) object type: percpu_counter hint:           (null)
> > > [    3.450360] Modules linked in:
> > > [    3.451593] Pid: 1, comm: swapper/0 Tainted: G        W    3.8.0-rc4-next-20130124-sasha-00004-g838a1b4 #266
> > > [    3.454508] Call Trace:
> > > [    3.455248]  [<ffffffff8110d1bc>] warn_slowpath_common+0x8c/0xc0
> > > [    3.455248]  [<ffffffff8110d291>] warn_slowpath_fmt+0x41/0x50
> > > [    3.455248]  [<ffffffff81a2bb5e>] debug_print_object+0x8e/0xb0
> > > [    3.455248]  [<ffffffff81a2c26b>] __debug_object_init+0x20b/0x290
> > > [    3.455248]  [<ffffffff81a2c305>] debug_object_init+0x15/0x20
> > > [    3.455248]  [<ffffffff81a3fbed>] __percpu_counter_init+0x6d/0xe0
> > > [    3.455248]  [<ffffffff81231bdc>] bdi_init+0x1ac/0x270
> > > [    3.455248]  [<ffffffff8618f20b>] swap_setup+0x3b/0x87
> > > [    3.455248]  [<ffffffff8618f257>] ? swap_setup+0x87/0x87
> > > [    3.455248]  [<ffffffff8618f268>] kswapd_init+0x11/0x7c
> > > [    3.455248]  [<ffffffff810020ca>] do_one_initcall+0x8a/0x180
> > > [    3.455248]  [<ffffffff86168cfd>] do_basic_setup+0x96/0xb4
> > > [    3.455248]  [<ffffffff861685ae>] ? loglevel+0x31/0x31
> > > [    3.455248]  [<ffffffff861885cd>] ? sched_init_smp+0x150/0x157
> > > [    3.455248]  [<ffffffff86168ded>] kernel_init_freeable+0xd2/0x14c
> > > [    3.455248]  [<ffffffff83cade10>] ? rest_init+0x140/0x140
> > > [    3.455248]  [<ffffffff83cade19>] kernel_init+0x9/0xf0
> > > [    3.455248]  [<ffffffff83d5727c>] ret_from_fork+0x7c/0xb0
> > > [    3.455248]  [<ffffffff83cade10>] ? rest_init+0x140/0x140
> > > [    3.455248] ---[ end trace 0b176d5c0f21bffb ]---
> > > 
> > > I haven't looked deeper into it yet, and will do so tomorrow, unless this
> > > spew is obvious to anyone.
> > 
> > Does this one help?
> > 
> > Subject: give-each-swapper-space-separate-backing_dev_info
> > 
> > The backing_dev_info can't be shared by all swapper address space.
> 
> Whyever not?  It's perfectly normal for different inodes/address_spaces
> to share a single backing_dev!  Sasha's trace says that it's wrong to
> initialize it MAX_SWAPFILES times: fair enough.  But why should I now
> want to spend 32kB (not even counting their __percpu counters) on all
> these pseudo-backing_devs?

That's correct, silly me. Updated it.
> 
> p.s. a grand little change would be to move page_cluster and swap_setup()
> from mm/swap.c to mm/swap_state.c: they have nothing to do with the other
> contents of swap.c, and everything to do with the contents of swap_state.c.
> Why swap.c is called swap.c is rather a mystery.

Tried, but looks page_cluster is used in sysctl, moving to swap_state.c will
make it optional. don't want to add another #ifdef, so give up.


Subject: init-swap-space-backing-dev-info-once


Sasha reported:
Commit "swap: make each swap partition have one address_space" is triggering
a series of warnings on boot:

[    3.446071] ------------[ cut here ]------------
[    3.446664] WARNING: at lib/debugobjects.c:261 debug_print_object+0x8e/0xb0()
[    3.447715] ODEBUG: init active (active state 0) object type: percpu_counter hint:           (null)
[    3.450360] Modules linked in:
[    3.451593] Pid: 1, comm: swapper/0 Tainted: G        W    3.8.0-rc4-next-20130124-sasha-00004-g838a1b4 #266
[    3.454508] Call Trace:
[    3.455248]  [<ffffffff8110d1bc>] warn_slowpath_common+0x8c/0xc0
[    3.455248]  [<ffffffff8110d291>] warn_slowpath_fmt+0x41/0x50
[    3.455248]  [<ffffffff81a2bb5e>] debug_print_object+0x8e/0xb0
[    3.455248]  [<ffffffff81a2c26b>] __debug_object_init+0x20b/0x290
[    3.455248]  [<ffffffff81a2c305>] debug_object_init+0x15/0x20
[    3.455248]  [<ffffffff81a3fbed>] __percpu_counter_init+0x6d/0xe0
[    3.455248]  [<ffffffff81231bdc>] bdi_init+0x1ac/0x270
[    3.455248]  [<ffffffff8618f20b>] swap_setup+0x3b/0x87
[    3.455248]  [<ffffffff8618f257>] ? swap_setup+0x87/0x87
[    3.455248]  [<ffffffff8618f268>] kswapd_init+0x11/0x7c
[    3.455248]  [<ffffffff810020ca>] do_one_initcall+0x8a/0x180
[    3.455248]  [<ffffffff86168cfd>] do_basic_setup+0x96/0xb4
[    3.455248]  [<ffffffff861685ae>] ? loglevel+0x31/0x31
[    3.455248]  [<ffffffff861885cd>] ? sched_init_smp+0x150/0x157
[    3.455248]  [<ffffffff86168ded>] kernel_init_freeable+0xd2/0x14c
[    3.455248]  [<ffffffff83cade10>] ? rest_init+0x140/0x140
[    3.455248]  [<ffffffff83cade19>] kernel_init+0x9/0xf0
[    3.455248]  [<ffffffff83d5727c>] ret_from_fork+0x7c/0xb0
[    3.455248]  [<ffffffff83cade10>] ? rest_init+0x140/0x140
[    3.455248] ---[ end trace 0b176d5c0f21bffb ]---

Initialize swap space backing_dev_info once to avoid the warning.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/mm/swap.c
===================================================================
--- linux.orig/mm/swap.c	2013-01-27 21:26:21.942696713 +0800
+++ linux/mm/swap.c	2013-01-27 21:27:29.233865394 +0800
@@ -858,8 +858,8 @@ void __init swap_setup(void)
 #ifdef CONFIG_SWAP
 	int i;
 
+	bdi_init(swapper_spaces[0].backing_dev_info);
 	for (i = 0; i < MAX_SWAPFILES; i++) {
-		bdi_init(swapper_spaces[i].backing_dev_info);
 		spin_lock_init(&swapper_spaces[i].tree_lock);
 		INIT_LIST_HEAD(&swapper_spaces[i].i_mmap_nonlinear);
 	}
