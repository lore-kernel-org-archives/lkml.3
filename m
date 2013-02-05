Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab3BEOHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:07:42 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:56354 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab3BEOHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:07:40 -0500
MIME-Version: 1.0
Date: Tue, 5 Feb 2013 16:07:30 +0200
Message-ID: <CA+ydwtq_4V2rCTzXVSVHBn1PoRaC8uqvO3NA6CK0YXF=iFtvhQ@mail.gmail.com>
Subject: lockdep circular locking splat: tasklist_lock --> &nonblocking_pool.lock
 --> &(&new->fa_lock)->rlock
From: Tommi Rantala <tt.rantala@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Reporting a lockdep complaint that got triggered after fuzzing with
Trinity for a few hours:

[77365.024024] ======================================================
[77365.024871] [ INFO: possible circular locking dependency detected ]
[77365.024871] 3.8.0-rc6+ #29 Tainted: G        W
[77365.024871] -------------------------------------------------------
[77365.028112] trinity-child20/1940 is trying to acquire lock:
[77365.028112]  (tasklist_lock){.+.+..}, at: [<ffffffff811b19e2>]
send_sigio+0x52/0x100
[77365.028112] but task is already holding lock:
[77365.028112]  (&(&new->fa_lock)->rlock){-.-...}, at:
[<ffffffff811b1f09>] kill_fasync+0x69/0xe0
[77365.028112] which lock already depends on the new lock.
[77365.028112]
the existing dependency chain (in reverse order) is:
[77365.028112] -> #3 (&(&new->fa_lock)->rlock){-.-...}:
[77365.028112]        [<ffffffff810f2f9b>] lock_acquire+0x9b/0x120
[77365.028112]        [<ffffffff81b60f91>] _raw_spin_lock+0x31/0x40
[77365.028112]        [<ffffffff81b500b7>] get_partial_node.isra.54+0x45/0x1fb
[77365.028112]        [<ffffffff81b5040e>] __slab_alloc+0x1a1/0x4f3
[77365.028112]        [<ffffffff81193284>] kmem_cache_alloc_trace+0xe4/0x140
[77365.028112]        [<ffffffff81216529>] sysfs_open_file+0xc9/0x270
[77365.028112]        [<ffffffff8119ea8b>] do_dentry_open+0x1bb/0x250
[77365.028112]        [<ffffffff8119fa05>] finish_open+0x35/0x50
[77365.028112]        [<ffffffff811ae01e>] do_last+0x6de/0xe00
[77365.028112]        [<ffffffff811ae7fc>] path_openat+0xbc/0x4e0
[77365.028112]        [<ffffffff811aec61>] do_filp_open+0x41/0xa0
[77365.028112]        [<ffffffff8119fe84>] do_sys_open+0xf4/0x1e0
[77365.028112]        [<ffffffff8119ff91>] sys_open+0x21/0x30
[77365.028112]        [<ffffffff81b62819>] system_call_fastpath+0x16/0x1b
[77365.028112] -> #2 (&nonblocking_pool.lock){..-...}:
[77365.028112]        [<ffffffff810f2f9b>] lock_acquire+0x9b/0x120
[77365.028112]        [<ffffffff81b60fee>] _raw_spin_lock_irqsave+0x4e/0x70
[77365.028112]        [<ffffffff8141fbd9>] mix_pool_bytes.constprop.20+0x49/0xb0
[77365.028112]        [<ffffffff81420db4>] add_device_randomness+0x64/0x90
[77365.028112]        [<ffffffff810c0512>] posix_cpu_timers_exit+0x22/0x50
[77365.028112]        [<ffffffff8109cd80>] release_task+0xe0/0x470
[77365.028112]        [<ffffffff8109e755>] do_exit+0x5d5/0x9f0
[77365.028112]        [<ffffffff810b4250>] ____call_usermodehelper+0x110/0x120
[77365.028112]        [<ffffffff810b427e>] call_helper+0x1e/0x20
[77365.028112]        [<ffffffff81b6276c>] ret_from_fork+0x7c/0xb0
[77365.028112] -> #1 (&(&sighand->siglock)->rlock){-.-.-.}:
[77365.028112]        [<ffffffff810f2f9b>] lock_acquire+0x9b/0x120
[77365.028112]        [<ffffffff81b60f91>] _raw_spin_lock+0x31/0x40
[77365.028112]        [<ffffffff81097564>] copy_process.part.32+0xfe4/0x15b0
[77365.028112]        [<ffffffff81097bf4>] do_fork+0x94/0x360
[77365.085677]        [<ffffffff81097ee6>] kernel_thread+0x26/0x30
[77365.085677]        [<ffffffff810bdc60>] kthreadd+0x120/0x160
[77365.085677]        [<ffffffff81b6276c>] ret_from_fork+0x7c/0xb0
[77365.085677] -> #0 (tasklist_lock){.+.+..}:
[77365.085677]        [<ffffffff810f1733>] __lock_acquire+0x1be3/0x1c10
[77365.085677]        [<ffffffff810f2f9b>] lock_acquire+0x9b/0x120
[77365.085677]        [<ffffffff81b61274>] _raw_read_lock+0x34/0x50
[77365.085677]        [<ffffffff811b19e2>] send_sigio+0x52/0x100
[77365.085677]        [<ffffffff811b1f37>] kill_fasync+0x97/0xe0
[77365.085677]        [<ffffffff811ec4df>] lease_break_callback+0x1f/0x30
[77365.085677]        [<ffffffff811ed773>] __break_lease+0x133/0x320
[77365.085677]        [<ffffffff8119e9f7>] do_dentry_open+0x127/0x250
[77365.085677]        [<ffffffff8119fa05>] finish_open+0x35/0x50
[77365.085677]        [<ffffffff811ae01e>] do_last+0x6de/0xe00
[77365.085677]        [<ffffffff811ae7fc>] path_openat+0xbc/0x4e0
[77365.085677]        [<ffffffff811aec61>] do_filp_open+0x41/0xa0
[77365.085677]        [<ffffffff8119fe84>] do_sys_open+0xf4/0x1e0
[77365.085677]        [<ffffffff8119ff91>] sys_open+0x21/0x30
[77365.085677]        [<ffffffff81b62819>] system_call_fastpath+0x16/0x1b
[77365.085677] other info that might help us debug this:
[77365.085677] Chain exists of:
  tasklist_lock --> &nonblocking_pool.lock --> &(&new->fa_lock)->rlock
