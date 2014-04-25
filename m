Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaDYJm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:42:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbaDYJmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:42:25 -0400
Date: Fri, 25 Apr 2014 11:43:50 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Shahed Shaikh <shahed.shaikh@qlogic.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dept-HSG Linux NIC Dev <Dept-HSGLinuxNICDev@qlogic.com>,
        netdev <netdev@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>
Subject: [PATCH v2 net-next 2/2] qlcnic: Use pci_enable_msix_exact() instead
 of pci_enable_msix()
Message-ID: <20140425094349.GA6397@dhcp-26-207.brq.redhat.com>
References: <cover.1398412015.git.agordeev@redhat.com>
 <0a0d5f5c33d86e3777c22c3c1bbd81035660d57c.1398412015.git.agordeev@redhat.com>
 <262CB373A6D1F14F9B81E82F74F77D5A46F9EE54@avmb2.qlogic.org>
 <20140425090029.GA2500@dhcp-26-207.brq.redhat.com>
 <262CB373A6D1F14F9B81E82F74F77D5A46F9EEA2@avmb2.qlogic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <262CB373A6D1F14F9B81E82F74F77D5A46F9EEA2@avmb2.qlogic.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Cc: Shahed Shaikh <shahed.shaikh@qlogic.com>
Cc: Dept-HSGLinuxNICDev@qlogic.com
Cc: netdev@vger.kernel.org
Cc: linux-pci@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index dbf7539..73f908a 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -690,10 +690,10 @@ int qlcnic_setup_tss_rss_intr(struct qlcnic_adapter *adapter)
 		adapter->msix_entries[vector].entry = vector;
 
 restore:
-	err = pci_enable_msix(pdev, adapter->msix_entries, num_msix);
-	if (err > 0) {
+	err = pci_enable_msix_exact(pdev, adapter->msix_entries, num_msix);
+	if (err == -ENOSPC) {
 		if (!adapter->drv_tss_rings && !adapter->drv_rss_rings)
-			return -ENOSPC;
+			return err;
 
 		netdev_info(adapter->netdev,
 			    "Unable to allocate %d MSI-X vectors, Available vectors %d\n",
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
