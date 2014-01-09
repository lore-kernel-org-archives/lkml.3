Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaAILon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:44:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaAILoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:44:39 -0500
Subject: Curious lockdep report
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 09 Jan 2014 11:43:59 +0000
Message-ID: <1389267839.2717.7.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to track down the cause of the lockdep report which I've
included below. It is a bit odd since it doesn't say which lock it
refers to, although my suspicions are that it is the mapping's
tree_lock. The other thing I know is that it goes away if I revert this
patch:

https://git.kernel.org/cgit/linux/kernel/git/steve/gfs2-3.0-nmw.git/commit/?id=70d4ee94b370c5ef54d0870600f16bd92d18013c

However, it is not immediately obvious why, if the lockdep code is
certain that there are no errors in the code, it needs to warn about
missing annotation, nor is it clear what that annotation should be.

The reproducer is simple - just mount a gfs2 filesystem with the latest
gfs2 -nmw tree and with lockdep turned on (can be local, doesn't need to
be clustered) and do mkdir.

Any suggestions as to whats going wrong gratefully received :-)

Steve.


[  167.059199] DLM installed
[  167.112127] GFS2 installed
[  167.122666] GFS2: fsid=unity:myfs: Trying to join cluster "lock_nolock", "unity:myfs"
[  167.122669] GFS2: fsid=unity:myfs: Now mounting FS...
[  167.191458] GFS2: fsid=unity:myfs.0: jid=0, already locked for use
[  167.191462] GFS2: fsid=unity:myfs.0: jid=0: Looking at journal...
[  167.583653] GFS2: fsid=unity:myfs.0: jid=0: Done
[  167.583751] GFS2: fsid=unity:myfs.0: first mount done, others may mount
[  176.634734] INFO: trying to register non-static key.
[  176.634738] the code is fine but needs lockdep annotation.
[  176.634741] turning off the locking correctness validator.
[  176.634746] CPU: 1 PID: 1151 Comm: mkdir Not tainted 3.13.0-rc6+ #385
[  176.634747] Hardware name: Dell Inc. PowerEdge R710/0N047H, BIOS 2.1.15 09/02/2010
[  176.634749]  ffff8801a74e2c78 ffff88019ccbb8c8 ffffffff81776984 0000000000000002
[  176.634756]  ffff88019ccbb988 ffffffff810e1b74 ffff8800cf1b69c8 ffff8800cf1b6210
[  176.634760]  ffff88019ccbb9a8 ffffffff810e042a ffffffff81a6a689 ffff8800cf1b6210
[  176.634765] Call Trace:
[  176.634774]  [<ffffffff81776984>] dump_stack+0x4e/0x7a
[  176.634780]  [<ffffffff810e1b74>] __lock_acquire+0x1a54/0x1ee0
[  176.634783]  [<ffffffff810e042a>] ? __lock_acquire+0x30a/0x1ee0
[  176.634787]  [<ffffffff8104de74>] ? native_sched_clock+0x24/0x80
[  176.634791]  [<ffffffff810c453d>] ? get_parent_ip+0xd/0x50
[  176.634795]  [<ffffffff810e2881>] lock_acquire+0x91/0x120
[  176.634800]  [<ffffffff811604fa>] ? add_to_page_cache_locked+0x7a/0x180
[  176.634804]  [<ffffffff8177e396>] _raw_spin_lock_irq+0x46/0x80
[  176.634807]  [<ffffffff811604fa>] ? add_to_page_cache_locked+0x7a/0x180
[  176.634810]  [<ffffffff811604fa>] add_to_page_cache_locked+0x7a/0x180
[  176.634814]  [<ffffffff8116061a>] add_to_page_cache_lru+0x1a/0x40
[  176.634817]  [<ffffffff8116069a>] find_or_create_page+0x5a/0x90
[  176.634831]  [<ffffffffa03c68ec>] gfs2_getbuf+0x7c/0x170 [gfs2]
[  176.634834]  [<ffffffff8104de74>] ? native_sched_clock+0x24/0x80
[  176.634843]  [<ffffffffa03c6a82>] gfs2_meta_read+0x32/0x140 [gfs2]
[  176.634855]  [<ffffffffa03d70b9>] gfs2_rgrp_bh_get+0x89/0x450 [gfs2]
[  176.634858]  [<ffffffff810c453d>] ? get_parent_ip+0xd/0x50
[  176.634868]  [<ffffffffa03d7541>] gfs2_rgrp_go_lock+0x31/0x40 [gfs2]
[  176.634875]  [<ffffffffa03be913>] do_promote+0x253/0x3b0 [gfs2]
[  176.634883]  [<ffffffffa03c0c68>] finish_xmote+0x3d8/0x5b0 [gfs2]
[  176.634890]  [<ffffffffa03c10a2>] do_xmote+0x262/0x2d0 [gfs2]
[  176.634898]  [<ffffffffa03c11de>] run_queue+0xce/0x2c0 [gfs2]
[  176.634905]  [<ffffffffa03c16f0>] gfs2_glock_nq+0x180/0x490 [gfs2]
[  176.634915]  [<ffffffffa03d8134>] gfs2_inplace_reserve+0x5d4/0x9e0 [gfs2]
[  176.634918]  [<ffffffff810dcdae>] ? put_lock_stats.isra.23+0xe/0x30
[  176.634927]  [<ffffffffa03ced73>] gfs2_create_inode+0x573/0xef0 [gfs2]
[  176.634937]  [<ffffffffa03ce8ac>] ? gfs2_create_inode+0xac/0xef0 [gfs2]
[  176.634940]  [<ffffffff810dfe3d>] ? trace_hardirqs_on+0xd/0x10
[  176.634949]  [<ffffffffa03cf777>] gfs2_mkdir+0x47/0x50 [gfs2]
[  176.634953]  [<ffffffff811ccde5>] vfs_mkdir+0x85/0xd0
[  176.634956]  [<ffffffff811d1a40>] SyS_mkdirat+0x60/0xc0
[  176.634959]  [<ffffffff811d1ab9>] SyS_mkdir+0x19/0x20
[  176.634962]  [<ffffffff81786912>] system_call_fastpath+0x16/0x1b


