Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab3KUWDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 17:03:17 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:49109 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab3KUWDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 17:03:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUHQ7jQfpxi+s7yeef17-+ApGjU2X1iRnm=azJ0+BFWZw@mail.gmail.com>
References: <20131113151718.GN21461@twins.programming.kicks-ass.net>
	<tip-9abf24d465180f5f2eb26a43545348262f16b771@git.kernel.org>
	<CAE9FiQUk2Mr+4WypL41tCp3+54Aa+CT-17ga9+RffscUxwWAAg@mail.gmail.com>
	<20131121150344.GG10022@twins.programming.kicks-ass.net>
	<CAE9FiQUHQ7jQfpxi+s7yeef17-+ApGjU2X1iRnm=azJ0+BFWZw@mail.gmail.com>
Date: Thu, 21 Nov 2013 14:03:13 -0800
X-Google-Sender-Auth: 9V9Bf335E0XfspiOszQUsKnfr7U
Message-ID: <CAE9FiQUCPvzeiCSan34aV6hfrDHdV=sfHug0tMaAgpOMbum7jw@mail.gmail.com>
Subject: Re: [tip:sched/urgent] sched: Check sched_domain before computing
 group power
From: Yinghai Lu <yinghai@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        srikar@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 9:22 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Nov 21, 2013 at 7:03 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>>
>>> This one seems fix NULL reference in compute_group_power.
>>>
>>> but get following on current Linus tree plus tip/sched/urgent.
>>>
>>> divide error: 0000 [#1]  SMP
>>> [   28.190477] Modules linked in:
>>> [   28.192012] CPU: 11 PID: 484 Comm: kworker/u324:0 Not tainted
>>> 3.12.0-yh-10487-g4b94e59-dirty #2044
>>> [   28.210488] Hardware name: Oracle Corporation  Sun Fire
>>> [   28.229877] task: ffff88ff25205140 ti: ffff88ff2520a000 task.ti:
>>> ffff88ff2520a000
>>> [   28.236139] RIP: 0010:[<ffffffff810d9ff4>]  [<ffffffff810d9ff4>]
>>> find_busiest_group+0x2b4/0x8a0
>>
>> Hurmph.. what kind of hardware is that? and is there anything funny you
>> do to make it do this?
>
> intel nehanem-ex or westmere-ex 8 sockets system.
>
> I tried without my local patches, the problem is still there.

original one in linus's tree:

[    8.952728] NMI watchdog: enabled on all CPUs, permanently consumes
one hw-PMU counter.
[    8.965697] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000010
[    8.969495] IP: [<ffffffff810d7b53>] update_group_power+0x1d3/0x250
[    8.987159] PGD 0
[    8.989280] Oops: 0000 [#1] SMP
[    8.991686] Modules linked in:
[    8.993803] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
3.12.0-yh-02845-g527d151 #2048
[    9.009175] Hardware name: Oracle Corporation  Sun Fire X4800 M2 /
   , BIOS 15013200    04/19/2012
[    9.028433] task: ffff883f24e28000 ti: ffff883f24e24000 task.ti:
ffff883f24e24000
[    9.033249] RIP: 0010:[<ffffffff810d7b53>]  [<ffffffff810d7b53>]
update_group_power+0x1d3/0x250
[    9.051193] RSP: 0000:ffff883f24e25d68  EFLAGS: 00010283
[    9.068162] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000000
[    9.071838] RDX: 0000000000000000 RSI: 00000000000000a0 RDI: 00000000000000a0
[    9.090260] RBP: ffff883f24e25d98 R08: ffff88ffc4891020 R09: 0000000000000000
[    9.107870] R10: ffff88ffc4890818 R11: 0000000000000001 R12: 00000000001d40c0
[    9.111527] R13: ffff88ffc4891018 R14: ffff88ffc4891000 R15: 0000000000000000
[    9.131279] FS:  0000000000000000(0000) GS:ffff883f7d600000(0000)
knlGS:0000000000000000
[    9.148870] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    9.151914] CR2: 0000000000000010 CR3: 0000000002c14000 CR4: 00000000000007f0
[    9.168645] Stack:
[    9.169871]  ffff883f24e25d88 ffff88ffc4891000 ffff88ffc4870000
0000000000000001
[    9.188660]  0000000000000001 ffff883f23b0d400 ffff883f24e25e58
ffffffff810ce094
[    9.193232]  ffff883f24e25dd8 0000000000000246 0000000000000003
ffffffff000000a0
[    9.210992] Call Trace:
[    9.212524]  [<ffffffff810ce094>] build_sched_domains+0x6f4/0x980
[    9.229900]  [<ffffffff83042a2b>] sched_init_smp+0x95/0x146
[    9.233236]  [<ffffffff83023023>] kernel_init_freeable+0x148/0x259
[    9.250019]  [<ffffffff82121bce>] ? kernel_init+0xe/0x130
[    9.253356]  [<ffffffff82121bc0>] ? rest_init+0xd0/0xd0
[    9.268882]  [<ffffffff82121bce>] kernel_init+0xe/0x130
[    9.271661]  [<ffffffff8215176c>] ret_from_fork+0x7c/0xb0
[    9.288882]  [<ffffffff82121bc0>] ? rest_init+0xd0/0xd0
[    9.292476] Code: ff 31 db b8 ff ff ff ff 4d 8d 6e 18 eb 31 66 2e
0f 1f 84 00 00 00 00 00 48 63 d0 48 8b 14 d5 40 c4 e2 82 49 8b 94 14
08 09 00 00 <48> 8b 52 10 48 8b 52 10 8b 4a 08 8b 52 04 49 01 cf 48 01
d3 83
[    9.335669] RIP  [<ffffffff810d7b53>] update_group_power+0x1d3/0x250
[    9.348090]  RSP <ffff883f24e25d68>
[    9.350240] CR2: 0000000000000010
[    9.351803] ---[ end trace a21cca9ad6b48d40 ]---
[    9.367839] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x00000009
[    9.367839]
