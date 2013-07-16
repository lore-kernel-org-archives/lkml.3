Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab3GPBxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 21:53:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412Ab3GPBxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 21:53:14 -0400
Date: Mon, 15 Jul 2013 21:53:05 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: splice vs execve lockdep trace.
Message-ID: <20130716015305.GB30569@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(ignore taint, it's unrelated due to a broken debug patch in my tree).


[  696.047396] ======================================================
[  696.049036] [ INFO: possible circular locking dependency detected ]
[  696.050689] 3.11.0-rc1+ #53 Tainted: G        W   
[  696.052182] -------------------------------------------------------
[  696.053846] trinity-child2/14017 is trying to acquire lock:
[  696.055429]  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff8122fa55>] proc_pid_attr_write+0xf5/0x140
[  696.057652] but task is already holding lock:
[  696.060171]  (&pipe->mutex/1){+.+.+.}, at: [<ffffffff811c7096>] pipe_lock+0x26/0x30
[  696.062097] which lock already depends on the new lock.
[  696.065723] the existing dependency chain (in reverse order) is:
[  696.068295] -> #2 (&pipe->mutex/1){+.+.+.}:
[  696.070650]        [<ffffffff810c4bd1>] lock_acquire+0x91/0x1f0
[  696.072258]        [<ffffffff8170677a>] mutex_lock_nested+0x7a/0x410
[  696.073916]        [<ffffffff811c7096>] pipe_lock+0x26/0x30
[  696.075464]        [<ffffffff811f0024>] generic_file_splice_write+0x64/0x170
[  696.077192]        [<ffffffffa001afc0>] xfs_file_splice_write+0xb0/0x230 [xfs]
[  696.078914]        [<ffffffff811f1f5a>] SyS_splice+0x24a/0x7e0
[  696.080455]        [<ffffffff81714694>] tracesys+0xdd/0xe2
[  696.082000] -> #1 (&(&ip->i_iolock)->mr_lock){++++++}:
[  696.084428]        [<ffffffff810c4bd1>] lock_acquire+0x91/0x1f0
[  696.086017]        [<ffffffff8108bc92>] down_read_nested+0x52/0xa0
[  696.087643]        [<ffffffffa007b310>] xfs_ilock+0x1d0/0x280 [xfs]
[  696.089305]        [<ffffffffa001aa12>] xfs_file_aio_read+0x112/0x3e0 [xfs]
[  696.091037]        [<ffffffff811be2c0>] do_sync_read+0x80/0xb0
[  696.092571]        [<ffffffff811be931>] vfs_read+0xa1/0x170
[  696.094124]        [<ffffffff811c4ae1>] kernel_read+0x41/0x60
[  696.095693]        [<ffffffff811c4d03>] prepare_binprm+0xb3/0x130
[  696.097307]        [<ffffffff811c6b29>] do_execve_common.isra.29+0x599/0x6c0
[  696.099036]        [<ffffffff811c6f36>] SyS_execve+0x36/0x50
[  696.100577]        [<ffffffff81714a79>] stub_execve+0x69/0xa0
[  696.102157] -> #0 (&sig->cred_guard_mutex){+.+.+.}:
[  696.104536]        [<ffffffff810c40b6>] __lock_acquire+0x1786/0x1af0
[  696.106189]        [<ffffffff810c4bd1>] lock_acquire+0x91/0x1f0
[  696.107813]        [<ffffffff817062b5>] mutex_lock_interruptible_nested+0x75/0x4c0
[  696.109616]        [<ffffffff8122fa55>] proc_pid_attr_write+0xf5/0x140
[  696.111243]        [<ffffffff811bf372>] __kernel_write+0x72/0x150
[  696.112870]        [<ffffffff811f03f9>] write_pipe_buf+0x49/0x70
[  696.114503]        [<ffffffff811efa24>] splice_from_pipe_feed+0x84/0x140
[  696.116202]        [<ffffffff811efdce>] __splice_from_pipe+0x6e/0x90
[  696.117836]        [<ffffffff811f18c1>] splice_from_pipe+0x51/0x70
[  696.119419]        [<ffffffff811f1919>] default_file_splice_write+0x19/0x30
[  696.121147]        [<ffffffff811f1f5a>] SyS_splice+0x24a/0x7e0
[  696.122719]        [<ffffffff81714694>] tracesys+0xdd/0xe2
[  696.124272] other info that might help us debug this:

