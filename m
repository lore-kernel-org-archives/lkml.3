Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaA0Rb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:31:58 -0500
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:38365 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861AbaA0Rb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:31:57 -0500
X-Yandex-Uniq: cd5e6c8c-e4ba-40b7-bebe-a136b567d7cf
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Mon, 27 Jan 2014 21:31:49 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: dan.j.williams@intel.com, dave.jiang@intel.com, vinod.koul@intel.com,
        alexander.h.duyck@intel.com, whipple@securedatainnovations.ch
Cc: linux-kernel@vger.kernel.org
Subject: [REGRESSION][BISECTED] 3.10.26: net_dma: mark broken (b69ec589136c)
Message-ID: <20140127173149.GA8099@stfomichev-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For Xeon machines in config we have:
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DCA=m

"net_dma: mark broken" changed it to (no CONFIG_NET_DMA):
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=m

Since this commit, we started to observe that after machine reboots there
is some change (1 out of 10) that ksoftirqd/0 will eat 100% CPU#0.
In this case I see huge number of tasklets executed on CPU#0 (about a million
each second).

To reproduce I just reboot machine and check ksoftirqd/0 CPU usage, if it's <5%,
reboot machine again.

I added trace_printk into tasklet_action and I see the same tasklet
"executed" (it's disabled) over and over:
     ksoftirqd/0-3     [000] ..s.    65.281375: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
     ksoftirqd/0-3     [000] ..s.    65.281376: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
     ksoftirqd/0-3     [000] ..s.    65.281376: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
     ksoftirqd/0-3     [000] ..s.    65.281376: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
     ksoftirqd/0-3     [000] ..s.    65.281377: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
     ksoftirqd/0-3     [000] ..s.    65.281377: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
     ksoftirqd/0-3     [000] ..s.    65.281377: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
     ksoftirqd/0-3     [000] ..s.    65.281378: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
     ksoftirqd/0-3     [000] ..s.    65.281378: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
     ksoftirqd/0-3     [000] ..s.    65.281378: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
     ksoftirqd/0-3     [000] ..s.    65.281379: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
     ksoftirqd/0-3     [000] ..s.    65.281379: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
     ksoftirqd/0-3     [000] ..s.    65.281379: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1

Then I added more printk's and got the following (correct) trace for the case
when ksoftirqd/0 doesn't consume 100% CPU:
        modprobe-650   [005] ....     9.553511: ioat_init_channel: tasklet_init(ffff880c13d72500)
     migration/3-71    [003] d...     9.554049: complete: x=ffff88061a6f9df0 ret=cpu_stop_signal_done
    migration/15-132   [015] d...     9.554790: complete: x=ffff880c15fe3df0 ret=cpu_stop_signal_done
        modprobe-650   [005] ..s.     9.556690: ioat_dma_self_test: init_completion(ffff88061c2bfa18) ret=ioat3_dma_self_test [ioatdma]
        modprobe-650   [005] ....     9.556693: ioat_dma_self_test: wait_for_completion(ffff88061c2bfa18, 750)
           mount-620   [000] d.h.     9.556694: ioat_dma_do_interrupt_msix: tasklet_schedule(ffff880c13d72500)
           mount-620   [000] d.h.     9.556695: __tasklet_schedule: t=ffff880c13d72500 ret=ioat_dma_do_interrupt_msix [ioatdma]
           mount-620   [000] ..s.     9.556696: tasklet_action: t=ffff880627c03e98 func=ioat3_cleanup_event [ioatdma] count=0
           mount-620   [000] ..s.     9.556699: ioat_dma_test_callback: complete(ffff88061c2bfa18) ret=__cleanup [ioatdma]
           mount-620   [000] d.s.     9.556700: complete: x=ffff88061c2bfa18 ret=ioat_dma_test_callback [ioatdma]
           mount-620   [000] d.H.     9.556704: ioat_dma_do_interrupt_msix: tasklet_schedule(ffff880c13d72500)
           mount-620   [000] d.H.     9.556705: __tasklet_schedule: t=ffff880c13d72500 ret=ioat_dma_do_interrupt_msix [ioatdma]
           mount-620   [000] ..s.     9.556705: tasklet_action: t=ffff880627c03e98 func=ioat3_cleanup_event [ioatdma] count=0
    migration/10-107   [010] d...     9.558487: complete: x=ffff880c15f4fdf0 ret=cpu_stop_signal_done
        modprobe-650   [011] ....     9.560545: ioat_dma_self_test: wait_for_completion returned tmo=750

And really weird trace when ksoftirqd/0 consumes 100% CPU:
        modprobe-689   [014] ....     9.490260: ioat_init_channel: tasklet_init(ffff880c13c8b568)
     migration/3-71    [003] d...     9.491727: complete: x=ffff88061a761df0 ret=cpu_stop_signal_done
    migration/13-122   [013] d...     9.492212: complete: x=ffff880c15567df0 ret=cpu_stop_signal_done
     migration/3-71    [003] d...     9.493098: complete: x=ffff880c15565df0 ret=cpu_stop_signal_done
        modprobe-689   [014] ..s.     9.493655: ioat_dma_self_test: init_completion(ffff88061a503a18) ret=ioat3_dma_self_test [ioatdma]
        modprobe-689   [014] ....     9.493657: ioat_dma_self_test: wait_for_completion(ffff88061a503a18, 750)
        modprobe-689   [014] ....     9.494250: ioat_dma_self_test: wait_for_completion returned tmo=750
        kthreadd-736   [002] d...     9.496220: complete: x=ffff880c143cfbe0 ret=kthread
     migration/2-66    [002] d...     9.499974: complete: x=ffff880619c59df0 ret=cpu_stop_signal_done
    migration/11-112   [011] d...     9.500705: complete: x=ffff880c15589df0 ret=cpu_stop_signal_done
     migration/1-61    [001] d...     9.501807: complete: x=ffff88061a48ddf0 ret=cpu_stop_signal_done
        modprobe-689   [014] ....     9.506554: ioat_init_channel: tasklet_init(ffff880c1363e358)
     migration/3-71    [003] d...     9.506737: complete: x=ffff88061a7b1df0 ret=cpu_stop_signal_done
    migration/13-122   [013] d...     9.508612: complete: x=ffff880c1570fdf0 ret=cpu_stop_signal_done
        modprobe-689   [014] ..s.     9.508988: ioat_dma_self_test: init_completion(ffff88061a503a18) ret=ioat3_dma_self_test [ioatdma]
        modprobe-689   [014] ....     9.508990: ioat_dma_self_test: wait_for_completion(ffff88061a503a18, 750)
    migration/11-112   [011] d...     9.509157: complete: x=ffff88061a76ddf0 ret=cpu_stop_signal_done
    migration/11-112   [011] d...     9.509998: complete: x=ffff880c14385df0 ret=cpu_stop_signal_done
     migration/4-76    [004] d...     9.512649: complete: x=ffff880c155b1df0 ret=cpu_stop_signal_done
    migration/10-107   [010] d...     9.513768: complete: x=ffff88061a773df0 ret=cpu_stop_signal_done
     migration/8-97    [008] d...     9.515415: complete: x=ffff880c155b3df0 ret=cpu_stop_signal_done
     migration/6-87    [006] d...     9.515475: complete: x=ffff880c155a5df0 ret=cpu_stop_signal_done
    migration/11-112   [011] d...     9.515650: complete: x=ffff880c155a7df0 ret=cpu_stop_signal_done
     migration/4-76    [004] d...     9.516355: complete: x=ffff880619c5bdf0 ret=cpu_stop_signal_done
     migration/4-76    [004] d...     9.516492: complete: x=ffff880619c4bdf0 ret=cpu_stop_signal_done
     migration/4-76    [004] d...     9.516882: complete: x=ffff880c1576ddf0 ret=cpu_stop_signal_done
     migration/3-71    [003] d...     9.518353: complete: x=ffff880c15763df0 ret=cpu_stop_signal_done
    migration/14-127   [014] d...     9.518737: complete: x=ffff880c15785df0 ret=cpu_stop_signal_done
     migration/3-71    [003] d...     9.518947: complete: x=ffff880c15761df0 ret=cpu_stop_signal_done
     migration/8-97    [008] d...     9.519121: complete: x=ffff88061ab03df0 ret=cpu_stop_signal_done
     migration/8-97    [008] d...     9.519492: complete: x=ffff880c15b15df0 ret=cpu_stop_signal_done
     migration/1-61    [001] d...     9.523569: complete: x=ffff880c15b2fdf0 ret=cpu_stop_signal_done
     migration/3-71    [003] d...     9.524123: complete: x=ffff880619fc9df0 ret=cpu_stop_signal_done
        modprobe-689   [008] ..s.     9.524370: ioat_dma_self_test: init_completion(ffff88061a503a18) ret=ioat3_dma_self_test [ioatdma]
        modprobe-689   [008] ....     9.524372: ioat_dma_self_test: wait_for_completion(ffff88061a503a18, 750)
     migration/1-61    [001] d...     9.524835: complete: x=ffff880c13e51df0 ret=cpu_stop_signal_done
    ksoftirqd/14-128   [014] d.s.     9.525102: complete: x=ffff88061a7b1b20 ret=blk_end_sync_rq
     ksoftirqd/3-72    [003] d.s.     9.526560: complete: x=ffff880c155b1b20 ret=blk_end_sync_rq
     migration/9-102   [009] d...     9.526669: complete: x=ffff880c157e7df0 ret=cpu_stop_signal_done
        kthreadd-768   [003] d...     9.526770: complete: x=ffff88061dbcfd00 ret=kthread
        kthreadd-769   [012] d...     9.526833: complete: x=ffff88061dd29d00 ret=kthread
     ksoftirqd/7-93    [007] d.s.     9.527077: complete: x=ffff880c1570fb20 ret=blk_end_sync_rq
        kthreadd-771   [007] d...     9.527799: complete: x=ffff880c17403d00 ret=kthread
     migration/7-92    [007] d...     9.527916: complete: x=ffff880c13e47df0 ret=cpu_stop_signal_done
        modprobe-689   [003] ....     9.527917: ioat_dma_self_test: wait_for_completion returned tmo=750

.. later

     ksoftirqd/0-3     [000] ..s.    65.281375: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
     ksoftirqd/0-3     [000] ..s.    65.281376: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
     ksoftirqd/0-3     [000] ..s.    65.281376: tasklet_action: t=ffff88061e5cddc0 func=ioat3_cleanup_event [ioatdma] count=1
     ... and forever

So nobody is completing the work (but wait_for_completion_timeout returns
without a timeout) and nobody schedules tasklet, but it somehow ends up
in the CPU#0 tasklet vector (disabled).
Any ideas what could be wrong and how I can further debug it?

If I put something like udelay(1000) in ioat_dma_self_test before
wait_for_completion_timeout I never see this issue.

Probably because we had NET_DMA=y, our NIC driver used DMA and somehow
masked the issue prior to this 'bad' commit.

This behavior also occurs on 3.13, I assume the reason is the same.

Here is where I placed trace_printk, just in case:
---
diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 17a2393b3e25..646f5f9da9e3 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -93,6 +93,7 @@ static irqreturn_t ioat_dma_do_interrupt_msix(int irq, void *data)
 {
 	struct ioat_chan_common *chan = data;
 
+	trace_printk("tasklet_schedule(%p)\n", &chan->cleanup_task);
 	tasklet_schedule(&chan->cleanup_task);
 
 	return IRQ_HANDLED;
@@ -115,6 +116,7 @@ void ioat_init_channel(struct ioatdma_device *device, struct ioat_chan_common *c
 	init_timer(&chan->timer);
 	chan->timer.function = device->timer_fn;
 	chan->timer.data = data;
+	trace_printk("tasklet_init(%p)\n", &chan->cleanup_task);
 	tasklet_init(&chan->cleanup_task, device->cleanup_fn, data);
 	tasklet_disable(&chan->cleanup_task);
 }
@@ -786,6 +788,7 @@ static void ioat_dma_test_callback(void *dma_async_param)
 {
 	struct completion *cmp = dma_async_param;
 
+	trace_printk("complete(%p) ret=%pf\n", cmp, (void *)_RET_IP_);
 	complete(cmp);
 }
 
@@ -844,6 +847,7 @@ int ioat_dma_self_test(struct ioatdma_device *device)
 	}
 
 	async_tx_ack(tx);
+	trace_printk("init_completion(%p) ret=%pf\n", &cmp, (void *)_RET_IP_);
 	init_completion(&cmp);
 	tx->callback = ioat_dma_test_callback;
 	tx->callback_param = &cmp;
@@ -855,7 +859,9 @@ int ioat_dma_self_test(struct ioatdma_device *device)
 	}
 	dma->device_issue_pending(dma_chan);
 
