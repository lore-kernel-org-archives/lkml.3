Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab3LBRti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 12:49:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab3LBRtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 12:49:35 -0500
Date: Mon, 2 Dec 2013 12:49:13 -0500
From: Dave Jones <davej@redhat.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Kristian Nielsen <knielsen@knielsen-hq.org>,
        Benjamin LaHaise <bcrl@kvack.org>, Kent Overstreet <kmo@daterainc.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: GPF in aio_migratepage
Message-ID: <20131202174913.GA18853@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Gu Zheng <guz.fnst@cn.fujitsu.com>,
	Kristian Nielsen <knielsen@knielsen-hq.org>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Kent Overstreet <kmo@daterainc.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Sasha Levin <sasha.levin@oracle.com>
References: <20131126032645.GA32301@redhat.com>
 <20131126060132.GA6400@redhat.com>
 <20131126071953.GE9244@kmo-pixel>
 <20131126152337.GL15489@kvack.org>
 <87d2lh6h92.fsf@frigg.knielsen-hq.org>
 <529C5CA6.6090708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529C5CA6.6090708@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 06:10:46PM +0800, Gu Zheng wrote:
 > Hi Kristian, Dave,
 > 
 > Could you please help to check whether the following patch can fix this issue?

This introduces some locking bugs..


[  222.327950] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:616
[  222.328004] in_atomic(): 1, irqs_disabled(): 0, pid: 12794, name: trinity-child1
[  222.328044] 1 lock held by trinity-child1/12794:
[  222.328072]  #0:  (&(&mapping->private_lock)->rlock){+.+...}, at: [<ffffffff81210a64>] aio_free_ring+0x44/0x160
[  222.328147] CPU: 1 PID: 12794 Comm: trinity-child1 Not tainted 3.13.0-rc2+ #12 
[  222.328268]  0000000000000268 ffff880229517d68 ffffffff8173bc52 0000000000000000
[  222.328320]  ffff880229517d90 ffffffff8108ad95 ffff880223b6acd0 0000000000000000
[  222.328370]  0000000000000000 ffff880229517e08 ffffffff81741cf3 ffff880229517dc0
[  222.328421] Call Trace:
[  222.328443]  [<ffffffff8173bc52>] dump_stack+0x4e/0x7a
[  222.328475]  [<ffffffff8108ad95>] __might_sleep+0x175/0x200
[  222.328510]  [<ffffffff81741cf3>] mutex_lock_nested+0x33/0x400
[  222.328545]  [<ffffffff81179e68>] unmap_mapping_range+0x68/0x170
[  222.328582]  [<ffffffff81160a35>] truncate_pagecache+0x35/0x60
[  222.328617]  [<ffffffff81160a72>] truncate_setsize+0x12/0x20
[  222.328651]  [<ffffffff81210ab9>] aio_free_ring+0x99/0x160
[  222.328684]  [<ffffffff81213071>] SyS_io_setup+0xef1/0xf00
[  222.328717]  [<ffffffff8174eaa4>] tracesys+0xdd/0xe2

[  222.328769] ======================================================
[  222.328804] [ INFO: possible circular locking dependency detected ]
[  222.328838] 3.13.0-rc2+ #12 Not tainted
[  222.328862] -------------------------------------------------------
[  222.328896] trinity-child1/12794 is trying to acquire lock:
[  222.328928]  (&mapping->i_mmap_mutex){+.+...}, at: [<ffffffff81179e68>] unmap_mapping_range+0x68/0x170
[  222.328987] 
but task is already holding lock:
[  222.329020]  (&(&mapping->private_lock)->rlock){+.+...}, at: [<ffffffff81210a64>] aio_free_ring+0x44/0x160
[  222.329081] 
which lock already depends on the new lock.

