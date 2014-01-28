Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbaA1Ih5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:37:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848AbaA1Ih4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:37:56 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org
Subject: [PATCH 09/14] NVMe: Access interrupt vectors using nvme_queue::cq_vector only
Date: Tue, 28 Jan 2014 09:38:55 +0100
Message-Id: <c1d0e20606ca3171faa63248693bae9063365c67.1390897693.git.agordeev@redhat.com>
In-Reply-To: <cover.1390897693.git.agordeev@redhat.com>
References: <cover.1390897693.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minimize a poissible error when accessing dev-entry[] array
entries using an arbitrary index rather than the legitimate
nvme_queue::cq_vector value. This update also makes affinity
hint setup conform to the rest of the code around.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/block/nvme-core.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 98d4b51..1821091 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1424,7 +1424,7 @@ static int nvme_configure_admin_queue(struct nvme_dev *dev)
 	if (result)
 		return result;
 
-	dev->entry[0].vector = dev->pci_dev->irq;
+	dev->entry[nvmeq->cq_vector].vector = dev->pci_dev->irq;
 	result = queue_request_irq(nvmeq, "nvme admin");
 	if (result)
 		return result;
@@ -1908,7 +1908,7 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 	}
 
 	/* Deregister the admin queue's interrupt */
-	free_irq(dev->entry[0].vector, dev->queues[0]);
+	free_irq(dev->entry[dev->queues[0]->cq_vector].vector, dev->queues[0]);
 
 	vecs = nr_io_queues;
 	for (i = 0; i < vecs; i++)
@@ -1989,9 +1989,16 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 		}
 	}
 
-	cpu = cpumask_first(cpu_online_mask);
-	for (i = 0; i < nr_io_queues; i++) {
-		irq_set_affinity_hint(dev->entry[i].vector, get_cpu_mask(cpu));
+	cpu = nr_cpu_ids;
+	for (i = 1; i < dev->queue_count; i++) {
+		struct nvme_queue *nvmeq = dev->queues[i];
+
+		if (cpu >= nr_cpu_ids)
+			cpu = cpumask_first(cpu_online_mask);
+
+		irq_set_affinity_hint(dev->entry[nvmeq->cq_vector].vector,
+				      get_cpu_mask(cpu));
+
 		cpu = cpumask_next(cpu, cpu_online_mask);
 	}
 
-- 
1.7.7.6