[77365.085677]  Possible unsafe locking scenario:
[77365.085677]        CPU0                    CPU1
[77365.085677]        ----                    ----
[77365.085677]   lock(&(&new->fa_lock)->rlock);
[77365.085677]                                lock(&nonblocking_pool.lock);
[77365.085677]                                lock(&(&new->fa_lock)->rlock);
[77365.085677]   lock(tasklist_lock);
[77365.085677]  *** DEADLOCK ***
[77365.085677] 4 locks held by trinity-child20/1940:
[77365.085677]  #0:  (file_lock_lock){+.+...}, at:
[<ffffffff811ec5e5>] lock_flocks+0x15/0x20
[77365.085677]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff811b1ec1>]
kill_fasync+0x21/0xe0
[77365.085677]  #2:  (&(&new->fa_lock)->rlock){-.-...}, at:
[<ffffffff811b1f09>] kill_fasync+0x69/0xe0
[77365.085677]  #3:  (&f->f_owner.lock){.?.?..}, at:
[<ffffffff811b19b4>] send_sigio+0x24/0x100
[77365.085677] stack backtrace:
[77365.085677] Pid: 1940, comm: trinity-child20 Tainted: G        W
3.8.0-rc6+ #29
[77365.085677] Call Trace:
[77365.085677]  [<ffffffff81b4da81>] print_circular_bug+0x1fb/0x20c
[77365.085677]  [<ffffffff810f1733>] __lock_acquire+0x1be3/0x1c10
[77365.085677]  [<ffffffff810f2f9b>] lock_acquire+0x9b/0x120
[77365.085677]  [<ffffffff811b19e2>] ? send_sigio+0x52/0x100
[77365.085677]  [<ffffffff81b61274>] _raw_read_lock+0x34/0x50
[77365.085677]  [<ffffffff811b19e2>] ? send_sigio+0x52/0x100
[77365.085677]  [<ffffffff811b19e2>] send_sigio+0x52/0x100
[77365.085677]  [<ffffffff811b1f37>] kill_fasync+0x97/0xe0
[77365.085677]  [<ffffffff811b1ec1>] ? kill_fasync+0x21/0xe0
[77365.085677]  [<ffffffff81b60f99>] ? _raw_spin_lock+0x39/0x40
[77365.085677]  [<ffffffff811ec4df>] lease_break_callback+0x1f/0x30
[77365.085677]  [<ffffffff811ed773>] __break_lease+0x133/0x320
[77365.085677]  [<ffffffff812f1e9a>] ?
inode_has_perm.isra.27.constprop.67+0x2a/0x30
[77365.085677]  [<ffffffff8119e9f7>] do_dentry_open+0x127/0x250
[77365.085677]  [<ffffffff8119fa05>] finish_open+0x35/0x50
[77365.085677]  [<ffffffff811ae01e>] do_last+0x6de/0xe00
[77365.085677]  [<ffffffff811aab68>] ? inode_permission+0x18/0x50
[77365.085677]  [<ffffffff811ac20d>] ? link_path_walk+0x23d/0x890
[77365.085677]  [<ffffffff811ae7fc>] path_openat+0xbc/0x4e0
[77365.085677]  [<ffffffff810f1ced>] ? trace_hardirqs_on+0xd/0x10
[77365.085677]  [<ffffffff811bd6f4>] ? __alloc_fd+0x34/0x140
[77365.085677]  [<ffffffff811aec61>] do_filp_open+0x41/0xa0
[77365.085677]  [<ffffffff811bd7a9>] ? __alloc_fd+0xe9/0x140
[77365.085677]  [<ffffffff8119fe84>] do_sys_open+0xf4/0x1e0
[77365.085677]  [<ffffffff8119ff91>] sys_open+0x21/0x30
[77365.085677]  [<ffffffff81b62819>] system_call_fastpath+0x16/0x1b

Tommi
