Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947Ab3LHU6G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 15:58:06 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:17292 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab3LHU6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 15:58:01 -0500
Message-ID: <52A4DD51.6090709@oracle.com>
Date: Sun, 08 Dec 2013 15:57:53 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: viro@zeniv.linux.org.uk
Subject: fs: proc: lockdep spew and questions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've been looking at permissions in procfs, and noticed that directories are usually added with 
execute permission.

As far as I know, there's nothing executable by default inside procfs, and on top of that, many of 
the files there don't deal well with being executed so it's easy to cause lockdep spews (one below).

Is there a reason execute bit is set for directories?


sh-4.1# chmod +x /proc/10/net/igmp
sh-4.1# /proc/10/net/igmp
/proc/10/net/igmp: line 1: Idx: command not found
sh-4.1# cat /proc/10/maps
[   64.535651]
[   64.535898] ======================================================
[   64.536674] [ INFO: possible circular locking dependency detected ]
[   64.537288] 3.13.0-rc2-next-20131206-sasha-00005-g8be2375-dirty #4052 Not tainted
[   64.538211] -------------------------------------------------------
[   64.538831] cat/7896 is trying to acquire lock:
[   64.539307]  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff8112e684>] mm_access+0x34/0xb0
[   64.540349]
[   64.540349] but task is already holding lock:
[   64.540906]  (&p->lock){+.+.+.}, at: [<ffffffff813000df>] seq_read+0x3f/0x430
[   64.541877]
[   64.541877] which lock already depends on the new lock.
[   64.541877]
[   64.542449]
[   64.542449] the existing dependency chain (in reverse order) is:
[   64.542449]
-> #1 (&p->lock){+.+.+.}:
[   64.542449]        [<ffffffff81194833>] validate_chain+0x6c3/0x7b0
[   64.542449]        [<ffffffff81194dcd>] __lock_acquire+0x4ad/0x580
[   64.542449]        [<ffffffff81195022>] lock_acquire+0x182/0x1d0
[   64.542449]        [<ffffffff8439825f>] mutex_lock_nested+0x6f/0x520
[   64.542449]        [<ffffffff813000df>] seq_read+0x3f/0x430
[   64.542449]        [<ffffffff8134e62f>] proc_reg_read+0x5f/0x80
[   64.542449]        [<ffffffff812d7177>] vfs_read+0xc7/0x180
[   64.542449]        [<ffffffff812dce66>] kernel_read+0x46/0x60
[   64.542449]        [<ffffffff812dcfd3>] prepare_binprm+0x153/0x170
[   64.542449]        [<ffffffff812de2d5>] do_execve_common+0x1a5/0x360
[   64.542449]        [<ffffffff812de557>] do_execve+0x37/0x40
[   64.542449]        [<ffffffff812de5a6>] SyS_execve+0x46/0x70
[   64.542449]        [<ffffffff843a6c19>] stub_execve+0x69/0xa0
[   64.542449]
-> #0 (&sig->cred_guard_mutex){+.+.+.}:
[   64.542449]        [<ffffffff81193d5f>] check_prev_add+0x13f/0x550
[   64.542449]        [<ffffffff81194833>] validate_chain+0x6c3/0x7b0
[   64.542449]        [<ffffffff81194dcd>] __lock_acquire+0x4ad/0x580
[   64.542449]        [<ffffffff81195022>] lock_acquire+0x182/0x1d0
[   64.542449]        [<ffffffff8439967f>] mutex_lock_killable_nested+0x6f/0x620
[   64.542449]        [<ffffffff8112e684>] mm_access+0x34/0xb0
[   64.542449]        [<ffffffff8134bf49>] m_start+0x79/0x1d0
[   64.542449]        [<ffffffff81300228>] seq_read+0x188/0x430
[   64.542449]        [<ffffffff812d7177>] vfs_read+0xc7/0x180
[   64.542449]        [<ffffffff812d7332>] SyS_read+0x62/0xa0
[   64.542449]        [<ffffffff843a6810>] tracesys+0xdd/0xe2
[   64.542449]
[   64.542449] other info that might help us debug this:
[   64.542449]
[   64.542449]  Possible unsafe locking scenario:
[   64.542449]
[   64.542449]        CPU0                    CPU1
[   64.542449]        ----                    ----
[   64.542449]   lock(&p->lock);
[   64.542449]                                lock(&sig->cred_guard_mutex);
[   64.542449]                                lock(&p->lock);
[   64.542449]   lock(&sig->cred_guard_mutex);
[   64.542449]
[   64.542449]  *** DEADLOCK ***
[   64.542449]
[   64.542449] 1 lock held by cat/7896:
[   64.542449]  #0:  (&p->lock){+.+.+.}, at: [<ffffffff813000df>] seq_read+0x3f/0x430
[   64.542449]
[   64.542449] stack backtrace:
[   64.542449] CPU: 0 PID: 7896 Comm: cat Not tainted 
3.13.0-rc2-next-20131206-sasha-00005-g8be2375-dirty #4052
[   64.542449]  0000000000000000 ffff880fbc169af8 ffffffff843956f7 0000000000000000
[   64.542449]  0000000000000000 ffff880fbc169b48 ffffffff81191909 ffff880fbc169b68
[   64.542449]  ffff880fbc169b68 ffff880fbc169b48 ffff880fb89fbbd8 ffff880fb89fbc10
[   64.542449] Call Trace:
[   64.542449]  [<ffffffff843956f7>] dump_stack+0x52/0x7f
[   64.542449]  [<ffffffff81191909>] print_circular_bug+0x129/0x160
[   64.542449]  [<ffffffff81193d5f>] check_prev_add+0x13f/0x550
[   64.542449]  [<ffffffff812aec6f>] ? deactivate_slab+0x8cf/0x920
[   64.542449]  [<ffffffff81194833>] validate_chain+0x6c3/0x7b0
[   64.542449]  [<ffffffff811755b8>] ? sched_clock_cpu+0x108/0x120
[   64.542449]  [<ffffffff81194dcd>] __lock_acquire+0x4ad/0x580
[   64.542449]  [<ffffffff81195022>] lock_acquire+0x182/0x1d0
[   64.542449]  [<ffffffff8112e684>] ? mm_access+0x34/0xb0
[   64.542449]  [<ffffffff8439967f>] mutex_lock_killable_nested+0x6f/0x620
[   64.542449]  [<ffffffff8112e684>] ? mm_access+0x34/0xb0
[   64.542449]  [<ffffffff81159480>] ? get_pid_task+0xd0/0x100
[   64.542449]  [<ffffffff8112e684>] ? mm_access+0x34/0xb0
[   64.542449]  [<ffffffff8112e684>] mm_access+0x34/0xb0
[   64.542449]  [<ffffffff811593b0>] ? alloc_pid+0x260/0x260
[   64.542449]  [<ffffffff8134bf49>] m_start+0x79/0x1d0
[   64.542449]  [<ffffffff81176376>] ? vtime_account_user+0x96/0xb0
[   64.542449]  [<ffffffff81300228>] seq_read+0x188/0x430
[   64.542449]  [<ffffffff812d7177>] vfs_read+0xc7/0x180
[   64.542449]  [<ffffffff812d7332>] SyS_read+0x62/0xa0
[   64.542449]  [<ffffffff843a6810>] tracesys+0xdd/0xe2
