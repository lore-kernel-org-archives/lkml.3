Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab3AMXfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 18:35:50 -0500
Received: from mail-wg0-f74.google.com ([74.125.82.74]:43866 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab3AMXft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 18:35:49 -0500
Subject: [PATCH v7 1/4] PCI: pciehp: Use per-slot workqueues to avoid deadlock
To: Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel J Blueman <daniel@quora.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Date: Sun, 13 Jan 2013 16:27:37 -0700
Message-ID: <20130113232737.7225.97136.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20130113232606.7225.94802.stgit@bhelgaas.mtv.corp.google.com>
References: <20130113232606.7225.94802.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yijing Wang <wangyijing@huawei.com>

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
CC: stable@vger.kernel.org
---
 drivers/pci/hotplug/pciehp.h      |    2 +-
 drivers/pci/hotplug/pciehp_core.c |   11 ++---------
 drivers/pci/hotplug/pciehp_ctrl.c |    8 ++++----
 drivers/pci/hotplug/pciehp_hpc.c  |   11 ++++++++++-
 4 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index 26ffd3e..2c113de 100644
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
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 916bf4f..939bd1d 100644
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
 
diff --git a/drivers/pci/hotplug/pciehp_ctrl.c b/drivers/pci/hotplug/pciehp_ctrl.c
index 27f4429..38f0186 100644
--- a/drivers/pci/hotplug/pciehp_ctrl.c
+++ b/drivers/pci/hotplug/pciehp_ctrl.c
@@ -49,7 +49,7 @@ static int queue_interrupt_event(struct slot *p_slot, u32 event_type)
 	info->p_slot = p_slot;
 	INIT_WORK(&info->work, interrupt_event_handler);
 
-	queue_work(pciehp_wq, &info->work);
+	queue_work(p_slot->wq, &info->work);
 
 	return 0;
 }
@@ -344,7 +344,7 @@ void pciehp_queue_pushbutton_work(struct work_struct *work)
 		kfree(info);
 		goto out;
 	}
-	queue_work(pciehp_wq, &info->work);
+	queue_work(p_slot->wq, &info->work);
  out:
 	mutex_unlock(&p_slot->lock);
 }
@@ -377,7 +377,7 @@ static void handle_button_press_event(struct slot *p_slot)
 		if (ATTN_LED(ctrl))
 			pciehp_set_attention_status(p_slot, 0);
 
-		queue_delayed_work(pciehp_wq, &p_slot->work, 5*HZ);
+		queue_delayed_work(p_slot->wq, &p_slot->work, 5*HZ);
 		break;
 	case BLINKINGOFF_STATE:
 	case BLINKINGON_STATE:
@@ -439,7 +439,7 @@ static void handle_surprise_event(struct slot *p_slot)
 	else
 		p_slot->state = POWERON_STATE;
 
-	queue_work(pciehp_wq, &info->work);
+	queue_work(p_slot->wq, &info->work);
 }
 
 static void interrupt_event_handler(struct work_struct *work)
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 13b2eaf..5127f3f 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -773,23 +773,32 @@ static void pcie_shutdown_notification(struct controller *ctrl)
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
 