[  222.329125] 
the existing dependency chain (in reverse order) is:
[  222.329166] 
-> #2 (&(&mapping->private_lock)->rlock){+.+...}:
[  222.329211]        [<ffffffff810af833>] lock_acquire+0x93/0x1c0
[  222.329248]        [<ffffffff817454f0>] _raw_spin_lock+0x40/0x80
[  222.329285]        [<ffffffff811f334d>] __set_page_dirty_buffers+0x2d/0xb0
[  222.331243]        [<ffffffff8115aada>] set_page_dirty+0x3a/0x60
[  222.334437]        [<ffffffff81179a7f>] unmap_single_vma+0x62f/0x830
[  222.337633]        [<ffffffff8117ad19>] unmap_vmas+0x49/0x90
[  222.340819]        [<ffffffff811804bd>] unmap_region+0x9d/0x110
[  222.343968]        [<ffffffff811829f6>] do_munmap+0x226/0x3b0
[  222.346689]        [<ffffffff81182bc4>] vm_munmap+0x44/0x60
[  222.349741]        [<ffffffff81183b42>] SyS_munmap+0x22/0x30
[  222.352758]        [<ffffffff8174eaa4>] tracesys+0xdd/0xe2
[  222.355735] 
-> #1 (&(ptlock_ptr(page))->rlock#2){+.+...}:
[  222.361611]        [<ffffffff810af833>] lock_acquire+0x93/0x1c0
[  222.364589]        [<ffffffff817454f0>] _raw_spin_lock+0x40/0x80
[  222.367200]        [<ffffffff81186338>] __page_check_address+0x98/0x160
[  222.370168]        [<ffffffff811864fe>] page_mkclean+0xfe/0x1c0
[  222.373120]        [<ffffffff8115ad60>] clear_page_dirty_for_io+0x60/0x100
[  222.376076]        [<ffffffff8124d207>] mpage_submit_page+0x47/0x80
[  222.379015]        [<ffffffff8124d350>] mpage_process_page_bufs+0x110/0x130
[  222.381955]        [<ffffffff8124d91b>] mpage_prepare_extent_to_map+0x22b/0x2f0
[  222.384895]        [<ffffffff8125318f>] ext4_writepages+0x4ef/0x1050
[  222.387839]        [<ffffffff8115cdf1>] do_writepages+0x21/0x50
[  222.390786]        [<ffffffff81150959>] __filemap_fdatawrite_range+0x59/0x60
[  222.393747]        [<ffffffff81150a5d>] filemap_write_and_wait_range+0x2d/0x70
[  222.396729]        [<ffffffff812498ca>] ext4_sync_file+0xba/0x4d0
[  222.399714]        [<ffffffff811f1691>] do_fsync+0x51/0x80
[  222.402317]        [<ffffffff811f1980>] SyS_fsync+0x10/0x20
[  222.405240]        [<ffffffff8174eaa4>] tracesys+0xdd/0xe2
[  222.407760] 
-> #0 (&mapping->i_mmap_mutex){+.+...}:
[  222.413349]        [<ffffffff810aed16>] __lock_acquire+0x1786/0x1af0
[  222.416127]        [<ffffffff810af833>] lock_acquire+0x93/0x1c0
[  222.418826]        [<ffffffff81741d37>] mutex_lock_nested+0x77/0x400
[  222.421456]        [<ffffffff81179e68>] unmap_mapping_range+0x68/0x170
[  222.424085]        [<ffffffff81160a35>] truncate_pagecache+0x35/0x60
[  222.426696]        [<ffffffff81160a72>] truncate_setsize+0x12/0x20
[  222.428955]        [<ffffffff81210ab9>] aio_free_ring+0x99/0x160
[  222.431509]        [<ffffffff81213071>] SyS_io_setup+0xef1/0xf00
[  222.434069]        [<ffffffff8174eaa4>] tracesys+0xdd/0xe2
[  222.436308] 
other info that might help us debug this:

[  222.443857] Chain exists of:
  &mapping->i_mmap_mutex --> &(ptlock_ptr(page))->rlock#2 --> &(&mapping->private_lock)->rlock

[  222.451618]  Possible unsafe locking scenario:

[  222.456831]        CPU0                    CPU1
[  222.459413]        ----                    ----
[  222.461958]   lock(&(&mapping->private_lock)->rlock);
[  222.464505]                                lock(&(ptlock_ptr(page))->rlock#2);
[  222.467094]                                lock(&(&mapping->private_lock)->rlock);
[  222.469625]   lock(&mapping->i_mmap_mutex);
[  222.472111] 
 *** DEADLOCK ***

[  222.478392] 1 lock held by trinity-child1/12794:
[  222.480744]  #0:  (&(&mapping->private_lock)->rlock){+.+...}, at: [<ffffffff81210a64>] aio_free_ring+0x44/0x160
[  222.483240] 
stack backtrace:
[  222.488119] CPU: 1 PID: 12794 Comm: trinity-child1 Not tainted 3.13.0-rc2+ #12 
[  222.493016]  ffffffff824cb110 ffff880229517c30 ffffffff8173bc52 ffffffff824a3f40
[  222.495690]  ffff880229517c70 ffffffff81737fed ffff880229517cc0 ffff8800a1e49d10
[  222.498379]  ffff8800a1e495d0 0000000000000001 0000000000000001 ffff8800a1e49d10
[  222.501073] Call Trace:
[  222.503394]  [<ffffffff8173bc52>] dump_stack+0x4e/0x7a
[  222.506080]  [<ffffffff81737fed>] print_circular_bug+0x200/0x20f
[  222.508781]  [<ffffffff810aed16>] __lock_acquire+0x1786/0x1af0
[  222.511485]  [<ffffffff810af833>] lock_acquire+0x93/0x1c0
[  222.514197]  [<ffffffff81179e68>] ? unmap_mapping_range+0x68/0x170
[  222.516594]  [<ffffffff81179e68>] ? unmap_mapping_range+0x68/0x170
[  222.519307]  [<ffffffff81741d37>] mutex_lock_nested+0x77/0x400
[  222.522028]  [<ffffffff81179e68>] ? unmap_mapping_range+0x68/0x170
[  222.524752]  [<ffffffff81179e68>] ? unmap_mapping_range+0x68/0x170
[  222.527445]  [<ffffffff81179e68>] unmap_mapping_range+0x68/0x170
[  222.530113]  [<ffffffff81160a35>] truncate_pagecache+0x35/0x60
[  222.532785]  [<ffffffff81160a72>] truncate_setsize+0x12/0x20
[  222.535439]  [<ffffffff81210ab9>] aio_free_ring+0x99/0x160
[  222.538089]  [<ffffffff81213071>] SyS_io_setup+0xef1/0xf00
[  222.540725]  [<ffffffff8174eaa4>] tracesys+0xdd/0xe2

