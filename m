Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaC3XdO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:33:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36508 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753138AbaC3XZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "VMware, Inc." <pv-drivers@vmware.com>,
        "Shreyas Bhatewara" <sbhatewara@vmware.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Neil Horman" <nhorman@tuxdriver.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.848763263@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 175/200] vmxnet3: fix building without CONFIG_PCI_MSI
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1733,13 +1733,16 @@ static void
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

