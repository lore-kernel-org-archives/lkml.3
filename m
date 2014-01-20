Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbaATIlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:41:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbaATIlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:41:37 -0500
Date: Mon, 20 Jan 2014 09:43:14 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Keith Busch <keith.busch@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH] nvme: Cleanup nvme_dev_start()
Message-ID: <20140120084314.GD19068@dhcp-26-207.brq.redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
 <1c441f670f33375b6c41e074baf6e84e6c7bb0c2.1389904166.git.agordeev@redhat.com>
 <CAErSpo4g_xm4vZWZDgyjtJu+z5ARSerQLrtJ6W_peXv4bKwcgg@mail.gmail.com>
 <alpine.LRH.2.03.1401171419370.25844@AMR>
 <20140120083835.GA19068@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120083835.GA19068@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This update fixes an oddity when a device is first added
and then removed from dev_list in case of initialization
failure, instead of just being added in case of success.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/block/nvme-core.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index e1e4ad4..e4e12be 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -2105,29 +2105,26 @@ static int nvme_dev_start(struct nvme_dev *dev)
 	if (result)
 		goto unmap;
 
-	spin_lock(&dev_list_lock);
-	list_add(&dev->node, &dev_list);
-	spin_unlock(&dev_list_lock);
-
 	result = set_queue_count(dev, num_online_cpus());
 	if (result == -EBUSY)
-		return -EBUSY;
+		goto adddev;
 
 	nvme_teardown_admin_queue(dev);
 
 	if (result)
-		goto disable;
+		goto unmap;
 
 	result = nvme_setup_io_queues(dev, result);
 	if (result)
-		goto disable;
-
-	return 0;
+		goto unmap;
 
- disable:
+ adddev:
 	spin_lock(&dev_list_lock);
-	list_del_init(&dev->node);
+	list_add(&dev->node, &dev_list);
 	spin_unlock(&dev_list_lock);
+
+	return result;
+
  unmap:
 	nvme_dev_unmap(dev);
 	return result;
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