+	trace_printk("wait_for_completion(%p, %lu)\n", &cmp, msecs_to_jiffies(3000));
 	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
+	trace_printk("wait_for_completion returned tmo=%lu\n", msecs_to_jiffies(3000));
 
 	if (tmo == 0 ||
 	    dma->device_tx_status(dma_chan, cookie, NULL)
diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index b925e1b1d139..5483645ab83a 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -191,6 +191,8 @@ void ioat2_cleanup_event(unsigned long data)
 {
 	struct ioat2_dma_chan *ioat = to_ioat2_chan((void *) data);
 
+	trace_printk("%pF\n", (void*)_RET_IP_);
+
 	ioat2_cleanup(ioat);
 	writew(IOAT_CHANCTRL_RUN, ioat->base.reg_base + IOAT_CHANCTRL_OFFSET);
 }
@@ -303,6 +305,7 @@ void ioat2_timer_event(unsigned long data)
 	u64 status;
 
 	status = ioat_chansts(chan);
+	trace_printk("tasklet=%p\n", &chan->cleanup_task);
 
 	/* when halted due to errors check for channel
 	 * programming errors before advancing the completion state
@@ -885,6 +888,8 @@ int ioat2_dma_probe(struct ioatdma_device *device, int dca)
 	struct ioat_chan_common *chan;
 	int err;
 
+	trace_printk("%pF\n", (void*)_RET_IP_);
+
 	device->enumerate_channels = ioat2_enumerate_channels;
 	device->reset_hw = ioat2_reset_hw;
 	device->cleanup_fn = ioat2_cleanup_event;
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index fa43a42ccc86..3e4e810ded12 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -748,6 +748,8 @@ static void ioat3_timer_event(unsigned long data)
 	dma_addr_t phys_complete;
 	u64 status;
 
+	trace_printk("tasklet=%p\n", &chan->cleanup_task);
+
 	status = ioat_chansts(chan);
 
 	/* when halted due to errors check for channel
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e8b335016c52..b4e27cf0d983 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3267,6 +3267,7 @@ void complete(struct completion *x)
 	unsigned long flags;
 
 	spin_lock_irqsave(&x->wait.lock, flags);
+	trace_printk("x=%p ret=%pf\n", x, (void *)_RET_IP_);
 	x->done++;
 	__wake_up_common(&x->wait, TASK_NORMAL, 1, 0, NULL);
 	spin_unlock_irqrestore(&x->wait.lock, flags);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 787b3a032429..a4792c68ccd4 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -436,6 +436,7 @@ void __tasklet_schedule(struct tasklet_struct *t)
 	unsigned long flags;
 
 	local_irq_save(flags);
+	trace_printk("t=%p ret=%pf\n", t, (void *)_RET_IP_);
 	t->next = NULL;
 	*__this_cpu_read(tasklet_vec.tail) = t;
 	__this_cpu_write(tasklet_vec.tail, &(t->next));
@@ -486,6 +487,7 @@ static void tasklet_action(struct softirq_action *a)
 		list = list->next;
 
 		if (tasklet_trylock(t)) {
+			trace_printk("t=%p func=%pf count=%d\n", &t, t->func, atomic_read(&t->count));
 			if (!atomic_read(&t->count)) {
 				if (!test_and_clear_bit(TASKLET_STATE_SCHED, &t->state))
 					BUG();
