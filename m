Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaAQE55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 23:57:57 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:22425 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751215AbaAQE5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 23:57:55 -0500
Date: Thu, 16 Jan 2014 23:57:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Clark Williams <williams@redhat.com>
Subject: [RFC][PATCH] preempt: Debug for possible missed preemption checks
Message-ID: <20140116235751.084728c8@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra mentioned that he wanted to catch the following problem:

 local_irq_disable();
 preempt_disable();
 local_irq_enable();

 local_irq_disable();
 preempt_enable();
 local_irq_enable();

Now what's wrong with the above? What happens if an interrupt comes in
the middle of that (between the local_irq_enable() and
local_irq_disable()) and sets the NEED_RESCHED flag? Because preemption
is disabled, it wont schedule there. It expects the schedule will
happen when preemption is enabled.

But the problem is that the preempt_enable() happens when a schedule
can not take place (interrupts are disabled), so it is ignored. Now
when interrupts are enabled, there's no NEED_RESCHED check, and we miss
our schedule.

Note, the first preempt_disable() did not need to even be within
the irq_disabled section. You can get the same problem with:

 preempt_disable();

  <interrupt - set NEED_RESCHED>

 local_irq_disable();
 preempt_enable();
 local_irq_enable();

Basically anytime you go from preemption disabled and interrupts
enabled, to preemption enabled and interrupts disabled without ever
going back to preemption enabled and interrupts disabled state.

This can be solved by keeping track of the preemption and interrupt
states for the CPU. Here's the state diagram:

 State 0:  Preempt Enabled, Interrupts Enabled  (PEIE)
 State 1:  Preempt Enabled, Interrupts Disabled (PEID)
 State 2:  Preempt Disabled, Interrupts Enabled (PDIEX) *
 State 3:  Preempt Disabled, Interrupts Enabled (PDIE) **
 State 4:  Preempt Disabled, Interrupts Disabled (PDID)
 State 5:  Preempt Disabled, Interrupts Disabled (PDIDX)
 State 6:  Preempt Enabled, Interrupts Disabled (PEIDX)
 State 7:  Preempt Enabled, Interrupts Enabled (PEIEX) ***

(*) State 2 is the state where problems can occur (an interrupt
    setting NEED_RESCHED while preemption is disabled).

Notice that some of the states have the same preemption and interrupts
disabled state. The difference between them is that those that went
through state 2 (denoted with an "X"), can lead us to state 6 which is
the state that can miss a preemption point.

(**) The difference between state 2 and state 3, is that state 3 is
     state 2 when it is in an interrupt. Ideally we would just switch
     state 7 to state 0 if we are in an interrupt, but this code can
     be called outside the setting of the "in_interrupt()" counter, and
     we can not detect it. To work around this, state 3 is created to
     keep from going into states 5, 6 and 7 while in an interrupt.

(***) If we hit state 7, we know that there's a path that exists that
      can lead us to miss a required schedule.

The state transactions are:

                [preemption state changes]     [interrupt state changes]
 State 0: (PEIE)           State 2                       State 1
 State 1: (PEID)           State 4                       State 0
 State 2: (PDIEX)          State 0                       State 5
 State 3: (PDIE)           State 0                       State 4
 State 4: (PDID)           State 1                       State 2
 State 5: (PDIDX)          State 6                       State 2
 State 6: (PEIDX)          State 5                       State 7
 State 7: (PEIEX)           [End]                         [End]


When PROVE_LOCKING and PREEMPT is configured, the preempt state
tracking is active. Testing this out, I added a module that did the
following:

  preempt_disable();
  local_irq_disable();
  preempt_enable();
  local_irq_enable();

I also tested against:

  local_irq_disable();
  preempt_disable();
  local_irq_enable();
  local_irq_disable();
  preempt_enable();
  local_irq_enable();

