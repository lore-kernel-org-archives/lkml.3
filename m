Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaIASSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 14:18:21 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33743 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754252AbaIASSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 14:18:20 -0400
Date: Mon, 1 Sep 2014 19:18:08 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Yan@leverpostej.cambridge.arm.com,
        Zheng <zheng.z.yan@intel.com>, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Possible race between CPU hotplug and perf_pmu_migrate_context
Message-ID: <20140901181808.GA6427@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While trying some rework of the ARM CCI PMU driver on v3.17-rc2, I
encountered what seems to be a race between CPU hotplug and perf event
context migration, which results in a BUG in mm/slub.c.

It looks like this is a generic issue as I'm able to cause the same
splat with the uncore_imc driver on a Haswell machine (on v3.16.1 at
least):

[   66.621306] ------------[ cut here ]------------
[   66.625933] kernel BUG at mm/slub.c:3380!
[   66.629947] invalid opcode: 0000 [#1] SMP
[   66.634101] Modules linked in: vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) x86_pkg_temp_thermal
[   66.643476] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G           O  3.16.1-uncore-pmu-test #2
[   66.653132] Hardware name: LENOVO 10A6A03EUK/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[   66.660530] task: ffff88040b584f50 ti: ffff88040b5d4000 task.ti: ffff88040b5d4000
[   66.668009] RIP: 0010:[<ffffffff8114a443>]  [<ffffffff8114a443>] kfree+0x133/0x140
[   66.675615] RSP: 0018:ffff88041dc43ea8  EFLAGS: 00010246
[   66.680930] RAX: 0200000000000400 RBX: ffff88041dc18100 RCX: 00000000000000c8
[   66.688066] RDX: 0200000000000000 RSI: ffff8800db601800 RDI: ffff88041dc18100
[   66.695202] RBP: ffff88041dc43ec0 R08: 00000000000156e0 R09: ffff88041dc556e0
[   66.702334] R10: ffffea0010770600 R11: ffffea00036d8000 R12: ffffffff81c3dec0
[   66.709472] R13: ffffffff8109dd33 R14: ffff880409b96b08 R15: 0000000000000006
[   66.716607] FS:  0000000000000000(0000) GS:ffff88041dc40000(0000) knlGS:0000000000000000
[   66.724697] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   66.730443] CR2: 00007fae8a93b000 CR3: 00000000dc962000 CR4: 00000000001407e0
[   66.737580] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   66.744714] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   66.751852] Stack:
[   66.753873]  ffff88041dc4d300 ffffffff81c3dec0 000000000000000a ffff88041dc43f20
[   66.761371]  ffffffff8109dd33 ffff8800db600500 ffff88040b584f50 ffff88040b5d7fd8
[   66.768873]  ffff88041dc4d328 0000000000000000 0000000000000009 ffffffff81c090c8
[   66.776371] Call Trace:
[   66.778823]  <IRQ>
[   66.780759]  [<ffffffff8109dd33>] rcu_process_callbacks+0x1e3/0x540
[   66.787254]  [<ffffffff8104e70e>] __do_softirq+0xee/0x280
[   66.792654]  [<ffffffff8104eaad>] irq_exit+0x9d/0xb0
[   66.797625]  [<ffffffff81032b4f>] smp_apic_timer_interrupt+0x3f/0x50
[   66.803982]  [<ffffffff817de68a>] apic_timer_interrupt+0x6a/0x70
[   66.809994]  <EOI>
[   66.811926]  [<ffffffff81590ce7>] ? cpuidle_enter_state+0x47/0xc0
[   66.818250]  [<ffffffff81590e12>] cpuidle_enter+0x12/0x20
[   66.823650]  [<ffffffff81086aa6>] cpu_startup_entry+0x256/0x3f0
[   66.829572]  [<ffffffff81030d82>] start_secondary+0x192/0x200
[   66.835319] Code: 49 8b 02 31 f6 f6 c4 40 74 04 41 8b 72 68 4c 89 d7 e8 92 ed fb ff eb 93 4c 8b 50 30 48 8b 10 80 e6 80 4c 0f 44 d0 e9 36 ff ff ff <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 c7 c0 ea ff ff ff
[   66.855859] RIP  [<ffffffff8114a443>] kfree+0x133/0x140
[   66.861113]  RSP <ffff88041dc43ea8>
[   66.864617] ---[ end trace 825fa0ba52ca10eb ]---
[   66.869240] Kernel panic - not syncing: Fatal exception in interrupt
[   66.875616] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[   66.885791] ---[ end Kernel panic - not syncing: Fatal exception in interrupt

Has anything seen anything like this before? Is this a known issue?

I'm testing by opening and closing uncore/system PMU events while
hotplugging CPUs to force migration. I run a few instances of the
following program and script in parallel (please forgive the hardcoded
numbers).

Thanks,
Mark.

---->8----
#include <errno.h>
#include <linux/hw_breakpoint.h>
#include <linux/perf_event.h>
#include <stdio.h>
#include <sys/syscall.h>
#include <unistd.h>

static int perf_event_open(struct perf_event_attr *attr, pid_t pid, int cpu,
			   int group_fd, unsigned long flags)
{
	return syscall(__NR_perf_event_open, attr, pid, cpu, group_fd, flags);
}

#define PMU_TYPE	6	/* uncore_imc */
#define PMU_EVENT	1	/* data_read */

struct perf_event_attr attr = {
	.type = PMU_TYPE,
	.config = PMU_EVENT,
	.size = sizeof(attr),
};

int main(int argc, char *argv[])
{
	while (1) {
		int ret = perf_event_open(&attr, -1, 0, -1, 0);
		if (ret < 0) {
			fprintf(stderr, "Unable to open event: %d (%d)\n", ret, errno);
			return ret;
		}
		close(ret);
	}

	return 0;
}
----8<----

---->8----
#!/bin/sh

MAX_CPU=7

while true; do
	for i in $(seq 0 ${MAX_CPU}); do
		echo 0 > /sys/devices/system/cpu/cpu${i}/online;
		echo 1 > /sys/devices/system/cpu/cpu${i}/online;
	done
done
----8<----

