Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab3FCIJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:09:29 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:36963 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab3FCIJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:09:24 -0400
MIME-Version: 1.0
Date: Mon, 3 Jun 2013 11:09:23 +0300
Message-ID: <CA+ydwtrTb0zSiUPj7FpPhwj4WNLLZTNLM4HNDiQJ=Ef9JswntQ@mail.gmail.com>
Subject: kernel/events/callchain.c:141 suspicious rcu_dereference_check() usage!
From: Tommi Rantala <tt.rantala@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        trinity@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Hit this while fuzzing v3.10-rc4-0-gd683b96 with trinity.

Tommi

[ 8703.304587]
[ 8703.305106] ===============================
[ 8703.305106] [ INFO: suspicious RCU usage. ]
[ 8703.305106] 3.10.0-rc4 #1 Tainted: G          I
[ 8703.305106] -------------------------------
[ 8703.305106] /build/linux/kernel/events/callchain.c:141 suspicious
rcu_dereference_check() usage!
[ 8703.305106]
[ 8703.305106] other info that might help us debug this:
[ 8703.305106]
[ 8703.305106]
[ 8703.305106] rcu_scheduler_active = 1, debug_locks = 0
[ 8703.305106] 2 locks held by trinity-child28/23333:
[ 8703.305106]  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff8229f128>]
__schedule+0x1c8/0xa00
[ 8703.305106]  #1:  (&ctx->lock){-.-...}, at: [<ffffffff811cd037>]
__perf_event_task_sched_out+0x407/0x4b0
[ 8703.305106]
[ 8703.305106] stack backtrace:
[ 8703.305106] CPU: 1 PID: 23333 Comm: trinity-child28 Tainted: G
    I  3.10.0-rc4 #1
[ 8703.305106] Hardware name: Hewlett-Packard HP Compaq dc7800 Small
Form Factor/0AA8h, BIOS 786F1 v01.24 03/18/2008
[ 8703.305106]  0000000000000001 ffff880103899a00 ffffffff8228e109
ffff880103899a30
[ 8703.305106]  ffffffff81176f06 0000000000000001 0000000000000000
ffff8800d46e1bd8
[ 8703.305106]  ffff880103899b88 ffff880103899a78 ffffffff811d36a3
ffff880102ab1a08
[ 8703.305106] Call Trace:
[ 8703.305106]  [<ffffffff8228e109>] dump_stack+0x19/0x1b
[ 8703.305106]  [<ffffffff81176f06>] lockdep_rcu_suspicious+0x116/0x140
[ 8703.305106]  [<ffffffff811d36a3>] perf_callchain+0x153/0x290
[ 8703.305106]  [<ffffffff811cf286>] perf_prepare_sample+0x86/0x2b0
[ 8703.305106]  [<ffffffff8107cbe8>] intel_pmu_drain_bts_buffer+0xf8/0x1b0
[ 8703.305106]  [<ffffffff8115219d>] ? sched_clock_local+0x1d/0x90
[ 8703.305106]  [<ffffffff81173058>] ? trace_hardirqs_off_caller+0x28/0xe0
[ 8703.305106]  [<ffffffff8107ddb3>] intel_pmu_disable_event+0x33/0x140
[ 8703.305106]  [<ffffffff81077573>] x86_pmu_stop+0x43/0xd0
[ 8703.305106]  [<ffffffff81077636>] x86_pmu_del+0x36/0x100
[ 8703.305106]  [<ffffffff811c8c8a>] event_sched_out.isra.28+0xba/0x150
[ 8703.305106]  [<ffffffff811c8d76>] group_sched_out+0x56/0xd0
[ 8703.305106]  [<ffffffff811c9614>] ctx_sched_out+0x104/0x130
[ 8703.305106]  [<ffffffff811cd048>] __perf_event_task_sched_out+0x418/0x4b0
[ 8703.305106]  [<ffffffff811ccc97>] ? __perf_event_task_sched_out+0x67/0x4b0
[ 8703.305106]  [<ffffffff81173058>] ? trace_hardirqs_off_caller+0x28/0xe0
[ 8703.305106]  [<ffffffff8117311d>] ? trace_hardirqs_off+0xd/0x10
[ 8703.305106]  [<ffffffff8114a5c7>] perf_event_task_sched_out+0x87/0xa0
[ 8703.305106]  [<ffffffff814deb67>] ? do_raw_spin_unlock+0xa7/0xc0
[ 8703.305106]  [<ffffffff822a16c2>] ? _raw_spin_unlock+0x22/0x40
[ 8703.305106]  [<ffffffff8115348d>] ? __dequeue_entity+0x3d/0x50
[ 8703.305106]  [<ffffffff81157376>] ? set_next_entity+0x26/0x90
[ 8703.305106]  [<ffffffff811574f3>] ? pick_next_task_fair+0xd3/0x150
[ 8703.305106]  [<ffffffff8229f5f8>] __schedule+0x698/0xa00
[ 8703.305106]  [<ffffffff8229f9b5>] schedule+0x55/0x60
[ 8703.305106]  [<ffffffff822a2ea9>] sysret_careful+0x19/0x1c