And here's what the output looks like:

 ===============================
 [INFO: preempt check hit problem state]
 irq event stamp: 12
 hardirqs last  enabled at (11): [<ffffffff81666510>] _raw_spin_unlock_irq+0x30/0x60
 hardirqs last disabled at (12): [<ffffffffa050d01e>] dumb_thread+0x1e/0x80 [preempt_bug]
 softirqs last  enabled at (0): [<ffffffff8104f038>] copy_process+0x788/0x1a50
 softirqs last disabled at (0): [<          (null)>]           (null)
 Entered dangerous state at: 
    [<ffffffff8166a83b>] preempt_count_add+0xab/0x110
    [<ffffffffa050d018>] dumb_thread+0x18/0x80 [preempt_bug]
    [<ffffffff81076c03>] kthread+0xf3/0x110
    [<ffffffff8166e52c>] ret_from_fork+0x7c/0xb0
    [<ffffffffffffffff>] 0xffffffffffffffff
 stack backtrace:
 CPU: 4 PID: 3405 Comm: task1 Tainted: G           O 3.13.0-rc8-test+ #60
 Hardware name: Hewlett-Packard HP Compaq Pro 6300 SFF/339A, BIOS K01 v02.05 05/07/2012
  0000000000000006 ffff8800d47e5da8 ffffffff8165d459 0000000000000002
  ffffffffa050d028 ffff8800d47e5de8 ffffffff81099fc8 ffff8800d47e5df8
  ffffffffa050d028 0000000000000000 ffffffffa050d000 0000000000000000
 Call Trace:
  [<ffffffff8165d459>] dump_stack+0x4f/0x7c
  [<ffffffffa050d028>] ? dumb_thread+0x28/0x80 [preempt_bug]
  [<ffffffff81099fc8>] update_pied_state+0x398/0x3b0
  [<ffffffffa050d028>] ? dumb_thread+0x28/0x80 [preempt_bug]
  [<ffffffffa050d000>] ? 0xffffffffa050cfff
  [<ffffffff8109de40>] trace_preempt_on+0x20/0x30
  [<ffffffff8166a749>] preempt_count_sub+0xb9/0x100
  [<ffffffffa050d028>] dumb_thread+0x28/0x80 [preempt_bug]
  [<ffffffff81076c03>] kthread+0xf3/0x110
  [<ffffffff81076b10>] ? flush_kthread_worker+0x150/0x150
  [<ffffffff8166e52c>] ret_from_fork+0x7c/0xb0
  [<ffffffff81076b10>] ? flush_kthread_worker+0x150/0x150
 Last states (starting with most recent):
  1) State 5 (PDIDX)
      pc: 00000001  irqs: D
      .. [<ffffffffa050d01e>] .... dumb_thread+0x1e/0x80 [preempt_bug]
  2) State 2 (PDIEX)
      pc: 00000001  irqs: E
      .. [<ffffffffa050d018>] .... dumb_thread+0x18/0x80 [preempt_bug]
  3) State 0 (PEIE)
      pc: 00000001  irqs: E
      .. [<ffffffff81660d64>] .... __schedule+0x3b4/0x840
  4) State 2 (PDIEX)
      pc: 00000002  irqs: D
      .. [<ffffffff81666510>] .... _raw_spin_unlock_irq+0x30/0x60
  5) State 5 (PDIDX)
      pc: 00000001  irqs: D
      .. [<ffffffff81665dc7>] .... _raw_spin_lock_irq+0x17/0x50
  6) State 2 (PDIEX)
      pc: 00000001  irqs: D
      .. [<ffffffff810b8e19>] .... rcu_note_context_switch+0x99/0x300
  7) State 5 (PDIDX)
      pc: 00000001  irqs: D
      .. [<ffffffff810b8de7>] .... rcu_note_context_switch+0x67/0x300
  8) State 2 (PDIEX)
      pc: 00000001  irqs: E
      .. [<ffffffff816609f9>] .... __schedule+0x49/0x840
  9) State 0 (PEIE)
      pc: 00000001  irqs: E
      .. [<ffffffff81661633>] .... schedule_preempt_disabled+0x13/0x30
  10) State 2 (PDIEX)
      pc: 00000001  irqs: D
      .. [<ffffffff810c49e9>] .... tick_nohz_idle_exit+0x129/0x190
  11) State 5 (PDIDX)
      pc: 00000001  irqs: D
      .. [<ffffffff810c48f1>] .... tick_nohz_idle_exit+0x31/0x190
  12) State 2 (PDIEX)
      pc: 00000001  irqs: D
      .. [<ffffffff810b6019>] .... rcu_idle_exit+0x79/0xe0
  13) State 5 (PDIDX)
      pc: 00000001  irqs: D
      .. [<ffffffff810b5fc2>] .... rcu_idle_exit+0x22/0xe0
  14) State 2 (PDIEX)
      pc: 00000001  irqs: D
      .. [<ffffffff814f122f>] .... cpuidle_enter_state+0x5f/0xe0
  15) State 5 (PDIDX)
      pc: 00000001  irqs: D
      .. [<ffffffff810aca4f>] .... cpu_startup_entry+0xbf/0x320
  16) State 2 (PDIEX)
      pc: 00000001  irqs: D
      .. [<ffffffff810c47aa>] .... tick_nohz_idle_enter+0x4a/0x80

