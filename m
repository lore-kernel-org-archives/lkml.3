Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaIZJwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:52:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183AbaIZJqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:52 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 140/142] ibmveth: Fix endian issues with rx_no_buffer statistic
Date: Fri, 26 Sep 2014 11:45:51 +0200
Message-Id: <e66983c5b25182a5e1ebc3ab4f68f613eb1c9fe8.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit cbd5228199d8be45d895d9d0cc2b8ce53835fc21 upstream.

Hidden away in the last 8 bytes of the buffer_list page is a solitary
statistic. It needs to be byte swapped or else ethtool -S will
produce numbers that terrify the user.

Since we do this in multiple places, create a helper function with a
comment explaining what is going on.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/ibm/ibmveth.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 6c0fd8e0f9bf..895b086ec261 100644
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
2.1.0

