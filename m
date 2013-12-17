Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab3LQUHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:07:08 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47382 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab3LQUHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:07:04 -0500
Message-ID: <52B0AEE4.1000900@gmail.com>
Date: Tue, 17 Dec 2013 12:07:00 -0800
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
Subject: [PATCH v3 7/8] pciehp: Ensure very fast hotplug events are also processed.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today, this is how all the hotplug and unplug events work:

Hotplug / Removal needs to be done
  => Set slot->state (protected by slot->lock) to either
    POWERON_STATE (for enabling) or POWEROFF_STATE (for disabling).
  => Submit the work item for pciehp_power_thread() to slot->wq.

Problem:
  There is a problem if the hotplug events can happen fast enough that
  they do not give SW enough time to add or remove the new devices.

  => Assume: Event for unplug comes (e.g. surprise removal). But
     before the pciehp_power_thread() work item was executed, the
     card was replaced by another card, causing surprise hotplug event.

  => What goes wrong:
    => The hot-removal event sets slot->state to POWEROFF_STATE, and
       schedules the pciehp_power_thread().
    => The hot-add event sets slot->state to POWERON_STATE, and
       schedules the pciehp_power_thread().
    => Now the pciehp_power_thread() is scheduled twice, and on both
       occasions it will find POWERON_STATE and will try to add the
       devices on the slot, and will fail complaining that the devices
       already exist.

  => Why this is a problem: If the device was replaced between the hot
     removal and hot-add, then we should unload the old driver and
     reload the new one. This does not happen today. The kernel or the
     driver is not even aware that the device was replaced.

     The problem is that the pciehp_power_thread() only looks at the
     slot->state which would only contain the *latest* state - not
     the actual event (add / remove) that was the intent of the IRQ
     handler who submitted the work.

What this patch does:

  => Hotplug events pass on an actual request (for addition or removal)
     to pciehp_power_thread() which is local to that work item
     submission.

  => pciehp_power_thread() does not need to look at slote->state and
     hence no locks needed in that.

  => Essentially this results in all the hotplug and unplug events
     "replayed" by pciehp_power_thread().

Signed-off-by: Rajat Jain <rajatjain@juniper.net>
Signed-off-by: Guenter Roeck <groeck@juniper.net>
---
v3: * same as v2. Only the patch numbering has changed from [3/4] to [7/8]
    * Folded 4 hunks into one since handler functions were combined.
v2: Same as v1, dropped the "RFC" from subject, added Guenter's signature
v1: Initial patch

 drivers/pci/hotplug/pciehp_ctrl.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_ctrl.c b/drivers/pci/hotplug/pciehp_ctrl.c
index e934618..36a8061 100644
--- a/drivers/pci/hotplug/pciehp_ctrl.c
+++ b/drivers/pci/hotplug/pciehp_ctrl.c
@@ -297,6 +297,9 @@ static int remove_board(struct slot *p_slot)
 struct power_work_info {
 	struct slot *p_slot;
 	struct work_struct work;
+	unsigned int req;
+#define DISABLE_REQ 0
+#define ENABLE_REQ  1
 };
 
 /**
@@ -312,10 +315,8 @@ static void pciehp_power_thread(struct work_struct *work)
 		container_of(work, struct power_work_info, work);
 	struct slot *p_slot = info->p_slot;
 
-	mutex_lock(&p_slot->lock);
-	switch (p_slot->state) {
-	case POWEROFF_STATE:
-		mutex_unlock(&p_slot->lock);
+	switch (info->req) {
+	case DISABLE_REQ:
 		ctrl_dbg(p_slot->ctrl,
 			 "Disabling domain:bus:device=%04x:%02x:00\n",
 			 pci_domain_nr(p_slot->ctrl->pcie->port->subordinate),
@@ -323,18 +324,22 @@ static void pciehp_power_thread(struct work_struct *work)
 		pciehp_disable_slot(p_slot);
 		mutex_lock(&p_slot->lock);
 		p_slot->state = STATIC_STATE;
-		break;
-	case POWERON_STATE:
 		mutex_unlock(&p_slot->lock);
+		break;
+	case ENABLE_REQ:
+		ctrl_dbg(p_slot->ctrl,
+			 "Enabling domain:bus:device=%04x:%02x:00\n",
+			 pci_domain_nr(p_slot->ctrl->pcie->port->subordinate),
+			 p_slot->ctrl->pcie->port->subordinate->number);
 		if (pciehp_enable_slot(p_slot) && PWR_LED(p_slot->ctrl))
 			pciehp_green_led_off(p_slot);
 		mutex_lock(&p_slot->lock);
 		p_slot->state = STATIC_STATE;
+		mutex_unlock(&p_slot->lock);
 		break;
 	default:
 		break;
 	}
-	mutex_unlock(&p_slot->lock);
 
 	kfree(info);
 }
@@ -357,9 +362,11 @@ void pciehp_queue_pushbutton_work(struct work_struct *work)
 	switch (p_slot->state) {
 	case BLINKINGOFF_STATE:
 		p_slot->state = POWEROFF_STATE;
+		info->req = DISABLE_REQ;
 		break;
 	case BLINKINGON_STATE:
 		p_slot->state = POWERON_STATE;
+		info->req = ENABLE_REQ;
 		break;
 	default:
 		kfree(info);
@@ -455,10 +462,13 @@ static void handle_surprise_event(struct slot *p_slot)
 	INIT_WORK(&info->work, pciehp_power_thread);
 
 	pciehp_get_adapter_status(p_slot, &getstatus);
-	if (!getstatus)
+	if (!getstatus) {
 		p_slot->state = POWEROFF_STATE;
-	else
+		info->req = DISABLE_REQ;
+	} else {
 		p_slot->state = POWERON_STATE;
+		info->req = ENABLE_REQ;
+	}
 
 	queue_work(p_slot->wq, &info->work);
 }
@@ -478,6 +488,7 @@ static void handle_link_event(struct slot *p_slot, u32 event)
 		return;
 	}
 	info->p_slot = p_slot;
+	info->req = event == INT_LINK_UP ? ENABLE_REQ : DISABLE_REQ;
 	INIT_WORK(&info->work, pciehp_power_thread);
 
 	switch (p_slot->state) {
-- 
1.7.9.5

