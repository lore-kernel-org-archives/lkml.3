Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab3LCWcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:32:54 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:47966 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab3LCWcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:32:51 -0500
Message-ID: <529E5C0E.80903@gmail.com>
Date: Tue, 03 Dec 2013 14:32:46 -0800
From: Rajat Jain <rajatjain.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Paul Bolle <pebolle@tiscali.nl>
CC: Rajat Jain <rajatjain@juniper.net>, Rajat Jain <rajatxjain@gmail.com>,
        Rajat Jain <rajatjain.linux@gmail.com>,
        Guenter Roeck <groeck@juniper.net>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 2/4] pciehp: Use link change notifications for hot-plug
 and removal
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of systems do not have the fancy buttons and LEDs, and instead
want to rely only on the Link state change events to drive the hotplug
and removal state machinery.
(http://www.spinics.net/lists/hotplug/msg05802.html)

This patch adds support for that functionality. Here are the details
about the patch itself:

* Define and use interrupt events for linkup / linkdown.

* Introduce the functions to handle link-up and link-down events and
  queue the work in the slot->wq to be processed by pciehp_power_thread

* The current code bails out from device removal, if an adapter is not
  detected. That is not right, because if an adapter is not present at
  all, it provides all the more reason to REMOVE the device. This is
  specially a problem for link state hot-plug, because some ports use
  in band mechanism to detect the presence detection. Thus when link
  goes down, presence detect also goes down. We _want_ that the devices
  should be removed in this case.

* The current pciehp driver disabled the link in case of a hot-removal.
  Since for link change based hot-plug to work, we need that enabled,
  hence make sure to not disable the link permanently if link state
  based hot-plug is to be used. Also have to remove
  pciehp_link_disable() and pcie_wait_link_not_active() static functions
  since they are not being used anywhere else.

* pciehp_reset_slot - reset of secondary bus may cause undesirable
  spurious link notifications. Thus disable these around the secondary
  bus reset.

Signed-off-by: Rajat Jain <rajatjain@juniper.net>
Signed-off-by: Guenter Roeck <groeck@juniper.net>
---
 v2: - drop the use_link_state_events module parameter as discussed here:
       http://marc.info/?t=138513966800006&r=1&w=2
     - removed the static functions left unused after this patch.
     - make the pciehp_handle_linkstate_change() return void.
     - dropped the "RFC" from subject, and added Guenter's signature

 drivers/pci/hotplug/pciehp.h      |    3 +
 drivers/pci/hotplug/pciehp_ctrl.c |  130 ++++++++++++++++++++++++++++++++++---
 drivers/pci/hotplug/pciehp_hpc.c  |   56 ++++++++--------
 3 files changed, 150 insertions(+), 39 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index fc322ed..353edda 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -110,6 +110,8 @@ struct controller {
 #define INT_BUTTON_PRESS		7
 #define INT_BUTTON_RELEASE		8
 #define INT_BUTTON_CANCEL		9
+#define INT_LINK_UP			10
+#define INT_LINK_DOWN			11
 
 #define STATIC_STATE			0
 #define BLINKINGON_STATE		1
@@ -133,6 +135,7 @@ u8 pciehp_handle_attention_button(struct slot *p_slot);
 u8 pciehp_handle_switch_change(struct slot *p_slot);
 u8 pciehp_handle_presence_change(struct slot *p_slot);
 u8 pciehp_handle_power_fault(struct slot *p_slot);
+void pciehp_handle_linkstate_change(struct slot *p_slot);
 int pciehp_configure_device(struct slot *p_slot);
 int pciehp_unconfigure_device(struct slot *p_slot);
 void pciehp_queue_pushbutton_work(struct work_struct *work);
diff --git a/drivers/pci/hotplug/pciehp_ctrl.c b/drivers/pci/hotplug/pciehp_ctrl.c
index 38f0186..4c2544c 100644
--- a/drivers/pci/hotplug/pciehp_ctrl.c
+++ b/drivers/pci/hotplug/pciehp_ctrl.c
@@ -150,6 +150,27 @@ u8 pciehp_handle_power_fault(struct slot *p_slot)
 	return 1;
 }
 
+void pciehp_handle_linkstate_change(struct slot *p_slot)
+{
+	u32 event_type;
+	struct controller *ctrl = p_slot->ctrl;
+
+	/* Link Status Change */
+	ctrl_dbg(ctrl, "Data Link Layer State change\n");
+
+	if (pciehp_check_link_active(ctrl)) {
+		ctrl_info(ctrl, "slot(%s): Link Up event\n",
+			  slot_name(p_slot));
+		event_type = INT_LINK_UP;
+	} else {
+		ctrl_info(ctrl, "slot(%s): Link Down event\n",
+			  slot_name(p_slot));
+		event_type = INT_LINK_DOWN;
+	}
+
+	queue_interrupt_event(p_slot, event_type);
+}
+
 /* The following routines constitute the bulk of the
    hotplug controller logic
  */
@@ -442,6 +463,100 @@ static void handle_surprise_event(struct slot *p_slot)
 	queue_work(p_slot->wq, &info->work);
 }
 
