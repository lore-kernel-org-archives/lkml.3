Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab3A0Vkm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 16:40:42 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:57495 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561Ab3A0Vkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 16:40:40 -0500
Date: Sun, 27 Jan 2013 13:40:40 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Shaohua Li <shli@kernel.org>
cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shli@fusionio.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: boot warnings due to swap: make each swap partition have one
 address_space
In-Reply-To: <20130127141253.GA27019@kernel.org>
Message-ID: <alpine.LNX.2.00.1301271321500.16981@eggly.anvils>
References: <5101FFF5.6030503@oracle.com> <20130125042512.GA32017@kernel.org> <alpine.LNX.2.00.1301261754530.7300@eggly.anvils> <20130127141253.GA27019@kernel.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2013, Shaohua Li wrote:
> On Sat, Jan 26, 2013 at 06:16:05PM -0800, Hugh Dickins wrote:
> > On Fri, 25 Jan 2013, Shaohua Li wrote:
> > > On Thu, Jan 24, 2013 at 10:45:57PM -0500, Sasha Levin wrote:
> > > 
> > > Subject: give-each-swapper-space-separate-backing_dev_info
> > > 
> > > The backing_dev_info can't be shared by all swapper address space.
> > 
> > Whyever not?  It's perfectly normal for different inodes/address_spaces
> > to share a single backing_dev!  Sasha's trace says that it's wrong to
> > initialize it MAX_SWAPFILES times: fair enough.  But why should I now
> > want to spend 32kB (not even counting their __percpu counters) on all
> > these pseudo-backing_devs?
> 
> That's correct, silly me. Updated it.

Looks much more to my taste, thank you!

> > 
> > p.s. a grand little change would be to move page_cluster and swap_setup()
> > from mm/swap.c to mm/swap_state.c: they have nothing to do with the other
> > contents of swap.c, and everything to do with the contents of swap_state.c.
> > Why swap.c is called swap.c is rather a mystery.
> 
> Tried, but looks page_cluster is used in sysctl, moving to swap_state.c will
> make it optional. don't want to add another #ifdef, so give up.

Good point, thanks for trying, maybe I'll attack it next time it
irritates me.

I don't yet know whether I approve of your changes or not, but running
with them to see (and I'll send another bugfix separately in a moment).

I was the one who removed the swap_device_lock() which 2.4 used,
because it almost always ended up having to take both swap_list_lock()
and swap_device_lock(si).  You seem to have done a much better job of
separating them usefully, but I need to convince myself that it does
end up safely.

My reservations so far would be: how many installations actually have
more than one swap area, so is it a good tradeoff to add more overhead
to help those at the (slight) expense of everyone else?  The increasingly
ugly page_mapping() worries me, and the static array of swapper_spaces
annoys me a little.

I'm glad Minchan has now pointed you to Rik's posting of two years ago:
I think there are more important changes to be made in that direction.

Hugh

> 
> 
> Subject: init-swap-space-backing-dev-info-once
> 
> 
> Sasha reported:
> Commit "swap: make each swap partition have one address_space" is triggering
> a series of warnings on boot:
> 
> [    3.446071] ------------[ cut here ]------------
> [    3.446664] WARNING: at lib/debugobjects.c:261 debug_print_object+0x8e/0xb0()
> [    3.447715] ODEBUG: init active (active state 0) object type: percpu_counter hint:           (null)
> [    3.450360] Modules linked in:
> [    3.451593] Pid: 1, comm: swapper/0 Tainted: G        W    3.8.0-rc4-next-20130124-sasha-00004-g838a1b4 #266
> [    3.454508] Call Trace:
> [    3.455248]  [<ffffffff8110d1bc>] warn_slowpath_common+0x8c/0xc0
> [    3.455248]  [<ffffffff8110d291>] warn_slowpath_fmt+0x41/0x50
> [    3.455248]  [<ffffffff81a2bb5e>] debug_print_object+0x8e/0xb0
> [    3.455248]  [<ffffffff81a2c26b>] __debug_object_init+0x20b/0x290
> [    3.455248]  [<ffffffff81a2c305>] debug_object_init+0x15/0x20
> [    3.455248]  [<ffffffff81a3fbed>] __percpu_counter_init+0x6d/0xe0
> [    3.455248]  [<ffffffff81231bdc>] bdi_init+0x1ac/0x270
> [    3.455248]  [<ffffffff8618f20b>] swap_setup+0x3b/0x87
> [    3.455248]  [<ffffffff8618f257>] ? swap_setup+0x87/0x87
> [    3.455248]  [<ffffffff8618f268>] kswapd_init+0x11/0x7c
> [    3.455248]  [<ffffffff810020ca>] do_one_initcall+0x8a/0x180
> [    3.455248]  [<ffffffff86168cfd>] do_basic_setup+0x96/0xb4
> [    3.455248]  [<ffffffff861685ae>] ? loglevel+0x31/0x31
> [    3.455248]  [<ffffffff861885cd>] ? sched_init_smp+0x150/0x157
> [    3.455248]  [<ffffffff86168ded>] kernel_init_freeable+0xd2/0x14c
> [    3.455248]  [<ffffffff83cade10>] ? rest_init+0x140/0x140
> [    3.455248]  [<ffffffff83cade19>] kernel_init+0x9/0xf0
> [    3.455248]  [<ffffffff83d5727c>] ret_from_fork+0x7c/0xb0
> [    3.455248]  [<ffffffff83cade10>] ? rest_init+0x140/0x140
> [    3.455248] ---[ end trace 0b176d5c0f21bffb ]---
> 
> Initialize swap space backing_dev_info once to avoid the warning.
> 
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  mm/swap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/mm/swap.c
> ===================================================================
> --- linux.orig/mm/swap.c	2013-01-27 21:26:21.942696713 +0800
> +++ linux/mm/swap.c	2013-01-27 21:27:29.233865394 +0800
> @@ -858,8 +858,8 @@ void __init swap_setup(void)
>  #ifdef CONFIG_SWAP
>  	int i;
>  
> +	bdi_init(swapper_spaces[0].backing_dev_info);
>  	for (i = 0; i < MAX_SWAPFILES; i++) {
> -		bdi_init(swapper_spaces[i].backing_dev_info);
>  		spin_lock_init(&swapper_spaces[i].tree_lock);
>  		INIT_LIST_HEAD(&swapper_spaces[i].i_mmap_nonlinear);
>  	}
> 
