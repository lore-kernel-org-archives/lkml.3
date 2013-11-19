Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab3KSW7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:59:45 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:47678 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab3KSW7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:59:42 -0500
Message-ID: <528BED5A.9070101@gmail.com>
Date: Tue, 19 Nov 2013 14:59:38 -0800
From: Rajat Jain <rajatjain.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linux-PCI <linux-pci@vger.kernel.org>,
        Linux-hotplug <linux-hotplug@vger.kernel.org>,
        linux-kernel@vger.kernel.org
CC: Bjorn Helgaas <bhelgaas@google.com>, Guenter Roeck <linux@roeck-us.net>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Paul Bolle <pebolle@tiscali.nl>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Rajat Jain <rajatjain.linux@gmail.com>,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>
Subject: [RFC PATCH 2/4] pciehp: Use link change notifications for hot-plug
 and, removal
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

* Add "pciehp_use_link_events" module parameter to indicate link state
  changes to be used for hot-plug.

* Define and use interrupt events for linkup / linkdown.

* Introduce the functions to handle link-up and link-down events and
  queue the work in the slot->wq to be processed by pciehp_power_thread

* Many ports use inband mechanism such as receiver detection to find out
  whether an adapter is present. In such HP ports, when link goes down,
  adapter presence will also toggle. Thus don't bail out the removal
  process initiated by link down, if adapter is not found to be present.

* The current pciehp driver disabled the link in case of a hot-removal.
  Since for link change based hot-plug to work, we need that enabled,
  hence make sure to not disable the link permanently if link state
  based hot-plug is to be used.

* pciehp_reset_slot - reset of secondary bus may cause undesirable
  spurious link notifications. Thus disable these around the secondary
  bus reset.

Signed-off-by: Rajat Jain <rajatjain@juniper.net>
---
 drivers/pci/hotplug/pciehp.h      |    4 ++
 drivers/pci/hotplug/pciehp_core.c |    3 +
 drivers/pci/hotplug/pciehp_ctrl.c |  132 ++++++++++++++++++++++++++++++++++++-
 drivers/pci/hotplug/pciehp_hpc.c  |   56 +++++++++++-----
 4 files changed, 179 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index fc322ed..64a6840 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -44,6 +44,7 @@ extern bool pciehp_poll_mode;
 extern int pciehp_poll_time;
 extern bool pciehp_debug;
 extern bool pciehp_force;
+extern bool pciehp_use_link_events;      /* Use link state events for hotplug */
 
 #define dbg(format, arg...)						\
 do {									\
@@ -110,6 +111,8 @@ struct controller {
 #define INT_BUTTON_PRESS		7
 #define INT_BUTTON_RELEASE		8
 #define INT_BUTTON_CANCEL		9
+#define INT_LINK_UP			10
+#define INT_LINK_DOWN			11
 
 #define STATIC_STATE			0
 #define BLINKINGON_STATE		1
@@ -133,6 +136,7 @@ u8 pciehp_handle_attention_button(struct slot *p_slot);
 u8 pciehp_handle_switch_change(struct slot *p_slot);
 u8 pciehp_handle_presence_change(struct slot *p_slot);
 u8 pciehp_handle_power_fault(struct slot *p_slot);
+u8 pciehp_handle_linkstate_change(struct slot *p_slot);
 int pciehp_configure_device(struct slot *p_slot);
 int pciehp_unconfigure_device(struct slot *p_slot);
 void pciehp_queue_pushbutton_work(struct work_struct *work);
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index f4a18f5..5a2c43c 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -42,6 +42,7 @@ bool pciehp_debug;
 bool pciehp_poll_mode;
 int pciehp_poll_time;
 bool pciehp_force;
+bool pciehp_use_link_events;
 
 #define DRIVER_VERSION	"0.4"
 #define DRIVER_AUTHOR	"Dan Zink <dan.zink@compaq.com>, Greg Kroah-Hartman <greg@kroah.com>, Dely Sy <dely.l.sy@intel.com>"
@@ -55,10 +56,12 @@ module_param(pciehp_debug, bool, 0644);
 module_param(pciehp_poll_mode, bool, 0644);
 module_param(pciehp_poll_time, int, 0644);
 module_param(pciehp_force, bool, 0644);
+module_param(pciehp_use_link_events, bool, 0644);
 MODULE_PARM_DESC(pciehp_debug, "Debugging mode enabled or not");
 MODULE_PARM_DESC(pciehp_poll_mode, "Using polling mechanism for hot-plug events or not");
 MODULE_PARM_DESC(pciehp_poll_time, "Polling mechanism frequency, in seconds");
 MODULE_PARM_DESC(pciehp_force, "Force pciehp, even if OSHP is missing");
+MODULE_PARM_DESC(pciehp_use_link_events, "Use link state change events to drive pciehp hot-plug");
 
 #define PCIE_MODULE_NAME "pciehp"
 
diff --git a/drivers/pci/hotplug/pciehp_ctrl.c b/drivers/pci/hotplug/pciehp_ctrl.c
index 38f0186..3899b52 100644
--- a/drivers/pci/hotplug/pciehp_ctrl.c
+++ b/drivers/pci/hotplug/pciehp_ctrl.c
@@ -150,6 +150,29 @@ u8 pciehp_handle_power_fault(struct slot *p_slot)
 	return 1;
 }
 
+u8 pciehp_handle_linkstate_change(struct slot *p_slot)
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
+
+	return 1;
+}
+
 /* The following routines constitute the bulk of the
    hotplug controller logic
  */
