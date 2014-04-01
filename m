Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaDAQPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:15:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44595 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbaDAQPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:15:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arnd Bergmann <arnd@arndb.de>, Neil Horman <nhorman@tuxdriver.com>,
        Shreyas Bhatewara <sbhatewara@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 72/86] vmxnet3: fix building without CONFIG_PCI_MSI
Date: Tue,  1 Apr 2014 09:08:25 -0700
Message-Id: <1396368519-12728-73-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 0a8d8c446b5429d15ff2d48f46e00d8a08552303 upstream.

Since commit d25f06ea466e "vmxnet3: fix netpoll race condition",
the vmxnet3 driver fails to build when CONFIG_PCI_MSI is disabled,
because it unconditionally references the vmxnet3_msix_rx()
function.

To fix this, use the same #ifdef in the caller that exists around
the function definition.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Shreyas Bhatewara <sbhatewara@vmware.com>
Cc: "VMware, Inc." <pv-drivers@vmware.com>
Cc: "David S. Miller" <davem@davemloft.net>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index b87753c..0cb0462 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1751,13 +1751,16 @@ static void
 vmxnet3_netpoll(struct net_device *netdev)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
-	int i;
 
 	switch (adapter->intr.type) {
-	case VMXNET3_IT_MSIX:
+#ifdef CONFIG_PCI_MSI
+	case VMXNET3_IT_MSIX: {
+		int i;
 		for (i = 0; i < adapter->num_rx_queues; i++)
 			vmxnet3_msix_rx(0, &adapter->rx_queue[i]);
 		break;
+	}
+#endif
 	case VMXNET3_IT_MSI:
 	default:
 		vmxnet3_intr(0, adapter->netdev);
-- 
1.8.3.2

