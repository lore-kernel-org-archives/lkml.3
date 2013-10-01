Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3JAO6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:58:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab3JAO6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:58:04 -0400
Date: Tue, 1 Oct 2013 10:57:55 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: ebiederm@xmission.com, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: pipe/cred lockdep warning
Message-ID: <20131001145755.GA22729@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, ebiederm@xmission.com,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I seem to recall hitting this quite a while ago. Does it look familiar ?
Either it didn't get fixed, or it's back..

	Dave

[ 2836.628351] ======================================================
[ 2836.628392] [ INFO: possible circular locking dependency detected ]
[ 2836.628436] 3.12.0-rc3+ #90 Not tainted
[ 2836.628464] -------------------------------------------------------
[ 2836.628506] trinity-child0/30759 is trying to acquire lock:
[ 2836.628544]  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff81239045>] proc_pid_attr_write+0xf5/0x140
[ 2836.628624] 
but task is already holding lock:
[ 2836.628664]  (&pipe->mutex/1){+.+.+.}, at: [<ffffffff811ccf66>] pipe_lock+0x26/0x30
[ 2836.628734] 
which lock already depends on the new lock.

[ 2836.628787] 
the existing dependency chain (in reverse order) is:
[ 2836.628837] 
-> #2 (&pipe->mutex/1){+.+.+.}:
[ 2836.628888]        [<ffffffff810cc1e3>] lock_acquire+0x93/0x200
[ 2836.628933]        [<ffffffff8172de5c>] mutex_lock_nested+0x7c/0x420
[ 2836.628981]        [<ffffffff811ccf66>] pipe_lock+0x26/0x30
[ 2836.629023]        [<ffffffff811f6e94>] generic_file_splice_write+0x64/0x170
[ 2836.629076]        [<ffffffffa02dc710>] xfs_file_splice_write+0xb0/0x230 [xfs]
[ 2836.629152]        [<ffffffff811f8dca>] SyS_splice+0x24a/0x7e0
[ 2836.629196]        [<ffffffff8173ce24>] tracesys+0xdd/0xe2
[ 2836.629238] 
-> #1 (&(&ip->i_iolock)->mr_lock){++++++}:
[ 2836.629291]        [<ffffffff810cc1e3>] lock_acquire+0x93/0x200
[ 2836.629335]        [<ffffffff81089562>] down_read_nested+0x52/0xa0
[ 2836.630980]        [<ffffffffa033b7a0>] xfs_ilock+0x1d0/0x280 [xfs]
[ 2836.632649]        [<ffffffffa02dc161>] xfs_file_aio_read+0x111/0x3e0 [xfs]
[ 2836.634313]        [<ffffffff811c3f1a>] do_sync_read+0x5a/0x90
[ 2836.635957]        [<ffffffff811c4551>] vfs_read+0xa1/0x170
[ 2836.637581]        [<ffffffff811ca911>] kernel_read+0x41/0x60
[ 2836.639184]        [<ffffffff811cab33>] prepare_binprm+0xb3/0x170
[ 2836.640768]        [<ffffffff811cc733>] do_execve_common.isra.28+0x5a3/0x990
[ 2836.642344]        [<ffffffff811cce06>] SyS_execve+0x36/0x50
[ 2836.643904]        [<ffffffff8173d209>] stub_execve+0x69/0xa0
[ 2836.645442] 
-> #0 (&sig->cred_guard_mutex){+.+.+.}:
[ 2836.648483]        [<ffffffff810cb76a>] __lock_acquire+0x191a/0x1be0
[ 2836.650025]        [<ffffffff810cc1e3>] lock_acquire+0x93/0x200
[ 2836.651559]        [<ffffffff8172eba7>] mutex_lock_interruptible_nested+0x77/0x510
[ 2836.653110]        [<ffffffff81239045>] proc_pid_attr_write+0xf5/0x140
[ 2836.654659]        [<ffffffff811c4f92>] __kernel_write+0x72/0x150
[ 2836.656208]        [<ffffffff811f7269>] write_pipe_buf+0x49/0x70
[ 2836.657750]        [<ffffffff811f6894>] splice_from_pipe_feed+0x84/0x140
[ 2836.659310]        [<ffffffff811f6c3e>] __splice_from_pipe+0x6e/0x90
[ 2836.660868]        [<ffffffff811f8731>] splice_from_pipe+0x51/0x70
[ 2836.662423]        [<ffffffff811f8789>] default_file_splice_write+0x19/0x30
[ 2836.663979]        [<ffffffff811f8dca>] SyS_splice+0x24a/0x7e0
[ 2836.665518]        [<ffffffff8173ce24>] tracesys+0xdd/0xe2
[ 2836.666999] 
other info that might help us debug this:

