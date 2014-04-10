Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934520AbaDJACx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 20:02:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:51562 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933480AbaDJACv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 20:02:51 -0400
Message-ID: <1397088144.3671.155.camel@pasglop>
Subject: Re: [BUG] kernel BUG at /.../block/cfq-iosched.c:3145!
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jens Axboe <axboe@fb.com>
Cc: Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Brian J King <bjking1@us.ibm.com>
Date: Thu, 10 Apr 2014 10:02:24 +1000
In-Reply-To: <1397087273.3671.150.camel@pasglop>
References: <1397018647.3671.123.camel@pasglop> <53454CBC.9060905@fb.com>
	 <1397087273.3671.150.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-10 at 09:47 +1000, Benjamin Herrenschmidt wrote:

> > Nope, that's not a known issue. This must be related to the FIFO 
> > changes... How reproducible is this?
> 
> Dunno yet, haven't had a chance to dig. I'll try to grab that machine
> later today and reproduce &| bisect.

Second boot leads to a slightly different symptom (see below). I'll
try bisecting a bit later today if I get a chance.

=============================================================================
BUG blkdev_requests (Not tainted): Poison overwritten
-----------------------------------------------------------------------------

Disabling lock debugging due to kernel taint
INFO: 0xc000003ca627f790-0xc000003ca627f797. First byte 0xc0 instead of 0x6b
INFO: Allocated in .mempool_alloc_slab+0x1c/0x30 age=17 cpu=36 pid=3579
	.kmem_cache_alloc+0xc0/0x1ac
	.mempool_alloc_slab+0x1c/0x30
	.mempool_alloc+0x98/0x18c
	.get_request+0x248/0x490
	.blk_queue_bio+0x174/0x25c
	.generic_make_request+0xa8/0xec
	.submit_bio+0x134/0x14c
	.mpage_readpages+0x108/0x118
	.ext4_readpages+0x48/0x5c
	.__do_page_cache_readahead+0x1b0/0x298
	.ra_submit+0x28/0x38
	.filemap_fault+0x158/0x3e4
	.__do_fault+0x48/0xbc
	.do_read_fault.isra.65+0x2c/0xe4
	.handle_mm_fault+0x460/0xbb8
	.do_page_fault+0x498/0x7e0
INFO: Freed in .mempool_free_slab+0x1c/0x30 age=17 cpu=36 pid=0
	.kmem_cache_free+0x1d4/0x1fc
	.mempool_free_slab+0x1c/0x30
	.mempool_free+0xb0/0xbc
	.__blk_put_request+0xd0/0x104
	.blk_end_bidi_request+0x40/0x64
	.scsi_io_completion+0x198/0x5a4
	.scsi_finish_command+0xd0/0xdc
	.scsi_softirq_done+0x128/0x134
	.blk_done_softirq+0xa0/0xb8
	.__do_softirq+0x1b8/0x370
	.irq_exit+0x74/0xa4
	.__do_irq+0x90/0xa4
	.call_do_irq+0x14/0x24
	.do_IRQ+0x80/0xc0
	hardware_interrupt_common+0x138/0x180
	0xc000000001e46640
INFO: Slab 0xf00000000d445888 objects=92 used=92 fp=0x          (null) flags=0x13fff8000000080
INFO: Object 0xc000003ca627f788 @offset=63368 fp=0xc000003ca6270de8

