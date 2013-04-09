Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936897Ab3DIPzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:55:12 -0400
Received: from www.sr71.net ([198.145.64.142]:53161 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936061Ab3DIPzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:55:11 -0400
Message-ID: <516439DF.3050901@sr71.net>
Date: Tue, 09 Apr 2013 08:55:11 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Borislav Petkov <bp@alien8.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        dhillf@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] kthread: Prevent unpark race which puts threads on the
 wrong cpu
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos> <20130408115553.GA4395@pd.tnic> <alpine.LFD.2.02.1304081415570.21884@ionos> <alpine.LFD.2.02.1304091635430.21884@ionos>
In-Reply-To: <alpine.LFD.2.02.1304091635430.21884@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,

I don't think the patch helped my case.  Looks like the same BUG_ON().

I accidentally booted with possible_cpus=10 instead of 160.  I wasn't
able to trigger this in that case, even repeatedly on/offlining them.
But, once I booted with possible_cpus=160, it triggered in a jiffy.

Two oopses below (bottom one has cpu numbers):

> [  467.106219] ------------[ cut here ]------------
> [  467.106400] kernel BUG at kernel/smpboot.c:134!
> [  467.106556] invalid opcode: 0000 [#1] SMP 
> [  467.106831] Modules linked in:
> [  467.107039] CPU 0 
> [  467.107109] Pid: 3095, comm: migration/115 Tainted: G        W    3.9.0-rc6-00020-g84ee980-dirty #132 FUJITSU-SV PRIMEQUEST 1800E2/SB
> [  467.107507] RIP: 0010:[<ffffffff8110bed8>]  [<ffffffff8110bed8>] smpboot_thread_fn+0x258/0x280
> [  467.107820] RSP: 0018:ffff887ff0561e08  EFLAGS: 00010202
> [  467.107980] RAX: 0000000000000000 RBX: ffff887ff04ef010 RCX: 000000000000b888
> [  467.108142] RDX: ffff887ff0561fd8 RSI: ffff881ffda00000 RDI: 0000000000000073
> [  467.108303] RBP: ffff887ff0561e38 R08: 0000000000000001 R09: 0000000000000000
> [  467.108465] R10: 0000000000000018 R11: 0000000000000000 R12: ffff887ff053c5c0
> [  467.108629] R13: ffffffff81e587a0 R14: ffff887ff053c5c0 R15: 0000000000000000
> [  467.108791] FS:  0000000000000000(0000) GS:ffff881ffda00000(0000) knlGS:0000000000000000
> [  467.109037] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  467.109194] CR2: 000000000117c278 CR3: 0000000001e0b000 CR4: 00000000000007f0
> [  467.109357] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  467.109519] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  467.109684] Process migration/115 (pid: 3095, threadinfo ffff887ff0560000, task ffff887ff053c5c0)
> [  467.109930] Stack:
> [  467.110075]  ffff887ff0561e38 0000000000000000 ffff881fe60adcc0 ffff887ff0561ec0
> [  467.110580]  ffff887ff04ef010 ffffffff8110bc80 ffff887ff0561f48 ffffffff810ff1df
> [  467.111075]  0000000000000001 ffff881f00000073 ffff887ff04ef010 ffff887f00000001
> [  467.111568] Call Trace:
> [  467.111726]  [<ffffffff8110bc80>] ? __smpboot_create_thread+0x180/0x180
> [  467.111893]  [<ffffffff810ff1df>] kthread+0xef/0x100
> [  467.112057]  [<ffffffff8110e340>] ? complete+0x30/0x80
> [  467.112216]  [<ffffffff810ff0f0>] ? __init_kthread_worker+0x80/0x80
> [  467.112386]  [<ffffffff819db99c>] ret_from_fork+0x7c/0xb0
> [  467.112548]  [<ffffffff810ff0f0>] ? __init_kthread_worker+0x80/0x80
> [  467.112708] Code: ef 3d 01 01 48 89 df e8 c7 af 16 00 48 83 05 97 ef 3d 01 01 48 83 c4 10 31 c0 5b 41 5c 41 5d 41 5e 5d c3 48 83 05 c0 ef 3d 01 01 <0f> 0b 48 83 05 c6 ef 3d 01 01 48 83 05 86 ef 3d 01 01 0f 0b 48 
> [  467.117014] RIP  [<ffffffff8110bed8>] smpboot_thread_fn+0x258/0x280
> [  467.117233]  RSP <ffff887ff0561e08>
> [  467.117414] ---[ end trace d851dfb0bce51ca2 ]---

