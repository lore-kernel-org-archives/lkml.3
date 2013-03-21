Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab3CUTG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:06:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab3CUTG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:06:57 -0400
Date: Thu, 21 Mar 2013 15:06:53 -0400
From: Dave Jones <davej@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: VFS deadlock ?
Message-ID: <20130321190653.GA15479@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al, Linus,
 I've seen this happen a few times recently.. I have a bunch of trinity processes
that run for a few hours, and then eventually all those processes end up spinning
waiting on each other.

The stack traces always seem to look like this..

Does this look like a real kernel deadlock, or more likely that trinity was unlucky enough
to do something really dumb that I need to protect itself against ?

I've only seen it happening the last week or so (but that may be because of all
the crap that I ended up finding last week preventing me running long enough
to hit this until now..)

Tree is Linus' latest with Peter Hurley's tty patchset on top (which afair
doesn't touch anything in these paths).

lockdep hasn't picked up anything, which makes me wonder if it's my problem..

	Dave


trinity-child2  D ffff880110b3a7e0  5448  7669      1 0x00000004
 ffff8801272a7d20 0000000000000086 ffff880101874920 ffff8801272a7fd8
 ffff8801272a7fd8 ffff8801272a7fd8 ffff880128ca8000 ffff880101874920
 ffff8801039a0250 0000000000000246 ffff880101874920 ffff8801272a7fd8
Call Trace:
 [<ffffffff816c2fd3>] schedule_preempt_disabled+0x33/0x80
 [<ffffffff816bfcc1>] mutex_lock_nested+0x1a1/0x3d0
 [<ffffffff811c7034>] ? lock_rename+0x114/0x120
 [<ffffffff811c7034>] ? lock_rename+0x114/0x120
 [<ffffffff811c7034>] lock_rename+0x114/0x120
 [<ffffffff811cd7a7>] sys_renameat+0x1f7/0x3b0
 [<ffffffff810b33a2>] ? get_lock_stats+0x22/0x70
 [<ffffffff810b6b95>] ? trace_hardirqs_on_caller+0x115/0x1a0
 [<ffffffff810b6b95>] ? trace_hardirqs_on_caller+0x115/0x1a0
 [<ffffffff8134a24e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff816cd102>] system_call_fastpath+0x16/0x1b

trinity-child1  D ffff880110b3a7e0  5200  7901      1 0x00000004
 ffff8801015ddc50 0000000000000086 ffff880123fca490 ffff8801015ddfd8
 ffff8801015ddfd8 ffff8801015ddfd8 ffff880128cac920 ffff880123fca490
 ffff8801015dde60 0000000000000246 ffff880123fca490 ffff8801015ddfd8
Call Trace:
 [<ffffffff816c2fd3>] schedule_preempt_disabled+0x33/0x80
 [<ffffffff816bfcc1>] mutex_lock_nested+0x1a1/0x3d0
 [<ffffffff816bb512>] ? lookup_slow+0x13f/0x1b8
 [<ffffffff816bb512>] ? lookup_slow+0x13f/0x1b8
 [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8
 [<ffffffff811c805a>] ? lookup_fast+0x16a/0x2d0
 [<ffffffff811c9d7c>] path_lookupat+0x79c/0x7c0
 [<ffffffff8119fa87>] ? kmem_cache_alloc+0xf7/0x340
 [<ffffffff8100a144>] ? native_sched_clock+0x24/0x80
 [<ffffffff811c826a>] ? getname_flags+0x5a/0x1a0
 [<ffffffff811c9dd4>] filename_lookup+0x34/0xc0
 [<ffffffff811ccd23>] user_path_at_empty+0x63/0xa0
 [<ffffffff8100a144>] ? native_sched_clock+0x24/0x80
 [<ffffffff810b3288>] ? trace_hardirqs_off_caller+0x28/0xc0
 [<ffffffff816cd127>] ? sysret_check+0x1b/0x56
 [<ffffffff811ccd71>] user_path_at+0x11/0x20
 [<ffffffff811bb538>] sys_fchmodat+0x38/0xa0
 [<ffffffff8134a24e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff811bb5b9>] sys_chmod+0x19/0x20
 [<ffffffff816cd102>] system_call_fastpath+0x16/0x1b

trinity-child1  D ffff880110b3a7e0  5528  8651  29705 0x00000004
 ffff8801187cfc60 0000000000000082 ffff880126a28000 ffff8801187cffd8
 ffff8801187cffd8 ffff8801187cffd8 ffffffff81c10440 ffff880126a28000
 ffff8801187cfe70 0000000000000246 ffff880126a28000 ffff8801187cffd8
Call Trace:
 [<ffffffff816c2fd3>] schedule_preempt_disabled+0x33/0x80
 [<ffffffff816bfcc1>] mutex_lock_nested+0x1a1/0x3d0
 [<ffffffff816bb512>] ? lookup_slow+0x13f/0x1b8
 [<ffffffff816bb512>] ? lookup_slow+0x13f/0x1b8
 [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8
 [<ffffffff811c805a>] ? lookup_fast+0x16a/0x2d0
 [<ffffffff811c9d7c>] path_lookupat+0x79c/0x7c0
 [<ffffffff8119fa87>] ? kmem_cache_alloc+0xf7/0x340
 [<ffffffff810b3288>] ? trace_hardirqs_off_caller+0x28/0xc0
 [<ffffffff811c826a>] ? getname_flags+0x5a/0x1a0
 [<ffffffff811c9dd4>] filename_lookup+0x34/0xc0
 [<ffffffff811ccd23>] user_path_at_empty+0x63/0xa0
 [<ffffffff810b3288>] ? trace_hardirqs_off_caller+0x28/0xc0
 [<ffffffff816cd127>] ? sysret_check+0x1b/0x56
 [<ffffffff811ccd71>] user_path_at+0x11/0x20
 [<ffffffff811e4904>] sys_removexattr+0x34/0xb0
 [<ffffffff816cd102>] system_call_fastpath+0x16/0x1b

trinity-child3  D ffff880110b3a7e0  5312  9067      1 0x00000004
 ffff880100d29c60 0000000000000082 ffff8801271a0000 ffff880100d29fd8
 ffff880100d29fd8 ffff880100d29fd8 ffff880128cac920 ffff8801271a0000
 ffff880100d29e70 0000000000000246 ffff8801271a0000 ffff880100d29fd8
Call Trace:
 [<ffffffff816c2fd3>] schedule_preempt_disabled+0x33/0x80
 [<ffffffff816bfcc1>] mutex_lock_nested+0x1a1/0x3d0
 [<ffffffff816bb512>] ? lookup_slow+0x13f/0x1b8
 [<ffffffff816bb512>] ? lookup_slow+0x13f/0x1b8
 [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8
 [<ffffffff811c805a>] ? lookup_fast+0x16a/0x2d0
 [<ffffffff811c9d7c>] path_lookupat+0x79c/0x7c0
 [<ffffffff8119fa87>] ? kmem_cache_alloc+0xf7/0x340
 [<ffffffff811c826a>] ? getname_flags+0x5a/0x1a0
 [<ffffffff811c9dd4>] filename_lookup+0x34/0xc0
 [<ffffffff811ccd23>] user_path_at_empty+0x63/0xa0
 [<ffffffff810b3ace>] ? put_lock_stats.isra.27+0xe/0x40
 [<ffffffff810b6c2d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff816c4787>] ? _raw_spin_unlock_irq+0x37/0x60
 [<ffffffff816cd127>] ? sysret_check+0x1b/0x56
 [<ffffffff811ccd71>] user_path_at+0x11/0x20
 [<ffffffff811bb538>] sys_fchmodat+0x38/0xa0
 [<ffffffff816cd102>] system_call_fastpath+0x16/0x1b

trinity-child0  D ffff880110b3a7e0  5320  9112      1 0x00000004
 ffff8801014fbc50 0000000000000086 ffff880123a94920 ffff8801014fbfd8
 ffff8801014fbfd8 ffff8801014fbfd8 ffffffff81c10440 ffff880123a94920
 ffff8801014fbe60 0000000000000246 ffff880123a94920 ffff8801014fbfd8
Call Trace:
 [<ffffffff816c2fd3>] schedule_preempt_disabled+0x33/0x80
 [<ffffffff816bfcc1>] mutex_lock_nested+0x1a1/0x3d0
 [<ffffffff816bb512>] ? lookup_slow+0x13f/0x1b8
 [<ffffffff816bb512>] ? lookup_slow+0x13f/0x1b8
 [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8
 [<ffffffff811c805a>] ? lookup_fast+0x16a/0x2d0
 [<ffffffff811c9d7c>] path_lookupat+0x79c/0x7c0
 [<ffffffff8119fa87>] ? kmem_cache_alloc+0xf7/0x340
 [<ffffffff8100a144>] ? native_sched_clock+0x24/0x80
 [<ffffffff811c826a>] ? getname_flags+0x5a/0x1a0
 [<ffffffff811c9dd4>] filename_lookup+0x34/0xc0
 [<ffffffff811ccd23>] user_path_at_empty+0x63/0xa0
 [<ffffffff8100a144>] ? native_sched_clock+0x24/0x80
 [<ffffffff810b3288>] ? trace_hardirqs_off_caller+0x28/0xc0
 [<ffffffff816cd127>] ? sysret_check+0x1b/0x56
 [<ffffffff811ccd71>] user_path_at+0x11/0x20
 [<ffffffff811babb5>] do_sys_truncate+0x35/0x90
 [<ffffffff811bad7e>] sys_truncate+0xe/0x10
 [<ffffffff816cd102>] system_call_fastpath+0x16/0x1b

trinity-child3  D ffff880110b3a7e0  5304  9414  29705 0x00000004
 ffff880127b23c40 0000000000000082 ffff880128d38000 ffff880127b23fd8
 ffff880127b23fd8 ffff880127b23fd8 ffffffff81c10440 ffff880128d38000
 ffff880127b23e50 0000000000000246 ffff880128d38000 ffff880127b23fd8
Call Trace:
 [<ffffffff816c2fd3>] schedule_preempt_disabled+0x33/0x80
 [<ffffffff816bfcc1>] mutex_lock_nested+0x1a1/0x3d0
 [<ffffffff816bb512>] ? lookup_slow+0x13f/0x1b8
 [<ffffffff816bb512>] ? lookup_slow+0x13f/0x1b8
 [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8
 [<ffffffff811c805a>] ? lookup_fast+0x16a/0x2d0
 [<ffffffff811c9d7c>] path_lookupat+0x79c/0x7c0
 [<ffffffff8119fa87>] ? kmem_cache_alloc+0xf7/0x340
 [<ffffffff811c826a>] ? getname_flags+0x5a/0x1a0
 [<ffffffff811c9dd4>] filename_lookup+0x34/0xc0
 [<ffffffff811ccd23>] user_path_at_empty+0x63/0xa0
 [<ffffffff8119fa87>] ? kmem_cache_alloc+0xf7/0x340
 [<ffffffff81078c32>] ? creds_are_invalid.part.8+0x12/0x50
 [<ffffffff81078f6a>] ? prepare_creds+0x3a/0x1f0
 [<ffffffff811ccd71>] user_path_at+0x11/0x20
 [<ffffffff811bb093>] sys_faccessat+0xa3/0x230
 [<ffffffff816cd102>] system_call_fastpath+0x16/0x1b

trinity-child2  D ffff880110b3a7e0  5704 10021  29705 0x00000004
 ffff8801228a7be0 0000000000000086 ffff880128c18000 ffff8801228a7fd8
 ffff8801228a7fd8 ffff8801228a7fd8 ffffffff81c10440 ffff880128c18000
 ffff8801228a7df0 0000000000000246 ffff880128c18000 ffff8801228a7fd8
Call Trace:
 [<ffffffff816c2fd3>] schedule_preempt_disabled+0x33/0x80
 [<ffffffff816bfcc1>] mutex_lock_nested+0x1a1/0x3d0
 [<ffffffff816bb512>] ? lookup_slow+0x13f/0x1b8
 [<ffffffff816bb512>] ? lookup_slow+0x13f/0x1b8
 [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8
 [<ffffffff811c805a>] ? lookup_fast+0x16a/0x2d0
 [<ffffffff8100a144>] ? native_sched_clock+0x24/0x80
 [<ffffffff811c9d7c>] path_lookupat+0x79c/0x7c0
 [<ffffffff8119fa87>] ? kmem_cache_alloc+0xf7/0x340
 [<ffffffff811c826a>] ? getname_flags+0x5a/0x1a0
 [<ffffffff811c9dd4>] filename_lookup+0x34/0xc0
 [<ffffffff811ccd23>] user_path_at_empty+0x63/0xa0
 [<ffffffff8116fbdc>] ? might_fault+0x9c/0xb0
 [<ffffffff811ccd71>] user_path_at+0x11/0x20
 [<ffffffff811c1379>] vfs_fstatat+0x49/0x90
 [<ffffffff811c1917>] sys_newlstat+0x27/0x40
 [<ffffffff810b6b95>] ? trace_hardirqs_on_caller+0x115/0x1a0
 [<ffffffff8134a24e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff816cd102>] system_call_fastpath+0x16/0x1b

trinity-child0  D ffff880110b3a7e0  5624 10222  29705 0x00000004
 ffff8801005ebc50 0000000000000086 ffff880101872490 ffff8801005ebfd8
 ffff8801005ebfd8 ffff8801005ebfd8 ffffffff81c10440 ffff880101872490
 ffff8801005ebe60 0000000000000246 ffff880101872490 ffff8801005ebfd8
Call Trace:
 [<ffffffff816c2fd3>] schedule_preempt_disabled+0x33/0x80
 [<ffffffff816bfcc1>] mutex_lock_nested+0x1a1/0x3d0
 [<ffffffff816bb512>] ? lookup_slow+0x13f/0x1b8
 [<ffffffff816bb512>] ? lookup_slow+0x13f/0x1b8
 [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8
 [<ffffffff811c805a>] ? lookup_fast+0x16a/0x2d0
 [<ffffffff811c9d7c>] path_lookupat+0x79c/0x7c0
 [<ffffffff8119fa87>] ? kmem_cache_alloc+0xf7/0x340
 [<ffffffff811c826a>] ? getname_flags+0x5a/0x1a0
 [<ffffffff811c9dd4>] filename_lookup+0x34/0xc0
 [<ffffffff811ccd23>] user_path_at_empty+0x63/0xa0
 [<ffffffff810b33a2>] ? get_lock_stats+0x22/0x70
 [<ffffffff810b6c2d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff816c4787>] ? _raw_spin_unlock_irq+0x37/0x60
 [<ffffffff816cd127>] ? sysret_check+0x1b/0x56
 [<ffffffff811ccd71>] user_path_at+0x11/0x20
 [<ffffffff811bb626>] sys_fchownat+0x66/0x110
 [<ffffffff816cd102>] system_call_fastpath+0x16/0x1b


runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------


Showing all locks held in the system:
4 locks on stack by trinity-child2/7669:
 #0: blocked:  (sb_writers#4){.+.+.+}, instance: ffff8801292d17d8, at: [<ffffffff811df134>] mnt_want_write+0x24/0x50
 #1: held:     (&type->s_vfs_rename_key){+.+.+.}, instance: ffff8801292d1928, at: [<ffffffff811c6f5e>] lock_rename+0x3e/0x120
 #2: held:     (&type->i_mutex_dir_key#2/1){+.+.+.}, instance: ffff880110b3a858, at: [<ffffffff811c701e>] lock_rename+0xfe/0x120
 #3: blocked:  (&type->i_mutex_dir_key#2/2){+.+.+.}, instance: ffff880110b3a858, at: [<ffffffff811c7034>] lock_rename+0x114/0x120
1 lock on stack by trinity-child1/7901:
 #0: blocked:  (&type->i_mutex_dir_key#2){+.+.+.}, instance: ffff880110b3a858, at: [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8
1 lock on stack by trinity-child1/8651:
 #0: blocked:  (&type->i_mutex_dir_key#2){+.+.+.}, instance: ffff880110b3a858, at: [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8
1 lock on stack by trinity-child3/9067:
 #0: blocked:  (&type->i_mutex_dir_key#2){+.+.+.}, instance: ffff880110b3a858, at: [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8
1 lock on stack by trinity-child0/9112:
 #0: blocked:  (&type->i_mutex_dir_key#2){+.+.+.}, instance: ffff880110b3a858, at: [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8
1 lock on stack by trinity-child3/9414:
 #0: blocked:  (&type->i_mutex_dir_key#2){+.+.+.}, instance: ffff880110b3a858, at: [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8
1 lock on stack by trinity-child2/10021:
 #0: blocked:  (&type->i_mutex_dir_key#2){+.+.+.}, instance: ffff880110b3a858, at: [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8
1 lock on stack by trinity-child0/10222:
 #0: blocked:  (&type->i_mutex_dir_key#2){+.+.+.}, instance: ffff880110b3a858, at: [<ffffffff816bb512>] lookup_slow+0x13f/0x1b8