+/*
+ * Note: This function must be called with slot->lock held
+ */
+static void handle_link_up_event(struct slot *p_slot)
+{
+	struct controller *ctrl = p_slot->ctrl;
+	struct power_work_info *info;
+
+	info = kmalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		ctrl_err(p_slot->ctrl, "%s: Cannot allocate memory\n",
+			 __func__);
+		return;
+	}
+	info->p_slot = p_slot;
+	INIT_WORK(&info->work, pciehp_power_thread);
+
+	switch (p_slot->state) {
+	case BLINKINGON_STATE:
+	case BLINKINGOFF_STATE:
+		cancel_delayed_work(&p_slot->work);
+		/* Fall through */
+	case STATIC_STATE:
+		p_slot->state = POWERON_STATE;
+		queue_work(p_slot->wq, &info->work);
+		break;
+	case POWERON_STATE:
+		ctrl_info(ctrl,
+			  "Link Up event ignored on slot(%s): already powering on\n",
+			  slot_name(p_slot));
+		kfree(info);
+		break;
+	case POWEROFF_STATE:
+		ctrl_info(ctrl,
+			  "Link Up event queued on slot(%s): currently getting powered off\n",
+			  slot_name(p_slot));
+		p_slot->state = POWERON_STATE;
+		queue_work(p_slot->wq, &info->work);
+		break;
+	default:
+		ctrl_err(ctrl, "Not a valid state on slot(%s)\n",
+			 slot_name(p_slot));
+		kfree(info);
+		break;
+	}
+}
+
+/*
+ * Note: This function must be called with slot->lock held
+ */
+static void handle_link_down_event(struct slot *p_slot)
+{
+	struct controller *ctrl = p_slot->ctrl;
+	struct power_work_info *info;
+
+	info = kmalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		ctrl_err(p_slot->ctrl, "%s: Cannot allocate memory\n",
+			 __func__);
+		return;
+	}
+	info->p_slot = p_slot;
+	INIT_WORK(&info->work, pciehp_power_thread);
+
+	switch (p_slot->state) {
+	case BLINKINGON_STATE:
+	case BLINKINGOFF_STATE:
+		cancel_delayed_work(&p_slot->work);
+		/* Fall through */
+	case STATIC_STATE:
+		p_slot->state = POWEROFF_STATE;
+		queue_work(p_slot->wq, &info->work);
+		break;
+	case POWEROFF_STATE:
+		ctrl_info(ctrl,
+			  "Link Down event ignored on slot(%s): already powering off\n",
+			  slot_name(p_slot));
+		kfree(info);
+		break;
+	case POWERON_STATE:
+		ctrl_info(ctrl,
+			  "Link Down event queued on slot(%s): currently getting powered on\n",
+			  slot_name(p_slot));
+		p_slot->state = POWEROFF_STATE;
+		queue_work(p_slot->wq, &info->work);
+		break;
+	default:
+		ctrl_err(ctrl, "Not a valid state on slot %s\n",
+			 slot_name(p_slot));
+		kfree(info);
+		break;
+	}
+}
+
 static void interrupt_event_handler(struct work_struct *work)
 {
 	struct event_info *info = container_of(work, struct event_info, work);
@@ -468,6 +583,12 @@ static void interrupt_event_handler(struct work_struct *work)
 		ctrl_dbg(ctrl, "Surprise Removal\n");
 		handle_surprise_event(p_slot);
 		break;
+	case INT_LINK_UP:
+		handle_link_up_event(p_slot);
+		break;
+	case INT_LINK_DOWN:
+		handle_link_down_event(p_slot);
+		break;
 	default:
 		break;
 	}
@@ -524,15 +645,6 @@ int pciehp_disable_slot(struct slot *p_slot)
 	if (!p_slot->ctrl)
 		return 1;
 
