Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab3BQRsW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 12:48:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:42312 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3BQRsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 12:48:21 -0500
Message-ID: <512117D5.3050602@oracle.com>
Date: Sun, 17 Feb 2013 12:48:05 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>, serge.hallyn@canonical.com
CC: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: BUG in find_pid_ns
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest, running latest -next kernel,
I've stumbled on the following spew:

[  400.345287] BUG: unable to handle kernel paging request at fffffffffffffff0
[  400.346614] IP: [<ffffffff81131d50>] find_pid_ns+0x110/0x1f0
[  400.347649] PGD 5429067 PUD 542b067 PMD 0
[  400.348459] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  400.351166] Dumping ftrace buffer:
[  400.352884]    (ftrace buffer empty)
[  400.354640] Modules linked in:
[  400.355021] CPU 1
[  400.355021] Pid: 6890, comm: trinity Tainted: G        W    3.8.0-rc7-next-20130215-sasha-00027-gb399f44-dirty #288
[  400.355021] RIP: 0010:[<ffffffff81131d50>]  [<ffffffff81131d50>] find_pid_ns+0x110/0x1f0
[  400.375245] RSP: 0018:ffff8800aedb5e18  EFLAGS: 00010286
[  400.380086] RAX: 0000000000000001 RBX: 0000000000007e7d RCX: 0000000000000000
[  400.383643] RDX: 0000000000000001 RSI: ffffffff85466e40 RDI: 0000000000000286
[  400.383643] RBP: ffff8800aedb5e48 R08: 0000000000000001 R09: 0000000000000001
[  400.383643] R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff85466460
[  400.383643] R13: ffff8800bf8d3928 R14: fffffffffffffff0 R15: ffff8800a5b7f140
[  400.383643] FS:  00007faab0ad2700(0000) GS:ffff8800bb800000(0000) knlGS:0000000000000000
[  400.383643] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  400.383643] CR2: fffffffffffffff0 CR3: 00000000b07a1000 CR4: 00000000000406e0
[  400.383643] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  400.383643] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  400.383643] Process trinity (pid: 6890, threadinfo ffff8800aedb4000, task ffff8800b0660000)
[  400.383643] Stack:
[  400.383643]  ffffffff85466e40 0000000000007e7d ffff8800aedb5ed8 0000000000000000
[  400.383643]  0000000000000004 20c49ba5e353f7cf ffff8800aedb5e58 ffffffff81131e5c
[  400.383643]  ffff8800aedb5ec8 ffffffff8112400f ffffffff81123f9c 0000000000000000
[  400.383643] Call Trace:
[  400.383643]  [<ffffffff81131e5c>] find_vpid+0x2c/0x30
[  400.383643]  [<ffffffff81123f9c>] ? kill_something_info+0x2c/0x270
[  400.383643]  [<ffffffff81125e38>] sys_kill+0x88/0xa0
[  400.383643]  [<ffffffff8107ad34>] ? syscall_trace_enter+0x24/0x2e0
[  400.383643]  [<ffffffff811813b8>] ? trace_hardirqs_on_caller+0x128/0x160
[  400.383643]  [<ffffffff83d96275>] ? tracesys+0x7e/0xe6
[  400.383643]  [<ffffffff83d962d8>] tracesys+0xe1/0xe6
[  400.383643] Code: 4d 8b 75 00 e8 b2 0e 00 00 85 c0 0f 84 d2 00 00 00 80 3d fa 17 d5 04 00 0f 85 c5 00 00 00 e9 93 00 00 00 0f
1f 84 00 00 00 00 00 <41> 39 1e 75 2b 4d 39 66 08 75 25 41 8b 84 24 20 08 00 00 48 c1
[  400.383643] RIP  [<ffffffff81131d50>] find_pid_ns+0x110/0x1f0
[  400.383643]  RSP <ffff8800aedb5e18>
[  400.383643] CR2: fffffffffffffff0
[  400.383643] ---[ end trace 5bae629f658bf736 ]---

This points out to:

struct pid *find_pid_ns(int nr, struct pid_namespace *ns)
{
        struct upid *pnr;

        hlist_for_each_entry_rcu(pnr,
                        &pid_hash[pid_hashfn(nr, ns)], pid_chain)
                if (pnr->nr == nr && pnr->ns == ns)		<=== here
                        return container_of(pnr, struct pid,
                                        numbers[ns->level]);

        return NULL;
}


Thanks,
Sasha
