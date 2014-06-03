Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934040AbaFCXeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 19:34:00 -0400
Received: from imap.thunk.org ([74.207.234.97]:49026 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbaFCXd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 19:33:58 -0400
Date: Tue, 3 Jun 2014 19:33:56 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        axboe@kernel.dk
Subject: Scheduling while atomic regression in Linus's next branch
Message-ID: <20140603233356.GA25980@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	axboe@kernel.dk
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using 3.15.0-rc8-04539-gc84a1e3, mke2fs failed while trying to fsync
to a block device (probably /dev/vdc).

I haven't tried to bisect this yet, but this seems pretty blatent.
Is this a known bug?

Thanks,

  	  	   	       	    - Ted

[   11.563804] BUG: scheduling while atomic: mkfs.ext4/2975/0x00000002
[   11.564832] no locks held by mkfs.ext4/2975.
[   11.565320] Modules linked in:
[   11.565623] CPU: 0 PID: 2975 Comm: mkfs.ext4 Not tainted 3.15.0-rc8-04539-gc84a1e3 #200
[   11.566444] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   11.567382]  00000000 00000000 f3e93bb0 c1056a06 f4152710 f3e93bbc c104fa37 f3e93ec8
[   11.568452]  f3e93c34 c105e229 c0235c8b 00000000 000000ec f3e92000 c1869d00 f3e93bf4
[   11.569501]  00000007 f4152710 c02682ab f4580200 f3e93bfc c023c177 f4580200 f3e93c10
[   11.570475] Call Trace:
[   11.570696]  [<c1056a06>] dump_stack+0xaa/0xec
[   11.571074]  [<c104fa37>] __schedule_bug+0xd0/0xfd
[   11.571478]  [<c105e229>] __schedule+0xb1/0xb62
[   11.571869]  [<c0235c8b>] ? lock_release_holdtime+0xc0/0x10f
[   11.572440]  [<c02682ab>] ? read_seqcount_begin.constprop.6+0xe7/0x154
[   11.573106]  [<c023c177>] ? trace_hardirqs_on_caller+0x2d2/0x360
[   11.573799]  [<c0268955>] ? timekeeping_get_ns.constprop.10+0x1f/0x80
[   11.574470]  [<c0268cc5>] ? ktime_get_ts+0x73/0x112
[   11.574984]  [<c105ef19>] schedule+0xf5/0x106
[   11.575427]  [<c105efce>] io_schedule+0xa4/0xe5
[   11.575928]  [<c0837812>] bt_get+0x133/0x174
[   11.576300]  [<c022bf46>] ? bit_waitqueue+0x58/0x58
[   11.576762]  [<c0837bda>] blk_mq_get_tag+0x34/0x116
[   11.577206]  [<c0832e4c>] __blk_mq_alloc_request+0x38/0x208
[   11.577728]  [<c08345d9>] blk_mq_map_request+0x2eb/0x312
[   11.578354]  [<c021d0d2>] ? sched_clock_cpu+0x1bf/0x1f2
[   11.578922]  [<c0835096>] blk_sq_make_request+0x150/0x302
[   11.579379]  [<c08237e6>] generic_make_request+0xe6/0x151
[   11.579824]  [<c0823a00>] submit_bio+0x1af/0x1c5
[   11.580268]  [<c023c177>] ? trace_hardirqs_on_caller+0x2d2/0x360
[   11.580781]  [<c03b57f9>] ? i_size_read+0x10c/0x18f
[   11.581189]  [<c03b5b90>] _submit_bh+0x314/0x360
[   11.581580]  [<c03b5bf9>] submit_bh+0x1d/0x2d
[   11.581948]  [<c03b9a78>] __block_write_full_page+0x3a3/0x5fc
[   11.582440]  [<c03bc3ad>] ? I_BDEV+0x18/0x18
[   11.582802]  [<c03b9d30>] block_write_full_page_endio+0x5f/0x120
[   11.583303]  [<c03bbc48>] ? block_read_full_page+0x39d/0x39d
[   11.583819]  [<c03bc3ad>] ? I_BDEV+0x18/0x18
[   11.584182]  [<c03b9e11>] block_write_full_page+0x20/0x30
[   11.584633]  [<c03bbc48>] ? block_read_full_page+0x39d/0x39d
[   11.585098]  [<c03bd92a>] blkdev_writepage+0x22/0x32
[   11.585514]  [<c031425b>] __writepage+0x21/0x85
[   11.585886]  [<c0315577>] write_cache_pages+0x3ac/0x53f
[   11.586314]  [<c031423a>] ? set_page_dirty+0xd1/0xd1
[   11.586775]  [<c016f05f>] ? native_sched_clock+0x84/0x98
[   11.587221]  [<c031576b>] generic_writepages+0x61/0x91
[   11.587645]  [<c03174ba>] do_writepages+0x3f/0x75
[   11.588041]  [<c0308fc1>] __filemap_fdatawrite_range+0x76/0x8c
[   11.588527]  [<c0309013>] filemap_write_and_wait_range+0x3c/0xca
[   11.589022]  [<c03bdbe7>] ? init_once+0xb2/0xb2
[   11.589393]  [<c03bdc11>] blkdev_fsync+0x2a/0x86
[   11.589778]  [<c03b1ee6>] vfs_fsync_range+0x44/0x5c
[   11.590234]  [<c03b1f25>] vfs_fsync+0x27/0x37
[   11.590604]  [<c03b1f8b>] do_fsync+0x56/0x96
[   11.590961]  [<c03b254f>] SyS_fsync+0x20/0x3e
[   11.591324]  [<c1067352>] syscall_call+0x7/0xb

