Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaI3Vif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:38:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32833 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbaI3Vib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 037/103] ibmveth: Fix endian issues with rx_no_buffer statistic
Date: Tue, 30 Sep 2014 14:30:42 -0700
Message-Id: <1412112708-27356-38-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit cbd5228199d8be45d895d9d0cc2b8ce53835fc21 upstream.

Hidden away in the last 8 bytes of the buffer_list page is a solitary
statistic. It needs to be byte swapped or else ethtool -S will
produce numbers that terrify the user.

Since we do this in multiple places, create a helper function with a
comment explaining what is going on.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/ibm/ibmveth.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 6c0fd8e..895b086 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -293,6 +293,18 @@ failure:
 	atomic_add(buffers_added, &(pool->available));
 }
 
+/*
+ * The final 8 bytes of the buffer list is a counter of frames dropped
+ * because there was not a buffer in the buffer list capable of holding
+ * the frame.
+ */
+static void ibmveth_update_rx_no_buffer(struct ibmveth_adapter *adapter)
+{
+	__be64 *p = adapter->buffer_list_addr + 4096 - 8;
+
+	adapter->rx_no_buffer = be64_to_cpup(p);
+}
+
 /* replenish routine */
 static void ibmveth_replenish_task(struct ibmveth_adapter *adapter)
 {
@@ -308,8 +320,7 @@ static void ibmveth_replenish_task(struct ibmveth_adapter *adapter)
 			ibmveth_replenish_buffer_pool(adapter, pool);
 	}
 
-	adapter->rx_no_buffer = *(u64 *)(((char*)adapter->buffer_list_addr) +
-						4096 - 8);
+	ibmveth_update_rx_no_buffer(adapter);
 }
 
 /* empty and free ana buffer pool - also used to do cleanup in error paths */
@@ -699,8 +710,7 @@ static int ibmveth_close(struct net_device *netdev)
 
 	free_irq(netdev->irq, netdev);
 
-	adapter->rx_no_buffer = *(u64 *)(((char *)adapter->buffer_list_addr) +
-						4096 - 8);
+	ibmveth_update_rx_no_buffer(adapter);
 
 	ibmveth_cleanup(adapter);
 
-- 
1.9.1

