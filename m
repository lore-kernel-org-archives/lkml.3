Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaCMJoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:44:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58619 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaCMJow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:44:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Shreyas Bhatewara <sbhatewara@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] vmxnet3: fix building without CONFIG_PCI_MSI
Date: Thu, 13 Mar 2014 10:44:34 +0100
Message-ID: <7825453.7LB7BmvA2b@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:/ckG+5ndPAr4eBHIaTnx7pIfyVsMjv2nC3R8FlsY66c
 Ezzz7+j7Yhl+uYjEF3KDKf4Xv92ynhkuDE5DdSGo4mn2SBSuQs
 MDRz9czuUHjzllX5Rg3cmdNZ4UaNGZ6w/drtrzKTgULDJ6yQmn
 66tg2XVO0shsKNqYqiAdRBReKGZiiu+JH0V3CH62iCYziHFVhg
 ALs8YjJ3IQ/v4Yce2WmfigPW7o9HEWi3mUWT7wcQi2eQR39jxm
 NGaZpOQgDs65zvOQ0ElPIgi0xvgSoXLuW2D2iP7kIJyDbhLypW
 Wict5oQ7o6pHa3ropYyLUAUEfF+gdYiwxPlLfXmObONDxKXrkC
 2Fqj7Xq+0zLDh3OJC5mo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@vger.kernel.org
---
Found this during randconfig testing on ARM. Most of the time when
I report network driver problems, they get fixed in the netdev tree
before I even find them, but since this is for a patch marked "stable",
I made a proper patch anyway.

Please ignore if this is already a known problem, otherwise make sure
the original patch doesn't get backported without addressing this
issue first.

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index cbd898f..28965ad 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1761,13 +1761,16 @@ static void
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

