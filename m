Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbaCEBnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:43:09 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:10839 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbaCEBnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:43:06 -0500
Message-ID: <1393983784.2512.40.camel@buesod1.americas.hpqcorp.net>
Subject: futex funkiness -- massive lockups
From: Davidlohr Bueso <davidlohr@hp.com>
To: tglx@linutronix.de, mingo@kernel.org, dvhart@linux.intel.com,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Date: Tue, 04 Mar 2014 17:43:04 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A large amount of lockups are seen on a 480 core system doing some sort
of database-like workload. All except one are soft lockups. This is a
SLES11 system with most of the recent futex changes backported,
including commits 63b1a816, b0c29f79, 99b60ce6, a52b89eb, 0d00c7b2,
5cdec2d8 and f12d5bfc.

The following are some traces I put together in chronological order from
the report I received. While the traces aren't perfect, I believe it
exemplifies the issue pretty well. There are a lot more, but just of the
same.

[212046.044098] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 22
[212046.044098] Pid: 312554, comm: XXX Tainted: GF     D W  N  3.0.101-0.15-default #1
[212046.044098] Call Trace:
[212046.044098]  [<ffffffff81004935>] dump_trace+0x75/0x310
[212046.044098]  [<ffffffff8145e0b3>] dump_stack+0x69/0x6f
[212046.044098]  [<ffffffff8145e14c>] panic+0x93/0x201
[212046.044098]  [<ffffffff810c65e4>] watchdog_overflow_callback+0xb4/0xc0
[212046.044098]  [<ffffffff810f2d9a>] __perf_event_overflow+0xaa/0x230
[212046.044098]  [<ffffffff81018210>] intel_pmu_handle_irq+0x1a0/0x330
[212046.044098]  [<ffffffff81462ae1>] perf_event_nmi_handler+0x31/0xa0
[212046.044098]  [<ffffffff81464c37>] notifier_call_chain+0x37/0x70
[212046.044098]  [<ffffffff81464c7d>] __atomic_notifier_call_chain+0xd/0x20
[212046.044098]  [<ffffffff81464ccd>] notify_die+0x2d/0x40
[212046.044098]  [<ffffffff81462127>] default_do_nmi+0x37/0x200
[212046.044098]  [<ffffffff81462358>] do_nmi+0x68/0x80
[212046.044098]  [<ffffffff814618ad>] restart_nmi+0x1a/0x1e
...
[212071.245827] BUG: soft lockup - CPU#432 stuck for 22s! [XXX:310367]
[212071.245827] Modules linked in:
[212071.245827] Modules linked in: scsi_dh_alua nfsd scsi_dh_emc nfs scsi_dh_rdac lockd scsi_dh fscache auth_rpcgss nfs_acl sunrpc cpufreq_conservative cpufreq_userspace scsi_mod cpufreq_powersave dm_snapshot acpi_cpufreq dm_mod mperf ipmi_devintf
[212071.245827] Pid: 310367, comm: XXX Tainted: GF     D W  N  3.0.101-0.15-default #1 ehci_hcd HP Superdome2 16s scsi_tgt
[212071.245827] RIP: 0010:[<ffffffff81460ec8>]  usb_common [<ffffffff81460ec8>] _raw_spin_lock+0x18/0x20
[212071.245827] RSP: 0018:ffff93575d465d30  EFLAGS: 00000283
[212071.245827] RAX: 000000000000aa44 RBX: 0000000100000260 RCX: 000000002b67de50
[212071.245827] RDX: 000000000000a9d5 RSI: 00000000181ab32e RDI: ffffc9077918b680
[212071.245827] RBP: ffff93575d464000 R08: 000000006efee553 R09: 00000000ab072dfb
[212071.245827] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff8146976e
[212071.245827] R13: 000000005d465d68 R14: 0000000000000260 R15: ffff9356ed3361c0
[212071.245827] FS:  00007ff3f34df700(0000) GS:ffff91dfffd60000(0000) knlGS:0000000000000000
[212071.245827] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[212071.245827] CR2: 00007f0798fd7000 CR3: 000009db7c4c8000 CR4: 00000000001407e0
[212071.245827] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[212071.245827] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[212071.245827] Stack:
[212071.245827]  ffffffff81095bc4
[212071.245827]  000000009888c620 0000000000000002 ffff93575d465e08
[212071.245827]  00000000ffffffea 0000000000000000 ffff93575d465dc8
[212071.245827] Call Trace:
[212071.245827]  [<ffffffff81095bc4>] futex_wait_setup+0x74/0x110
[212071.245827]  [<ffffffff81095ec9>] futex_wait+0xf9/0x250
[212071.245827]  [<ffffffff810987e8>] do_futex+0xb8/0x1c0
[212071.245827]  [<ffffffff81098972>] sys_futex+0x82/0x170
[212071.245827]  [<ffffffff81468d92>] system_call_fastpath+0x16/0x1b
[212071.245827]  [<00007ff690f54789>] 0x7ff690f54788
[212071.245827] Code: ba 01 00 00 00 75 02 31 d2 89 d0 c3 0f 1f 80 00 00 00
[212071.245827] 00  [<ffffffff810987e8>] do_futex+0xb8/0x1c0
[212071.245827] b8 00 00 01 00 f0 0f c1 07 0f b7 d0 c1 e8 10 39 c2 74 07 f3 90 0f b7 17 <eb> f5 c3 0f 1f 44 00 00 9c 58 0f 1f
[212071.245827] 44  [<ffffffff81098972>] sys_futex+0x82/0x170
[212071.245827] 00 00 48 89 c6 fa 66 0f
...
[212071.494920] BUG: soft lockup - CPU#221 stuck for 22s! [XXX:312526]
[212071.494920] Pid: 312526, comm: PoolThread Tainted: GF     D W  N  3.0.101-0.15-default #1 HP Superdome2 16s
[212071.494920] RIP: 0010:[<ffffffff81051205>]  [<ffffffff81051205>] find_busiest_group+0x145/0xb10
[212071.494920] RSP: 0018:ffff935fffb63bf0  EFLAGS: 00000286
[212071.494920] RAX: 0000000000000000 RBX: ffffffff810ed092 RCX: 00000000000000dd
[212071.494920] RDX: ffff935b7e352c00 RSI: 0000000000000000 RDI: 000000000000049a
[212071.494920] RBP: ffff935fffb63da0 R08: 0000000000000020 R09: ffff935b7e352450
[212071.494920] R10: 0000000000000002 R11: 0000000000000001 R12: ffffffff81469773
[212071.494920] R13: ffff935fffb63b68 R14: ffff935b7e352400 R15: 0000000000000096
[212071.494920] FS:  00007ff3f668b700(0000) GS:ffff935fffb60000(0000) knlGS:0000000000000000
[212071.494920] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[212071.494920] CR2: 00007f91e8664000 CR3: 000009db7c4c8000 CR4: 00000000001407e0
[212071.494920] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[212071.494920] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[212071.494920] Process XXX (pid: 312526, threadinfo ffff88b37648e000, task ffff88bba26fa400)
[212071.494920] Stack:
[212071.494920]  ffff935fffb63d30 ffff935fffb63c80 ffffffff81017c03 0000000000011818
[212071.494920]  0000000000011800 0000000000011818 0000000000011800 ffff935fffb63e84
[212071.494920]  ffff88c07f69f600 00000001ffb6e010 ffff935fffb63e18 000000ddffb750b8
[212071.494920] Call Trace:
[212071.494920]  [<ffffffff810589e5>] load_balance+0xa5/0x470
[212071.494920]  [<ffffffff81058f13>] rebalance_domains+0x163/0x220
[212071.494920]  [<ffffffff81059144>] run_rebalance_domains+0x44/0x60
[212071.494920]  [<ffffffff810677df>] __do_softirq+0x11f/0x260
[212071.494920]  [<ffffffff81469fdc>] call_softirq+0x1c/0x30
[212071.494920]  [<ffffffff81004435>] do_softirq+0x65/0xa0
[212071.494920]  [<ffffffff810675a5>] irq_exit+0xc5/0xe0
[212071.494920]  [<ffffffff81026588>] smp_apic_timer_interrupt+0x68/0xa0
[212071.494920]  [<ffffffff81469773>] apic_timer_interrupt+0x13/0x20
[212071.494920]  [<ffffffff81460ec5>] _raw_spin_lock+0x15/0x20
[212071.494920]  [<ffffffff8109626a>] futex_wake+0xba/0x180
[212071.494920]  [<ffffffff810987c4>] do_futex+0x94/0x1c0
[212071.494920]  [<ffffffff81098972>] sys_futex+0x82/0x170
[212071.494920]  [<ffffffff81468d92>] system_call_fastpath+0x16/0x1b

Does this ring a bell to anyone? Assuming this is in fact caused by
futexes and based on the traces and nature of the issue, my money's on
commit b0c29f79, but cannot say for sure. Could it be that on such large
systems some of the introduced barriers after the atomic ops could cause
this? Since on x86 these are no-ops and no overhead is added, I'd think
not, but just wanted to mention it anyway. Also, if for some reason the
ordering guarantees aren't being kept and wakers aren't seeing some
tasks being queued, in my experience it should just cause userspace to
hang, not the kernel.

>From the paths related to futex wait we are stuck when taking the hb
spinlock in futex_wait_setup >> queue_lock.

I have tried reproducing this on another 480 core box and same kernel,
with both Darren's and my futex stressers, no luck! Also, I cannot find
anything reported upstream, except perhaps for the following, which
shows a similar trace for the futex wait path (and, afaict, that kernel
does not include the recent futex work):
 https://bugzilla.redhat.com/show_bug.cgi?id=1051626

Anyways, I'll keep digging.

Thanks,
Davidlohr

