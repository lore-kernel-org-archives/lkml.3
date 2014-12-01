Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598AbaLAVOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:14:06 -0500
Received: from 4133fa24.cst.lightpath.net ([65.51.250.36]:44306 "EHLO
	mail1.intricatesoftware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932112AbaLAVOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:14:04 -0500
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Dec 2014 16:14:04 EST
Message-ID: <1417468100.27152.40.camel@sonic.justonedata.com>
Subject: 3.10 page_fault/mmap_sem/hugepages deadlock
From: Kurt Miller <kurt@intricatesoftware.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 01 Dec 2014 16:08:20 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SMTP-Vilter-Version: 1.3.8
X-SMTP-Vilter-Virus-Backend: clamd
X-SMTP-Vilter-Status: clean
X-SMTP-Vilter-clamd-Virus-Status: clean
X-Spamd-Symbols: BAYES_00,RCVD_IN_PBL,RCVD_IN_SORBS_DUL,RDNS_DYNAMIC,USER_IN_WHITELIST
X-SMTP-Vilter-Spam-Backend: spamd
X-Spam-Score: -97.6
X-Spam-Threshold: 5.0
X-Spam-Probability: -19.5
X-SMTP-Vilter-Unwanted-Backend: attachment
X-SMTP-Vilter-attachment-Unwanted-Status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.10.0-123.9.3.el7.x86_64 I am seeing a deadlock on mmap_sem which
causes ps(1) and similar utilities to freeze and our application to stop
functioning. Looking at the kernel crash dump (first time for me), it
looks like a page fault on a huge page is holding the mmap_sem and then
goes to sleep. The other processes such as khugepaged, ps(1), pgrep(1)
and netstat(8) are all blocked on mmap_sem and are unkillable with kill
-9.

The back trace for the suspect problem page fault looks like this:

crash> bt -l 2045
PID: 2045   TASK: ffff881002f35b00  CPU: 22  COMMAND: "icd"
 #0 [ffff880fdc9edbe8] __schedule at ffffffff815e75fd
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/kernel/sched/core.c: 2164
 #1 [ffff880fdc9edc50] io_schedule at ffffffff815e7e5d
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/arch/x86/include/asm/current.h: 14
 #2 [ffff880fdc9edc68] sleep_on_page at ffffffff8114112e
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/mm/filemap.c: 247
 #3 [ffff880fdc9edc78] __wait_on_bit at ffffffff815e5c20
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/kernel/wait.c: 203
 #4 [ffff880fdc9edcb8] wait_on_page_bit at ffffffff81140eb6
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/mm/filemap.c: 691
 #5 [ffff880fdc9edd10] wait_migrate_huge_page at ffffffff8119b7fb
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/mm/migrate.c: 1670
 #6 [ffff880fdc9edd20] do_huge_pmd_numa_page at ffffffff8119e62f
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/mm/huge_memory.c: 1315
 #7 [ffff880fdc9edd98] handle_mm_fault at ffffffff8116c324
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/mm/memory.c: 3748
 #8 [ffff880fdc9ede28] __do_page_fault at ffffffff815edb06
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/arch/x86/mm/fault.c: 1193
 #9 [ffff880fdc9edf28] do_page_fault at ffffffff815edf0a
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/arch/x86/mm/fault.c: 1233
#10 [ffff880fdc9edf50] page_fault at ffffffff815ea148
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/arch/x86/kernel/entry_64.S: 1511
    RIP: 000000000046e9da  RSP: 00007fb0cf52bdc0  RFLAGS: 00010202
    RAX: 00007fb0af1c4ec0  RBX: 00007fb06c000c00  RCX: b88ef6a13246e1d9
    RDX: c130973455498b41  RSI: 00007fb0b1b96000  RDI: 00007fb0af1c4ec0
    RBP: 00007fb0cf52be10   R8: 0000000000000000   R9: 00000000000007fd
    R10: 0000000000000000  R11: 00007fb0dac86280  R12: 0000000000000000
    R13: 00007fb0cf52d9c0  R14: 00007fb0cf52d700  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0033  SS: 002b

In frame 8, __do_page_fault() calls down_read(&mm->mmap_sem) on line 1138
and looks like it is holding it when it calls handle_mm_fault() on line 1193.
It looks like handle_mm_fault() eventually sleeps holding mmap_sem and doesn't
wake up.

The above process is hung up like ps(1) and friends and unkillable with kill -9.

khugepaged is blocked waiting for mmap_sem as well in frame 4 below:

crash> bt -l 206
PID: 206    TASK: ffff8808043138e0  CPU: 7   COMMAND: "khugepaged"
 #0 [ffff881001d7bc48] __schedule at ffffffff815e75fd
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/kernel/sched/core.c: 2164
 #1 [ffff881001d7bcb0] schedule at ffffffff815e7b39
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/kernel/sched/core.c: 3215
 #2 [ffff881001d7bcc0] rwsem_down_read_failed at ffffffff815e9655
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/lib/rwsem.c: 179
 #3 [ffff881001d7bd70] down_read at ffffffff815e6f20
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/kernel/rwsem.c: 24
 #4 [ffff881001d7bd88] khugepaged_scan_mm_slot at ffffffff8119cd24
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/arch/x86/include/asm/atomic.h: 25
 #5 [ffff881001d7be48] khugepaged at ffffffff8119dbaf
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/include/linux/spinlock.h: 333
 #6 [ffff881001d7bec8] kthread at ffffffff81085aff
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/kernel/kthread.c: 200
 #7 [ffff881001d7bf50] ret_from_fork at ffffffff815f29ec
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/arch/x86/kernel/entry_64.S: 570

ps(1), pgrep(1) and netstat(8) are all blocked in the same way.
__access_remote_vm() is blocked waiting on down_read(&mm->mmap_sem).

I'll include one back trace as an example:

crash> bt -l 8846
PID: 8846   TASK: ffff880fff78f1c0  CPU: 19  COMMAND: "ps"
 #0 [ffff880f30431c68] __schedule at ffffffff815e75fd
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/kernel/sched/core.c: 2164
 #1 [ffff880f30431cd0] schedule at ffffffff815e7b39
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/kernel/sched/core.c: 3215
 #2 [ffff880f30431ce0] rwsem_down_read_failed at ffffffff815e9655
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/lib/rwsem.c: 179
 #3 [ffff880f30431d50] call_rwsem_down_read_failed at ffffffff812c6414
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/arch/x86/lib/rwsem.S: 94
 #4 [ffff880f30431db0] __access_remote_vm at ffffffff8116d251
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/mm/memory.c: 4022
 #5 [ffff880f30431e40] access_process_vm at ffffffff8116e090
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/mm/memory.c: 4104
 #6 [ffff880f30431e80] proc_pid_cmdline at ffffffff81217a2a
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/fs/proc/base.c: 222
 #7 [ffff880f30431ec0] proc_info_read at ffffffff81218e8f
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/fs/proc/base.c: 654
 #8 [ffff880f30431f08] vfs_read at ffffffff811af57c
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/fs/read_write.c: 388
 #9 [ffff880f30431f38] sys_read at ffffffff811b00a8
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/fs/read_write.c: 489
#10 [ffff880f30431f80] system_call_fastpath at ffffffff815f2a99
    /usr/src/debug/kernel-3.10.0-123.9.3.el7/linux-3.10.0-123.9.3.el7.x86_64/arch/x86/kernel/entry_64.S: 645
    RIP: 00007fa31a3a5ce0  RSP: 00007fffe3b13d48  RFLAGS: 00000246
    RAX: 0000000000000000  RBX: ffffffff815f2a99  RCX: ffffffffffffffff
    RDX: 0000000000020000  RSI: 00007fa31ae80010  RDI: 0000000000000006
    RBP: 0000000000020000   R8: 00007fa31a306dff   R9: 0000000000000012
    R10: 0000000000000007  R11: 0000000000000246  R12: 0000000000000000
    R13: 00007fa31ae80010  R14: 0000000000000000  R15: 00007fa31ae80010
    ORIG_RAX: 0000000000000000  CS: 0033  SS: 002b

I searched the archives for similar reports and found this thread from 2010:
http://marc.info/?l=linux-kernel&m=127005640811303&w=2
But that seems like it was resolved long ago.

Please let me know if any additional information is needed to help
diagnose the problem. I can reproduce it under heavy load in about
24 hours.

Regards,
-Kurt

