Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab3CFWhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:37:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265Ab3CFWhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:37:00 -0500
Date: Wed, 6 Mar 2013 17:36:57 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: oleg@redhat.com
Subject: lockdep trace from prepare_bprm_creds
Message-ID: <20130306223657.GA7392@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, oleg@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like this happens when my fuzzer tries to look up garbage in /sys/fs/cgroup/freezer/

trinity -c execve -V /sys/fs/cgroup/freezer/

will reproduce it very quickly.

This isn't a new trace. I've seen it in the past from iknowthis also.

	Dave


[  943.971541] ======================================================
[  943.972451] [ INFO: possible circular locking dependency detected ]
[  943.973370] 3.9.0-rc1+ #69 Not tainted
[  943.973927] -------------------------------------------------------
[  943.974838] trinity-child0/1301 is trying to acquire lock:
[  943.975650] blocked:  (&sb->s_type->i_mutex_key#9){+.+.+.}, instance: ffff880127ea1680, at: [<ffffffff811c03fc>] do_last+0x35c/0xe30
[  943.977522] 
but task is already holding lock:
[  943.978371] held:     (&sig->cred_guard_mutex){+.+.+.}, instance: ffff880123937578, at: [<ffffffff811b8866>] prepare_bprm_creds+0x36/0x80
[  943.980260] 
which lock already depends on the new lock.

[  943.981434] 
the existing dependency chain (in reverse order) is:
[  943.982499] 
-> #2 (&sig->cred_guard_mutex){+.+.+.}:
[  943.983280]        [<ffffffff810b7b82>] lock_acquire+0x92/0x1d0
[  943.984196]        [<ffffffff816c1923>] mutex_lock_nested+0x73/0x3b0
[  943.985173]        [<ffffffff810d45f2>] attach_task_by_pid+0x122/0x8d0
[  943.986151]        [<ffffffff810d4dd3>] cgroup_tasks_write+0x13/0x20
[  943.987127]        [<ffffffff810d0f10>] cgroup_file_write+0x130/0x2f0
[  943.988118]        [<ffffffff811b119f>] vfs_write+0xaf/0x180
[  943.988985]        [<ffffffff811b14e5>] sys_write+0x55/0xa0
[  943.989853]        [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
[  943.990853] 
-> #1 (cgroup_mutex){+.+.+.}:
[  943.991616]        [<ffffffff810b7b82>] lock_acquire+0x92/0x1d0
[  943.992527]        [<ffffffff816c1923>] mutex_lock_nested+0x73/0x3b0
[  943.993492]        [<ffffffff810d33a7>] cgroup_mount+0x2e7/0x520
[  943.994423]        [<ffffffff811b5123>] mount_fs+0x43/0x1b0
[  943.995275]        [<ffffffff811d3051>] vfs_kern_mount+0x61/0x100
[  943.996220]        [<ffffffff811d5821>] do_mount+0x211/0xa00
[  943.997103]        [<ffffffff811d609e>] sys_mount+0x8e/0xe0
[  943.997965]        [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
[  943.998972] 
-> #0 (&sb->s_type->i_mutex_key#9){+.+.+.}:
[  943.999886]        [<ffffffff810b7406>] __lock_acquire+0x1b86/0x1c80
[  944.000864]        [<ffffffff810b7b82>] lock_acquire+0x92/0x1d0
[  944.001771]        [<ffffffff816c1923>] mutex_lock_nested+0x73/0x3b0
[  944.002750]        [<ffffffff811c03fc>] do_last+0x35c/0xe30
[  944.003620]        [<ffffffff811c0f8a>] path_openat+0xba/0x4f0
[  944.004517]        [<ffffffff811c1691>] do_filp_open+0x41/0xa0
[  944.005427]        [<ffffffff811b74d3>] open_exec+0x53/0x130
[  944.006296]        [<ffffffff811b8c3d>] do_execve_common.isra.26+0x31d/0x710
[  944.007373]        [<ffffffff811b9048>] do_execve+0x18/0x20
[  944.008222]        [<ffffffff811b933d>] sys_execve+0x3d/0x60
[  944.009093]        [<ffffffff816cdf39>] stub_execve+0x69/0xa0
[  944.009983] 
other info that might help us debug this:

[  944.011126] Chain exists of:
  &sb->s_type->i_mutex_key#9 --> cgroup_mutex --> &sig->cred_guard_mutex

[  944.012745]  Possible unsafe locking scenario:

[  944.013617]        CPU0                    CPU1
[  944.014280]        ----                    ----
[  944.014942]   lock(&sig->cred_guard_mutex);
[  944.021332]                                lock(cgroup_mutex);
[  944.028094]                                lock(&sig->cred_guard_mutex);
[  944.035007]   lock(&sb->s_type->i_mutex_key#9);
[  944.041602] 
 *** DEADLOCK ***

[  944.059241] 1 lock on stack by trinity-child0/1301:
[  944.065496]  #0: held:     (&sig->cred_guard_mutex){+.+.+.}, instance: ffff880123937578, at: [<ffffffff811b8866>] prepare_bprm_creds+0x36/0x80
[  944.073100] 
stack backtrace:
[  944.085269] Pid: 1301, comm: trinity-child0 Not tainted 3.9.0-rc1+ #69
[  944.091788] Call Trace:
[  944.097633]  [<ffffffff816b95f5>] print_circular_bug+0x1fe/0x20f
[  944.104041]  [<ffffffff810b7406>] __lock_acquire+0x1b86/0x1c80
[  944.110223]  [<ffffffff810b21bd>] ? trace_hardirqs_off+0xd/0x10
[  944.116282]  [<ffffffff810b7b82>] lock_acquire+0x92/0x1d0
[  944.122293]  [<ffffffff811c03fc>] ? do_last+0x35c/0xe30
[  944.128287]  [<ffffffff816c1923>] mutex_lock_nested+0x73/0x3b0
[  944.134460]  [<ffffffff811c03fc>] ? do_last+0x35c/0xe30
[  944.140497]  [<ffffffff811c03fc>] ? do_last+0x35c/0xe30
[  944.146446]  [<ffffffff811c03fc>] do_last+0x35c/0xe30
[  944.152303]  [<ffffffff811bd098>] ? inode_permission+0x18/0x50
[  944.158260]  [<ffffffff811bd315>] ? link_path_walk+0x245/0x880
[  944.164165]  [<ffffffff811c0f8a>] path_openat+0xba/0x4f0
[  944.169934]  [<ffffffff811c1691>] do_filp_open+0x41/0xa0
[  944.175834]  [<ffffffff811b8c2e>] ? do_execve_common.isra.26+0x30e/0x710
[  944.181817]  [<ffffffff810b2042>] ? get_lock_stats+0x22/0x70
[  944.187828]  [<ffffffff810b24ae>] ? put_lock_stats.isra.23+0xe/0x40
[  944.193892]  [<ffffffff810b2bcb>] ? lock_release_holdtime.part.24+0xcb/0x130
[  944.200099]  [<ffffffff811b74d3>] open_exec+0x53/0x130
[  944.206046]  [<ffffffff811b8c3d>] do_execve_common.isra.26+0x31d/0x710
[  944.212123]  [<ffffffff811b8a42>] ? do_execve_common.isra.26+0x122/0x710
[  944.218275]  [<ffffffff811b9048>] do_execve+0x18/0x20
[  944.224206]  [<ffffffff811b933d>] sys_execve+0x3d/0x60
[  944.230155]  [<ffffffff816cdf39>] stub_execve+0x69/0xa0

