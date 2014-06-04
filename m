Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaFDXWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:22:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaFDXWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.14 163/228] iwlwifi: pcie: disable interrupts upon PCIe alloc
Date: Wed,  4 Jun 2014 16:23:12 -0700
Message-Id: <20140604232353.266291923@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 83f7a85f1134c6e914453f5747435415a23d516b upstream.

In case RFKILL is in KILL position, the NIC will issue an
interrupt straight away. This interrupt won't be sent
because it is masked in the hardware.
But if our interrupt service routine is called for another
reason (SHARED_IRQ), then we'll look at the interrupt cause
and service it. This can cause bad things if we are not
ready yet.
Explicitly clean the interrupt cause register to make sure
we won't service anything before we are ready to.

Reported-and-tested-by: Alexander Monakov <amonakov@gmail.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/pcie/trans.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1563,6 +1563,10 @@ struct iwl_trans *iwl_trans_pcie_alloc(s
 	 * PCI Tx retries from interfering with C3 CPU state */
 	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
 
+	trans->dev = &pdev->dev;
+	trans_pcie->pci_dev = pdev;
+	iwl_disable_interrupts(trans);
+
 	err = pci_enable_msi(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "pci_enable_msi failed(0X%x)\n", err);
@@ -1574,8 +1578,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(s
 		}
 	}
 
-	trans->dev = &pdev->dev;
-	trans_pcie->pci_dev = pdev;
 	trans->hw_rev = iwl_read32(trans, CSR_HW_REV);
 	trans->hw_id = (pdev->device << 16) + pdev->subsystem_device;
 	snprintf(trans->hw_id_str, sizeof(trans->hw_id_str),
@@ -1601,8 +1603,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(s
 		goto out_pci_disable_msi;
 	}
 
-	trans_pcie->inta_mask = CSR_INI_SET_MASK;
-
 	if (iwl_pcie_alloc_ict(trans))
 		goto out_free_cmd_pool;
 
@@ -1614,6 +1614,8 @@ struct iwl_trans *iwl_trans_pcie_alloc(s
 		goto out_free_ict;
 	}
 
+	trans_pcie->inta_mask = CSR_INI_SET_MASK;
+
 	return trans;
 
 out_free_ict:


