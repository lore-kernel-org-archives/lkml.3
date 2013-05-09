Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab3EIW7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:59:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519Ab3EIWcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:32:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?T=F3th=20Attila?= <atoth@atoth.sote.hu>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Bruce Allan <bruce.w.allan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>, Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [ 14/73] e1000e: fix runtime power management transitions
Date: Thu,  9 May 2013 15:31:37 -0700
Message-Id: <20130509222759.512061751@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <khlebnikov@openvz.org>

commit 66148babe728f3e00e13c56f6b0ecf325abd80da upstream.

This patch removes redundant actions from driver and fixes its interaction
with actions in pci-bus runtime power management code.

It removes pci_save_state() from __e1000_shutdown() for normal adapters,
PCI bus callbacks pci_pm_*() will do all this for us. Now __e1000_shutdown()
switches to D3-state only quad-port adapters, because they needs quirk for
clearing false-positive error from downsteam pci-e port.

pci_save_state() now called after clearing bus-master bit, thus __e1000_resume()
and e1000_io_slot_reset() must set it back after restoring configuration space.

This patch set get_link_status before calling pm_runtime_put() in e1000_open()
to allow e1000_idle() get real link status and schedule first runtime suspend.

This patch also enables wakeup for device if management mode is enabled
(like for WoL) as result pci_prepare_to_sleep() would setup wakeup without
special actions like custom 'enable_wakeup' sign.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Bruce Allan <bruce.w.allan@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Borislav Petkov <bp@suse.de>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Tested-by: Tóth Attila <atoth@atoth.sote.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/e1000e/netdev.c |   78 ++++++-----------------------
 1 file changed, 18 insertions(+), 60 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -3952,6 +3952,7 @@ static int e1000_open(struct net_device
 	netif_start_queue(netdev);
 
 	adapter->idle_check = true;
+	hw->mac.get_link_status = true;
 	pm_runtime_put(&pdev->dev);
 
 	/* fire a link status change interrupt to start the watchdog */
@@ -5450,8 +5451,7 @@ release:
 	return retval;
 }
 
-static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake,
-			    bool runtime)
+static int __e1000_shutdown(struct pci_dev *pdev, bool runtime)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
@@ -5475,10 +5475,6 @@ static int __e1000_shutdown(struct pci_d
 	}
 	e1000e_reset_interrupt_capability(adapter);
 
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-
 	status = er32(STATUS);
 	if (status & E1000_STATUS_LU)
 		wufc &= ~E1000_WUFC_LNKC;
@@ -5534,13 +5530,6 @@ static int __e1000_shutdown(struct pci_d
 		ew32(WUFC, 0);
 	}
 
-	*enable_wake = !!wufc;
-
-	/* make sure adapter isn't asleep if manageability is enabled */
-	if ((adapter->flags & FLAG_MNG_PT_ENABLED) ||
-	    (hw->mac.ops.check_mng_mode(hw)))
-		*enable_wake = true;
-
 	if (adapter->hw.phy.type == e1000_phy_igp_3)
 		e1000e_igp3_phy_powerdown_workaround_ich8lan(&adapter->hw);
 
@@ -5551,26 +5540,6 @@ static int __e1000_shutdown(struct pci_d
 
 	pci_clear_master(pdev);
 
-	return 0;
-}
-
-static void e1000_power_off(struct pci_dev *pdev, bool sleep, bool wake)
-{
-	if (sleep && wake) {
-		pci_prepare_to_sleep(pdev);
-		return;
-	}
-
-	pci_wake_from_d3(pdev, wake);
-	pci_set_power_state(pdev, PCI_D3hot);
-}
-
-static void e1000_complete_shutdown(struct pci_dev *pdev, bool sleep,
-                                    bool wake)
-{
-	struct net_device *netdev = pci_get_drvdata(pdev);
-	struct e1000_adapter *adapter = netdev_priv(netdev);
-
 	/* The pci-e switch on some quad port adapters will report a
 	 * correctable error when the MAC transitions from D0 to D3.  To
 	 * prevent this we need to mask off the correctable errors on the
@@ -5584,12 +5553,13 @@ static void e1000_complete_shutdown(stru
 		pcie_capability_write_word(us_dev, PCI_EXP_DEVCTL,
 					   (devctl & ~PCI_EXP_DEVCTL_CERE));
 
-		e1000_power_off(pdev, sleep, wake);
+		pci_save_state(pdev);
+		pci_prepare_to_sleep(pdev);
 
 		pcie_capability_write_word(us_dev, PCI_EXP_DEVCTL, devctl);
-	} else {
-		e1000_power_off(pdev, sleep, wake);
 	}
+
+	return 0;
 }
 
 #ifdef CONFIG_PCIEASPM
@@ -5640,9 +5610,7 @@ static int __e1000_resume(struct pci_dev
 	if (aspm_disable_flag)
 		e1000e_disable_aspm(pdev, aspm_disable_flag);
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	pci_save_state(pdev);
+	pci_set_master(pdev);
 
 	e1000e_set_interrupt_capability(adapter);
 	if (netif_running(netdev)) {
@@ -5708,14 +5676,8 @@ static int __e1000_resume(struct pci_dev
 static int e1000_suspend(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	int retval;
-	bool wake;
-
-	retval = __e1000_shutdown(pdev, &wake, false);
-	if (!retval)
-		e1000_complete_shutdown(pdev, true, wake);
 
-	return retval;
+	return __e1000_shutdown(pdev, false);
 }
 
 static int e1000_resume(struct device *dev)
@@ -5738,13 +5700,10 @@ static int e1000_runtime_suspend(struct
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
-	if (e1000e_pm_ready(adapter)) {
-		bool wake;
-
-		__e1000_shutdown(pdev, &wake, true);
-	}
+	if (!e1000e_pm_ready(adapter))
+		return 0;
 
-	return 0;
+	return __e1000_shutdown(pdev, true);
 }
 
 static int e1000_idle(struct device *dev)
@@ -5782,12 +5741,7 @@ static int e1000_runtime_resume(struct d
 
 static void e1000_shutdown(struct pci_dev *pdev)
 {
-	bool wake = false;
-
-	__e1000_shutdown(pdev, &wake, false);
-
-	if (system_state == SYSTEM_POWER_OFF)
-		e1000_complete_shutdown(pdev, false, wake);
+	__e1000_shutdown(pdev, false);
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -5908,9 +5862,9 @@ static pci_ers_result_t e1000_io_slot_re
 			"Cannot re-enable PCI device after reset.\n");
 		result = PCI_ERS_RESULT_DISCONNECT;
 	} else {
-		pci_set_master(pdev);
 		pdev->state_saved = true;
 		pci_restore_state(pdev);
+		pci_set_master(pdev);
 
 		pci_enable_wake(pdev, PCI_D3hot, 0);
 		pci_enable_wake(pdev, PCI_D3cold, 0);
@@ -6341,7 +6295,11 @@ static int e1000_probe(struct pci_dev *p
 
 	/* initialize the wol settings based on the eeprom settings */
 	adapter->wol = adapter->eeprom_wol;
-	device_set_wakeup_enable(&adapter->pdev->dev, adapter->wol);
+
+	/* make sure adapter isn't asleep if manageability is enabled */
+	if (adapter->wol || (adapter->flags & FLAG_MNG_PT_ENABLED) ||
+	    (hw->mac.ops.check_mng_mode(hw)))
+		device_wakeup_enable(&pdev->dev);
 
 	/* save off EEPROM version number */
 	e1000_read_nvm(&adapter->hw, 5, 1, &adapter->eeprom_vers);