Here's the same oops, but with the line numbers munged because I added
some printks:

> [  161.551788] smpboot_thread_fn():
> [  161.551807] td->cpu: 132
> [  161.551808] smp_processor_id(): 121
> [  161.551811] comm: migration/%u
> [  161.551840] ------------[ cut here ]------------
> [  161.551939] kernel BUG at kernel/smpboot.c:149!
> [  161.552030] invalid opcode: 0000 [#1] SMP 
> [  161.552255] Modules linked in:
> [  161.552397] CPU 121 
> [  161.552474] Pid: 2957, comm: migration/132 Tainted: G        W    3.9.0-rc6-00020-g84ee980-dirty #136 FUJITSU-SV PRIMEQUEST 1800E2/SB
> [  161.552655] RIP: 0010:[<ffffffff8110bf29>]  [<ffffffff8110bf29>] smpboot_thread_fn+0x409/0x560
> [  161.552852] RSP: 0018:ffff88bff0403de8  EFLAGS: 00010202
> [  161.552935] RAX: 0000000000000079 RBX: ffff88bff02ac070 RCX: 0000000000000006
> [  161.553025] RDX: 0000000000000007 RSI: 0000000000000007 RDI: ffff889ffec0d190
> [  161.553115] RBP: ffff88bff0403e38 R08: 0000000000000001 R09: 0000000000000001
> [  161.553204] R10: 0000000000000000 R11: 0000000000000b09 R12: ffff88bff04745c0
> [  161.553319] R13: ffffffff81e587a0 R14: ffffffff8110bb20 R15: ffff88bff04745c0
> [  161.553411] FS:  0000000000000000(0000) GS:ffff889ffec00000(0000) knlGS:0000000000000000
> [  161.553534] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  161.553619] CR2: 00007f0c4155c6d0 CR3: 0000000001e0b000 CR4: 00000000000007e0
> [  161.553709] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  161.553799] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  161.553889] Process migration/132 (pid: 2957, threadinfo ffff88bff0402000, task ffff88bff04745c0)
> [  161.554156] Stack:
> [  161.554312]  ffffffff8110bb20 ffff88bff04745c0 ffff88bff0403e08 0000000000000000
> [  161.554839]  ffff88bff0403e38 ffff881fef323cc0 ffff88bff0403ec0 ffff88bff02ac070
> [  161.555370]  ffffffff8110bb20 0000000000000000 ffff88bff0403f48 ffffffff810ff08f
> [  161.555891] Call Trace:
> [  161.556055]  [<ffffffff8110bb20>] ? __smpboot_create_thread+0x180/0x180
> [  161.556230]  [<ffffffff8110bb20>] ? __smpboot_create_thread+0x180/0x180
> [  161.556409]  [<ffffffff810ff08f>] kthread+0xef/0x100
> [  161.556590]  [<ffffffff819d5154>] ? wait_for_completion+0x124/0x180
> [  161.556761]  [<ffffffff810fefa0>] ? __init_kthread_worker+0x80/0x80
> [  161.556982]  [<ffffffff819e59dc>] ret_from_fork+0x7c/0xb0
> [  161.557148]  [<ffffffff810fefa0>] ? __init_kthread_worker+0x80/0x80
> [  161.557316] Code: 05 e4 f1 3d 01 01 e8 2b cf 8b 00 48 83 05 df f1 3d 01 01 65 8b 04 25 64 b0 00 00 39 03 0f 84 0c fd ff ff 48 83 05 cf f1 3d 01 01 <0f> 0b 48 83 05 cd f1 3d 01 01 0f 1f 44 00 00 b9 8b 00 00 00 48 
> [  161.561934] RIP  [<ffffffff8110bf29>] smpboot_thread_fn+0x409/0x560
> [  161.562171]  RSP <ffff88bff0403de8>
> [  161.562352] ---[ end trace 6a3b5261afedf7da ]---

