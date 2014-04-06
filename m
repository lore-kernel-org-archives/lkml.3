Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbaDFO2X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 10:28:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51998 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbaDFO2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 10:28:21 -0400
Message-ID: <5341647D.8010103@oracle.com>
Date: Sun, 06 Apr 2014 10:28:13 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: reiserfs-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: reiserfs: REISERFS panic (device loop0): journal-003 check_journal_end:
 j_start (3452) is too high
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel, I've stumbled on the following:

[ 3680.222129] REISERFS panic (device loop0): journal-003 check_journal_end: j_start (3452) is too high
[ 3680.223125] ------------[ cut here ]------------
[ 3680.223571] kernel BUG at fs/reiserfs/prints.c:367!
[ 3680.224317] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 3680.225190] Dumping ftrace buffer:
[ 3680.225529] ---------------------------------
[ 3680.226017]  kswapd1-4007    1...1 35142723758us : mm_vmscan_kswapd_sleep: nid=1
[ 3680.227189] ---------------------------------
[ 3680.227948] Modules linked in:
[ 3680.228460] CPU: 6 PID: 21513 Comm: kworker/6:1 Not tainted 3.14.0-next-20140403-sasha-00022-g10224c0 #377
[ 3680.229927] Workqueue: events_long flush_old_commits
[ 3680.230154] task: ffff880172d58000 ti: ffff880182ae6000 task.ti: ffff880182ae6000
[ 3680.230154] RIP: __reiserfs_panic (fs/reiserfs/prints.c:367)
[ 3680.230154] RSP: 0018:ffff880182ae7b68  EFLAGS: 00010292
[ 3680.230154] RAX: 0000000000000058 RBX: ffffffff967775a3 RCX: 0000000000000006
[ 3680.230154] RDX: 00000000000070e0 RSI: ffffffff9681c2bc RDI: 0000000000000282
[ 3680.230154] RBP: ffff880182ae7bd8 R08: 0000000000000000 R09: 0000000000000000
[ 3680.230154] R10: 0000000000000001 R11: 68676968206f6f74 R12: ffff88009496c520
[ 3680.230154] R13: ffffffff956731f0 R14: ffffc90007d84000 R15: ffff88009496c520
[ 3680.230154] FS:  0000000000000000(0000) GS:ffff88018b000000(0000) knlGS:0000000000000000
[ 3680.230154] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 3680.230154] CR2: 00000000021b1258 CR3: 0000000016e2c000 CR4: 00000000000006a0
[ 3680.230154] Stack:
[ 3680.230154]  ffff880182ae7b78 ffffffff00000028 ffff880182ae7be8 ffff880182ae7b88
[ 3680.230154]  0000000000000000 ffff8800940f1290 0000000000000000 0000000000000000
[ 3680.230154]  0000000000000d7c 0000000000016485 ffff880182ae7bd8 ffffc90007d84000
[ 3680.230154] Call Trace:
[ 3680.230154] do_journal_end.isra.16 (fs/reiserfs/journal.c:947 fs/reiserfs/journal.c:3901)
[ 3680.230154] ? _raw_spin_unlock (arch/x86/include/asm/preempt.h:98 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:183)
[ 3680.230154] ? reiserfs_schedule_old_flush (fs/reiserfs/super.c:113)
[ 3680.230154] journal_end_sync (fs/reiserfs/journal.c:3429)
[ 3680.230154] reiserfs_sync_fs (fs/reiserfs/super.c:77)
[ 3680.230154] flush_old_commits (fs/reiserfs/super.c:96)
[ 3680.230154] process_one_work (kernel/workqueue.c:2221 include/linux/jump_label.h:105 include/trace/events/workqueue.h:111 kernel/workqueue.c:2226)
[ 3680.230154] ? process_one_work (include/linux/workqueue.h:186 kernel/workqueue.c:611 kernel/workqueue.c:638 kernel/workqueue.c:2214)
[ 3680.252625] worker_thread (kernel/workqueue.c:2348)
[ 3680.252625] ? rescuer_thread (kernel/workqueue.c:2297)
[ 3680.252625] kthread (kernel/kthread.c:219)
[ 3680.252625] ? kthread_create_on_node (kernel/kthread.c:185)
[ 3680.252625] ret_from_fork (arch/x86/kernel/entry_64.S:555)
[ 3680.252625] ? kthread_create_on_node (kernel/kthread.c:185)
[ 3680.252625] Code: 9f d2 7f 96 75 0a 48 c7 c2 da e8 8d 96 48 89 d3 49 c7 c0 80 4e 51 99 4c 89 e9 48 89 de 48 c7 c7 5c 6b 77 96 31 c0 e8 09 af 0d 03 <0f> 0b 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5 48 83
[ 3680.252625] RIP __reiserfs_panic (fs/reiserfs/prints.c:367)
[ 3680.252625]  RSP <ffff880182ae7b68>


Thanks,
Sasha
