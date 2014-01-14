Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaANWK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 17:10:57 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:47489 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbaANWKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 17:10:54 -0500
Date: Tue, 14 Jan 2014 23:10:40 +0100
From: Guillaume Morin <guillaume@morinfr.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: BUG: Bad page state in process with linux 3.4.76
Message-ID: <20140114221040.GA27903@bender.morinfr.org>
Mail-Followup-To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20140114203434.GA22994@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114203434.GA22994@bender.morinfr.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

I am going to do more testing but it seems that reverting this patch
from 3.4.69 fixes the BUG
commit b07ef016454ff46f98e633b5a6247ca7e343fb67
Author: Khalid Aziz <khalid.aziz@oracle.com>

I also verified that I cannot reproduce this problem with 3.13-rc8

Guillaume.

On 14 Jan 21:34, Guillaume Morin wrote:
>
> Hi,
> 
> I wrote this simple program (attached) to play around with kernel AIO.
> It simply does kernel AIO with O_DIRECT on a small temp file stored on
> an ext4 filesystem.
> 
> When I run it with "HUGETLB_MORECORE=yes LD_PRELOAD=libhugetlbfs.so", it
> triggers the kernel bug on exit every time.
> 
> Removing HUGETLB_MORECORE from the command line fixes the problem.  Note
> that my kernel does not use THP, it is NOT compiled with
> CONFIG_TRANSPARENT_HUGEPAGE.
> 
> I've tried it only with this 3.4.76 but I've been able to reproduce it without
> any issue on multiple machines running the same kernel.
> 
> BUG: Bad page state in process aio_test  pfn:1b7a01
> page:ffffea0006de8040 count:0 mapcount:1 mapping:          (null) index:0x0
> page flags: 0x20000000008000(tail)
> Modules linked in: nfsd exportfs nfs nfs_acl auth_rpcgss fscache lockd sunrpc
> rdma_ucm rdma_cm ib_addr iw_cm ib_uverbs ib_cm ib_sa ib_mad ib_core ipmi_si
> ipmi_devintf coretemp pcspkr microcode serio_raw i2c_i801 ioatdma i2c_core dca
> dm_mod sg sr_mod cdrom crc32c_intel ahci libahci [last unloaded: scsi_wait_scan]
> Pid: 4441, comm: aio_test Not tainted 3.4.76bug #1
> Call Trace:
> [<ffffffff810f3300>] ? is_free_buddy_page+0xa0/0xd0
> [<ffffffff814c0791>] bad_page+0xe6/0xfc
> [<ffffffff810f3dbc>] free_pages_prepare+0xfc/0x110
> [<ffffffff810f3dff>] __free_pages_ok+0x2f/0xd0
> [<ffffffff810f4080>] __free_pages+0x20/0x40
> [<ffffffff81124737>] update_and_free_page+0x77/0x80
> [<ffffffff8112633e>] free_huge_page+0x16e/0x180
> [<ffffffff810f8030>] __put_compound_page+0x20/0x50
> [<ffffffff810f8108>] put_compound_page+0x78/0x140
> [<ffffffff810f8546>] put_page+0x36/0x40
> [<ffffffff81126ede>] __unmap_hugepage_range+0x1ce/0x230
> [<ffffffff81127331>] unmap_hugepage_range+0x51/0x90
> [<ffffffff8110e880>] unmap_single_vma+0x730/0x740
> [<ffffffff8110f05f>] unmap_vmas+0x5f/0x80
> [<ffffffff8111672c>] exit_mmap+0xbc/0x130
> [<ffffffff8112e170>] ? kmem_cache_free+0x20/0xe0
> [<ffffffff81035155>] mmput+0x35/0xf0
> [<ffffffff8103a58d>] exit_mm+0xfd/0x120
> [<ffffffff8103bb6c>] do_exit+0x16c/0x8b0
> [<ffffffff811540c4>] ? mntput+0x24/0x40
> [<ffffffff81138962>] ? fput+0x192/0x250
> [<ffffffff8103c5ff>] do_group_exit+0x3f/0xa0
> [<ffffffff8103c677>] sys_exit_group+0x17/0x20
> [<ffffffff814d03d2>] system_call_fastpath+0x16/0x1b
> 


-- 
Guillaume Morin <guillaume@morinfr.org>
