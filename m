Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbaJCVcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:32:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbaJCVch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 034/357] ibmveth: Fix endian issues with rx_no_buffer statistic
Date: Fri,  3 Oct 2014 14:27:00 -0700
Message-Id: <20141003212934.493608259@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/ibm/ibmveth.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -292,6 +292,18 @@ failure:
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
@@ -307,8 +319,7 @@ static void ibmveth_replenish_task(struc
 			ibmveth_replenish_buffer_pool(adapter, pool);
 	}
 
-	adapter->rx_no_buffer = *(u64 *)(((char*)adapter->buffer_list_addr) +
-						4096 - 8);
+	ibmveth_update_rx_no_buffer(adapter);
 }
 
 /* empty and free ana buffer pool - also used to do cleanup in error paths */
@@ -698,8 +709,7 @@ static int ibmveth_close(struct net_devi
 
 	free_irq(netdev->irq, netdev);
 
-	adapter->rx_no_buffer = *(u64 *)(((char *)adapter->buffer_list_addr) +
-						4096 - 8);
+	ibmveth_update_rx_no_buffer(adapter);
 
 	ibmveth_cleanup(adapter);
 


