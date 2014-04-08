Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbaDHA7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 20:59:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:5120 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202AbaDHA7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 20:59:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,814,1389772800"; 
   d="scan'208";a="508850856"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] ntb_netdev: Fix list_for_each_entry exit issue
Date: Mon,  7 Apr 2014 17:52:46 -0700
Message-Id: <1396918374-5196-2-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396918374-5196-1-git-send-email-jon.mason@intel.com>
References: <1396918374-5196-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If list_for_each_entry exits without finding the ntb_device, the dev
pointer will not be NULL.  Thus the check will never be true and the
code will not exit when it should.  Correct this by adding a bool to
determine when the device is found, otherwise exit in good fashion.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/net/ntb_netdev.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index f3cdf64..8298880 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -367,12 +367,15 @@ static void ntb_netdev_remove(struct pci_dev *pdev)
 {
 	struct net_device *ndev;
 	struct ntb_netdev *dev;
+	bool found  = false;
 
 	list_for_each_entry(dev, &dev_list, list) {
-		if (dev->pdev == pdev)
+		if (dev->pdev == pdev) {
+			found = true;
 			break;
+		}
 	}
-	if (dev == NULL)
+	if (!found)
 		return;
 
 	list_del(&dev->list);
-- 
1.8.3.2

