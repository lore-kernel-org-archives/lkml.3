Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbaDHA7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 20:59:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:5120 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110AbaDHA7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 20:59:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,814,1389772800"; 
   d="scan'208";a="508850896"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] NTB: client event cleanup
Date: Mon,  7 Apr 2014 17:52:50 -0700
Message-Id: <1396918374-5196-6-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396918374-5196-1-git-send-email-jon.mason@intel.com>
References: <1396918374-5196-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a better event interface between the client and transport

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/net/ntb_netdev.c    | 16 ++++++++++++----
 drivers/ntb/ntb_hw.h        |  4 +---
 drivers/ntb/ntb_transport.c |  1 -
 include/linux/ntb.h         |  5 +++++
 4 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index 8e6752f..14570b2 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -78,11 +78,19 @@ static void ntb_netdev_event_handler(void *data, int status)
 	netdev_dbg(ndev, "Event %x, Link %x\n", status,
 		   ntb_transport_link_query(dev->qp));
 
-	/* Currently, only link status event is supported */
-	if (status)
-		netif_carrier_on(ndev);
-	else
+	switch (status) {
+	case NTB_LINK_DOWN:
 		netif_carrier_off(ndev);
+		break;
+	case NTB_LINK_UP:
+		if (!ntb_transport_link_query(dev->qp))
+			return;
+
+		netif_carrier_on(ndev);
+		break;
+	default:
+		netdev_warn(ndev, "Unsupported event type %d\n", status);
+	}
 }
 
 static void ntb_netdev_rx_handler(struct ntb_transport_qp *qp, void *qp_data,
diff --git a/drivers/ntb/ntb_hw.h b/drivers/ntb/ntb_hw.h
index bbdb7ed..d1960ff 100644
--- a/drivers/ntb/ntb_hw.h
+++ b/drivers/ntb/ntb_hw.h
@@ -45,6 +45,7 @@
  * Contact Information:
  * Jon Mason <jon.mason@intel.com>
  */
+#include <linux/ntb.h>
 
 #define PCI_DEVICE_ID_INTEL_NTB_B2B_JSF		0x3725
 #define PCI_DEVICE_ID_INTEL_NTB_PS_JSF		0x3726
@@ -83,9 +84,6 @@ static inline void writeq(u64 val, void __iomem *addr)
 #define NTB_BAR_MASK		((1 << NTB_BAR_MMIO) | (1 << NTB_BAR_23) |\
 				 (1 << NTB_BAR_45))
 
-#define NTB_LINK_DOWN		0
-#define NTB_LINK_UP		1
-
 #define NTB_HB_TIMEOUT		msecs_to_jiffies(1000)
 
 #define NTB_MAX_NUM_MW		2
diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 3217f39..042fb3d 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -56,7 +56,6 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/types.h>
-#include <linux/ntb.h>
 #include "ntb_hw.h"
 
 #define NTB_TRANSPORT_VERSION	3
diff --git a/include/linux/ntb.h b/include/linux/ntb.h
index f6a1520..cbc792c 100644
--- a/include/linux/ntb.h
+++ b/include/linux/ntb.h
@@ -54,6 +54,11 @@ struct ntb_client {
 	void (*remove) (struct pci_dev *pdev);
 };
 
+enum {
+	NTB_LINK_DOWN = 0,
+	NTB_LINK_UP,
+};
+
 int ntb_register_client(struct ntb_client *drvr);
 void ntb_unregister_client(struct ntb_client *drvr);
 int ntb_register_client_dev(char *device_name);
-- 
1.8.3.2

