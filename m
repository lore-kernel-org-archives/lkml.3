Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760786Ab3ICUnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 16:43:11 -0400
Received: from peace.netnation.com ([204.174.223.2]:47595 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760604Ab3ICUnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 16:43:09 -0400
Date: Tue, 3 Sep 2013 13:43:07 -0700
From: Simon Kirby <sim@hostway.ca>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [3.10] Oopses in kmem_cache_allocate() via prepare_creds()
Message-ID: <20130903204307.GB22714@hostway.ca>
References: <20130706000949.GD16853@hostway.ca>
 <CAOJsxLGA+Aha8JcPsWyNd3BLQ6L0g7iznN0o2fG5yL5Xw0s8Lg@mail.gmail.com>
 <20130819201717.GA23608@hostway.ca>
 <0000014098447577-0d3e3f6b-f97b-4c73-946d-d70b697ce194-000000@email.amazonses.com>
 <CA+55aFxiYzxLDUnr+9BGQ+fsfmb1T8_zW4fOOC=SQ4rVzwbv4A@mail.gmail.com>
 <20130819212441.17880.16729@localhost.localdomain>
 <20130819233138.GE23608@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819233138.GE23608@hostway.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 04:31:38PM -0700, Simon Kirby wrote:

> On Mon, Aug 19, 2013 at 05:24:41PM -0400, Chris Mason wrote:
> 
> > Quoting Linus Torvalds (2013-08-19 17:16:36)
> > > On Mon, Aug 19, 2013 at 1:29 PM, Christoph Lameter <cl@gentwo.org> wrote:
> > > > On Mon, 19 Aug 2013, Simon Kirby wrote:
> > > >
> > > >>    [... ]  The
> > > >> alloc/free traces are always the same -- always alloc_pipe_info and
> > > >> free_pipe_info. This is seen on 3.10 and (now) 3.11-rc4:
> > > >>
> > > >> Object ffff880090f19e78: 6b 6b 6b 6b 6c 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkklkkkkkkkkkkk
> > > >
> > > > This looks like an increment after free in the second 32 bit value of the
> > > > structure. First 32 bit value's poison is unchanged.
> > > 
> > > Ugh. If that is "struct pipe_inode_info" and I read it right, that's
> > > the "wait_lock" spinlock that is part of the mutex.
> > > 
> > > Doing a "spin_lock()" could indeed cause an increment operation. But
> > > it still sounds like a very odd case. And even for some wild pointer
> > > I'd then expect the spin_unlock to also happen, and to then increment
> > > the next byte (or word) too. More importantly, for a mutex, I'd expect
> > > the *other* fields to be corrupted too (the "waiter" field etc). That
> > > is, unless we're still spinning waiting for the mutex, but with that
> > > value we shouldn't, as far as I can see.
> > > 
> > 
> > Simon, is this box doing btrfs send/receive?  If so, it's probably where
> > this pipe is coming from.
> 
> No, not for some time (a few kernel versions ago).
> 
> > Linus' CONFIG_DEBUG_PAGE_ALLOC suggestions are going to be the fastest
> > way to find it, I can give you a patch if it'll help.
> 
> I presume it's just:
> 
> diff --git a/fs/pipe.c b/fs/pipe.c
> index d2c45e1..30d5b8d 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -780,7 +780,7 @@ struct pipe_inode_info *alloc_pipe_info(void)
>  {
>  	struct pipe_inode_info *pipe;
>  
> -	pipe = kzalloc(sizeof(struct pipe_inode_info), GFP_KERNEL);
> +	pipe = (void *)get_zeroed_page(GFP_KERNEL);
>  	if (pipe) {
>  		pipe->bufs = kzalloc(sizeof(struct pipe_buffer) * PIPE_DEF_BUFFERS, GFP_KERNEL);
>  		if (pipe->bufs) {
> @@ -790,7 +790,7 @@ struct pipe_inode_info *alloc_pipe_info(void)
>  			mutex_init(&pipe->mutex);
>  			return pipe;
>  		}
> -		kfree(pipe);
> +		free_page((unsigned long)pipe);
>  	}
>  
>  	return NULL;
> @@ -808,7 +808,7 @@ void free_pipe_info(struct pipe_inode_info *pipe)
>  	if (pipe->tmp_page)
>  		__free_page(pipe->tmp_page);
>  	kfree(pipe->bufs);
> -	kfree(pipe);
> +	free_page((unsigned long)pipe);
>  }
>  
>  static struct vfsmount *pipe_mnt __read_mostly;
> 
> ...and CONFIG_DEBUG_PAGEALLOC enabled.
> 
> > It would be nice if you could trigger this on plain 3.11-rcX instead of
> > btrfs-next.
> 
> On 3.10 it was with some btrfs-next pulled in, but the 3.11-rc4 traces
> were from 3.11-rc4 with just some of our local patches:
> 
> > git diff --stat v3.11-rc4..master
>  firmware/Makefile                         |    4 +-
>  firmware/bnx2/bnx2-mips-06-6.2.3.fw.ihex  | 5804 ++++++++++++++++++++++
>  firmware/bnx2/bnx2-mips-09-6.2.1b.fw.ihex | 6496 +++++++++++++++++++++++++
>  kernel/acct.c                             |   21 +-
>  net/sunrpc/auth.c                         |    2 +-
>  net/sunrpc/clnt.c                         |   10 +
>  net/sunrpc/xprt.c                         |    8 +-
>  7 files changed, 12335 insertions(+), 10 deletions(-)
> 
> None of them look relevant, but I'm building vanilla -rc4 with
> CONFIG_DEBUG_PAGEALLOC and the patch above.

Stock 3.11-rc4 plus the above get_zeroed_page() for pipe allocations has
been running since August 19th on a few btrfs boxes. It has been quiet
until a few days ago, where we hit this:

BUG: soft lockup - CPU#5 stuck for 22s! [btrfs-cleaner:5871]
Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler aoe serio_raw bnx2 evdev
CPU: 5 PID: 5871 Comm: btrfs-cleaner Not tainted 3.11.0-rc4-hw+ #48
Hardware name: Dell Inc. PowerEdge 2950/0NH278, BIOS 2.7.0 10/30/2010
task: ffff8804261117d0 ti: ffff8804120d8000 task.ti: ffff8804120d8000
RIP: 0010:[<ffffffff817b4c8c>]  [<ffffffff817b4c8c>] _raw_spin_unlock_irqrestore+0xc/0x20
RSP: 0018:ffff8804120d98b8  EFLAGS: 00000296
RAX: ffff88042d800a80 RBX: ffffffff81130ffc RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000296 RDI: 0000000000000296
RBP: ffff8804120d98b8 R08: ffff8804120d9840 R09: 0000000000000000
R10: ffff8803c6f47400 R11: ffff88042d807180 R12: ffff8803c6f474a8
R13: 00000000000000cc R14: ffffffff8101f6da R15: ffff8804120d9828
FS:  0000000000000000(0000) GS:ffff88043fd40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffff600400 CR3: 00000001a9fc4000 CR4: 00000000000007e0
Stack:
 ffff8804120d9958 ffffffff817abea8 ffff8804120d98f8 ffffffff813733d0
 00000034ffffffff 0000000000000296 ffff88004edd99d0 0000000000000010
 ffff8804120d9918 ffffffff81319211 0000000000000004 ffff88004edd99d0
Call Trace:
 [<ffffffff817abea8>] __slab_free+0x45/0x2df
 [<ffffffff813733d0>] ? btrfs_set_lock_blocking_rw+0xa0/0xe0
 [<ffffffff81319211>] ? btrfs_set_path_blocking+0x31/0x70
 [<ffffffff8131f15b>] ? btrfs_search_old_slot+0x75b/0x980
 [<ffffffff8139899e>] ? ulist_free+0x1e/0x30
 [<ffffffff811336ed>] kfree+0xfd/0x130
 [<ffffffff8139899e>] ulist_free+0x1e/0x30
 [<ffffffff81396b96>] __resolve_indirect_refs+0x436/0x5b0
 [<ffffffff8139757c>] find_parent_nodes+0x47c/0x6c0
 [<ffffffff81397851>] btrfs_find_all_roots+0x91/0x100
 [<ffffffff8139b7e8>] btrfs_qgroup_account_ref+0x148/0x500
 [<ffffffff81328016>] btrfs_delayed_refs_qgroup_accounting+0xa6/0x100
 [<ffffffff8132f6f9>] btrfs_run_delayed_refs+0x49/0x5b0
 [<ffffffff81328460>] ? walk_down_proc+0x120/0x2d0
 [<ffffffff8135e359>] ? free_extent_buffer+0x59/0xb0
 [<ffffffff8132c741>] ? walk_up_tree+0xe1/0x1e0
 [<ffffffff8133f03a>] btrfs_should_end_transaction+0x4a/0x70
 [<ffffffff8132df2b>] btrfs_drop_snapshot+0x3db/0x6a0
 [<ffffffff8138e726>] ? btrfs_kill_all_delayed_nodes+0x56/0xf0
 [<ffffffff817b4bee>] ? _raw_spin_lock+0xe/0x30
 [<ffffffff81340b06>] btrfs_clean_one_deleted_snapshot+0xc6/0x130
 [<ffffffff81337ab0>] cleaner_kthread+0x120/0x180
 [<ffffffff81337990>] ? transaction_kthread+0x210/0x210
 [<ffffffff8107af5b>] kthread+0xbb/0xc0
 [<ffffffff81010000>] ? xen_smp_intr_init+0x100/0x220
 [<ffffffff8107aea0>] ? kthread_freezable_should_stop+0x60/0x60
 [<ffffffff817bcdbc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8107aea0>] ? kthread_freezable_should_stop+0x60/0x60
Code: 66 0f c1 07 0f b6 d4 38 c2 74 0d 0f 1f 40 00 f3 90 0f b6 07 38 d0 75 f7 5d c3 0f 1f 44 00 00 55 48 89 e5 80 07 01 48 89 f7 57 9d <0f> 1f 44 00 00 5d c3 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55

Perhaps something is still be wrong with the btrfs ulist stuff, even with
35f0399db6658f465b00893bdd13b992a0acfef0?

I was thinking of going back to the regular slab pipe allocations and
DEBUG_MUTEXES, but it may not be pipe-related at this point...

Simon-
