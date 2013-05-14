Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab3ENPz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:55:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49063 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab3ENPz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:55:27 -0400
Date: Tue, 14 May 2013 08:50:13 -0700
From: "tip-bot for Srivatsa S. Bhat" <tipbot@zytor.com>
Message-ID: <tip-b47430d3adbedbfdb5979ba4874f5dadf94f16b1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        rostedt@goodmis.org, dipankar@in.ibm.com, tglx@linutronix.de,
        bjorn@mork.no
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        rostedt@goodmis.org, dipankar@in.ibm.com, bjorn@mork.no,
        tglx@linutronix.de
In-Reply-To: <519169BF.4080208@linux.vnet.ibm.com>
References: <519169BF.4080208@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu/idle:
  Wrap cpu-idle poll mode within rcu_idle_enter/exit
Git-Commit-ID: b47430d3adbedbfdb5979ba4874f5dadf94f16b1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b47430d3adbedbfdb5979ba4874f5dadf94f16b1
Gitweb:     http://git.kernel.org/tip/b47430d3adbedbfdb5979ba4874f5dadf94f16b1
Author:     Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
AuthorDate: Tue, 14 May 2013 04:01:27 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 14 May 2013 17:43:29 +0200

rcu/idle: Wrap cpu-idle poll mode within rcu_idle_enter/exit

Bjørn Mork reported the following warning when running powertop.

[   49.289034] ------------[ cut here ]------------
[   49.289055] WARNING: at kernel/rcutree.c:502 rcu_eqs_exit_common.isra.48+0x3d/0x125()
[   49.289244] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.0-bisect-rcu-warn+ #107
[   49.289251]  ffffffff8157d8c8 ffffffff81801e28 ffffffff8137e4e3 ffffffff81801e68
[   49.289260]  ffffffff8103094f ffffffff81801e68 0000000000000000 ffff88023afcd9b0
[   49.289268]  0000000000000000 0140000000000000 ffff88023bee7700 ffffffff81801e78
[   49.289276] Call Trace:
[   49.289285]  [<ffffffff8137e4e3>] dump_stack+0x19/0x1b
[   49.289293]  [<ffffffff8103094f>] warn_slowpath_common+0x62/0x7b
[   49.289300]  [<ffffffff8103097d>] warn_slowpath_null+0x15/0x17
[   49.289306]  [<ffffffff810a9006>] rcu_eqs_exit_common.isra.48+0x3d/0x125
[   49.289314]  [<ffffffff81079b49>] ? trace_hardirqs_off_caller+0x37/0xa6
[   49.289320]  [<ffffffff810a9692>] rcu_idle_exit+0x85/0xa8
[   49.289327]  [<ffffffff8107076e>] trace_cpu_idle_rcuidle+0xae/0xff
[   49.289334]  [<ffffffff810708b1>] cpu_startup_entry+0x72/0x115
[   49.289341]  [<ffffffff813689e5>] rest_init+0x149/0x150
[   49.289347]  [<ffffffff8136889c>] ? csum_partial_copy_generic+0x16c/0x16c
[   49.289355]  [<ffffffff81a82d34>] start_kernel+0x3f0/0x3fd
[   49.289362]  [<ffffffff81a8274c>] ? repair_env_string+0x5a/0x5a
[   49.289368]  [<ffffffff81a82481>] x86_64_start_reservations+0x2a/0x2c
[   49.289375]  [<ffffffff81a82550>] x86_64_start_kernel+0xcd/0xd1
[   49.289379] ---[ end trace 07a1cc95e29e9036 ]---

The warning is that 'rdtp->dynticks' has an unexpected value, which roughly
translates to - the calls to rcu_idle_enter() and rcu_idle_exit() were not
made in the correct order, or otherwise messed up.

And Bjørn's painstaking debugging indicated that this happens when the idle
loop enters the poll mode. Looking at the poll function cpu_idle_poll(), and
the implementation of trace_cpu_idle_rcuidle(), the problem becomes very clear:
cpu_idle_poll() lacks calls to rcu_idle_enter/exit(), and trace_cpu_idle_rcuidle()
calls them in the reverse order - first rcu_idle_exit(), and then rcu_idle_enter().
Hence the even/odd alternative sequencing of rdtp->dynticks goes for a toss.

And powertop readily triggers this because powertop uses the idle-tracing
infrastructure extensively.

So, to fix this, wrap the code in cpu_idle_poll() within rcu_idle_enter/exit(),
so that it blends properly with the calls inside trace_cpu_idle_rcuidle() and
thus get the function ordering right.

Reported-and-tested-by: Bjørn Mork <bjorn@mork.no>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/519169BF.4080208@linux.vnet.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/cpu/idle.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
index 8b86c0c..d5585f5 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -40,11 +40,13 @@ __setup("hlt", cpu_idle_nopoll_setup);
 
 static inline int cpu_idle_poll(void)
 {
+	rcu_idle_enter();
 	trace_cpu_idle_rcuidle(0, smp_processor_id());
 	local_irq_enable();
 	while (!need_resched())
 		cpu_relax();
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
+	rcu_idle_exit();
 	return 1;
 }
 
