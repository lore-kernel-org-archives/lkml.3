Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbbAOSST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 13:18:19 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:34658 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbbAOSSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 13:18:17 -0500
Date: Thu, 15 Jan 2015 10:18:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2 2/7] block: rewrite __bio_copy_iov()
Message-ID: <20150115181817.GA32041@infradead.org>
References: <cover.1421052656.git.dongsu.park@profitbricks.com>
 <0bdbbd2ef9d449be2d00e01ca7dc7f101b6cfb88.1421052656.git.dongsu.park@profitbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bdbbd2ef9d449be2d00e01ca7dc7f101b6cfb88.1421052656.git.dongsu.park@profitbricks.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 12:43:59PM +0100, Dongsu Park wrote:
> Rewrite __bio_copy_iov() so that it can call either _read() or _write()
> variant, which is determined by direction to_iov, given as either READ
> or WRITE. Moreover, make __bio_copy_iov() take its parameter iov_iter
> by value, to avoid awkward situations like ref-/dereferencing pointer
> and value repeatedly.
> 
> This commit should contain only literal replacements, without
> functional changes.

This breaks booting a simple KVM VM for me:

[    2.692732] general protection fault: 0000 [#1] SMP 
[    2.696041] Modules linked in:
[    2.696041] CPU: 2 PID: 1819 Comm: cdrom_id Not tainted 3.19.0-rc4+ #47
[    2.696041] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    2.696041] task: ffff88007b318b90 ti: ffff88007a0b0000 task.ti: ffff88007a0b0000
[    2.696041] RIP: 0010:[<ffffffff81742460>]  [<ffffffff81742460>] bio_uncopy_user+0x60/0x160
[    2.701775] RSP: 0018:ffff88007a0b3a88  EFLAGS: 00010246
[    2.701775] RAX: 0000000000000024 RBX: 20202020554d4551 RCX: 0000000000000000
[    2.701775] RDX: 0000000000000024 RSI: ffff88007a6c7024 RDI: ffff88007cc9e304
[    2.705548] RBP: ffff88007a0b3b08 R08: 0000000000000024 R09: 0000000000000000
[    2.705548] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[    2.705548] R13: ffff88007cc9e280 R14: ffff880079cdd200 R15: 0000000000000000
[    2.705548] FS:  00007fdeb0282700(0000) GS:ffff88007fd00000(0000) knlGS:0000000000000000
[    2.705548] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.705548] CR2: 0000000001ebd008 CR3: 000000007aca6000 CR4: 00000000000006e0
[    2.705548] Stack:
[    2.715017]  0000000000000001 0000000000000000 0000000000000024 ffff88007a0b3a70
[    2.716562]  0000000000000001 0000000000000001 0000000000000024 0000000000000000
[    2.717630]  ffff88007a0b3a70 0000000000000001 ffff88007a0b3b18 ffff88007cc9e280
[    2.717630] Call Trace:
[    2.717630]  [<ffffffff8174fbb4>] __blk_rq_unmap_user+0x14/0x40
[    2.717630]  [<ffffffff8174fc11>] blk_rq_unmap_user+0x31/0x60
[    2.717630]  [<ffffffff8175cb33>] sg_io+0x2c3/0x4a0
[    2.724739]  [<ffffffff8175d1d5>] scsi_cmd_ioctl+0x425/0x4a0
[    2.724739]  [<ffffffff8175d29a>] scsi_cmd_blk_ioctl+0x4a/0x60
[    2.726432]  [<ffffffff81b4ae1b>] cdrom_ioctl+0x3b/0xc10
[    2.726432]  [<ffffffff810fdecd>] ? trace_hardirqs_on+0xd/0x10
[    2.726432]  [<ffffffff81a50638>] ? sr_block_ioctl+0x48/0xd0
[    2.726432]  [<ffffffff810fddfd>] ? trace_hardirqs_on_caller+0x10d/0x1d0
[    2.726432]  [<ffffffff810fdecd>] ? trace_hardirqs_on+0xd/0x10
[    2.726432]  [<ffffffff81a50674>] sr_block_ioctl+0x84/0xd0
[    2.726432]  [<ffffffff81759782>] blkdev_ioctl+0x232/0x7f0
[    2.726432]  [<ffffffff811fdb6c>] block_ioctl+0x3c/0x40
[    2.726432]  [<ffffffff811d8d93>] do_vfs_ioctl+0x83/0x5b0
[    2.726432]  [<ffffffff811d6021>] ? final_putname+0x21/0x50
[    2.726432]  [<ffffffff81e04095>] ? sysret_check+0x22/0x5d
[    2.726432]  [<ffffffff811d9307>] SyS_ioctl+0x47/0x90
[    2.726432]  [<ffffffff81e04069>] system_call_fastpath+0x12/0x17
[    2.726432] Code: 48 83 b8 48 03 00 00 00 74 06 f6 47 18 01 74 63 41 8b 1e 85 db 74 30 66 41 83 7d 60 00 49 8b 5d 68 74 24 45 31 e4 0f 1f 44 00 00 <48> 8b 3b 31 f6 41 83 c4 01 48 83 c3 10 e8 7e d4 a3 ff 41 0f b7 
[    2.726432] RIP  [<ffffffff81742460>] bio_uncopy_user+0x60/0x160
[    2.750102]  RSP <ffff88007a0b3a88>
[    2.751775] ---[ end trace 577bd821e65932ad ]---



(gdb) l *(bio_uncopy_user+0x60/0x160)
0xffffffff81742400 is in bio_uncopy_user (../block/bio.c:1137).
1132	 *
1133	 *	Free pages allocated from bio_copy_user() and write back
data
1134	 *	to user space in case of a read.
1135	 */
1136	int bio_uncopy_user(struct bio *bio)
1137	{
1138		struct bio_map_data *bmd = bio->bi_private;
1139		struct bio_vec *bvec;
1140		int ret = 0, i;
1141	