Link: http://lkml.kernel.org/r/20140116174536.GB9655@laptop.programming.kicks-ass.net
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


Index: linux-trace.git/include/linux/ftrace.h
===================================================================
--- linux-trace.git.orig/include/linux/ftrace.h
+++ linux-trace.git/include/linux/ftrace.h
@@ -634,16 +634,36 @@ static inline void __ftrace_enabled_rest
 #endif
 
 #ifdef CONFIG_PREEMPT_TRACER
-  extern void trace_preempt_on(unsigned long a0, unsigned long a1);
-  extern void trace_preempt_off(unsigned long a0, unsigned long a1);
-#else
+ extern void time_preempt_on(unsigned long a0, unsigned long a1);
+ extern void time_preempt_off(unsigned long a0, unsigned long a1);
+# ifdef CONFIG_PROVE_LOCKING
+   extern void trace_preempt_on(unsigned long a0, unsigned long a1);
+   extern void trace_preempt_off(unsigned long a0, unsigned long a1);
+# else
+static inline void trace_preempt_on(unsigned long a0, unsigned long a1)
+{
+	time_preempt_on(a0, a1);
+}
+static inline void trace_preempt_off(unsigned long a0, unsigned long a1)
+{
+	time_preempt_off(a0, a1);
+}
+# endif /* CONFIG_PROVE_LOCKING */
+#else /* !CONFIG_PREEMPT_TRACER */
+static inline void time_preempt_on(unsigned long a0, unsigned long a1) { }
+ extern void time_preempt_off(unsigned long a0, unsigned long a1);
+# ifdef CONFIG_PROVE_LOCKING
+   extern void trace_preempt_on(unsigned long a0, unsigned long a1);
+   extern void trace_preempt_off(unsigned long a0, unsigned long a1);
+# else
 /*
  * Use defines instead of static inlines because some arches will make code out
  * of the CALLER_ADDR, when we really want these to be a real nop.
  */
 # define trace_preempt_on(a0, a1) do { } while (0)
 # define trace_preempt_off(a0, a1) do { } while (0)
-#endif
+# endif /* CONFIG_PROVE_LOCKING */
+#endif /* CONFIG_PREEMPT_TRACER */
 
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 extern void ftrace_init(void);
Index: linux-trace.git/kernel/locking/lockdep.c
===================================================================
--- linux-trace.git.orig/kernel/locking/lockdep.c
+++ linux-trace.git/kernel/locking/lockdep.c
@@ -67,6 +67,18 @@ module_param(lock_stat, int, 0644);
 #define lock_stat 0
 #endif
 
