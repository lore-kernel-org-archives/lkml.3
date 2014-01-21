Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaAUKEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 05:04:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871AbaAUKEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 05:04:35 -0500
Date: Tue, 21 Jan 2014 11:06:12 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Keith Busch <keith.busch@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 1/2] Revert "NVMe: Disable admin queue on init failure"
Message-ID: <20140121100611.GB8847@dhcp-26-207.brq.redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
 <1c441f670f33375b6c41e074baf6e84e6c7bb0c2.1389904166.git.agordeev@redhat.com>
 <CAErSpo4g_xm4vZWZDgyjtJu+z5ARSerQLrtJ6W_peXv4bKwcgg@mail.gmail.com>
 <alpine.LRH.2.03.1401171419370.25844@AMR>
 <20140120083835.GA19068@dhcp-26-207.brq.redhat.com>
 <20140120084212.GC19068@dhcp-26-207.brq.redhat.com>
 <alpine.LRH.2.03.1401201541000.25844@AMR>
 <20140121100311.GA8847@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121100311.GA8847@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit c5dc9192d52a4a3a479f701e97386347d454af84.
---
 drivers/block/nvme-core.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index b59a93a..c790679 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1151,11 +1151,11 @@ static void nvme_free_queue(struct nvme_queue *nvmeq)
 	kfree(nvmeq);
 }
 
-static void nvme_free_queues(struct nvme_dev *dev, int lowest)
+static void nvme_free_queues(struct nvme_dev *dev)
 {
 	int i;
 
-	for (i = dev->queue_count - 1; i >= lowest; i--) {
+	for (i = dev->queue_count - 1; i >= 0; i--) {
 		nvme_free_queue(dev->queues[i]);
 		dev->queue_count--;
 		dev->queues[i] = NULL;
@@ -1989,7 +1989,7 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
 	return 0;
 
  free_queues:
-	nvme_free_queues(dev, 1);
+	nvme_free_queues(dev);
 	return result;
 }
 
@@ -2409,7 +2409,6 @@ static int nvme_dev_start(struct nvme_dev *dev)
 	return result;
 
  disable:
-	nvme_disable_queue(dev, 0);
 	spin_lock(&dev_list_lock);
 	list_del_init(&dev->node);
 	spin_unlock(&dev_list_lock);
@@ -2541,7 +2540,7 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  shutdown:
 	nvme_dev_shutdown(dev);
  release_pools:
-	nvme_free_queues(dev, 0);
+	nvme_free_queues(dev);
 	nvme_release_prp_pools(dev);
  release:
 	nvme_release_instance(dev);
@@ -2565,7 +2564,7 @@ static void nvme_remove(struct pci_dev *pdev)
 	misc_deregister(&dev->miscdev);
 	nvme_dev_remove(dev);
 	nvme_dev_shutdown(dev);
-	nvme_free_queues(dev, 0);
+	nvme_free_queues(dev);
 	nvme_release_instance(dev);
 	nvme_release_prp_pools(dev);
 	kref_put(&dev->kref, nvme_free_dev);
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
