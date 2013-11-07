Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3KGTUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:20:33 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:40263 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3KGTUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:20:25 -0500
Date: Thu, 7 Nov 2013 11:20:51 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Olof Johansson <olof@lixom.net>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zach Brown <zab@zabbo.net>
Subject: Re: linux-next: manual merge of the block tree with the tree
Message-ID: <20131107192050.GB17641@moria.home.lan>
References: <20131101142026.10390b6e3f70de348770c137@canb.auug.org.au>
 <5273C473.5070803@kernel.dk>
 <20131102072252.88d2380fa392705b912dbfad@canb.auug.org.au>
 <52740EB1.2070901@kernel.dk>
 <527411DD.7050008@oracle.com>
 <527414DE.9090704@kernel.dk>
 <52756583.2030808@oracle.com>
 <CAOesGMgRFkMVteUyKKsEc=-tLSLqCAV6VZUDCMF6-5iW4Y-JOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMgRFkMVteUyKKsEc=-tLSLqCAV6VZUDCMF6-5iW4Y-JOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 11:17:22AM -0800, Olof Johansson wrote:
> On Sat, Nov 2, 2013 at 1:50 PM, Dave Kleikamp <dave.kleikamp@oracle.com> wrote:
> > On 11/01/2013 03:53 PM, Jens Axboe wrote:
> >> On 11/01/2013 02:41 PM, Dave Kleikamp wrote:
> >>> On 11/01/2013 03:27 PM, Jens Axboe wrote:
> >>>> On 11/01/2013 02:22 PM, Stephen Rothwell wrote:
> >>>>> Hi Jens,
> >>>>>
> >>>>> On Fri, 01 Nov 2013 09:10:43 -0600 Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>>
> >>>>>> On 10/31/2013 09:20 PM, Stephen Rothwell wrote:
> >>>>>>>
> >>>>>>> Today's linux-next merge of the block tree got a conflict in
> >>>>>>> drivers/block/loop.c between commit 2486740b52fd ("loop: use aio to
> >>>>>>> perform io on the underlying file") from the aio-direct tree and commit
> >>>>>>> ed2d2f9a8265 ("block: Abstract out bvec iterator") from the block tree.
> >>>>>>>
> >>>>>>> I fixed it up (I think - see below - I have also attached the final
> >>>>>>> resulting file) and can carry the fix as necessary (no action is
> >>>>>>> required).
> >>>>>>>
> >>>>>>
> >>>>>> What tree is this from? It'd be a lot more convenient to fold that loop
> >>>>>> patch into my tree, especially since the block tree in linux-next failed
> >>>>>> after this merge.
> >>>>>
> >>>>> I can only agree with you.  It is from the aio-direct tree (probably
> >>>>> misnamed by me) (git://github.com/kleikamp/linux-shaggy.git#for-next) run
> >>>>> by Dave Kleikamp.
> >>>>
> >>>> Dave, input requested.
> >>>>
> >>>> In any case, I would suggest dropping the aio-direct tree instead of the
> >>>> entire block tree for coverage purposes, if merge or build failures
> >>>> happen because of it.
> >>>
> >>> I've had these patches in linux-next since August, and I'd really like
> >>> to push them in the 3.13 merge window.
> >>>
> >>> Are there other problems besides this merge issue? I'll take a closer
> >>> look at Stephen's merge patch and see if I find any other issues, but I
> >>> really don't want to pull these patches out of linux-next now.
> >>
> >> I'm not saying that the patches should be dropped or not go into 3.13.
> >> What I'm saying is that if the choice is between having the bio and
> >> blk-mq stuff in linux-next or an addon to the loop driver, the decision
> >> should be quite clear.
> >>
> >> So we've three immediate options:
> >>
> >> 1) You base it on top of the block tree
> >> 2) I carry the loop updates
> >> 3) You hand Stephen a merge patch for the resulting merge of the two
> >
> > Attached is a merge patch and the merged loop.c. I'm having problems
> > with the loop driver with both the block and my tree. I'll continue to
> > look at that, but everything should build cleanly with this.
> 
> Hijacking(?) this thread since it seems relevant:
> 
> I noticed the following panic on a chromebox with last night's next.
> 20131106 shows it as well. I didn't go back further to see. 3.12 runs
> fine.
> 
> I bisected it down, and unfortunately it points at Stephen's merge commit:
> 
> commit 3caa8f38e7eeb56c7d48b0d5c323ffbf4939635d
> Merge: 447b374 bb6f7be
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Thu Nov 7 14:07:20 2013 +1100
> 
>     Merge remote-tracking branch 'aio-direct/for-next'
> 
>     Conflicts:
>         drivers/block/loop.c
>         fs/nfs/direct.c
>         fs/nfs/file.c
>         include/linux/blk_types.h
> 
> 
> ... but the branch alone runs fine.
> 
> Context to the failure: Userspace is already up and running. ChromeOS
> will do ecryptfs and loopback mounts, etc, which is likely where this
> is hitting given the process running. It definitely happens during
> early userspace setup.

That looks like the bi_remaining BUG_ON() in bio_endio(), probably
related to the loopback driver. I'll start looking at the code soon as I
get into the office, this one should be easy to track down.

