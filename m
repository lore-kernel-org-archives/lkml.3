Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaKKPt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:49:59 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56211 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaKKPsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:48:41 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 10/15] irqchip: GICv3: ITS: device allocation and configuration
Date: Tue, 11 Nov 2014 15:48:08 +0000
Message-Id: <1415720893-13371-11-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com>
References: <1415720893-13371-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ITS has a notion of "device" that can write to it in order to
generate an interrupt.

Conversly, the driver maintains a per-ITS list of devices, together
with their configuration information, and uses this to configure
the HW.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 74 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 92e0f49..8d13012 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -981,3 +981,77 @@ static void its_cpu_init_collection(void)
 
 	spin_unlock(&its_lock);
 }
+
+static struct its_device *its_find_device(struct its_node *its, u32 dev_id)
+{
+	struct its_device *its_dev = NULL, *tmp;
+
+	raw_spin_lock(&its->lock);
+
+	list_for_each_entry(tmp, &its->its_device_list, entry) {
+		if (tmp->device_id == dev_id) {
+			its_dev = tmp;
+			break;
+		}
+	}
+
+	raw_spin_unlock(&its->lock);
+
+	return its_dev;
+}
+
+static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
+					    int nvecs)
+{
+	struct its_device *dev;
+	unsigned long *lpi_map;
+	void *itt;
+	int lpi_base;
+	int nr_lpis;
+	int cpu;
+	int sz;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	sz = nvecs * its->ite_size;
+	sz = max(sz, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
+	itt = kmalloc(sz, GFP_KERNEL);
+	lpi_map = its_lpi_alloc_chunks(nvecs, &lpi_base, &nr_lpis);
+
+	if (!dev || !itt || !lpi_map) {
+		kfree(dev);
+		kfree(itt);
+		kfree(lpi_map);
+		return NULL;
+	}
+
+	dev->its = its;
+	dev->itt = itt;
+	dev->nr_ites = nvecs;
+	dev->lpi_map = lpi_map;
+	dev->lpi_base = lpi_base;
+	dev->nr_lpis = nr_lpis;
+	dev->device_id = dev_id;
+	INIT_LIST_HEAD(&dev->entry);
+
+	raw_spin_lock(&its->lock);
+	list_add(&dev->entry, &its->its_device_list);
+	raw_spin_unlock(&its->lock);
+
+	/* Bind the device to the first possible CPU */
+	cpu = cpumask_first(cpu_online_mask);
+	dev->collection = &its->collections[cpu];
+
+	/* Map device to its ITT */
+	its_send_mapd(dev, 1);
+
+	return dev;
+}
+
+static void its_free_device(struct its_device *its_dev)
+{
+	raw_spin_lock(&its_dev->its->lock);
+	list_del(&its_dev->entry);
+	raw_spin_unlock(&its_dev->its->lock);
+	kfree(its_dev->itt);
+	kfree(its_dev);
+}
-- 
2.0.4

