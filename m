Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaBTHNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 02:13:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:32421 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbaBTHNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 02:13:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,511,1389772800"; 
   d="scan'208";a="484640528"
Subject: [PATCH] ioat: fix tasklet tear down
From: Dan Williams <dan.j.williams@intel.com>
To: dmaengine@vger.kernel.org
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Mike Galbraith <bitbucket@online.de>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Date: Wed, 19 Feb 2014 23:13:12 -0800
Message-ID: <20140220071145.21609.89019.stgit@viggo.jf.intel.com>
User-Agent: StGit/0.17.1-3-g7cb9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 77873803363c "net_dma: mark broken" we no longer pin dma
engines active for the network-receive-offload use case.  As a result
the ->free_chan_resources() that occurs after the driver self-test no
longer has a NET_DMA induced ->alloc_chan_resources() to back it up.  A
late firing irq can lead to ksoftirqd spinning indefinitely due to the
tasklet_disable() performed by ->free_chan_resources().  Only
->alloc_chan_resources() can clear this condition in affected kernels.

This problem has been present since commit 3e037454bcfa "I/OAT: Add
support for MSI and MSI-X" in 2.6.24, but is now exposed. Given the
NET_DMA use case is deprecated we can revisit moving the driver to use
threaded irqs.  For now, just tear down the irq and tasklet properly by:

1/ Disable the irq from triggering the tasklet

2/ Disable the irq from re-arming

3/ Flush inflight interrupts

4/ Flush the timer

5/ Flush inflight tasklets

References:
https://lkml.org/lkml/2014/1/27/282
https://lkml.org/lkml/2014/2/19/672

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>
Reported-by: Mike Galbraith <bitbucket@online.de>
Reported-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

Passes my testing, but would appreciate a tested-by.

 drivers/dma/ioat/dma.c    |   52 +++++++++++++++++++++++++++++++++++++++------
 drivers/dma/ioat/dma.h    |    1 +
 drivers/dma/ioat/dma_v2.c |   11 ++++------
 drivers/dma/ioat/dma_v3.c |    3 +++
 4 files changed, 54 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 87529181efcc..4e3549a16132 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -77,7 +77,8 @@ static irqreturn_t ioat_dma_do_interrupt(int irq, void *data)
 	attnstatus = readl(instance->reg_base + IOAT_ATTNSTATUS_OFFSET);
 	for_each_set_bit(bit, &attnstatus, BITS_PER_LONG) {
 		chan = ioat_chan_by_index(instance, bit);
-		tasklet_schedule(&chan->cleanup_task);
+		if (test_bit(IOAT_RUN, &chan->state))
+			tasklet_schedule(&chan->cleanup_task);
 	}
 
 	writeb(intrctrl, instance->reg_base + IOAT_INTRCTRL_OFFSET);
@@ -93,7 +94,8 @@ static irqreturn_t ioat_dma_do_interrupt_msix(int irq, void *data)
 {
 	struct ioat_chan_common *chan = data;
 
-	tasklet_schedule(&chan->cleanup_task);
+	if (test_bit(IOAT_RUN, &chan->state))
+		tasklet_schedule(&chan->cleanup_task);
 
 	return IRQ_HANDLED;
 }
@@ -116,7 +118,6 @@ void ioat_init_channel(struct ioatdma_device *device, struct ioat_chan_common *c
 	chan->timer.function = device->timer_fn;
 	chan->timer.data = data;
 	tasklet_init(&chan->cleanup_task, device->cleanup_fn, data);
-	tasklet_disable(&chan->cleanup_task);
 }
 
 /**
@@ -354,13 +355,49 @@ static int ioat1_dma_alloc_chan_resources(struct dma_chan *c)
 	writel(((u64) chan->completion_dma) >> 32,
 	       chan->reg_base + IOAT_CHANCMP_OFFSET_HIGH);
 
-	tasklet_enable(&chan->cleanup_task);
+	set_bit(IOAT_RUN, &chan->state);
 	ioat1_dma_start_null_desc(ioat);  /* give chain to dma device */
 	dev_dbg(to_dev(chan), "%s: allocated %d descriptors\n",
 		__func__, ioat->desccount);
 	return ioat->desccount;
 }
 