+#ifdef CONFIG_PREEMPT
+enum pied_stat_type {
+	PIED_STATE_PREEMPT,
+	PIED_STATE_INTERRUPT
+};
+
+static void update_pied_state(enum pied_stat_type type, bool enable,
+			      unsigned long ip);
+#else
+#define update_pied_state(type, enable, ip)	do { } while (0)
+#endif
+
 /*
  * lockdep_lock: protects the lockdep graph, the hashes and the
  *               class/list/hash allocators.
@@ -2572,6 +2584,8 @@ void trace_hardirqs_on_caller(unsigned l
 		return;
 	}
 
+	update_pied_state(PIED_STATE_INTERRUPT, true, ip);
+
 	/*
 	 * We're enabling irqs and according to our state above irqs weren't
 	 * already enabled, yet we find the hardware thinks they are in fact
@@ -2617,6 +2631,8 @@ void trace_hardirqs_off_caller(unsigned
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
 
+	update_pied_state(PIED_STATE_INTERRUPT, false, ip);
+
 	/*
 	 * So we're supposed to get called after you mask local IRQs, but for
 	 * some reason the hardware doesn't quite think you did a proper job.
@@ -4255,3 +4271,331 @@ void lockdep_rcu_suspicious(const char *
 	dump_stack();
 }
 EXPORT_SYMBOL_GPL(lockdep_rcu_suspicious);
+
+#ifdef CONFIG_PREEMPT
+
+/*
+ * If preemption is ever disabled with interrupts enabled, there's a chance
+ * that an interrupt could happen and set the NEED_RESCHED flag. That's 
+ * fine and all as the preempt_enable() will do the scheduling. But if
+ * the preempt enable happens to be within a interrupt disabled section
+ * this preemption point will be lost as enabling interrupts does not
+ * check the NEED_RESCHED flag. For example:
+ *
+ * preempt_disable();
+ * <interrupt - set NEED_RESCHED>
+ * local_irq_save();
+ * preempt_enable(); <-- checks NEED_RESCHED but wont schedule due to
+ *                       interrupts disabled.
+ * local_irq_enable(); <-- does not check NEED_RESCHED and we miss the
+ *                         preemption point.
+ *
+ * Now to catch this scenerio, 8 states are defined for each CPU.
+ *
+ * State 0:  Preempt Enabled, Interrupts Enabled  (PEIE)
+ * State 1:  Preempt Enabled, Interrupts Disabled (PEID)
+ * State 2:  Preempt Disabled, Interrupts Enabled (PDIEX) *
+ * State 3:  Preempt Disabled, Interrupts Enabled (PDIE) **
+ * State 4:  Preempt Disabled, Interrupts Disabled (PDID)
+ * State 5:  Preempt Disabled, Interrupts Disabled (PDIDX)
+ * State 6:  Preempt Enabled, Interrupts Disabled (PEIDX)
+ * State 7:  Preempt Enabled, Interrupts Enabled (PEIEX) ***
+ *
+ * (*) State 2 is the state where problems can occur (an interrupt setting
+ * NEED_RESCHED while preemption is disabled).
+ *
+ * Notice that some of the states have the same preemption and interrupts
+ * disabled state. The difference between them is that those went through
+ * state 2 (denoted with an "X"), can lead us to state 6 which is the
+ * state that can miss a preemption point.
+ *
+ * (**) The difference between state 2 and state 3, is that state 3
+ * is state 2 when it is in an interrupt. Ideally we would just switch
+ * state 7 to state 0 if we are in an interrupt, but this code can
+ * be called outside the setting of the "in_interrupt()" counter, and
+ * we can not detect it. To work around this, state 3 is created to keep
+ * from going into states 5, 6 and 7 while in an interrupt.
+ *
+ * (***) If we hit state 7, we know that there's a path that exists that
+ * can lead us to miss a required schedule.
+ *
+ * The state transactions are:
+ *
+ *                 [preemption state changes]     [interrupt state changes]
+ * State 0: (PEIE)           State 2                       State 1
+ * State 1: (PEID)           State 4                       State 0
+ * State 2: (PDIEX)          State 0                       State 5
+ * State 3: (PDIE)           State 0                       State 4
+ * State 4: (PDID)           State 1                       State 2
+ * State 5: (PDIDX)          State 6                       State 2
+ * State 6: (PEIDX)          State 5                       State 7
+ * State 7: (PEIEX)           [End]                         [End]
+ */
+
+static const char *pied_state_names[] = {
+	"PEIE", "PEID", "PDIEX", "PDIE", "PDID", "PDIDX", "PEIDX", "PEIEX"
+};
+
+/*
+ * The Preempt Interrupt Enable/Disable state (PIED) structure
+ *  preempt_change: 	what state to go to on change of preemption.
+ *  interrupt_change:	what state to go to on change of interrupt.
+ */
+struct pied_state {
+	int		preempt_change;
+	int		interrupt_change;
+};
+
+static struct pied_state pied_state_trans[] = {
+	{	2,	1	},
+	{	4,	0	},
+	{	0,	5	},
+	{	0,	4	},
+	{	1,	2	},
+	{	6,	2	},
+	{	5,	7	},
+	{	7,	7	}
+};
+
+#define PIED_DANGEROUS_STATE	2
+#define PIED_BAD_STATE		6
+
+static bool pied_failed __read_mostly = false;
+
+#define PIED_STACK_MAX 100
+
+static DEFINE_PER_CPU(int, current_pied_state);
+static DEFINE_PER_CPU(int, pied_initialized);
+static DEFINE_PER_CPU(int, pied_irqsoff);
+static DEFINE_PER_CPU(struct stack_trace, pied_stack_trace);
+static DEFINE_PER_CPU(unsigned long, pied_stack[PIED_STACK_MAX]);
+
+struct pied_state_trail {
+	short		state;
+	short		irq;
+	int		pc;
+	unsigned long	ip;
+};
+
+#define  PIED_STATE_TRAIL_BITS	4
+#define PIED_STATE_TRAIL_SIZE	(1 << PIED_STATE_TRAIL_BITS)
+#define PIED_STATE_TRAIL_MASK	(PIED_STATE_TRAIL_SIZE - 1)
+
+
+static DEFINE_PER_CPU(struct pied_state_trail,
+		      pied_state_trail[PIED_STATE_TRAIL_SIZE]);
+static DEFINE_PER_CPU(unsigned int, pied_state_trail_idx);
+static DEFINE_PER_CPU(unsigned int, pied_recursive);
+
+static void update_pied_trail(int state, unsigned long ip, int irq)
+{
+	struct pied_state_trail *trail;
+	int idx = this_cpu_read(pied_state_trail_idx) &
+		PIED_STATE_TRAIL_MASK;
+
+	this_cpu_inc(pied_state_trail_idx);
+
+	trail = this_cpu_ptr(pied_state_trail);
+	trail[idx].state = state;
+	trail[idx].irq = irq;
+	trail[idx].ip = ip;
+	trail[idx].pc = preempt_count();
+}
+
+static void print_pied_trail(void)
+{
+	struct pied_state_trail *trail;
+	int idx = this_cpu_read(pied_state_trail_idx);
+	int i, x, s;
+
+	printk("Last states (starting with most recent):\n");
+
+	trail = this_cpu_ptr(pied_state_trail);
+
+	for (i = 1; i <= PIED_STATE_TRAIL_SIZE; i++) {
+		x = (idx - i) & PIED_STATE_TRAIL_MASK;
+		s = trail[x].state;
+		printk(" %d) State %d (%s)\n", i, s, pied_state_names[s]);
+		printk("     pc: %08x  irqs: %c\n",
+		       trail[x].pc, trail[x].irq ? 'D' : 'E');
+		printk("     .. [<%08lx>] .... %pS\n",
+		       trail[x].ip, (void *)trail[x].ip);
+		if (0 && !s)
+			break;
+	}
+}
+
+static void pied_state_bug(enum pied_stat_type type, bool enable,
+			   int old_state, int state)
+{
+	const char *stype;
+	const char *senable;
+
+	switch (type) {
+	case PIED_STATE_PREEMPT:
+		stype = "preempt";
+		break;
+	case PIED_STATE_INTERRUPT:
+		stype = "interrupt";
+		break;
+	}
+
+	if (enable)
+		senable = "disable";
+	else
+		senable = "enable";
+
+	lockdep_off();
+	pied_failed = true;
+	printk("\n");
+	printk("===============================\n");
+	printk("[INFO: preempt check state corruption]\n");
+	printk("Expected %s %s in state %d (%s) (from state %d [%s])\n",
+	       stype, senable, state, pied_state_names[state],
+	       old_state, pied_state_names[old_state]);
+	print_irqtrace_events(current);
+	dump_stack();
+	print_pied_trail();
+	lockdep_on();
+}
+
+static void update_pied_state(enum pied_stat_type type, bool enable,
+			      unsigned long ip)
+{
+	struct stack_trace *trace;
+	int state, new_state;
+	unsigned long flags;
+
+	if (pied_failed)
+		return;
+
+	if (this_cpu_read(pied_recursive))
+		return;
+
+	/*
+	 * Boot up may start with interrupts and/or preemption
+	 * disabled. We can't start the state updates till
+	 * we have synced with the initial state.
+	 */
+	if (!this_cpu_read(pied_initialized)) {
+		/*
+		 * The first time we enable preemption with interrupts
+		 * enabled on a CPU, start the state transactions.
+		 */
+		if (!in_interrupt() && type == PIED_STATE_PREEMPT &&
+		    enable && !irqs_disabled())
+			this_cpu_write(pied_initialized, 1);
+		return;
+	}
+
+	if (type == PIED_STATE_INTERRUPT) {
+		if (enable == false) {
+			/* Ignore nested disabling of interrupts */
+			if (this_cpu_read(pied_irqsoff))
+				return;
+			this_cpu_write(pied_irqsoff, 1);
+		} else
+			this_cpu_write(pied_irqsoff, 0);
+	}
+
+	this_cpu_inc(pied_recursive);
+	raw_local_irq_save(flags);
+
+	state = this_cpu_read(current_pied_state);
+
+	switch (type) {
+	case PIED_STATE_PREEMPT:
+		new_state = pied_state_trans[state].preempt_change;
+		switch (new_state) {
+		case 0: case 1: case 6: case 7:
+			if (!enable)
+				pied_state_bug(type, enable, state, new_state);
+			break;
+		default:
+			if (enable)
+				pied_state_bug(type, enable, state, new_state);
+			break;
+		}
+		break;
+	case PIED_STATE_INTERRUPT:
+		new_state = pied_state_trans[state].interrupt_change;
+		switch (new_state) {
+		case 0: case 2: case 3: case 7:
+			if (!enable)
+				pied_state_bug(type, enable, state, new_state);
+			break;
+		default:
+			if (enable)
+				pied_state_bug(type, enable, state, new_state);
+			break;
+		}
+		break;
+	}
+
+	switch (new_state) {
+	case PIED_DANGEROUS_STATE:
+		/*
+		 * If we are in an interrupt, then we need to switch
+		 * to state 3 to prevent from going into state 5, 6 and 7.
+		 *
+		 * PDIEX ==> PDIE
+		 */
+		if (in_interrupt()) {
+			new_state = 3;
+			break;
+		}
+		trace = this_cpu_ptr(&pied_stack_trace);
+		trace->nr_entries = 0;
+		trace->max_entries = PIED_STACK_MAX;
+		trace->entries = this_cpu_ptr(pied_stack);
+
+		trace->skip = 3;
+
+		save_stack_trace(trace);
+
+		break;
+	case PIED_BAD_STATE:
+
+		/*
+		 * Interrupts themselves do not cause problems as they
+		 * always check NEED_RESCHED when going back to normal context.
+		 *
+		 * PEIEX ==> PEIE
+		 */
+		if (in_interrupt()) {
+			new_state = 0;
+			break;
+		}
+
+		lockdep_off();
+		pied_failed = true;
+		printk("\n");
+		printk("===============================\n");
+		printk("[INFO: preempt check hit problem state]\n");
+		print_irqtrace_events(current);
+		printk("Entered dangerous state at: \n");
+		print_stack_trace(this_cpu_ptr(&pied_stack_trace), 2); 
+		printk("\nstack backtrace:\n");
+		dump_stack();
+		print_pied_trail();
+		lockdep_on();
+		break;
+	}
+	this_cpu_write(current_pied_state, new_state);
+	update_pied_trail(new_state, ip, irqs_disabled_flags(flags));
+	raw_local_irq_restore(flags);
+	this_cpu_dec(pied_recursive);
+}
+
+void trace_preempt_on(unsigned long a0, unsigned long a1)
+{
+	time_preempt_on(a0, a1);
+	update_pied_state(PIED_STATE_PREEMPT, true, a0);
+}
+
+void trace_preempt_off(unsigned long a0, unsigned long a1)
+{
+	time_preempt_off(a0, a1);
+	update_pied_state(PIED_STATE_PREEMPT, false, a0);
+}
+#endif /* CONFIG_PREEMPT */
Index: linux-trace.git/kernel/sched/core.c
===================================================================
--- linux-trace.git.orig/kernel/sched/core.c
+++ linux-trace.git/kernel/sched/core.c
@@ -2414,7 +2414,8 @@ void __kprobes preempt_count_add(int val
 	DEBUG_LOCKS_WARN_ON((preempt_count() & PREEMPT_MASK) >=
 				PREEMPT_MASK - 10);
 #endif
-	if (preempt_count() == val)
+	/* PREEMPT_ACTIVE gets set directly, it must be ignored */
+	if ((preempt_count() & ~PREEMPT_ACTIVE) == val)
 		trace_preempt_off(ip, parent_ip);
 }
 EXPORT_SYMBOL(preempt_count_add);
