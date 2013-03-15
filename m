Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751010Ab3COEHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 00:07:09 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46289 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab3COEHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 00:07:07 -0400
Message-ID: <51429E72.7090405@oracle.com>
Date: Fri, 15 Mar 2013 00:07:14 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>, Dave Jones <davej@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: vfs: lockdep splat with prepare_bprm_creds
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running latest -next kernel
I've stumbled on the following.

Dave Jones reported something similar, but that seemed to involve cgroup's mutex
and didn't seem like it was the same issue as this one.


[  549.400084] ======================================================
[  549.400084] [ INFO: possible circular locking dependency detected ]
[  549.400084] 3.9.0-rc2-next-20130314-sasha-00046-g3897511 #295 Tainted: G        W
[  549.400084] -------------------------------------------------------
[  549.420729] can: request_module (can-proto-0) failed.
[  549.400084] trinity-child20/12048 is trying to acquire lock:
[  549.400084]  (&p->lock){+.+.+.}, at: [<ffffffff8129f11a>] seq_read+0x3a/0x3d0
[  549.400084]
[  549.400084] but task is already holding lock:
[  549.400084]  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff812813d1>] prepare_bprm_creds+0x31/0x80
[  549.400084]
[  549.400084] which lock already depends on the new lock.
[  549.400084]
[  549.400084]
[  549.400084] the existing dependency chain (in reverse order) is:
[  549.400084]
-> #1 (&sig->cred_guard_mutex){+.+.+.}:
[  549.400084]        [<ffffffff8117994a>] check_prevs_add+0xba/0x1a0
[  549.400084]        [<ffffffff8117a100>] validate_chain.isra.21+0x6d0/0x800
[  549.400084]        [<ffffffff8117d523>] __lock_acquire+0xa23/0xb10
[  549.400084]        [<ffffffff8117df3a>] lock_acquire+0x1ca/0x270
[  549.400084]        [<ffffffff83d8786a>] __mutex_lock_common+0x5a/0x5a0
[  549.400084]        [<ffffffff83d87e3f>] mutex_lock_killable_nested+0x3f/0x50
[  549.400084]        [<ffffffff812e8858>] lock_trace+0x28/0x70
[  549.400084]        [<ffffffff812e8a45>] proc_pid_stack+0x65/0xf0
[  549.400084]        [<ffffffff812e9dfa>] proc_single_show+0x5a/0xa0
[  549.400084]        [<ffffffff8129f28f>] seq_read+0x1af/0x3d0
[  549.400084]        [<ffffffff8127a22b>] do_loop_readv_writev+0x4b/0x90
[  549.400084]        [<ffffffff8127a4a6>] do_readv_writev+0xf6/0x1d0
[  549.400084]        [<ffffffff8127a61e>] vfs_readv+0x3e/0x60
[  549.400084]        [<ffffffff8127a690>] SyS_readv+0x50/0xd0
[  549.400084]        [<ffffffff83d946d8>] tracesys+0xe1/0xe6
[  549.400084]
-> #0 (&p->lock){+.+.+.}:
[  549.400084]        [<ffffffff811792c5>] check_prev_add+0x145/0x710
[  549.400084]        [<ffffffff8117994a>] check_prevs_add+0xba/0x1a0
[  549.400084]        [<ffffffff8117a100>] validate_chain.isra.21+0x6d0/0x800
[  549.400084]        [<ffffffff8117d523>] __lock_acquire+0xa23/0xb10
[  549.400084]        [<ffffffff8117df3a>] lock_acquire+0x1ca/0x270
[  549.400084]        [<ffffffff83d8786a>] __mutex_lock_common+0x5a/0x5a0
[  549.400084]        [<ffffffff83d87edf>] mutex_lock_nested+0x3f/0x50
[  549.400084]        [<ffffffff8129f11a>] seq_read+0x3a/0x3d0
[  549.400084]        [<ffffffff812e7b61>] proc_reg_read+0x201/0x230
[  549.400084]        [<ffffffff81279e05>] vfs_read+0xb5/0x180
[  549.400084]        [<ffffffff8127fc61>] kernel_read+0x41/0x60
[  549.400084]        [<ffffffff8127fe0d>] prepare_binprm+0x18d/0x1b0
[  549.400084]        [<ffffffff81281646>] do_execve_common.isra.21+0x1b6/0x380
[  549.400084]        [<ffffffff81281823>] do_execve+0x13/0x20
[  549.400084]        [<ffffffff81281b0e>] SyS_execve+0x3e/0x60
[  549.400084]        [<ffffffff83d94ae9>] stub_execve+0x69/0xa0
[  549.400084]
[  549.400084] other info that might help us debug this:
[  549.400084]
[  549.400084]  Possible unsafe locking scenario:
[  549.400084]
[  549.400084]        CPU0                    CPU1
[  549.400084]        ----                    ----
[  549.400084]   lock(&sig->cred_guard_mutex);
[  549.400084]                                lock(&p->lock);
[  549.400084]                                lock(&sig->cred_guard_mutex);
[  549.400084]   lock(&p->lock);
[  549.400084]
[  549.400084]  *** DEADLOCK ***
[  549.400084]
[  549.400084] 1 lock held by trinity-child20/12048:
[  549.400084]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff812813d1>] prepare_bprm_creds+0x31/0x80
[  549.400084]
[  549.400084] stack backtrace:
[  549.400084] Pid: 12048, comm: trinity-child20 Tainted: G        W    3.9.0-rc2-next-20130314-sasha-00046-g3897511 #295
[  549.400084] Call Trace:
[  549.400084]  [<ffffffff83cfd02e>] print_circular_bug+0xd3/0xe4
[  549.400084]  [<ffffffff811792c5>] check_prev_add+0x145/0x710
[  549.400084]  [<ffffffff8117994a>] check_prevs_add+0xba/0x1a0
[  549.400084]  [<ffffffff8106ffa5>] ? sched_clock+0x15/0x20
[  549.400084]  [<ffffffff8117a100>] validate_chain.isra.21+0x6d0/0x800
[  549.400084]  [<ffffffff8117d523>] __lock_acquire+0xa23/0xb10
[  549.400084]  [<ffffffff8109b1c8>] ? kvm_clock_read+0x38/0x70
[  549.400084]  [<ffffffff811776ae>] ? lock_release_holdtime+0x12e/0x140
[  549.400084]  [<ffffffff8106ffa5>] ? sched_clock+0x15/0x20
[  549.400084]  [<ffffffff8114d2c5>] ? sched_clock_local+0x25/0x90
[  549.400084]  [<ffffffff81259396>] ? deactivate_slab+0x7d6/0x820
[  549.400084]  [<ffffffff8117df3a>] lock_acquire+0x1ca/0x270
[  549.400084]  [<ffffffff8129f11a>] ? seq_read+0x3a/0x3d0
[  549.400084]  [<ffffffff8114d2c5>] ? sched_clock_local+0x25/0x90
[  549.400084]  [<ffffffff8129f0e0>] ? seq_lseek+0x110/0x110
[  549.400084]  [<ffffffff83d8786a>] __mutex_lock_common+0x5a/0x5a0
[  549.400084]  [<ffffffff8129f11a>] ? seq_read+0x3a/0x3d0
[  549.400084]  [<ffffffff8117be32>] ? __lock_is_held+0x52/0x80
[  549.400084]  [<ffffffff8129f11a>] ? seq_read+0x3a/0x3d0
[  549.400084]  [<ffffffff8129f0e0>] ? seq_lseek+0x110/0x110
[  549.400084]  [<ffffffff83d87edf>] mutex_lock_nested+0x3f/0x50
[  549.400084]  [<ffffffff8129f11a>] seq_read+0x3a/0x3d0
[  549.400084]  [<ffffffff819f19cd>] ? delay_tsc+0xdd/0x110
[  549.400084]  [<ffffffff8129f0e0>] ? seq_lseek+0x110/0x110
[  549.400084]  [<ffffffff8129f0e0>] ? seq_lseek+0x110/0x110
[  549.400084]  [<ffffffff812e7b61>] proc_reg_read+0x201/0x230
[  549.400084]  [<ffffffff812e7960>] ? proc_reg_write+0x230/0x230
[  549.400084]  [<ffffffff81279e05>] vfs_read+0xb5/0x180
[  549.400084]  [<ffffffff8127fc61>] kernel_read+0x41/0x60
[  549.400084]  [<ffffffff8127fe0d>] prepare_binprm+0x18d/0x1b0
[  549.400084]  [<ffffffff81281646>] do_execve_common.isra.21+0x1b6/0x380
[  549.400084]  [<ffffffff81281823>] do_execve+0x13/0x20
[  549.400084]  [<ffffffff81281b0e>] SyS_execve+0x3e/0x60
[  549.400084]  [<ffffffff83d94ae9>] stub_execve+0x69/0xa0


Thanks,
Sasha
