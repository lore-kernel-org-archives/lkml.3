Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3IZSfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:35:13 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:52436 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab3IZSei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:34:38 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: [PATCH 4/4] [RFC] ipv6: Fix for possible ipv6 seqlock deadlock
Date: Thu, 26 Sep 2013 11:34:24 -0700
Message-Id: <1380220464-28840-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380220464-28840-1-git-send-email-john.stultz@linaro.org>
References: <1380220464-28840-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While enabling lockdep on seqlocks, I ran accross the warning below
caused by the ipv6 stats being updated in both irq and non-irq context.

This is a novice attempt to correct the issue, and with this patch
the warning goes away. Any better solutions would be appreciated!

[   11.120383] =================================
[   11.121024] [ INFO: inconsistent lock state ]
[   11.121663] 3.12.0-rc1+ #68 Not tainted
[   11.122229] ---------------------------------
[   11.122867] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
[   11.123741] init/4483 [HC0[0]:SC1[3]:HE1:SE0] takes:
[   11.124505]  (&stats->syncp.seq#6){+.?...}, at: [<c1ab80c2>] ndisc_send_ns+0xe2/0x130
[   11.125736] {SOFTIRQ-ON-W} state was registered at:
[   11.126447]   [<c10e0eb7>] __lock_acquire+0x5c7/0x1af0
[   11.127222]   [<c10e2996>] lock_acquire+0x96/0xd0
[   11.127925]   [<c1a9a2c3>] write_seqcount_begin+0x33/0x40
[   11.128766]   [<c1a9aa03>] ip6_dst_lookup_tail+0x3a3/0x460
[   11.129582]   [<c1a9e0ce>] ip6_dst_lookup_flow+0x2e/0x80
[   11.130014]   [<c1ad18e0>] ip6_datagram_connect+0x150/0x4e0
[   11.130014]   [<c1a4d0b5>] inet_dgram_connect+0x25/0x70
[   11.130014]   [<c198dd61>] SYSC_connect+0xa1/0xc0
[   11.130014]   [<c198f571>] SyS_connect+0x11/0x20
[   11.130014]   [<c198fe6b>] SyS_socketcall+0x12b/0x300
[   11.130014]   [<c1bbf880>] syscall_call+0x7/0xb
[   11.130014] irq event stamp: 1184
[   11.130014] hardirqs last  enabled at (1184): [<c1086901>] local_bh_enable+0x71/0x110
[   11.130014] hardirqs last disabled at (1183): [<c10868cd>] local_bh_enable+0x3d/0x110
[   11.130014] softirqs last  enabled at (0): [<c108014d>] copy_process.part.42+0x45d/0x11a0
[   11.130014] softirqs last disabled at (1147): [<c1086e05>] irq_exit+0xa5/0xb0
[   11.130014]
[   11.130014] other info that might help us debug this:
[   11.130014]  Possible unsafe locking scenario:
[   11.130014]
[   11.130014]        CPU0
[   11.130014]        ----
[   11.130014]   lock(&stats->syncp.seq#6);
[   11.130014]   <Interrupt>
[   11.130014]     lock(&stats->syncp.seq#6);
[   11.130014]
[   11.130014]  *** DEADLOCK ***
[   11.130014]
[   11.130014] 3 locks held by init/4483:
[   11.130014]  #0:  (rcu_read_lock){.+.+..}, at: [<c109363c>] SyS_setpriority+0x4c/0x620
[   11.130014]  #1:  (((&ifa->dad_timer))){+.-...}, at: [<c108c1c0>] call_timer_fn+0x0/0xf0
[   11.130014]  #2:  (rcu_read_lock){.+.+..}, at: [<c1ab6494>] ndisc_send_skb+0x54/0x5d0
[   11.130014]
[   11.130014] stack backtrace:
[   11.130014] CPU: 0 PID: 4483 Comm: init Not tainted 3.12.0-rc1+ #68
[   11.130014] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   11.130014]  00000000 00000000 c55e5c10 c1bb0e71 c57128b0 c55e5c4c c1badf79 c1ec1123
[   11.130014]  c1ec1484 00001183 00000000 00000000 00000001 00000003 00000001 00000000
[   11.130014]  c1ec1484 00000004 c5712dcc 00000000 c55e5c84 c10de492 00000004 c10755f2
[   11.130014] Call Trace:
[   11.130014]  [<c1bb0e71>] dump_stack+0x4b/0x66
[   11.130014]  [<c1badf79>] print_usage_bug+0x1d3/0x1dd
[   11.130014]  [<c10de492>] mark_lock+0x282/0x2f0
[   11.130014]  [<c10755f2>] ? kvm_clock_read+0x22/0x30
[   11.130014]  [<c10dd8b0>] ? check_usage_backwards+0x150/0x150
[   11.130014]  [<c10e0e74>] __lock_acquire+0x584/0x1af0
[   11.130014]  [<c10b1baf>] ? sched_clock_cpu+0xef/0x190
[   11.130014]  [<c10de58c>] ? mark_held_locks+0x8c/0xf0
[   11.130014]  [<c10e2996>] lock_acquire+0x96/0xd0
[   11.130014]  [<c1ab80c2>] ? ndisc_send_ns+0xe2/0x130
[   11.130014]  [<c1ab66d3>] ndisc_send_skb+0x293/0x5d0
[   11.130014]  [<c1ab80c2>] ? ndisc_send_ns+0xe2/0x130
[   11.130014]  [<c1ab80c2>] ndisc_send_ns+0xe2/0x130
[   11.130014]  [<c108cc32>] ? mod_timer+0xf2/0x160
[   11.130014]  [<c1aa706e>] ? addrconf_dad_timer+0xce/0x150
[   11.130014]  [<c1aa70aa>] addrconf_dad_timer+0x10a/0x150
[   11.130014]  [<c1aa6fa0>] ? addrconf_dad_completed+0x1c0/0x1c0
[   11.130014]  [<c108c233>] call_timer_fn+0x73/0xf0
[   11.130014]  [<c108c1c0>] ? __internal_add_timer+0xb0/0xb0
[   11.130014]  [<c1aa6fa0>] ? addrconf_dad_completed+0x1c0/0x1c0
[   11.130014]  [<c108c5b1>] run_timer_softirq+0x141/0x1e0
[   11.130014]  [<c1086b20>] ? __do_softirq+0x70/0x1b0
[   11.130014]  [<c1086b70>] __do_softirq+0xc0/0x1b0
[   11.130014]  [<c1086e05>] irq_exit+0xa5/0xb0
[   11.130014]  [<c106cfd5>] smp_apic_timer_interrupt+0x35/0x50
[   11.130014]  [<c1bbfbca>] apic_timer_interrupt+0x32/0x38
[   11.130014]  [<c10936ed>] ? SyS_setpriority+0xfd/0x620
[   11.130014]  [<c10e26c9>] ? lock_release+0x9/0x240
[   11.130014]  [<c10936d7>] ? SyS_setpriority+0xe7/0x620
[   11.130014]  [<c1bbee6d>] ? _raw_read_unlock+0x1d/0x30
[   11.130014]  [<c1093701>] SyS_setpriority+0x111/0x620
[   11.130014]  [<c109363c>] ? SyS_setpriority+0x4c/0x620
[   11.130014]  [<c1bbf880>] syscall_call+0x7/0xb

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 net/ipv6/ip6_output.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 3a692d5..7614b63 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -908,8 +908,13 @@ static int ip6_dst_lookup_tail(struct sock *sk,
 	return 0;
 
 out_err_release:
-	if (err == -ENETUNREACH)
+	if (err == -ENETUNREACH) {
+		unsigned long flags;
+		/* some of the stats are locked in irq context */
+		local_irq_save(flags);
 		IP6_INC_STATS_BH(net, NULL, IPSTATS_MIB_OUTNOROUTES);
+		local_irq_restore(flags);
+	}
 	dst_release(*dst);
 	*dst = NULL;
 	return err;
-- 
1.8.1.2