@@ -2435,7 +2436,8 @@ void __kprobes preempt_count_sub(int val
 		return;
 #endif
 
-	if (preempt_count() == val)
+	/* PREEMPT_ACTIVE gets set directly, it must be ignored */
+	if ((preempt_count() & ~PREEMPT_ACTIVE) == val)
 		trace_preempt_on(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
 	__preempt_count_sub(val);
 }
Index: linux-trace.git/kernel/softirq.c
===================================================================
--- linux-trace.git.orig/kernel/softirq.c
+++ linux-trace.git/kernel/softirq.c
@@ -111,7 +111,8 @@ static void __local_bh_disable(unsigned
 		trace_softirqs_off(ip);
 	raw_local_irq_restore(flags);
 
-	if (preempt_count() == cnt)
+	/* PREEMPT_ACTIVE gets set directly, it must be ignored */
+	if ((preempt_count() & ~PREEMPT_ACTIVE) == cnt)
 		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
 }
 #else /* !CONFIG_TRACE_IRQFLAGS */
Index: linux-trace.git/kernel/trace/trace_irqsoff.c
===================================================================
--- linux-trace.git.orig/kernel/trace/trace_irqsoff.c
+++ linux-trace.git/kernel/trace/trace_irqsoff.c
@@ -516,13 +516,13 @@ EXPORT_SYMBOL(trace_hardirqs_off_caller)
 #endif /*  CONFIG_IRQSOFF_TRACER */
 
 #ifdef CONFIG_PREEMPT_TRACER
-void trace_preempt_on(unsigned long a0, unsigned long a1)
+void time_preempt_on(unsigned long a0, unsigned long a1)
 {
 	if (preempt_trace() && !irq_trace())
 		stop_critical_timing(a0, a1);
 }
 
-void trace_preempt_off(unsigned long a0, unsigned long a1)
+void time_preempt_off(unsigned long a0, unsigned long a1)
 {
 	if (preempt_trace() && !irq_trace())
 		start_critical_timing(a0, a1);