[ 2836.671264] Chain exists of:
  &sig->cred_guard_mutex --> &(&ip->i_iolock)->mr_lock --> &pipe->mutex/1

[ 2836.675587]  Possible unsafe locking scenario:

[ 2836.678443]        CPU0                    CPU1
[ 2836.679832]        ----                    ----
[ 2836.681187]   lock(&pipe->mutex/1);
[ 2836.682548]                                lock(&(&ip->i_iolock)->mr_lock);
[ 2836.683938]                                lock(&pipe->mutex/1);
[ 2836.685309]   lock(&sig->cred_guard_mutex);
[ 2836.686670] 
 *** DEADLOCK ***

[ 2836.690616] 2 locks held by trinity-child0/30759:
[ 2836.691921]  #0:  (sb_writers#4){.+.+.+}, at: [<ffffffff811f92b1>] SyS_splice+0x731/0x7e0
[ 2836.693264]  #1:  (&pipe->mutex/1){+.+.+.}, at: [<ffffffff811ccf66>] pipe_lock+0x26/0x30
[ 2836.694597] 
stack backtrace:
[ 2836.697165] CPU: 0 PID: 30759 Comm: trinity-child0 Not tainted 3.12.0-rc3+ #90
[ 2836.699886]  ffffffff825329d0 ffff88009cb61b88 ffffffff81729d13 ffffffff82504b80
[ 2836.701295]  ffff88009cb61bc8 ffffffff817260f1 ffff88009cb61c20 ffff88009caa5cb8
[ 2836.702723]  ffff88009caa5580 0000000000000001 ffff88009caa5c80 ffff88009caa5cb8
[ 2836.704149] Call Trace:
[ 2836.705547]  [<ffffffff81729d13>] dump_stack+0x4e/0x82
[ 2836.706958]  [<ffffffff817260f1>] print_circular_bug+0x200/0x20f
[ 2836.708365]  [<ffffffff810cb76a>] __lock_acquire+0x191a/0x1be0
[ 2836.709778]  [<ffffffff810cc1e3>] lock_acquire+0x93/0x200
[ 2836.711184]  [<ffffffff81239045>] ? proc_pid_attr_write+0xf5/0x140
[ 2836.712596]  [<ffffffff81239045>] ? proc_pid_attr_write+0xf5/0x140
[ 2836.713983]  [<ffffffff8172eba7>] mutex_lock_interruptible_nested+0x77/0x510
[ 2836.715382]  [<ffffffff81239045>] ? proc_pid_attr_write+0xf5/0x140
[ 2836.716785]  [<ffffffff81239045>] ? proc_pid_attr_write+0xf5/0x140
[ 2836.718171]  [<ffffffff811a5b99>] ? alloc_pages_current+0xa9/0x170
[ 2836.719554]  [<ffffffff81239045>] proc_pid_attr_write+0xf5/0x140
[ 2836.720926]  [<ffffffff811f7220>] ? splice_direct_to_actor+0x1f0/0x1f0
[ 2836.722303]  [<ffffffff811c4f92>] __kernel_write+0x72/0x150
[ 2836.723680]  [<ffffffff811f7220>] ? splice_direct_to_actor+0x1f0/0x1f0
[ 2836.725052]  [<ffffffff811f7269>] write_pipe_buf+0x49/0x70
[ 2836.726420]  [<ffffffff811f6894>] splice_from_pipe_feed+0x84/0x140
[ 2836.727805]  [<ffffffff811f7220>] ? splice_direct_to_actor+0x1f0/0x1f0
[ 2836.729199]  [<ffffffff811f6c3e>] __splice_from_pipe+0x6e/0x90
[ 2836.730589]  [<ffffffff811f7220>] ? splice_direct_to_actor+0x1f0/0x1f0
[ 2836.731983]  [<ffffffff811f8731>] splice_from_pipe+0x51/0x70
[ 2836.733373]  [<ffffffff811f8789>] default_file_splice_write+0x19/0x30
[ 2836.734771]  [<ffffffff811f8dca>] SyS_splice+0x24a/0x7e0
[ 2836.736161]  [<ffffffff8173ce24>] tracesys+0xdd/0xe2

