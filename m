Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab3CKTaC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:30:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab3CKTaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:30:00 -0400
Date: Mon, 11 Mar 2013 15:29:55 -0400
From: David Teigland <teigland@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 67/77] dlm: convert to idr_alloc()
Message-ID: <20130311192955.GA23892@redhat.com>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
 <1360179649-22465-68-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360179649-22465-68-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 11:40:39AM -0800, Tejun Heo wrote:
>  static int create_lkb(struct dlm_ls *ls, struct dlm_lkb **lkb_ret)
>  {
>  	struct dlm_lkb *lkb;
> -	int rv, id;
> +	int rv;
>  
>  	lkb = dlm_allocate_lkb(ls);
>  	if (!lkb)
> @@ -1199,19 +1199,13 @@ static int create_lkb(struct dlm_ls *ls, struct dlm_lkb **lkb_ret)
>  	mutex_init(&lkb->lkb_cb_mutex);
>  	INIT_WORK(&lkb->lkb_cb_work, dlm_callback_work);
>  
> - retry:
> -	rv = idr_pre_get(&ls->ls_lkbidr, GFP_NOFS);
> -	if (!rv)
> -		return -ENOMEM;
> -
> +	idr_preload(GFP_NOFS);
>  	spin_lock(&ls->ls_lkbidr_spin);
> -	rv = idr_get_new_above(&ls->ls_lkbidr, lkb, 1, &id);
> -	if (!rv)
> -		lkb->lkb_id = id;
> +	rv = idr_alloc(&ls->ls_lkbidr, lkb, 1, 0, GFP_NOWAIT);

Hi Tejun,
I'm seeing a number of new failure/warning messages within this idr_alloc.
I've not seen idr_alloc itself return an error yet.  Is this an expected
failure where the warnings should be suppressed?
Dave

kworker/u:3: page allocation failure: order:1, mode:0x200000
Pid: 181, comm: kworker/u:3 Not tainted 3.9.0-rc2+ #1
Call Trace:
 [<ffffffff810c870b>] warn_alloc_failed+0xeb/0x150
 [<ffffffff8105f91e>] ? __wake_up+0x4e/0x70
 [<ffffffff810ca626>] __alloc_pages_nodemask+0x666/0x930
 [<ffffffff810ca626>] ? __alloc_pages_nodemask+0x666/0x930
 [<ffffffff811031ff>] kmem_getpages+0x5f/0x1b0
 [<ffffffff81103e33>] fallback_alloc+0x173/0x250
 [<ffffffff81103be3>] ____cache_alloc_node+0x93/0x170
 [<ffffffff811035f8>] ? cache_alloc_refill+0x2a8/0x310
 [<ffffffff81104e59>] kmem_cache_alloc+0xd9/0x130
 [<ffffffff811da11c>] idr_layer_alloc+0x2c/0x80
 [<ffffffff811dac8c>] idr_get_empty_slot+0x2ec/0x390
 [<ffffffff811db0ad>] idr_alloc+0x4d/0xc0
 [<ffffffffa031ded2>] create_lkb+0x122/0x180 [dlm]
 [<ffffffffa03232a4>] receive_request+0x34/0x440 [dlm]
 [<ffffffffa0331f07>] ? dlm_wait_requestqueue+0x37/0x60 [dlm]
 [<ffffffffa0326aac>] _receive_message+0x67c/0x1050 [dlm]
 [<ffffffff81425f39>] ? mutex_unlock+0x9/0x10
 [<ffffffffa0327605>] dlm_receive_buffer+0x185/0x200 [dlm]
 [<ffffffffa032ab7f>] dlm_process_incoming_buffer+0xef/0x210 [dlm]
 [<ffffffffa032c5cc>] receive_from_sock+0x1ac/0x430 [dlm]
 [<ffffffffa032aee9>] process_recv_sockets+0x29/0x40 [dlm]
 [<ffffffff8104e0d7>] process_one_work+0x1c7/0x460
 [<ffffffff8104e071>] ? process_one_work+0x161/0x460
 [<ffffffff8105124d>] worker_thread+0x11d/0x3e0
 [<ffffffff81051130>] ? manage_workers+0x340/0x340
 [<ffffffff81056606>] kthread+0xe6/0xf0
 [<ffffffff81056520>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff8142feec>] ret_from_fork+0x7c/0xb0
 [<ffffffff81056520>] ? __init_kthread_worker+0x70/0x70
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 163
CPU    1: hi:  186, btch:  31 usd: 161
CPU    2: hi:  186, btch:  31 usd: 183
CPU    3: hi:  186, btch:  31 usd:  53
Node 1 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd: 191
CPU    3: hi:  186, btch:  31 usd: 166
Node 1 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd:  32
CPU    2: hi:  186, btch:  31 usd: 162
CPU    3: hi:  186, btch:  31 usd: 222
active_anon:4222 inactive_anon:8075 isolated_anon:0
 active_file:511976 inactive_file:334346 isolated_file:0
 unevictable:7742 dirty:0 writeback:0 unstable:0
 free:6682 slab_reclaimable:68508 slab_unreclaimable:62477
 mapped:8263 shmem:7537 pagetables:913 bounce:0
 free_cma:0
Node 0 DMA free:7912kB min:28kB low:32kB high:40kB active_anon:0kB inactive_anon:0kB active_file:7376kB inactive_file:256kB unevictable:24kB isolated(anon):0kB isolated(file):0kB present:15972kB managed:15884kB mlocked:24kB dirty:0kB writeback:0kB mapped:24kB shmem:24kB slab_reclaimable:296kB slab_unreclaimable:20kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 1971 1971 1971
Node 0 DMA32 free:7560kB min:4016kB low:5020kB high:6024kB active_anon:7868kB inactive_anon:22228kB active_file:1034116kB inactive_file:727656kB unevictable:1720kB isolated(anon):0kB isolated(file):0kB present:2080768kB managed:2019104kB mlocked:1720kB dirty:0kB writeback:0kB mapped:18188kB shmem:15648kB slab_reclaimable:101792kB slab_unreclaimable:110520kB kernel_stack:792kB pagetables:1632kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 1 DMA32 free:7928kB min:1952kB low:2440kB high:2928kB active_anon:44kB inactive_anon:888kB active_file:482644kB inactive_file:366988kB unevictable:26080kB isolated(anon):0kB isolated(file):0kB present:1047680kB managed:982144kB mlocked:26080kB dirty:0kB writeback:0kB mapped:4524kB shmem:4500kB slab_reclaimable:71140kB slab_unreclaimable:24332kB kernel_stack:24kB pagetables:96kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:27 all_unreclaimable? no
lowmem_reserve[]: 0 0 995 995
Node 1 Normal free:3328kB min:2024kB low:2528kB high:3036kB active_anon:8976kB inactive_anon:9184kB active_file:523768kB inactive_file:242484kB unevictable:3144kB isolated(anon):0kB isolated(file):0kB present:1048576kB managed:1018896kB mlocked:3144kB dirty:0kB writeback:0kB mapped:10316kB shmem:9976kB slab_reclaimable:100804kB slab_unreclaimable:115036kB kernel_stack:352kB pagetables:1924kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:71 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 2*4kB (U) 4*8kB (UEM) 4*16kB (UEM) 2*32kB (U) 3*64kB (UE) 1*128kB (E) 1*256kB (U) 2*512kB (EM) 2*1024kB (UE) 2*2048kB (ER) 0*4096kB = 7912kB
Node 0 DMA32: 1228*4kB (UEM) 25*8kB (UEM) 19*16kB (M) 17*32kB (M) 7*64kB (M) 1*128kB (M) 0*256kB 0*512kB 1*1024kB (R) 0*2048kB 0*4096kB = 7560kB
Node 1 DMA32: 1571*4kB (UEMR) 25*8kB (EMR) 9*16kB (MR) 5*32kB (MR) 2*64kB (M) 0*128kB 2*256kB (M) 1*512kB (M) 0*1024kB 0*2048kB 0*4096kB = 7940kB
Node 1 Normal: 537*4kB (UEMR) 46*8kB (UEMR) 19*16kB (MR) 8*32kB (MR) 0*64kB 0*128kB 1*256kB (R) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3332kB
854648 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 6160380kB
Total swap = 6160380kB
1048575 pages RAM
35415 pages reserved
884260 pages shared
916445 pages non-shared
SLAB: Unable to allocate memory on node 1 (gfp=0x0)
  cache: idr_layer_cache, object size: 2112, order: 1
  node 0: slabs: 91/91, objs: 273/273, free: 0
  node 1: slabs: 200/200, objs: 600/600, free: 0


> +	if (rv >= 0)
> +		lkb->lkb_id = rv;
>  	spin_unlock(&ls->ls_lkbidr_spin);
> -
> -	if (rv == -EAGAIN)
> -		goto retry;
> +	idr_preload_end();
>  
>  	if (rv < 0) {
>  		log_error(ls, "create_lkb idr error %d", rv);
