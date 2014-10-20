Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaJTWLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 18:11:33 -0400
Received: from mx.aristanetworks.com ([162.210.130.12]:55908 "EHLO
	prod-mx.aristanetworks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751233AbaJTWLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 18:11:32 -0400
Date: Mon, 20 Oct 2014 15:11:15 -0700
To: netdev@vger.kernel.org
Subject: [PATCH 1/1] e1000: unset IFF_UNICAST_FLT on WMware 82545EM
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, pv-drivers@vmware.com,
        linux.nics@intel.com, fruggeri@arista.com,
        e1000-devel@lists.sourceforge.net
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20141020221115.1FC9B480090@fruggeri-Arora18.sjc.aristanetworks.com>
From: fruggeri@aristanetworks.com (Francesco Ruggeri)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMWare's e1000 implementation does not seem to support unicast filtering.
This can be observed by configuring a macvlan interface on eth0 in a VM in
VMWare Fusion 5.0.5, and trying to use that interface instead of eth0.
Tested on 3.16.

Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 5f6aded..24f3986 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -1075,7 +1075,10 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				  NETIF_F_HW_CSUM |
 				  NETIF_F_SG);
 
-	netdev->priv_flags |= IFF_UNICAST_FLT;
+	/* Do not set IFF_UNICAST_FLT for VMWare's 82545EM */
+	if (hw->device_id != E1000_DEV_ID_82545EM_COPPER ||
+	    hw->subsystem_vendor_id != PCI_VENDOR_ID_VMWARE)
+		netdev->priv_flags |= IFF_UNICAST_FLT;
 
 	adapter->en_mng_pt = e1000_enable_mng_pass_thru(hw);
 
-- 
1.8.1.4

