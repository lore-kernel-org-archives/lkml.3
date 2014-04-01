Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaDAQNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:13:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44550 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaDAQNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:13:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 86/86] ioat: fix tasklet tear down
Date: Tue,  1 Apr 2014 09:08:39 -0700
Message-Id: <1396368519-12728-87-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit da87ca4d4ca101f177fffd84f1f0a5e4c0343557 upstream.

Since commit 77873803363c "net_dma: mark broken" we no longer pin dma
engines active for the network-receive-offload use case.  As a result
the ->free_chan_resources() that occurs after the driver self test no
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

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Reported-by: Mike Galbraith <bitbucket@online.de>
Reported-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Tested-by: Mike Galbraith <bitbucket@online.de>
Tested-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[bwh: Backported to 3.2:
 - Adjust context
 - As there is no ioatdma_device::irq_mode member, check
   pci_dev::msix_enabled instead]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Acked-by: Brad Figg <brad.figg@canonical.com>
Acked-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/dma/ioat/dma.c    | 46 +++++++++++++++++++++++++++++++++++++++-------
 drivers/dma/ioat/dma.h    |  1 +
 drivers/dma/ioat/dma_v2.c | 11 +++++------
 drivers/dma/ioat/dma_v3.c |  3 +++
 4 files changed, 48 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 1a68a8b..8bcaef1 100644
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
@@ -354,13 +355,43 @@ static int ioat1_dma_alloc_chan_resources(struct dma_chan *c)
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
+
+	/* 1/ stop irq from firing tasklets
+	 * 2/ stop the tasklet from re-arming irqs
+	 */
+	clear_bit(IOAT_RUN, &chan->state);
+
+	/* flush inflight interrupts */
+#ifdef CONFIG_PCI_MSI
+	if (pdev->msix_enabled) {
+		struct msix_entry *msix = &device->msix_entries[chan_id];
+		synchronize_irq(msix->vector);
+	} else
+#endif
+		synchronize_irq(pdev->irq);
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
@@ -379,9 +410,7 @@ static void ioat1_dma_free_chan_resources(struct dma_chan *c)
 	if (ioat->desccount == 0)
 		return;
 
-	tasklet_disable(&chan->cleanup_task);
-	del_timer_sync(&chan->timer);
-	ioat1_cleanup(ioat);
+	ioat_stop(chan);
 
 	/* Delay 100ms after reset to allow internal DMA logic to quiesce
 	 * before removing DMA descriptor resources.
@@ -526,8 +555,11 @@ ioat1_dma_prep_memcpy(struct dma_chan *c, dma_addr_t dma_dest,
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
index 087935f..24a72e0 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -320,6 +320,7 @@ bool ioat_cleanup_preamble(struct ioat_chan_common *chan,
 			   dma_addr_t *phys_complete);
 void ioat_kobject_add(struct ioatdma_device *device, struct kobj_type *type);
 void ioat_kobject_del(struct ioatdma_device *device);
+void ioat_stop(struct ioat_chan_common *chan);
 extern const struct sysfs_ops ioat_sysfs_ops;
 extern struct ioat_sysfs_entry ioat_version_attr;
 extern struct ioat_sysfs_entry ioat_cap_attr;
diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 82d4e30..1b3af8a 100644
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
 
@@ -538,10 +541,10 @@ int ioat2_alloc_chan_resources(struct dma_chan *c)
 	ioat->issued = 0;
 	ioat->tail = 0;
 	ioat->alloc_order = order;
+	set_bit(IOAT_RUN, &chan->state);
 	spin_unlock_bh(&ioat->prep_lock);
 	spin_unlock_bh(&chan->cleanup_lock);
 
-	tasklet_enable(&chan->cleanup_task);
 	ioat2_start_null_desc(ioat);
 
 	/* check that we got off the ground */
@@ -551,7 +554,6 @@ int ioat2_alloc_chan_resources(struct dma_chan *c)
 	} while (i++ < 20 && !is_ioat_active(status) && !is_ioat_idle(status));
 
 	if (is_ioat_active(status) || is_ioat_idle(status)) {
-		set_bit(IOAT_RUN, &chan->state);
 		return 1 << ioat->alloc_order;
 	} else {
 		u32 chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
@@ -794,11 +796,8 @@ void ioat2_free_chan_resources(struct dma_chan *c)
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
index 3e9d669..813abb0 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -325,8 +325,11 @@ static void ioat3_cleanup(struct ioat2_dma_chan *ioat)
 static void ioat3_cleanup_event(unsigned long data)
 {
 	struct ioat2_dma_chan *ioat = to_ioat2_chan((void *) data);
+	struct ioat_chan_common *chan = &ioat->base;
 
 	ioat3_cleanup(ioat);
+	if (!test_bit(IOAT_RUN, &chan->state))
+		return;
 	writew(IOAT_CHANCTRL_RUN, ioat->base.reg_base + IOAT_CHANCTRL_OFFSET);
 }
 
-- 
1.8.3.2