-	if (!HP_SUPR_RM(p_slot->ctrl)) {
-		ret = pciehp_get_adapter_status(p_slot, &getstatus);
-		if (ret || !getstatus) {
-			ctrl_info(ctrl, "No adapter on slot(%s)\n",
-				  slot_name(p_slot));
-			return -ENODEV;
-		}
-	}
-
 	if (MRL_SENS(p_slot->ctrl)) {
 		ret = pciehp_get_latch_status(p_slot, &getstatus);
 		if (ret || getstatus) {
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 3a5eee7..1f152f3 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -278,11 +278,6 @@ static void pcie_wait_link_active(struct controller *ctrl)
 	__pcie_wait_link_active(ctrl, true);
 }
 
-static void pcie_wait_link_not_active(struct controller *ctrl)
-{
-	__pcie_wait_link_active(ctrl, false);
-}
-
 static bool pci_bus_check_dev(struct pci_bus *bus, int devfn)
 {
 	u32 l;
@@ -383,11 +378,6 @@ static int pciehp_link_enable(struct controller *ctrl)
 	return __pciehp_link_set(ctrl, true);
 }
 
-static int pciehp_link_disable(struct controller *ctrl)
-{
-	return __pciehp_link_set(ctrl, false);
-}
-
 int pciehp_get_attention_status(struct slot *slot, u8 *status)
 {
 	struct controller *ctrl = slot->ctrl;
@@ -620,13 +610,10 @@ int pciehp_power_off_slot(struct slot * slot)
 	u16 cmd_mask;
 	int retval;
 
-	/* Disable the link at first */
-	pciehp_link_disable(ctrl);
-	/* wait the link is down */
-	if (ctrl->link_active_reporting)
-		pcie_wait_link_not_active(ctrl);
-	else
-		msleep(1000);
+	/*
+	 * We do not disable the link, since a future link-up event can now
+	 * be used to initiate hot-plug
+	 */
 
 	slot_cmd = POWER_OFF;
 	cmd_mask = PCI_EXP_SLTCTL_PCC;
@@ -661,7 +648,7 @@ static irqreturn_t pcie_isr(int irq, void *dev_id)
 
 		detected &= (PCI_EXP_SLTSTA_ABP | PCI_EXP_SLTSTA_PFD |
 			     PCI_EXP_SLTSTA_MRLSC | PCI_EXP_SLTSTA_PDC |
-			     PCI_EXP_SLTSTA_CC);
+			     PCI_EXP_SLTSTA_CC | PCI_EXP_SLTSTA_DLLSC);
 		detected &= ~intr_loc;
 		intr_loc |= detected;
 		if (!intr_loc)
@@ -702,6 +689,10 @@ static irqreturn_t pcie_isr(int irq, void *dev_id)
 		ctrl->power_fault_detected = 1;
 		pciehp_handle_power_fault(slot);
 	}
+
+	if (intr_loc & PCI_EXP_SLTSTA_DLLSC)
+		pciehp_handle_linkstate_change(slot);
+
 	return IRQ_HANDLED;
 }
 
@@ -719,7 +710,7 @@ int pcie_enable_notification(struct controller *ctrl)
 	 * when it is cleared in the interrupt service routine, and
 	 * next power fault detected interrupt was notified again.
 	 */
-	cmd = PCI_EXP_SLTCTL_PDCE;
+	cmd = PCI_EXP_SLTCTL_PDCE | PCI_EXP_SLTCTL_DLLSCE;
 	if (ATTN_BUTTN(ctrl))
 		cmd |= PCI_EXP_SLTCTL_ABPE;
 	if (MRL_SENS(ctrl))
@@ -751,31 +742,36 @@ static void pcie_disable_notification(struct controller *ctrl)
 
 /*
  * pciehp has a 1:1 bus:slot relationship so we ultimately want a secondary
- * bus reset of the bridge, but if the slot supports surprise removal we need
- * to disable presence detection around the bus reset and clear any spurious
+ * bus reset of the bridge, but if the slot supports surprise removal (or
+ * link state change based hotplug), we need to disable presence detection
+ * (or link state notifications) around the bus reset and clear any spurious
  * events after.
  */
 int pciehp_reset_slot(struct slot *slot, int probe)
 {
 	struct controller *ctrl = slot->ctrl;
+	u16 stat_mask = 0, ctrl_mask = 0;
 
 	if (probe)
 		return 0;
 
 	if (HP_SUPR_RM(ctrl)) {
-		pcie_write_cmd(ctrl, 0, PCI_EXP_SLTCTL_PDCE);
-		if (pciehp_poll_mode)
-			del_timer_sync(&ctrl->poll_timer);
+		ctrl_mask |= PCI_EXP_SLTCTL_PDCE;
+		stat_mask |= PCI_EXP_SLTSTA_PDC;
 	}
+	ctrl_mask |= PCI_EXP_SLTCTL_DLLSCE;
+	stat_mask |= PCI_EXP_SLTSTA_DLLSC;
+
+	pcie_write_cmd(ctrl, 0, ctrl_mask);
+	if (pciehp_poll_mode)
+		del_timer_sync(&ctrl->poll_timer);
 
 	pci_reset_bridge_secondary_bus(ctrl->pcie->port);
 
-	if (HP_SUPR_RM(ctrl)) {
-		pciehp_writew(ctrl, PCI_EXP_SLTSTA, PCI_EXP_SLTSTA_PDC);
-		pcie_write_cmd(ctrl, PCI_EXP_SLTCTL_PDCE, PCI_EXP_SLTCTL_PDCE);
-		if (pciehp_poll_mode)
-			int_poll_timeout(ctrl->poll_timer.data);
-	}
+	pciehp_writew(ctrl, PCI_EXP_SLTSTA, stat_mask);
+	pcie_write_cmd(ctrl, ctrl_mask, ctrl_mask);
+	if (pciehp_poll_mode)
+		int_poll_timeout(ctrl->poll_timer.data);
 
 	return 0;
 }
-- 
1.7.9.5

