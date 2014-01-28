Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbaA1Ihx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:37:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796AbaA1Iht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:37:49 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org
Subject: [PATCH 01/14] NVMe: Fix setup of affinity hint for unallocated queues
Date: Tue, 28 Jan 2014 09:38:47 +0100
Message-Id: <514969a133311cb142d6f80de92db89511aded7f.1390897693.git.agordeev@redhat.com>
In-Reply-To: <cover.1390897693.git.agordeev@redhat.com>
References: <cover.1390897693.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ affinity hints are attempted to setup for some or all
queues which have not yet been allocated: either on device
probe or resume. This update moves the setup after all
queues are successfully created.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/block/nvme-core.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index b59a93a..3dfb0d4 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1956,12 +1956,6 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 	}
 	spin_unlock(&dev_list_lock);
 
-	cpu = cpumask_first(cpu_online_mask);
-	for (i = 0; i < nr_io_queues; i++) {
-		irq_set_affinity_hint(dev->entry[i].vector, get_cpu_mask(cpu));
-		cpu = cpumask_next(cpu, cpu_online_mask);
-	}
-
 	q_depth = min_t(int, NVME_CAP_MQES(readq(&dev->bar->cap)) + 1,
 								NVME_Q_DEPTH);
 	for (i = dev->queue_count - 1; i < nr_io_queues; i++) {
@@ -1986,6 +1980,12 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 		}
 	}
 
+	cpu = cpumask_first(cpu_online_mask);
+	for (i = 0; i < nr_io_queues; i++) {
+		irq_set_affinity_hint(dev->entry[i].vector, get_cpu_mask(cpu));
+		cpu = cpumask_next(cpu, cpu_online_mask);
+	}
+
 	return 0;
 
  free_queues:
-- 
1.7.7.6