Bytes b4 c000003ca627f778: 00 00 00 00 ff fe ef be 5a 5a 5a 5a 5a 5a 5a 5a  ........ZZZZZZZZ
Object c000003ca627f788: 6b 6b 6b 6b 6b 6b 6b 6b c0 00 00 3c a6 27 fa 50  kkkkkkkk...<.'.P
Object c000003ca627f798: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f7a8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f7b8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f7c8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f7d8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f7e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f7f8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f808: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f818: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f828: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f838: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f848: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f858: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f868: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f878: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f888: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f898: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f8a8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f8b8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f8c8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f8d8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f8e8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object c000003ca627f8f8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
Redzone c000003ca627f908: bb bb bb bb bb bb bb bb                          ........
Padding c000003ca627fa48: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
CPU: 60 PID: 3579 Comm: X Tainted: G    B        3.14.0-test #1
Call Trace:
[c000003ca331aaf0] [c00000000001405c] .show_stack+0x50/0x14c (unreliable)
[c000003ca331abc0] [c0000000008a3a94] .dump_stack+0x90/0xc0
[c000003ca331ac40] [c00000000014bbec] .print_trailer+0x17c/0x188
[c000003ca331acd0] [c00000000014bd08] .check_bytes_and_report+0xc0/0x114
[c000003ca331ad80] [c00000000014be44] .check_object+0xe8/0x240
[c000003ca331ae20] [c0000000008a2488] .alloc_debug_processing+0x184/0x19c
[c000003ca331aeb0] [c0000000008a2958] .__slab_alloc+0x4b8/0x540
[c000003ca331b020] [c00000000014de68] .kmem_cache_alloc+0xc0/0x1ac
[c000003ca331b0d0] [c000000000107f3c] .mempool_alloc_slab+0x1c/0x30
[c000003ca331b140] [c0000000001080d4] .mempool_alloc+0x98/0x18c
[c000003ca331b220] [c0000000003227c4] .get_request+0x248/0x490
[c000003ca331b340] [c000000000324a68] .blk_queue_bio+0x174/0x25c
[c000003ca331b3e0] [c000000000322280] .generic_make_request+0xa8/0xec
[c000003ca331b470] [c0000000003223f8] .submit_bio+0x134/0x14c
[c000003ca331b530] [c000000000186030] ._submit_bh+0x244/0x278
[c000003ca331b5c0] [c000000000186b14] .ll_rw_block+0xd4/0x100
[c000003ca331b670] [c000000000188d80] .__breadahead+0x2c/0x4c
[c000003ca331b6f0] [c00000000021d18c] .__ext4_get_inode_loc+0x390/0x444
[c000003ca331b7c0] [c00000000021f7cc] .ext4_iget+0x4c/0x97c
[c000003ca331b8c0] [c000000000229558] .ext4_lookup+0xc4/0x15c
[c000003ca331b960] [c00000000016007c] .lookup_real+0x4c/0x74
[c000003ca331b9e0] [c000000000165bdc] .do_last+0x58c/0xc54
[c000003ca331bb10] [c00000000016650c] .path_openat+0x268/0x6a0
[c000003ca331bc30] [c000000000166cc0] .do_filp_open+0x34/0x80
[c000003ca331bd70] [c000000000155a10] .do_sys_open+0x1a4/0x250
[c000003ca331be30] [c00000000000a024] syscall_exit+0x0/0x98
FIX blkdev_requests: Restoring 0xc000003ca627f790-0xc000003ca627f797=0x6b

FIX blkdev_requests: Marking all objects used
------------[ cut here ]------------
kernel BUG at /home/benh/linux-powerpc-test/block/elevator.c:262!
cpu 0x34: Vector: 700 (Program Check) at [c000001febbd32c0]
    pc: c00000000031ee40: .elv_rqhash_add+0x10/0x8c
    lr: c0000000003202c8: .__elv_add_request+0x264/0x27c
    sp: c000001febbd3540
   msr: 9000000000029032
  current = 0xc000003ca620c320
  paca    = 0xc00000000ffed000	 softe: 0	 irq_happened: 0x01
    pid   = 3565, comm = in:imjournal
kernel BUG at /home/benh/linux-powerpc-test/block/elevator.c:262!
enter ? for help
[link register   ] c0000000003202c8 .__elv_add_request+0x264/0x27c
[c000001febbd3540] c0000000003201a0 .__elv_add_request+0x13c/0x27c (unreliable)
[c000001febbd35e0] c000000000324858 .blk_flush_plug_list+0x1f4/0x254
[c000001febbd36a0] c0000000003248d0 .blk_finish_plug+0x18/0x3c
[c000001febbd3720] c000000000111a84 .__do_page_cache_readahead+0x268/0x298
[c000001febbd3870] c000000000111d24 .ra_submit+0x28/0x38
[c000001febbd38e0] c000000000106f54 .filemap_fault+0x158/0x3e4
[c000001febbd39b0] c000000000126cfc .__do_fault+0x48/0xbc
[c000001febbd3a60] c0000000001272b0 .do_read_fault.isra.65+0x2c/0xe4
[c000001febbd3b20] c00000000012a718 .handle_mm_fault+0x460/0xbb8
[c000001febbd3c00] c00000000002ff54 .do_page_fault+0x498/0x7e0
[c000001febbd3e30] c0000000000094e8 handle_page_fault+0x10/0x30
--- Exception: 301 (Data Access) at 00003fff9a40d2d4
SP (3fff9585df30) is in userspace
34:mon> 


