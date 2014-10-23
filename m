Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbaJWRBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 13:01:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61408 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbaJWRBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:01:01 -0400
Message-ID: <54493433.4090703@arm.com>
Date: Thu, 23 Oct 2014 18:00:35 +0100
From: Andre Przywara <andre.przywara@arm.com>
Organization: ARM Ltd.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
CC: LAKML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: BPF crash with 3.18-rc1 on arm64 Juno hardware
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I see a crash with 3.18-rc1 on a Juno board related to bpf_jit (see dump
below). Userland tries to carry on afterwards, but eventually hangs in
RCU stalls.
The kernel has just CONFIG_BPF_JIT enabled, I guess Ubuntu enables this
automatically if detected.

The backtrace doesn't make too much sense to me:

void bpf_jit_free(struct bpf_prog *prog)
{
        if (prog->jited)
                module_free(NULL, prog->bpf_func);

        kfree(prog);
}
It crashes in kfree, but has survived the dereference before.

I have no clue about BPF, so if anyone could help me debug this, I'd be
grateful.

Cheers,
Andre.


 * Starting Signal sysvinit that local filesystems are mounted   [ OK ]
 * Starting configure network device security                    [ OK ]
Unable to handle kernel paging request at virtual address 37fffbd21c02290
pgd = ffffffc976538000
[37fffbd21c02290] *pgd=0000000000000000, *pud=0000000000000000
Internal error: Oops: 96000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 3 PID: 737 Comm: kworker/3:1 Not tainted 3.18.0-rc1+ #1666
Workqueue: events bpf_prog_free_deferred
task: ffffffc977a89580 ti: ffffffc976494000 task.ti: ffffffc976494000
PC is at kfree+0x70/0x260
LR is at bpf_jit_free+0x34/0x40
pc : [<ffffffc0001b0634>] lr : [<ffffffc000099290>] pstate: a0000145
sp : ffffffc976497ca0
x29: ffffffc976497ca0 x28: 0000000000000000
x27: ffffffc97feff400 x26: ffffffc0009b0000
x25: 0000000000000000 x24: 0000000000000000
x23: ffffffc97ff03900 x22: ffffffc97feff400
x21: ffffffc000099290 x20: ffffff800009e000
x19: ffffff800009e000 x18: 0000007feb492820
x17: 0000007fb71c6980 x16: ffffffc0001fcc14
x15: 003b9aca00000000 x14: 0027947614000000
x13: ffffffffabb6d0e3 x12: 0000000000000018
x11: 0000000033c2a168 x10: 0000000000000006
x9 : ffffffc976497bd0 x8 : ffffffc977a89a90
x7 : ffffffc97736c4d0 x6 : 00000000000009be
x5 : 0000000000000000 x4 : 0000000000000001
x3 : ffffffc97feff7c0 x2 : 03ffffff02002780
x1 : 037fffff21c02290 x0 : ffffffbe00000000

Process kworker/3:1 (pid: 737, stack limit = 0xffffffc976494058)
Stack: (0xffffffc976497ca0 to 0xffffffc976498000)
....