@@ -442,6 +465,100 @@ static void handle_surprise_event(struct slot *p_slot)
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
@@ -468,6 +585,12 @@ static void interrupt_event_handler(struct work_struct *work)
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
@@ -524,7 +647,14 @@ int pciehp_disable_slot(struct slot *p_slot)
 	if (!p_slot->ctrl)
 		return 1;
 
-	if (!HP_SUPR_RM(p_slot->ctrl)) {
+	/*
+	 * In certain scenarios, adapter may have already disappeared by this
+	 * time. E.g (1) Surprise Removal (2) Many ports use in-band
+	 * mechanisms to signal if adapter is present or not. Thus when a
+	 * link goes down, the device may have already gone away by the time
+	 * this code executes.
+	 */
+	if (!HP_SUPR_RM(p_slot->ctrl) && !pciehp_use_link_events) {
 		ret = pciehp_get_adapter_status(p_slot, &getstatus);
 		if (ret || !getstatus) {
 			ctrl_info(ctrl, "No adapter on slot(%s)\n",
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 3a5eee7..90eb8c6 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -620,13 +620,21 @@ int pciehp_power_off_slot(struct slot * slot)
 	u16 cmd_mask;
 	int retval;
 
-	/* Disable the link at first */
-	pciehp_link_disable(ctrl);
-	/* wait the link is down */
-	if (ctrl->link_active_reporting)
-		pcie_wait_link_not_active(ctrl);
-	else
-		msleep(1000);
+	if (!pciehp_use_link_events) {
+		/*
+		 * In case it is desired to use the link state events for
+		 * hot-plug, make sure to NOT disable the link permanently, or
+		 * else we might never get a link-up hotplug event again.
+		 */
+
+		/* Disable the link first */
+		pciehp_link_disable(ctrl);
+		/* wait until the link is down */
+		if (ctrl->link_active_reporting)
+			pcie_wait_link_not_active(ctrl);
+		else
+			msleep(1000);
+	}
 
 	slot_cmd = POWER_OFF;
 	cmd_mask = PCI_EXP_SLTCTL_PCC;
@@ -661,7 +669,7 @@ static irqreturn_t pcie_isr(int irq, void *dev_id)
 
 		detected &= (PCI_EXP_SLTSTA_ABP | PCI_EXP_SLTSTA_PFD |
 			     PCI_EXP_SLTSTA_MRLSC | PCI_EXP_SLTSTA_PDC |
-			     PCI_EXP_SLTSTA_CC);
+			     PCI_EXP_SLTSTA_CC | PCI_EXP_SLTSTA_DLLSC);
 		detected &= ~intr_loc;
 		intr_loc |= detected;
 		if (!intr_loc)
@@ -702,6 +710,10 @@ static irqreturn_t pcie_isr(int irq, void *dev_id)
 		ctrl->power_fault_detected = 1;
 		pciehp_handle_power_fault(slot);
 	}
+
+	if (intr_loc & PCI_EXP_SLTSTA_DLLSC)
+		pciehp_handle_linkstate_change(slot);
+
 	return IRQ_HANDLED;
 }
 
@@ -724,12 +736,15 @@ int pcie_enable_notification(struct controller *ctrl)
 		cmd |= PCI_EXP_SLTCTL_ABPE;
 	if (MRL_SENS(ctrl))
 		cmd |= PCI_EXP_SLTCTL_MRLSCE;
+	if (pciehp_use_link_events)
+		cmd |= PCI_EXP_SLTCTL_DLLSCE;
 	if (!pciehp_poll_mode)
 		cmd |= PCI_EXP_SLTCTL_HPIE | PCI_EXP_SLTCTL_CCIE;
 
 	mask = (PCI_EXP_SLTCTL_PDCE | PCI_EXP_SLTCTL_ABPE |
 		PCI_EXP_SLTCTL_MRLSCE | PCI_EXP_SLTCTL_PFDE |
-		PCI_EXP_SLTCTL_HPIE | PCI_EXP_SLTCTL_CCIE);
+		PCI_EXP_SLTCTL_HPIE | PCI_EXP_SLTCTL_CCIE |
+		PCI_EXP_SLTCTL_DLLSCE);
 
 	if (pcie_write_cmd(ctrl, cmd, mask)) {
 		ctrl_err(ctrl, "Cannot enable software notification\n");
@@ -751,28 +766,39 @@ static void pcie_disable_notification(struct controller *ctrl)
 
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
+		ctrl_mask |= PCI_EXP_SLTCTL_PDCE;
+		stat_mask |= PCI_EXP_SLTSTA_PDC;
+	}
+	if (pciehp_use_link_events) {
+		ctrl_mask |= PCI_EXP_SLTCTL_DLLSCE;
+		stat_mask |= PCI_EXP_SLTSTA_DLLSC;
+	}
+
+	if (ctrl_mask) {
+		pcie_write_cmd(ctrl, 0, ctrl_mask);
 		if (pciehp_poll_mode)
 			del_timer_sync(&ctrl->poll_timer);
 	}
 
 	pci_reset_bridge_secondary_bus(ctrl->pcie->port);
 
-	if (HP_SUPR_RM(ctrl)) {
-		pciehp_writew(ctrl, PCI_EXP_SLTSTA, PCI_EXP_SLTSTA_PDC);
-		pcie_write_cmd(ctrl, PCI_EXP_SLTCTL_PDCE, PCI_EXP_SLTCTL_PDCE);
+	if (ctrl_mask) {
+		pciehp_writew(ctrl, PCI_EXP_SLTSTA, stat_mask);
+		pcie_write_cmd(ctrl, ctrl_mask, ctrl_mask);
 		if (pciehp_poll_mode)
 			int_poll_timeout(ctrl->poll_timer.data);
 	}
-- 
1.7.9.5

