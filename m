Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbaA1Jn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 04:43:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471AbaA1Jnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 04:43:55 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org
Subject: [PATCH 10/14] NVMe: Factor out nvme_set_queue_count()
Date: Tue, 28 Jan 2014 09:38:56 +0100
Message-Id: <e9052b478a204f3243aa7a719684dd50c67c5885.1390897693.git.agordeev@redhat.com>
In-Reply-To: <cover.1390897693.git.agordeev@redhat.com>
References: <cover.1390897693.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function nvme_setup_io_queues() is quite big - make it more
readable by moving out a code with clearly distinguishable
functionality. This update is the first in a series.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/block/nvme-core.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 1821091..d81b4c4 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1875,22 +1875,21 @@ static int set_queue_count(struct nvme_dev *dev, int count)
 	return min(result & 0xffff, result >> 16) + 1;
 }
 
+static int nvme_set_queue_count(struct nvme_dev *dev, int count)
+{
+	int result = set_queue_count(dev, count);
+	return min(result, count);
+}
+
 static size_t db_bar_size(struct nvme_dev *dev, unsigned nr_io_queues)
 {
 	return 4096 + ((nr_io_queues + 1) * 8 * dev->db_stride);
 }
 
-static int nvme_setup_io_queues(struct nvme_dev *dev)
+static int nvme_setup_io_queues(struct nvme_dev *dev, int nr_io_queues)
 {
 	struct pci_dev *pdev = dev->pci_dev;
-	int result, cpu, i, vecs, nr_io_queues, size, q_depth;
-
-	nr_io_queues = num_online_cpus();
-	result = set_queue_count(dev, nr_io_queues);
-	if (result < 0)
-		return result;
-	if (result < nr_io_queues)
-		nr_io_queues = result;
+	int result, cpu, i, vecs, size, q_depth;
 
 	size = db_bar_size(dev, nr_io_queues);
 	if (size > 8192) {
@@ -2417,13 +2416,20 @@ static int nvme_dev_start(struct nvme_dev *dev)
 	list_add(&dev->node, &dev_list);
 	spin_unlock(&dev_list_lock);
 
-	result = nvme_setup_io_queues(dev);
-	if (result && result != -EBUSY)
+	result = nvme_set_queue_count(dev, num_online_cpus());
+	if (result < 0)
+		goto disable;
+
+	result = nvme_setup_io_queues(dev, result);
+	if (result)
 		goto disable;
 
 	return 0;
 
  disable:
+	if (result == -EBUSY)
+		return -EBUSY;
+
 	nvme_disable_queue(dev->queues[0]);
 	spin_lock(&dev_list_lock);
 	list_del_init(&dev->node);
-- 
1.7.7.6

