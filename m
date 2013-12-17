Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab3LQUFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:05:51 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:57637 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab3LQUFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:05:49 -0500
Message-ID: <52B0AE97.4020208@gmail.com>
Date: Tue, 17 Dec 2013 12:05:43 -0800
From: Rajat Jain <rajatjain.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
CC: Guenter Roeck <groeck@juniper.net>, Rajat Jain <rajatjain@juniper.net>,
        Rajat Jain <rajatxjain@gmail.com>
Subject: [PATCH v3 2/8] pciehp: Use link change notifications for hot-plug
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

* Make the pcie_isr() also look at link events, and direct control to
  corresponding (new) link state change handler function.

* Introduce the functions to handle link-up and link-down events and
  queue the add / removal work in the slot->wq to be processed by
  pciehp_power_thread()

As a side note, this patch also fixes the bug
https://bugzilla.kernel.org/show_bug.cgi?id=65521

Signed-off-by: Rajat Jain <rajatjain@juniper.net>
Signed-off-by: Guenter Roeck <groeck@juniper.net>
---
v3: * Split up the patch into other patches, thus smaller patch.
    * Combined handler for link up & down into handle_link_event()
      (Yijing Wang's comment)
v2: Same as v1, dropped the "RFC" from subject, added Guenter's signature
v1: Initial patch.


 drivers/pci/hotplug/pciehp.h      |    3 ++
 drivers/pci/hotplug/pciehp_ctrl.c |   88 +++++++++++++++++++++++++++++++++++++
 drivers/pci/hotplug/pciehp_hpc.c  |    6 ++-
 3 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index 4ffcf6b..92d7fed 100644
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
index 38f0186..7ae7b02 100644
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
@@ -442,6 +463,69 @@ static void handle_surprise_event(struct slot *p_slot)
 	queue_work(p_slot->wq, &info->work);
 }
 
+/*
+ * Note: This function must be called with slot->lock held
+ */
+static void handle_link_event(struct slot *p_slot, u32 event)
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
+		p_slot->state = event == INT_LINK_UP ?
+		    POWERON_STATE : POWEROFF_STATE;
+		queue_work(p_slot->wq, &info->work);
+		break;
+	case POWERON_STATE:
+		if (event == INT_LINK_UP) {
+			ctrl_info(ctrl,
+				  "Link Up event ignored on slot(%s): already powering on\n",
+				  slot_name(p_slot));
+			kfree(info);
+		} else {
+			ctrl_info(ctrl,
+				  "Link Down event queued on slot(%s): currently getting powered on\n",
+				  slot_name(p_slot));
+			p_slot->state = POWEROFF_STATE;
+			queue_work(p_slot->wq, &info->work);
+		}
+		break;
+	case POWEROFF_STATE:
+		if (event == INT_LINK_UP) {
+			ctrl_info(ctrl,
+				  "Link Up event queued on slot(%s): currently getting powered off\n",
+				  slot_name(p_slot));
+			p_slot->state = POWERON_STATE;
+			queue_work(p_slot->wq, &info->work);
+		} else {
+			ctrl_info(ctrl,
+				  "Link Down event ignored on slot(%s): already powering off\n",
+				  slot_name(p_slot));
+			kfree(info);
+		}
+		break;
+	default:
+		ctrl_err(ctrl, "Not a valid state on slot(%s)\n",
+			 slot_name(p_slot));
+		kfree(info);
+		break;
+	}
+}
+
 static void interrupt_event_handler(struct work_struct *work)
 {
 	struct event_info *info = container_of(work, struct event_info, work);
@@ -468,6 +552,10 @@ static void interrupt_event_handler(struct work_struct *work)
 		ctrl_dbg(ctrl, "Surprise Removal\n");
 		handle_surprise_event(p_slot);
 		break;
+	case INT_LINK_UP:
+	case INT_LINK_DOWN:
+		handle_link_event(p_slot, info->event_type);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index f8c7a5f..1e9f814 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -661,7 +661,7 @@ static irqreturn_t pcie_isr(int irq, void *dev_id)
 
 		detected &= (PCI_EXP_SLTSTA_ABP | PCI_EXP_SLTSTA_PFD |
 			     PCI_EXP_SLTSTA_MRLSC | PCI_EXP_SLTSTA_PDC |
-			     PCI_EXP_SLTSTA_CC);
+			     PCI_EXP_SLTSTA_CC | PCI_EXP_SLTSTA_DLLSC);
 		detected &= ~intr_loc;
 		intr_loc |= detected;
 		if (!intr_loc)
@@ -702,6 +702,10 @@ static irqreturn_t pcie_isr(int irq, void *dev_id)
 		ctrl->power_fault_detected = 1;
 		pciehp_handle_power_fault(slot);
 	}
+
+	if (intr_loc & PCI_EXP_SLTSTA_DLLSC)
+		pciehp_handle_linkstate_change(slot);
+
 	return IRQ_HANDLED;
 }
 
-- 
1.7.9.5

