Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab3BNDEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:04:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20074 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab3BNDEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:04:54 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=NbYD9KISzMsA:10 a=VwQbUJbxAAAA:8 a=YWKdqMyKAAAA:8 a=ZSQUmvvWAAAA:8 a=GwE8C_716FG_syHVI00A:9 a=PUjeQqilurYA:10 a=_WS7f9hlDtoA:10 a=OLNxAiqoKOyVwEeu:21 a=xVF1GwmG0FyB8q8T:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360811091.23152.25.camel@gandalf.local.home>
Subject: [ANNOUNCE] 3.4.29-rt42
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Wed, 13 Feb 2013 22:04:51 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.4.29-rt42 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: eab759b5f284bd3c29aaa12f41623ef2cb2ac60d


Or to build 3.4.29-rt42 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.4.29.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4.29-rt42.patch.xz


You can also build from 3.4.29-rt41 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/incr/patch-3.4.29-rt41-rt42.patch.xz



Enjoy,

-- Steve


Changes from 3.4.29-rt41:

---

Steven Rostedt (1):
      Linux 3.4.29-rt42

Thomas Gleixner (5):
      drivers-tty-pl011-irq-disable-madness.patch
      mmci: Remove bogus local_irq_save()
      sched: Init idle->on_rq in init_idle()
      sched: Check for idle task in might_sleep()
      mm: swap: Initialize local locks early

----
 drivers/mmc/host/mmci.c         |    5 -----
 drivers/tty/serial/amba-pl011.c |   15 ++++++++++-----
 kernel/sched/core.c             |    4 +++-
 localversion-rt                 |    2 +-
 mm/swap.c                       |   12 +++++++++---
 5 files changed, 23 insertions(+), 15 deletions(-)
---------------------------
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 032b847..6f8a1a7 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -910,15 +910,12 @@ static irqreturn_t mmci_pio_irq(int irq, void *dev_id)
 	struct sg_mapping_iter *sg_miter = &host->sg_miter;
 	struct variant_data *variant = host->variant;
 	void __iomem *base = host->base;
-	unsigned long flags;
 	u32 status;
 
 	status = readl(base + MMCISTATUS);
 
 	dev_dbg(mmc_dev(host->mmc), "irq1 (pio) %08x\n", status);
 
-	local_irq_save(flags);
-
 	do {
 		unsigned int remain, len;
 		char *buffer;
@@ -958,8 +955,6 @@ static irqreturn_t mmci_pio_irq(int irq, void *dev_id)
 
 	sg_miter_stop(sg_miter);
 
-	local_irq_restore(flags);
-
 	/*
 	 * If we have less than the fifo 'half-full' threshold to transfer,
 	 * trigger a PIO interrupt as soon as any data is available.
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index b69356c..7b29c92 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1788,13 +1788,19 @@ pl011_console_write(struct console *co, const char *s, unsigned int count)
 
 	clk_enable(uap->clk);
 
-	local_irq_save(flags);
+	/*
+	 * local_irq_save(flags);
+	 *
+	 * This local_irq_save() is nonsense. If we come in via sysrq
+	 * handling then interrupts are already disabled. Aside of
+	 * that the port.sysrq check is racy on SMP regardless.
+	*/
 	if (uap->port.sysrq)
 		locked = 0;
 	else if (oops_in_progress)
-		locked = spin_trylock(&uap->port.lock);
+		locked = spin_trylock_irqsave(&uap->port.lock, flags);
 	else
-		spin_lock(&uap->port.lock);
+		spin_lock_irqsave(&uap->port.lock, flags);
 
 	/*
 	 *	First save the CR then disable the interrupts
@@ -1816,8 +1822,7 @@ pl011_console_write(struct console *co, const char *s, unsigned int count)
 	writew(old_cr, uap->port.membase + UART011_CR);
 
 	if (locked)
-		spin_unlock(&uap->port.lock);
-	local_irq_restore(flags);
+		spin_unlock_irqrestore(&uap->port.lock, flags);
 
 	clk_disable(uap->clk);
 }
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fec5603..751ec60 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5264,6 +5264,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	rcu_read_unlock();
 
 	rq->curr = rq->idle = idle;
+	idle->on_rq = 1;
 #if defined(CONFIG_SMP)
 	idle->on_cpu = 1;
 #endif
@@ -7535,7 +7536,8 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
 	rcu_sleep_check(); /* WARN_ON_ONCE() by default, no rate limit reqd. */
-	if ((preempt_count_equals(preempt_offset) && !irqs_disabled()) ||
+	if ((preempt_count_equals(preempt_offset) && !irqs_disabled() &&
+	     !is_idle_task(current)) ||
 	    system_state != SYSTEM_RUNNING || oops_in_progress)
 		return;
 	if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)
diff --git a/localversion-rt b/localversion-rt
index 629e0b4..8bdfb9a 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt41
+-rt42
diff --git a/mm/swap.c b/mm/swap.c
index 2051da9..62dc70c 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -767,6 +767,15 @@ unsigned pagevec_lookup_tag(struct pagevec *pvec, struct address_space *mapping,
 }
 EXPORT_SYMBOL(pagevec_lookup_tag);
 
+/* Early setup for the local locks */
+static int __init swap_init_locks(void)
+{
+	local_irq_lock_init(rotate_lock);
+	local_irq_lock_init(swap_lock);
+	return 1;
+}
+early_initcall(swap_init_locks);
+
 /*
  * Perform any setup for the swap system
  */
@@ -774,9 +783,6 @@ void __init swap_setup(void)
 {
 	unsigned long megs = totalram_pages >> (20 - PAGE_SHIFT);
 
-	local_irq_lock_init(rotate_lock);
-	local_irq_lock_init(swap_lock);
-
 #ifdef CONFIG_SWAP
 	bdi_init(swapper_space.backing_dev_info);
 #endif