[  696.127604] Chain exists of:  &sig->cred_guard_mutex --> &(&ip->i_iolock)->mr_lock --> &pipe->mutex/1

[  696.131445]  Possible unsafe locking scenario:

[  696.133763]        CPU0                    CPU1
[  696.135108]        ----                    ----
[  696.136420]   lock(&pipe->mutex/1);
[  696.137745]                                lock(&(&ip->i_iolock)->mr_lock);
[  696.139469]                                lock(&pipe->mutex/1);
[  696.141030]   lock(&sig->cred_guard_mutex);
[  696.142409] 
 *** DEADLOCK ***

[  696.145237] 2 locks held by trinity-child2/14017:
[  696.146532]  #0:  (sb_writers#4){.+.+.+}, at: [<ffffffff811f2441>] SyS_splice+0x731/0x7e0
[  696.148435]  #1:  (&pipe->mutex/1){+.+.+.}, at: [<ffffffff811c7096>] pipe_lock+0x26/0x30
[  696.150357] stack backtrace:
[  696.152287] CPU: 2 PID: 14017 Comm: trinity-child2 Tainted: G        W    3.11.0-rc1+ #53 
[  696.156695]  ffffffff825270a0 ffff8801fee2db90 ffffffff8170164e ffffffff824f84c0
[  696.158392]  ffff8801fee2dbd0 ffffffff816fda92 ffff8801fee2dc20 ffff8802331446d8
[  696.160300]  ffff880233143fc0 0000000000000002 0000000000000002 ffff8802331446d8
[  696.162217] Call Trace:
[  696.163292]  [<ffffffff8170164e>] dump_stack+0x4e/0x82
[  696.164695]  [<ffffffff816fda92>] print_circular_bug+0x200/0x20f
[  696.166194]  [<ffffffff810c40b6>] __lock_acquire+0x1786/0x1af0
[  696.167677]  [<ffffffff810c4bd1>] lock_acquire+0x91/0x1f0
[  696.169111]  [<ffffffff8122fa55>] ? proc_pid_attr_write+0xf5/0x140
[  696.170633]  [<ffffffff8122fa55>] ? proc_pid_attr_write+0xf5/0x140
[  696.172151]  [<ffffffff817062b5>] mutex_lock_interruptible_nested+0x75/0x4c0
[  696.173765]  [<ffffffff8122fa55>] ? proc_pid_attr_write+0xf5/0x140
[  696.175280]  [<ffffffff8122fa55>] ? proc_pid_attr_write+0xf5/0x140
[  696.176793]  [<ffffffff8119e869>] ? alloc_pages_current+0xa9/0x170
[  696.178301]  [<ffffffff8122fa55>] proc_pid_attr_write+0xf5/0x140
[  696.179799]  [<ffffffff811f03b0>] ? splice_direct_to_actor+0x1f0/0x1f0
[  696.181346]  [<ffffffff811bf372>] __kernel_write+0x72/0x150
[  696.182796]  [<ffffffff811f03b0>] ? splice_direct_to_actor+0x1f0/0x1f0
[  696.184354]  [<ffffffff811f03f9>] write_pipe_buf+0x49/0x70
[  696.185779]  [<ffffffff811efa24>] splice_from_pipe_feed+0x84/0x140
[  696.187293]  [<ffffffff811f03b0>] ? splice_direct_to_actor+0x1f0/0x1f0
[  696.188850]  [<ffffffff811efdce>] __splice_from_pipe+0x6e/0x90
[  696.190325]  [<ffffffff811f03b0>] ? splice_direct_to_actor+0x1f0/0x1f0
[  696.191878]  [<ffffffff811f18c1>] splice_from_pipe+0x51/0x70
[  696.193335]  [<ffffffff811f1919>] default_file_splice_write+0x19/0x30
[  696.194896]  [<ffffffff811f1f5a>] SyS_splice+0x24a/0x7e0
[  696.196312]  [<ffffffff81714694>] tracesys+0xdd/0xe2


