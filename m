Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaIWCeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:34:19 -0400
Received: from mail.kernel.org ([198.145.19.201]:37426 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbaIWCeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:34:16 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        "David S. Miller" <davem@davemloft.net>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 03/45] ibmveth: Fix endian issues with rx_no_buffer statistic
Date: Tue, 23 Sep 2014 10:31:05 +0800
Message-Id: <1411439507-30391-3-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit cbd5228199d8be45d895d9d0cc2b8ce53835fc21 upstream.

Hidden away in the last 8 bytes of the buffer_list page is a solitary
statistic. It needs to be byte swapped or else ethtool -S will
produce numbers that terrify the user.

Since we do this in multiple places, create a helper function with a
comment explaining what is going on.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/net/ethernet/ibm/ibmveth.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 33a1760..b2b715f 100644
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
@@ -692,8 +703,7 @@ static int ibmveth_close(struct net_device *netdev)
 
 	free_irq(netdev->irq, netdev);
 
-	adapter->rx_no_buffer = *(u64 *)(((char *)adapter->buffer_list_addr) +
-						4096 - 8);
+	ibmveth_update_rx_no_buffer(adapter);
 
 	ibmveth_cleanup(adapter);
 
-- 
1.7.9.5

