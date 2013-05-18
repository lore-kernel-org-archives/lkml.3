Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007Ab3ERDJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:09:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758746Ab3ERDAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:22 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=PVPPP_nPF4IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=GrzLugPPESYA:10 a=6rqHouBjAAAA:8 a=QyXUC8HyAAAA:8 a=xrzxy3i7KhNRffTyM_AA:9 a=TAmEwCHjoHMA:10 a=dGJ0OcVc7YAA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021656.829696669@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bruce Allan <bruce.w.allan@intel.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>, Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [ 094/136 ] e1000e: fix runtime power management transitions
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0094-e1000e-fix-runtime-power-management-transitions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <khlebnikov@openvz.org>

[ Upstream commit 66148babe728f3e00e13c56f6b0ecf325abd80da ]

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

Cc: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Borislav Petkov <bp@suse.de>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c |   78 +++++++---------------------
 1 file changed, 18 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index a46e75e..d191a63 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -3951,6 +3951,7 @@ static int e1000_open(struct net_device *netdev)
 	netif_start_queue(netdev);
 
 	adapter->idle_check = true;
+	hw->mac.get_link_status = true;
 	pm_runtime_put(&pdev->dev);
 
 	/* fire a link status change interrupt to start the watchdog */
@@ -5454,8 +5455,7 @@ release:
 	return retval;
 }
 
-static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake,
-			    bool runtime)
+static int __e1000_shutdown(struct pci_dev *pdev, bool runtime)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
@@ -5479,10 +5479,6 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake,
 	}
 	e1000e_reset_interrupt_capability(adapter);
 
-	retval = pci_save_state(pdev);
-	if (retval)
-		return retval;
-
 	status = er32(STATUS);
 	if (status & E1000_STATUS_LU)
 		wufc &= ~E1000_WUFC_LNKC;
@@ -5538,13 +5534,6 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake,
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
 
@@ -5556,26 +5545,6 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool *enable_wake,
 
 	pci_disable_device(pdev);
 
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
 	/*
 	 * The pci-e switch on some quad port adapters will report a
 	 * correctable error when the MAC transitions from D0 to D3.  To
@@ -5591,12 +5560,13 @@ static void e1000_complete_shutdown(struct pci_dev *pdev, bool sleep,
 		pci_write_config_word(us_dev, pos + PCI_EXP_DEVCTL,
 		                      (devctl & ~PCI_EXP_DEVCTL_CERE));
 
-		e1000_power_off(pdev, sleep, wake);
+		pci_save_state(pdev);
+		pci_prepare_to_sleep(pdev);
 
 		pci_write_config_word(us_dev, pos + PCI_EXP_DEVCTL, devctl);
-	} else {
-		e1000_power_off(pdev, sleep, wake);
 	}
+
+	return 0;
 }
 
 #ifdef CONFIG_PCIEASPM
@@ -5658,9 +5628,7 @@ static int __e1000_resume(struct pci_dev *pdev)
 	if (aspm_disable_flag)
 		e1000e_disable_aspm(pdev, aspm_disable_flag);
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	pci_save_state(pdev);
+	pci_set_master(pdev);
 
 	e1000e_set_interrupt_capability(adapter);
 	if (netif_running(netdev)) {
@@ -5727,14 +5695,8 @@ static int __e1000_resume(struct pci_dev *pdev)
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
@@ -5757,13 +5719,10 @@ static int e1000_runtime_suspend(struct device *dev)
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
@@ -5801,12 +5760,7 @@ static int e1000_runtime_resume(struct device *dev)
 
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
@@ -5924,9 +5878,9 @@ static pci_ers_result_t e1000_io_slot_reset(struct pci_dev *pdev)
 			"Cannot re-enable PCI device after reset.\n");
 		result = PCI_ERS_RESULT_DISCONNECT;
 	} else {
-		pci_set_master(pdev);
 		pdev->state_saved = true;
 		pci_restore_state(pdev);
+		pci_set_master(pdev);
 
 		pci_enable_wake(pdev, PCI_D3hot, 0);
 		pci_enable_wake(pdev, PCI_D3cold, 0);
@@ -6363,7 +6317,11 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
 
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
-- 
1.7.10.4


