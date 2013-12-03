Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab3LCWdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:33:42 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:51979 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab3LCWdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:33:40 -0500
Message-ID: <529E5C40.5010300@gmail.com>
Date: Tue, 03 Dec 2013 14:33:36 -0800
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
Subject: [PATCH v2 4/4] pciehp: Introduce hotplug_lock to serialize HP events
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today it is there is no protection around pciehp_enable_slot() and
pciehp_disable_slot() to ensure that they complete before another
hot-plug operation can be done on that particular slot.

This patch introduces the slot->hotplug_lock to ensure that any
hotplug operations (add / remove) complete before another HP event
can begin processing on that particular slot.

Signed-off-by: Rajat Jain <rajatjain@juniper.net>
Signed-off-by: Guenter Roeck <groeck@juniper.net>
---
 v2: Same as v1, dropped the "RFC" from subject, added Guenter's signature

 drivers/pci/hotplug/pciehp.h      |    1 +
 drivers/pci/hotplug/pciehp_core.c |    7 ++++++-
 drivers/pci/hotplug/pciehp_ctrl.c |   17 +++++++++++++++--
 drivers/pci/hotplug/pciehp_hpc.c  |    1 +
 4 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index 353edda..33ef8e4 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -77,6 +77,7 @@ struct slot {
 	struct hotplug_slot *hotplug_slot;
 	struct delayed_work work;	/* work for button event */
 	struct mutex lock;
+	struct mutex hotplug_lock;
 	struct workqueue_struct *wq;
 };
 
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index f4a18f5..3904483 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -278,8 +278,11 @@ static int pciehp_probe(struct pcie_device *dev)
 	slot = ctrl->slot;
 	pciehp_get_adapter_status(slot, &occupied);
 	pciehp_get_power_status(slot, &poweron);
-	if (occupied && pciehp_force)
+	if (occupied && pciehp_force) {
+		mutex_lock(&slot->hotplug_lock);
 		pciehp_enable_slot(slot);
+		mutex_unlock(&slot->hotplug_lock);
+	}
 	/* If empty slot's power status is on, turn power off */
 	if (!occupied && poweron && POWER_CTRL(ctrl))
 		pciehp_power_off_slot(slot);
@@ -323,10 +326,12 @@ static int pciehp_resume (struct pcie_device *dev)
 
 	/* Check if slot is occupied */
 	pciehp_get_adapter_status(slot, &status);
+	mutex_lock(&slot->hotplug_lock);
 	if (status)
 		pciehp_enable_slot(slot);
 	else
 		pciehp_disable_slot(slot);
+	mutex_unlock(&slot->hotplug_lock);
 	return 0;
 }
 #endif /* PM */
diff --git a/drivers/pci/hotplug/pciehp_ctrl.c b/drivers/pci/hotplug/pciehp_ctrl.c
index c2cd02a..d3b1012 100644
--- a/drivers/pci/hotplug/pciehp_ctrl.c
+++ b/drivers/pci/hotplug/pciehp_ctrl.c
@@ -314,6 +314,7 @@ static void pciehp_power_thread(struct work_struct *work)
 	struct power_work_info *info =
 		container_of(work, struct power_work_info, work);
 	struct slot *p_slot = info->p_slot;
+	int ret;
 
 	switch (info->req) {
 	case DISABLE_REQ:
@@ -321,7 +322,9 @@ static void pciehp_power_thread(struct work_struct *work)
 			 "Disabling domain:bus:device=%04x:%02x:00\n",
 			 pci_domain_nr(p_slot->ctrl->pcie->port->subordinate),
 			 p_slot->ctrl->pcie->port->subordinate->number);
+		mutex_lock(&p_slot->hotplug_lock);
 		pciehp_disable_slot(p_slot);
+		mutex_unlock(&p_slot->hotplug_lock);
 		mutex_lock(&p_slot->lock);
 		p_slot->state = STATIC_STATE;
 		mutex_unlock(&p_slot->lock);
@@ -331,7 +334,10 @@ static void pciehp_power_thread(struct work_struct *work)
 			 "Enabling domain:bus:device=%04x:%02x:00\n",
 			 pci_domain_nr(p_slot->ctrl->pcie->port->subordinate),
 			 p_slot->ctrl->pcie->port->subordinate->number);
-		if (pciehp_enable_slot(p_slot) && PWR_LED(p_slot->ctrl))
+		mutex_lock(&p_slot->hotplug_lock);
+		ret = pciehp_enable_slot(p_slot);
+		mutex_unlock(&p_slot->hotplug_lock);
+		if (ret && PWR_LED(p_slot->ctrl))
 			pciehp_green_led_off(p_slot);
 		mutex_lock(&p_slot->lock);
 		p_slot->state = STATIC_STATE;
@@ -611,6 +617,9 @@ static void interrupt_event_handler(struct work_struct *work)
 	kfree(info);
 }
 
+/*
+ * Note: This function must be called with slot->hotplug_lock held
+ */
 int pciehp_enable_slot(struct slot *p_slot)
 {
 	u8 getstatus = 0;
@@ -649,7 +658,9 @@ int pciehp_enable_slot(struct slot *p_slot)
 	return rc;
 }
 
-
+/*
+ * Note: This function must be called with slot->hotplug_lock held
+ */
 int pciehp_disable_slot(struct slot *p_slot)
 {
 	u8 getstatus = 0;
@@ -692,7 +703,9 @@ int pciehp_sysfs_enable_slot(struct slot *p_slot)
 	case STATIC_STATE:
 		p_slot->state = POWERON_STATE;
 		mutex_unlock(&p_slot->lock);
+		mutex_lock(&p_slot->hotplug_lock);
 		retval = pciehp_enable_slot(p_slot);
+		mutex_unlock(&p_slot->hotplug_lock);
 		mutex_lock(&p_slot->lock);
 		p_slot->state = STATIC_STATE;
 		break;
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 1f152f3..1c014e9 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -811,6 +811,7 @@ static int pcie_init_slot(struct controller *ctrl)
 
 	slot->ctrl = ctrl;
 	mutex_init(&slot->lock);
+	mutex_init(&slot->hotplug_lock);
 	INIT_DELAYED_WORK(&slot->work, pciehp_queue_pushbutton_work);
 	ctrl->slot = slot;
 	return 0;
-- 
1.7.9.5