+void ioat_stop(struct ioat_chan_common *chan)
+{
+	struct ioatdma_device *device = chan->device;
+	struct pci_dev *pdev = device->pdev;
+	int chan_id = chan_num(chan);
+	struct msix_entry *msix;
+
+	/* 1/ stop irq from firing tasklets
+	 * 2/ stop the tasklet from re-arming irqs
+	 */
+	clear_bit(IOAT_RUN, &chan->state);
+
+	/* flush inflight interrupts */
+	switch (device->irq_mode) {
+	case IOAT_MSIX:
+		msix = &device->msix_entries[chan_id];
+		synchronize_irq(msix->vector);
+		break;
+	case IOAT_MSI:
+	case IOAT_INTX:
+		synchronize_irq(pdev->irq);
+		break;
+	default:
+		break;
+	}
+
+	/* flush inflight timers */
+	del_timer_sync(&chan->timer);
+
+	/* flush inflight tasklet runs */
+	tasklet_kill(&chan->cleanup_task);
+
+	/* final cleanup now that everything is quiesced and can't re-arm */
+	device->cleanup_fn((unsigned long) &chan->common);
+}
+
 /**
  * ioat1_dma_free_chan_resources - release all the descriptors
  * @chan: the channel to be cleaned
@@ -379,9 +416,7 @@ static void ioat1_dma_free_chan_resources(struct dma_chan *c)
 	if (ioat->desccount == 0)
 		return;
 
-	tasklet_disable(&chan->cleanup_task);
-	del_timer_sync(&chan->timer);
-	ioat1_cleanup(ioat);
+	ioat_stop(chan);
 
 	/* Delay 100ms after reset to allow internal DMA logic to quiesce
 	 * before removing DMA descriptor resources.
@@ -526,8 +561,11 @@ ioat1_dma_prep_memcpy(struct dma_chan *c, dma_addr_t dma_dest,
 static void ioat1_cleanup_event(unsigned long data)
 {
 	struct ioat_dma_chan *ioat = to_ioat_chan((void *) data);
+	struct ioat_chan_common *chan = &ioat->base;
 
 	ioat1_cleanup(ioat);
+	if (!test_bit(IOAT_RUN, &chan->state))
+		return;
 	writew(IOAT_CHANCTRL_RUN, ioat->base.reg_base + IOAT_CHANCTRL_OFFSET);
 }
 
diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index 11fb877ddca9..e982f00a9843 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -356,6 +356,7 @@ bool ioat_cleanup_preamble(struct ioat_chan_common *chan,
 void ioat_kobject_add(struct ioatdma_device *device, struct kobj_type *type);
 void ioat_kobject_del(struct ioatdma_device *device);
 int ioat_dma_setup_interrupts(struct ioatdma_device *device);
+void ioat_stop(struct ioat_chan_common *chan);
 extern const struct sysfs_ops ioat_sysfs_ops;
 extern struct ioat_sysfs_entry ioat_version_attr;
 extern struct ioat_sysfs_entry ioat_cap_attr;
diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 5d3affe7e976..8d1058085eeb 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -190,8 +190,11 @@ static void ioat2_cleanup(struct ioat2_dma_chan *ioat)
 void ioat2_cleanup_event(unsigned long data)
 {
 	struct ioat2_dma_chan *ioat = to_ioat2_chan((void *) data);
+	struct ioat_chan_common *chan = &ioat->base;
 
 	ioat2_cleanup(ioat);
+	if (!test_bit(IOAT_RUN, &chan->state))
+		return;
 	writew(IOAT_CHANCTRL_RUN, ioat->base.reg_base + IOAT_CHANCTRL_OFFSET);
 }
 
@@ -553,10 +556,10 @@ int ioat2_alloc_chan_resources(struct dma_chan *c)
 	ioat->issued = 0;
 	ioat->tail = 0;
 	ioat->alloc_order = order;
+	set_bit(IOAT_RUN, &chan->state);
 	spin_unlock_bh(&ioat->prep_lock);
 	spin_unlock_bh(&chan->cleanup_lock);
 
-	tasklet_enable(&chan->cleanup_task);
 	ioat2_start_null_desc(ioat);
 
 	/* check that we got off the ground */
@@ -566,7 +569,6 @@ int ioat2_alloc_chan_resources(struct dma_chan *c)
 	} while (i++ < 20 && !is_ioat_active(status) && !is_ioat_idle(status));
 
 	if (is_ioat_active(status) || is_ioat_idle(status)) {
-		set_bit(IOAT_RUN, &chan->state);
 		return 1 << ioat->alloc_order;
 	} else {
 		u32 chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
@@ -809,11 +811,8 @@ void ioat2_free_chan_resources(struct dma_chan *c)
 	if (!ioat->ring)
 		return;
 
-	tasklet_disable(&chan->cleanup_task);
-	del_timer_sync(&chan->timer);
-	device->cleanup_fn((unsigned long) c);
+	ioat_stop(chan);
 	device->reset_hw(chan);
-	clear_bit(IOAT_RUN, &chan->state);
 
 	spin_lock_bh(&chan->cleanup_lock);
 	spin_lock_bh(&ioat->prep_lock);
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 820817e97e62..b9b38a1cf92f 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -464,8 +464,11 @@ static void ioat3_cleanup(struct ioat2_dma_chan *ioat)
 static void ioat3_cleanup_event(unsigned long data)
 {
 	struct ioat2_dma_chan *ioat = to_ioat2_chan((void *) data);
+	struct ioat_chan_common *chan = &ioat->base;
 
 	ioat3_cleanup(ioat);
+	if (!test_bit(IOAT_RUN, &chan->state))
+		return;
 	writew(IOAT_CHANCTRL_RUN, ioat->base.reg_base + IOAT_CHANCTRL_OFFSET);
 }
 

