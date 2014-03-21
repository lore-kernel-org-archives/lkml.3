Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966614AbaCUA0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:26:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965674AbaCUAJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Neil Horman <nhorman@tuxdriver.com>,
        Shreyas Bhatewara <sbhatewara@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 61/85] vmxnet3: fix building without CONFIG_PCI_MSI
Date: Thu, 20 Mar 2014 17:10:04 -0700
Message-Id: <20140321000607.396849787@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/vmxnet3/vmxnet3_drv.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1740,13 +1740,16 @@ static void
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