> 
> Seems like we might be in for a bumpy ride in 3.13 w.r.t. block if the
> breakage we've found this week in -next is any indication.
> 
> This seems to be reliably reproducing for me so I can help collect
> data if needed, Dave/Jens.
> 
> [    3.373979] EXT4-fs (sda1): mounted filesystem with ordered data
> mode. Opts: commit=600
> [    3.385719] EXT4-fs (sda8): mounted filesystem with ordered data
> mode. Opts: commit=600
> [    3.475540] bio: create slab <bio-1> at 1
> [    3.483577] EXT4-fs (dm-0): mounted filesystem with ordered data
> mode. Opts: discard,commit=600
> [    3.556890] EXT4-fs (sda1): re-mounted. Opts: commit=600,data=ordered
> [    3.636658] ------------[ cut here ]------------
> [    3.641345] kernel BUG at
> /mnt/host/source/src/third_party/kernel-next/fs/bio.c:1725!
> [    3.649266] invalid opcode: 0000 [#1] SMP
> [    3.653473] Modules linked in:
> [    3.656610] CPU: 0 PID: 107 Comm: loop0 Tainted: G        W
> 3.12.0-next-20131107 #6
> [    3.664645] Hardware name: SAMSUNG Stumpy, BIOS
> Google_Stumpy.2183.0.2012_05_01_1303 05/01/2012
> [    3.673463] task: ffff88010001e250 ti: ffff880074c7e000 task.ti:
> ffff880074c7e000
> [    3.681023] RIP: 0010:[<ffffffff8111229d>]  [<ffffffff8111229d>]
> bio_endio+0x13/0x59
> [    3.688887] RSP: 0018:ffff880074c7fc50  EFLAGS: 00010246
> [    3.694272] RAX: 0000000000000000 RBX: ffff880074cb6120 RCX: 0000000000000000
> [    3.701496] RDX: 00000000fffffffb RSI: fffffffffffffffb RDI: ffff880074c4b000
> [    3.708728] RBP: ffff880074c7fc58 R08: 00000000002df000 R09: 0000000000000200
> [    3.715968] R10: 0000000000000000 R11: ffff880074cb6120 R12: ffffffffffffffff
> [    3.723198] R13: ffffffffffffffea R14: 0000000000010000 R15: 000000000000001f
> [    3.730439] FS:  0000000000000000(0000) GS:ffff880100200000(0000)
> knlGS:0000000000000000
> [    3.738590] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    3.744383] CR2: 00007fd88c159080 CR3: 000000000180c000 CR4: 00000000000407f0
> [    3.751605] Stack:
> [    3.753657]  ffffffff813369b4 ffff880074c7fc98 ffffffff8111f64f
> 00000000002df000
> [    3.761280]  ffff880074cb6120 ffff880074c19000 ffff880074cb6120
> 0000000000010000
> [    3.768848]  000000000000001f ffff880074c7fd08 ffffffff8111fb00
> ffff880075e9a200
> [    3.776419] Call Trace:
> [    3.778900]  [<ffffffff813369b4>] ? lo_rw_aio_complete+0x23/0x25
> [    3.785038]  [<ffffffff8111f64f>] aio_complete+0x4a/0x1f7
> [    3.790535]  [<ffffffff8111fb00>] aio_run_iocb.isra.13+0x304/0x329
> [    3.796781]  [<ffffffff8111f041>] ? kzalloc+0xf/0x11
> [    3.801837]  [<ffffffff8111fb53>] aio_kernel_submit+0x2e/0x45
> [    3.807658]  [<ffffffff81337349>] lo_rw_aio+0x1aa/0x1cf
> [    3.812940]  [<ffffffff813378d7>] loop_thread+0x2cf/0x4e7
> [    3.818408]  [<ffffffff8104eca6>] ? bit_waitqueue+0x7a/0x7a
> [    3.824009]  [<ffffffff81337608>] ? loop_attr_do_show_autoclear+0x1a/0x1a
> [    3.830901]  [<ffffffff8104e867>] kthread+0xea/0xf2
> [    3.835857]  [<ffffffff8104e77d>] ? flush_kthread_worker+0xba/0xba
> [    3.842085]  [<ffffffff814cb8ac>] ret_from_fork+0x7c/0xb0
> [    3.847564]  [<ffffffff8104e77d>] ? flush_kthread_worker+0xba/0xba
> [    3.853815] Code: 83 c3 10 41 0f b7 45 58 41 39 c4 7c b7 31 c0 5b
> 41 5c 41 5d 41 5e 5d c3 66 66 66 66 90 ba fb ff ff ff eb 37 8b 47 44
> 85 c0 7f 02 <0f> 0b 85 f6 74 07 f0 80 67 10 fe eb 09 48 8b 47 10 a8 01
> 0f 44
> [    3.874480] RIP  [<ffffffff8111229d>] bio_endio+0x13/0x59
> [    3.880004]  RSP <ffff880074c7fc50>
> [    3.883602] ---[ end trace ead15c309b799920 ]---
> [    3.888283] Kernel panic - not syncing: Fatal exception
> [    3.893581] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation
> range: 0xffffffff80000000-0xffffffff9fffffff)
