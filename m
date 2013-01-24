Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3AXVQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:16:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:40243 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756936Ab3AXVO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:14:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [ 22/46] PCI: pciehp: Use per-slot workqueues to avoid deadlock
Date: Thu, 24 Jan 2013 13:13:00 -0800
Message-Id: <20130124211144.300426989@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yijing Wang <wangyijing@huawei.com>

commit c2be6f93b383c873a4f9d521afa49b1b67d06085 upstream.

When we have a hotplug-capable PCIe port with a second hotplug-capable
PCIe port below it, removing the device below the upstream port causes
a deadlock.

The deadlock happens because we use the pciehp_wq workqueue to run
pciehp_power_thread(), which uses pciehp_disable_slot() to remove devices
below the upstream port.  When we remove the downstream PCIe port, we call
pciehp_remove(), the pciehp driver's .remove() method.  That calls
flush_workqueue(pciehp_wq), which deadlocks because the
pciehp_power_thread() work item is still running.

This patch avoids the deadlock by creating a workqueue for every PCIe port
and removing the single shared workqueue.

Here's the call path that leads to the deadlock:

  pciehp_queue_pushbutton_work
    queue_work(pciehp_wq)                   # queue pciehp_power_thread
    ...

  pciehp_power_thread
    pciehp_disable_slot
      remove_board
	pciehp_unconfigure_device
	  pci_stop_and_remove_bus_device
	    ...
	      pciehp_remove                 # pciehp driver .remove method
		pciehp_release_ctrl
		  pcie_cleanup_slot
		    flush_workqueue(pciehp_wq)

This is fairly urgent because it can be caused by simply unplugging a
Thunderbolt adapter, as reported by Daniel below.

[bhelgaas: changelog]
Reference: http://lkml.kernel.org/r/CAMVG2ssiRgcTD1bej2tkUUfsWmpL5eNtPcNif9va2-Gzb2u8nQ@mail.gmail.com
Reported-and-tested-by: Daniel J Blueman <daniel@quora.org>
Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/hotplug/pciehp.h      |    2 +-
 drivers/pci/hotplug/pciehp_core.c |   11 ++---------
 drivers/pci/hotplug/pciehp_ctrl.c |    8 ++++----
 drivers/pci/hotplug/pciehp_hpc.c  |   11 ++++++++++-
 4 files changed, 17 insertions(+), 15 deletions(-)

--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -44,7 +44,6 @@ extern bool pciehp_poll_mode;
 extern int pciehp_poll_time;
 extern bool pciehp_debug;
 extern bool pciehp_force;
-extern struct workqueue_struct *pciehp_wq;
 
 #define dbg(format, arg...)						\
 do {									\
@@ -78,6 +77,7 @@ struct slot {
 	struct hotplug_slot *hotplug_slot;
 	struct delayed_work work;	/* work for button event */
 	struct mutex lock;
+	struct workqueue_struct *wq;
 };
 
 struct event_info {
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -42,7 +42,6 @@ bool pciehp_debug;
 bool pciehp_poll_mode;
 int pciehp_poll_time;
 bool pciehp_force;
-struct workqueue_struct *pciehp_wq;
 
 #define DRIVER_VERSION	"0.4"
 #define DRIVER_AUTHOR	"Dan Zink <dan.zink@compaq.com>, Greg Kroah-Hartman <greg@kroah.com>, Dely Sy <dely.l.sy@intel.com>"
@@ -340,18 +339,13 @@ static int __init pcied_init(void)
 {
 	int retval = 0;
 
-	pciehp_wq = alloc_workqueue("pciehp", 0, 0);
-	if (!pciehp_wq)
-		return -ENOMEM;
-
 	pciehp_firmware_init();
 	retval = pcie_port_service_register(&hpdriver_portdrv);
  	dbg("pcie_port_service_register = %d\n", retval);
   	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
- 	if (retval) {
-		destroy_workqueue(pciehp_wq);
+	if (retval)
 		dbg("Failure to register service\n");
-	}
+
 	return retval;
 }
 
@@ -359,7 +353,6 @@ static void __exit pcied_cleanup(void)
 {
 	dbg("unload_pciehpd()\n");
 	pcie_port_service_unregister(&hpdriver_portdrv);
-	destroy_workqueue(pciehp_wq);
 	info(DRIVER_DESC " version: " DRIVER_VERSION " unloaded\n");
 }
 
--- a/drivers/pci/hotplug/pciehp_ctrl.c
+++ b/drivers/pci/hotplug/pciehp_ctrl.c
@@ -49,7 +49,7 @@ static int queue_interrupt_event(struct
 	info->p_slot = p_slot;
 	INIT_WORK(&info->work, interrupt_event_handler);
 
-	queue_work(pciehp_wq, &info->work);
+	queue_work(p_slot->wq, &info->work);
 
 	return 0;
 }
@@ -344,7 +344,7 @@ void pciehp_queue_pushbutton_work(struct
 		kfree(info);
 		goto out;
 	}
-	queue_work(pciehp_wq, &info->work);
+	queue_work(p_slot->wq, &info->work);
  out:
 	mutex_unlock(&p_slot->lock);
 }
@@ -377,7 +377,7 @@ static void handle_button_press_event(st
 		if (ATTN_LED(ctrl))
 			pciehp_set_attention_status(p_slot, 0);
 
-		queue_delayed_work(pciehp_wq, &p_slot->work, 5*HZ);
+		queue_delayed_work(p_slot->wq, &p_slot->work, 5*HZ);
 		break;
 	case BLINKINGOFF_STATE:
 	case BLINKINGON_STATE:
@@ -439,7 +439,7 @@ static void handle_surprise_event(struct
 	else
 		p_slot->state = POWERON_STATE;
 
-	queue_work(pciehp_wq, &info->work);
+	queue_work(p_slot->wq, &info->work);
 }
 
 static void interrupt_event_handler(struct work_struct *work)
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -773,23 +773,32 @@ static void pcie_shutdown_notification(s
 static int pcie_init_slot(struct controller *ctrl)
 {
 	struct slot *slot;
+	char name[32];
 
 	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
 	if (!slot)
 		return -ENOMEM;
 
+	snprintf(name, sizeof(name), "pciehp-%u", PSN(ctrl));
+	slot->wq = alloc_workqueue(name, 0, 0);
+	if (!slot->wq)
+		goto abort;
+
 	slot->ctrl = ctrl;
 	mutex_init(&slot->lock);
 	INIT_DELAYED_WORK(&slot->work, pciehp_queue_pushbutton_work);
 	ctrl->slot = slot;
 	return 0;
+abort:
+	kfree(slot);
+	return -ENOMEM;
 }
 
 static void pcie_cleanup_slot(struct controller *ctrl)
 {
 	struct slot *slot = ctrl->slot;
 	cancel_delayed_work(&slot->work);
-	flush_workqueue(pciehp_wq);
+	destroy_workqueue(slot->wq);
 	kfree(slot);
 }
 


