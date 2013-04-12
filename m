Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab3DLFeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 01:34:37 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:33572 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab3DLFef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 01:34:35 -0400
MIME-Version: 1.0
Date: Fri, 12 Apr 2013 08:34:33 +0300
Message-ID: <CA+ydwtrhpd2C3sK6B49qdoWg-k97gBXFDgnKXY2Mcb_wSsMiXQ@mail.gmail.com>
Subject: sw_perf_event_destroy() oops while fuzzing
From: Tommi Rantala <tt.rantala@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Saw these oopses while fuzzing with trinity.

I have some local modifications to trinity that might explain why Dave
and others have not hit this before.

Tommi

[91911.171328] warning: process `trinity-child7' used the deprecated
sysctl system call with 1029078728.32609.1029078728.32609.
[92425.932588] uhci_hcd 0000:00:1a.0: release dev 3 ep83-INT, period
32, phase 16, 12 us
[92426.354076] uhci_hcd 0000:00:1a.0: reserve dev 3 ep85-ISO, period
1, phase 0, 608 us
[92426.354179] uhci_hcd 0000:00:1a.0: reserve dev 3 ep83-INT, period
32, phase 16, 12 us
[92452.851590] uhci_hcd 0000:00:1a.0: release dev 3 ep85-ISO, period
1, phase 0, 608 us
[92452.858588] uhci_hcd 0000:00:1a.0: release dev 3 ep83-INT, period
32, phase 16, 12 us
[92452.866444] uhci_hcd 0000:00:1a.0: reserve dev 3 ep83-INT, period
32, phase 16, 12 us
[92759.010298] BUG: unable to handle kernel paging request at 0000000383c366b0
[92759.010341] IP: [<ffffffff811a7200>] sw_perf_event_destroy+0x30/0x90
[92759.010380] PGD 20d58c067 PUD 0
[92759.010404] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[92759.010436] CPU 1
[92759.010450] Pid: 21000, comm: trinity-child29 Not tainted
3.9.0-rc6+ #183 Dell Inc. OptiPlex 960                 /0G261D
[92759.010507] RIP: 0010:[<ffffffff811a7200>]  [<ffffffff811a7200>]
sw_perf_event_destroy+0x30/0x90
[92759.010551] RSP: 0018:ffff88020d4c5e38  EFLAGS: 00010246
[92759.010579] RAX: ffffffff811a71d0 RBX: ffff8801fea7dcd0 RCX: 0000000000000e60
[92759.010607] RDX: ffff88022dc14bc0 RSI: 0000000000000000 RDI: ffff8801fea7dcd0
[92759.010635] RBP: ffff88020d4c5e48 R08: 0000000000000001 R09: 0000000000000000
[92759.010663] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000ffffff4c
[92759.010691] R13: ffff8801fea7dcd0 R14: 00000000000002f9 R15: ffffffffffffffea
[92759.010720] FS:  00007f613d98f700(0000) GS:ffff88022dc00000(0000)
knlGS:0000000000000000
[92759.010754] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[92759.010777] CR2: 0000000383c366b0 CR3: 0000000229733000 CR4: 00000000000407e0
[92759.010805] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[92759.010833] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[92759.010862] Process trinity-child29 (pid: 21000, threadinfo
ffff88020d4c4000, task ffff8801febb47c0)
[92759.010898] Stack:
[92759.010908]  ffff8801fea7dcd0 0000000000000000 ffff88020d4c5e68
ffffffff811a789d
[92759.010946]  00000000000002f9 0000000000000000 ffff88020d4c5f78
ffffffff811af8d1
[92759.010983]  0000000000000000 ffff880229ae07b8 ffff88020d4c5f28
0000000000000040
[92759.011005] Call Trace:
[92759.011005]  [<ffffffff811a789d>] free_event+0xdd/0x110
[92759.011005]  [<ffffffff811af8d1>] sys_perf_event_open+0x931/0xa50
[92759.011005]  [<ffffffff81150685>] ? trace_hardirqs_on_caller+0x155/0x1f0
[92759.011005]  [<ffffffff822d0c55>] ? sysret_check+0x22/0x5d
[92759.011005]  [<ffffffff822d0c29>] system_call_fastpath+0x16/0x1b
[92759.011005] Code: 54 53 48 83 bf 88 02 00 00 00 48 89 fb 4c 8b a7
a8 00 00 00 74 15 be cd 14 00 00 48 c7 c7 50 3e 9c 82 e8 14 99 f4 ff
0f 1f 40 00 <f0> 42 ff 0c a5 80 69 c3 83 8b bb 94 02 00 00 83 ff ff 75
0c 4c
[92759.011005] RIP  [<ffffffff811a7200>] sw_perf_event_destroy+0x30/0x90
[92759.011005]  RSP <ffff88020d4c5e38>
[92759.011005] CR2: 0000000383c366b0
[92759.018790] ---[ end trace dda45d33c915bb60 ]---
[93318.817441] hid-generic 0003:05AC:020C.0001: pid 10943 passed too
short report
[95750.582278] usb 4-2.3: trinity-child17 timed out on ep0out len=8/311
[95750.629302] hid-generic 0003:05AC:020C.0001: pid 16838 passed too
short report
[95842.996683] sock: sock_set_timeout: `trinity-child2' (pid 17463)
tries to set negative timeout
[96743.777546] uhci_hcd 0000:00:1a.0: release dev 3 ep83-INT, period
32, phase 16, 12 us
[96744.103043] uhci_hcd 0000:00:1a.0: reserve dev 3 ep85-ISO, period
1, phase 0, 608 us
[96744.103122] uhci_hcd 0000:00:1a.0: reserve dev 3 ep83-INT, period
32, phase 16, 12 us
[96765.040554] uhci_hcd 0000:00:1a.0: release dev 3 ep85-ISO, period
1, phase 0, 608 us
[96765.054539] uhci_hcd 0000:00:1a.0: release dev 3 ep83-INT, period
32, phase 16, 12 us
[96765.072391] uhci_hcd 0000:00:1a.0: reserve dev 3 ep83-INT, period
32, phase 16, 12 us
[97328.032090] hid-generic 0003:05AC:020C.0001: pid 26780 passed too
short report
[97584.159890] hid-generic 0003:05AC:020C.0002: pid 28529 passed too
short report
[97584.164604] hid-generic 0003:05AC:020C.0002: pid 28529 passed too
large report
[97763.974233] irda_setsockopt: not allowed to set MAXSDUSIZE for this
socket type!
[98050.598832] uhci_hcd 0000:00:1a.0: release dev 3 ep83-INT, period
32, phase 16, 12 us
[98051.000874] uhci_hcd 0000:00:1a.0: reserve dev 3 ep85-ISO, period
1, phase 0, 608 us
[98051.002305] uhci_hcd 0000:00:1a.0: reserve dev 3 ep83-INT, period
32, phase 16, 12 us
[98066.969839] uhci_hcd 0000:00:1a.0: release dev 3 ep85-ISO, period
1, phase 0, 608 us
[98066.971827] uhci_hcd 0000:00:1a.0: release dev 3 ep83-INT, period
32, phase 16, 12 us
[98066.974803] uhci_hcd 0000:00:1a.0: reserve dev 3 ep83-INT, period
32, phase 16, 12 us
[98498.997908] hid-generic 0003:05AC:020C.0001: pid 1547 passed too short report
[98741.224526] hid-generic 0003:05AC:020C.0002: pid 3143 passed too short report
[99011.479889] irda_setsockopt: not allowed to set MAXSDUSIZE for this
socket type!
[99175.909698] irda_setsockopt: not allowed to set MAXSDUSIZE for this
socket type!
[100086.408287] uhci_hcd 0000:00:1a.0: release dev 3 ep83-INT, period
32, phase 16, 12 us
[100086.811309] uhci_hcd 0000:00:1a.0: reserve dev 3 ep85-ISO, period
1, phase 0, 608 us
[100086.812742] uhci_hcd 0000:00:1a.0: reserve dev 3 ep83-INT, period
32, phase 16, 12 us
[100120.745295] uhci_hcd 0000:00:1a.0: release dev 3 ep85-ISO, period
1, phase 0, 608 us
[100120.747288] uhci_hcd 0000:00:1a.0: release dev 3 ep83-INT, period
32, phase 16, 12 us
[100120.750408] uhci_hcd 0000:00:1a.0: reserve dev 3 ep83-INT, period
32, phase 16, 12 us
[100652.599883] irda_setsockopt: not allowed to set MAXSDUSIZE for
this socket type!
[100666.061821] irda_setsockopt: not allowed to set MAXSDUSIZE for
this socket type!
[102647.003371] hid-generic 0003:05AC:020C.0002: pid 28258 passed too
short report
[102653.360048] hid-generic 0003:05AC:020C.0002: pid 28228 passed too
short report
[102832.205637] irda_setsockopt: not allowed to set MAXSDUSIZE for
this socket type!
[102994.495114] hid-generic 0003:05AC:020C.0001: pid 30322 passed too
short report
[103512.879988] irda_setsockopt: not allowed to set MAXSDUSIZE for
this socket type!
[103555.898115] irda_setsockopt: not allowed to set MAXSDUSIZE for
this socket type!
[103652.416935] hid-generic 0003:05AC:020C.0001: pid 2145 passed too
large report
[103657.749513] irda_setsockopt: not allowed to set MAXSDUSIZE for
this socket type!
[105316.030453] uhci_hcd 0000:00:1a.0: release dev 3 ep83-INT, period
32, phase 16, 12 us
[105316.330494] uhci_hcd 0000:00:1a.0: reserve dev 3 ep85-ISO, period
1, phase 0, 608 us
[105316.332246] uhci_hcd 0000:00:1a.0: reserve dev 3 ep83-INT, period
32, phase 16, 12 us
[105336.959455] uhci_hcd 0000:00:1a.0: release dev 3 ep85-ISO, period
1, phase 0, 608 us
[105336.961448] uhci_hcd 0000:00:1a.0: release dev 3 ep83-INT, period
32, phase 16, 12 us
[105336.964806] uhci_hcd 0000:00:1a.0: reserve dev 3 ep83-INT, period
32, phase 16, 12 us
[105847.229187] irda_setsockopt: not allowed to set MAXSDUSIZE for
this socket type!
[106641.872712] usb 4-2.3: trinity-child22 timed out on ep0out len=8/511
[106643.162285] hid-generic 0003:05AC:020C.0001: pid 20764 passed too
large report
[107063.804445] hid-generic 0003:05AC:020C.0002: pid 23475 passed too
short report
[107384.854030] usb 4-2.3: trinity-child2 timed out on ep0out len=8/4096
[107953.633604] irda_setsockopt: not allowed to set MAXSDUSIZE for
this socket type!
[108970.022826] irda_setsockopt: not allowed to set MAXSDUSIZE for
this socket type!
[109238.722173] irda_setsockopt: not allowed to set MAXSDUSIZE for
this socket type!
[109246.510970] irda_setsockopt: not allowed to set MAXSDUSIZE for
this socket type!
[111026.344840] usb 4-2.3: trinity-child10 timed out on ep0out len=8/4095
[111270.094778] uhci_hcd 0000:00:1a.0: release dev 3 ep83-INT, period
32, phase 16, 12 us
[111270.516802] uhci_hcd 0000:00:1a.0: reserve dev 3 ep85-ISO, period
1, phase 0, 608 us
[111270.518054] uhci_hcd 0000:00:1a.0: reserve dev 3 ep83-INT, period
32, phase 16, 12 us
[111305.716797] uhci_hcd 0000:00:1a.0: release dev 3 ep85-ISO, period
1, phase 0, 608 us
[111305.718775] uhci_hcd 0000:00:1a.0: release dev 3 ep83-INT, period
32, phase 16, 12 us
[111305.721574] uhci_hcd 0000:00:1a.0: reserve dev 3 ep83-INT, period
32, phase 16, 12 us
[111837.539516] hrtimer: interrupt took 3474 ns
[112108.919163] hid-generic 0003:05AC:020C.0001: pid 22733 passed too
short report
[114607.069257] BUG: unable to handle kernel paging request at 0000000383c35328
[114607.070003] IP: [<ffffffff811a7200>] sw_perf_event_destroy+0x30/0x90
[114607.070003] PGD 1bc2ef067 PUD 0
[114607.070003] Oops: 0002 [#2] SMP DEBUG_PAGEALLOC
[114607.070003] CPU 0
[114607.070003] Pid: 5498, comm: trinity-child14 Tainted: G      D
 3.9.0-rc6+ #183 Dell Inc. OptiPlex 960                 /0G261D
[114607.070003] RIP: 0010:[<ffffffff811a7200>]  [<ffffffff811a7200>]
sw_perf_event_destroy+0x30/0x90
[114607.070003] RSP: 0018:ffff8800b198bb48  EFLAGS: 00010246
[114607.070003] RAX: ffffffff811a71d0 RBX: ffff8800b9544a40 RCX:
00000000158207da
[114607.070003] RDX: ffff8801febb0000 RSI: ffffffff822cc585 RDI:
ffff8800b9544a40
[114607.070003] RBP: ffff8800b198bb58 R08: ffff8800b9544a40 R09:
0000000000000000
[114607.070003] R10: dead000000200200 R11: 0000000000000000 R12:
00000000fffffa6a
[114607.070003] R13: ffff88001b1fdf80 R14: ffff8800b9544cd8 R15:
ffff88022c48cb60
[114607.070003] FS:  00007f3446e87700(0000) GS:ffff88022da00000(0000)
knlGS:0000000000000000
[114607.070003] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[114607.070003] CR2: 0000000383c35328 CR3: 0000000189eb2000 CR4:
00000000000407f0
[114607.070003] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[114607.070003] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[114607.070003] Process trinity-child14 (pid: 5498, threadinfo
ffff8800b198a000, task ffff8801febb0000)
[114607.070003] Stack:
[114607.070003]  ffff8800b9544a40 ffff88001b1fdf38 ffff8800b198bb78
ffffffff811a789d
[114607.070003]  ffff8800b198bb78 ffff8800b9544a40 ffff8800b198bba8
ffffffff811a8c56
[114607.070003]  ffff8801febb1258 ffff8800b9544a40 ffff8801febb0000
ffff8801febb1258
[114607.070003] Call Trace:
[114607.070003]  [<ffffffff811a789d>] free_event+0xdd/0x110
[114607.070003]  [<ffffffff811a8c56>] perf_event_release_kernel+0x96/0xb0
[114607.070003]  [<ffffffff811a8deb>] put_event+0x17b/0x190
[114607.070003]  [<ffffffff811a8c9e>] ? put_event+0x2e/0x190
[114607.070003]  [<ffffffff811a8ee0>] perf_release+0x10/0x20
[114607.070003]  [<ffffffff81210dea>] __fput+0x12a/0x230
[114607.070003]  [<ffffffff81210ef9>] ____fput+0x9/0x10
[114607.070003]  [<ffffffff81117a0e>] task_work_run+0xae/0xf0
[114607.070003]  [<ffffffff810f6f9c>] do_exit+0x44c/0xb60
[114607.070003]  [<ffffffff8110a519>] ? get_signal_to_deliver+0xf9/0x930
[114607.070003]  [<ffffffff811b6b48>] ? generic_file_aio_write+0xc8/0xf0
[114607.070003]  [<ffffffff810f7774>] do_group_exit+0x84/0xd0
[114607.070003]  [<ffffffff8110ac4d>] get_signal_to_deliver+0x82d/0x930
[114607.070003]  [<ffffffff81063402>] do_signal+0x52/0x570
[114607.070003]  [<ffffffff81254771>] ? fsnotify+0x4e1/0x560
[114607.070003]  [<ffffffff8125431d>] ? fsnotify+0x8d/0x560
[114607.070003]  [<ffffffff81063947>] do_notify_resume+0x27/0x70
[114607.070003]  [<ffffffff814c1e2e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[114607.070003]  [<ffffffff822d0f62>] int_signal+0x12/0x17
[114607.070003] Code: 54 53 48 83 bf 88 02 00 00 00 48 89 fb 4c 8b a7
a8 00 00 00 74 15 be cd 14 00 00 48 c7 c7 50 3e 9c 82 e8 14 99 f4 ff
0f 1f 40 00 <f0> 42 ff 0c a5 80 69 c3 83 8b bb 94 02 00 00 83 ff ff 75
0c 4c
[114607.070003] RIP  [<ffffffff811a7200>] sw_perf_event_destroy+0x30/0x90
[114607.070003]  RSP <ffff8800b198bb48>
[114607.070003] CR2: 0000000383c35328
[114607.157127] ---[ end trace dda45d33c915bb61 ]---
[114607.158255] Fixing recursive fault but reboot is needed!
[117235.958075] hid-generic 0003:05AC:020C.0002: pid 20314 passed too
short report
[117452.895339] atalk_connect: trinity-child0 is broken and did not
set SO_BROADCAST.
[118718.722253] irda_setsockopt: not allowed to set MAXSDUSIZE for
this socket type!
[118897.261172] ib_core:ibnl_rcv_msg: Index 43 wasn't found in client list
[119195.324549] uhci_hcd 0000:00:1a.0: release dev 3 ep83-INT, period
32, phase 16, 12 us
[119195.606565] uhci_hcd 0000:00:1a.0: reserve dev 3 ep85-ISO, period
1, phase 0, 608 us
