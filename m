Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab3FKFUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 01:20:20 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:48949 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535Ab3FKFUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 01:20:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYRAOWytlF5LHWc/2dsb2JhbABZgwm6DIUxBAF6F3SCIwEBBScTHCMQCAMOCgklDwUlAyETiAy6LRaOBIEdB4NgA5c/kUODISo
Date: Tue, 11 Jun 2013 15:20:12 +1000
From: Dave Chinner <david@fromorbit.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: axboe@kernel.dk, tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Immutable biovecs, dio rewrite
Message-ID: <20130611052012.GJ29376@dastard>
References: <1370744348-15407-1-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370744348-15407-1-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 08, 2013 at 07:18:42PM -0700, Kent Overstreet wrote:
> Immutable biovecs: Drivers no longer modify the biovec array directly
> (bv_len/bv_offset in particular) - we add a real iterator to struct bio
> that lets drivers partially complete a bio while only modifying the
> iterator. The iterator has the existing bi_sector, bi_size, bi_idx
> memembers, and also bi_bvec_done.
> 
> This gets us a couple things:
>  * Changing all the drivers to go through the iterator means that we can
>    submit a partially completed bio to generic_make_request() - this
>    previously worked on some drivers, but worked on others.
> 
>    This makes it much easier for upper layers to process bios
>    incrementally - not just stacking drivers, my dio rewrite relies
>    heavily on this strategy.
> 
>  * Previously, any code that might need to retry a bio somehow if it
>    errored (mainly stacking drivers) had to clone not just the bio, but
>    the entire biovec. The biovec can be up to BIO_MAX_PAGES, which works
>    out to 4k...
> 
>  * When cloning a bio, now we don't have to clone the biovec unless we
>    want to modify it. Bio splitting also becomes just a special case of
>    cloning a bio.
> 
> We also get to delete a lot of code. And this patch series barely
> scratches the surface - I've got more patches that delete another 1.5k
> lines of code, without trying all that hard.
> 
> I'd like to get as much of this into 3.11 as possible - I don't know if
> the dio rewrite is a realistic possibility (it currently breaks btrfs -
> we need to add a different hook for them) and it does need a lot of
> review and testing from the various driver maintainers. The dio rewrite
> does pass xfstests for me, though.

Please test with XFS and CONFIG_XFS_DEBUG=y - xfstests will stress
the dio subsystem a lot more when it is run on XFS. Indeed, xfstests
generic/013 assert fails almost immediately with:

[   58.859136] XFS (vda): Mounting Filesystem
[   58.881742] XFS (vda): Ending clean mount
[   58.989301] XFS: Assertion failed: bh_result->b_size >= (1 << inode->i_blkbits), file: fs/xfs/xfs_aops.c, line: 1209
[   58.992672] ------------[ cut here ]------------
[   58.994093] kernel BUG at fs/xfs/xfs_message.c:108!
[   58.995385] invalid opcode: 0000 [#1] SMP
[   58.996569] Modules linked in:
[   58.997427] CPU: 1 PID: 9529 Comm: fsstress Not tainted 3.10.0-rc4-next-20130510-dgc+ #85
[   58.999556] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   59.001143] task: ffff880079a34530 ti: ffff880079a0a000 task.ti: ffff880079a0a000
[   59.003130] RIP: 0010:[<ffffffff814655c2>]  [<ffffffff814655c2>] assfail+0x22/0x30
[   59.005263] RSP: 0018:ffff880079a0b998  EFLAGS: 00010292
[   59.006334] RAX: 0000000000000068 RBX: 0000000000054000 RCX: ffff88007fd0eb68
[   59.007676] RDX: 0000000000000000 RSI: ffff88007fd0d0d8 RDI: 0000000000000246
[   59.009076] RBP: ffff880079a0b998 R08: 000000000000000a R09: 00000000000001fa
[   59.010883] R10: 0000000000000000 R11: 00000000000001f9 R12: ffff880073730b50
[   59.012855] R13: ffff88007a91e800 R14: ffff880079a0baa0 R15: 0000000000000a00
[   59.014753] FS:  00007f784eb7b700(0000) GS:ffff88007fd00000(0000) knlGS:0000000000000000
[   59.016947] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   59.018174] CR2: 00007f5d4c40e1a0 CR3: 000000007b177000 CR4: 00000000000006e0
[   59.019509] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   59.020906] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   59.022252] Stack:
[   59.022648]  ffff880079a0ba48 ffffffff81450b2e ffff88007ba2d2c0 0000000000000001
[   59.024181]  ffff880000000000 ffffffff00000000 ffff880000000008 00010000ffff159d
[   59.025650]  0000000000000054 ffff880073730980 ffff880079a34530 0000000179a34530
[   59.027117] Call Trace:
[   59.027592]  [<ffffffff81450b2e>] __xfs_get_blocks+0x7e/0x5d0
[   59.028744]  [<ffffffff81451094>] xfs_get_blocks_direct+0x14/0x20
[   59.029914]  [<ffffffff811c157b>] get_blocks+0x9b/0x1b0
[   59.030903]  [<ffffffff8115da92>] ? get_user_pages+0x52/0x60
[   59.031968]  [<ffffffff811c1af7>] __blockdev_direct_IO+0x367/0x850
[   59.033191]  [<ffffffff81451080>] ? __xfs_get_blocks+0x5d0/0x5d0
[   59.034336]  [<ffffffff8144f3ed>] xfs_vm_direct_IO+0x18d/0x1b0
[   59.035436]  [<ffffffff81451080>] ? __xfs_get_blocks+0x5d0/0x5d0
[   59.036635]  [<ffffffff81144b42>] ? pagevec_lookup+0x22/0x30
[   59.037718]  [<ffffffff8113a6ef>] generic_file_aio_read+0x6bf/0x710
[   59.038899]  [<ffffffff814579a2>] xfs_file_aio_read+0x152/0x320
[   59.040089]  [<ffffffff81186910>] do_sync_read+0x80/0xb0
[   59.041100]  [<ffffffff811876d5>] vfs_read+0xa5/0x160
[   59.042098]  [<ffffffff81187912>] SyS_read+0x52/0xa0
[   59.043045]  [<ffffffff81c39e99>] system_call_fastpath+0x16/0x1b
[   59.044246] Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 f1 41 89 d0 48 89 e5 48 89 fa 48 c7 c6 48 f4 fb 81 31 ff 31 c0 e8 de fb ff ff <0f> 0b 66 66 66
[   59.049085] RIP  [<ffffffff814655c2>] assfail+0x22/0x30
[   59.050100]  RSP <ffff880079a0b998>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
