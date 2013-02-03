Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab3BCO4A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:56:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34255 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462Ab3BCOzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:54 -0500
Message-Id: <20130203144648.154874497@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [ 046/128] PCI: pciehp: Handle push button event asynchronously
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

commit 486b10b9f43500741cd63a878d0ef23cd87fc66d upstream.

Use non-ordered workqueue for attention button events.

Attention button events on each slot can be handled asynchronously. So
we should use non-ordered workqueue. This patch also removes ordered
workqueue in pciehp as a result.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/hotplug/pciehp.h      |    1 -
 drivers/pci/hotplug/pciehp_core.c |    9 ---------
 drivers/pci/hotplug/pciehp_ctrl.c |    4 ++--
 drivers/pci/hotplug/pciehp_hpc.c  |    1 -
 4 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index 838f571..9a33fdd 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -45,7 +45,6 @@ extern int pciehp_poll_time;
 extern int pciehp_debug;
 extern int pciehp_force;
 extern struct workqueue_struct *pciehp_wq;
-extern struct workqueue_struct *pciehp_ordered_wq;
 
 #define dbg(format, arg...)						\
 do {									\
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index a13ad13..b8c99d3 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -43,7 +43,6 @@ int pciehp_poll_mode;
 int pciehp_poll_time;
 int pciehp_force;
 struct workqueue_struct *pciehp_wq;
-struct workqueue_struct *pciehp_ordered_wq;
 
 #define DRIVER_VERSION	"0.4"
 #define DRIVER_AUTHOR	"Dan Zink <dan.zink@compaq.com>, Greg Kroah-Hartman <greg@kroah.com>, Dely Sy <dely.l.sy@intel.com>"
@@ -345,18 +344,11 @@ static int __init pcied_init(void)
 	if (!pciehp_wq)
 		return -ENOMEM;
 
-	pciehp_ordered_wq = alloc_ordered_workqueue("pciehp_ordered", 0);
-	if (!pciehp_ordered_wq) {
-		destroy_workqueue(pciehp_wq);
-		return -ENOMEM;
-	}
-
 	pciehp_firmware_init();
 	retval = pcie_port_service_register(&hpdriver_portdrv);
  	dbg("pcie_port_service_register = %d\n", retval);
   	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
  	if (retval) {
-		destroy_workqueue(pciehp_ordered_wq);
 		destroy_workqueue(pciehp_wq);
 		dbg("Failure to register service\n");
 	}
@@ -367,7 +359,6 @@ static void __exit pcied_cleanup(void)
 {
 	dbg("unload_pciehpd()\n");
 	pcie_port_service_unregister(&hpdriver_portdrv);
-	destroy_workqueue(pciehp_ordered_wq);
 	destroy_workqueue(pciehp_wq);
 	info(DRIVER_DESC " version: " DRIVER_VERSION " unloaded\n");
 }
diff --git a/drivers/pci/hotplug/pciehp_ctrl.c b/drivers/pci/hotplug/pciehp_ctrl.c
index 085dbb5..27f4429 100644
--- a/drivers/pci/hotplug/pciehp_ctrl.c
+++ b/drivers/pci/hotplug/pciehp_ctrl.c
@@ -344,7 +344,7 @@ void pciehp_queue_pushbutton_work(struct work_struct *work)
 		kfree(info);
 		goto out;
 	}
-	queue_work(pciehp_ordered_wq, &info->work);
+	queue_work(pciehp_wq, &info->work);
  out:
 	mutex_unlock(&p_slot->lock);
 }
@@ -439,7 +439,7 @@ static void handle_surprise_event(struct slot *p_slot)
 	else
 		p_slot->state = POWERON_STATE;
 
-	queue_work(pciehp_ordered_wq, &info->work);
+	queue_work(pciehp_wq, &info->work);
 }
 
 static void interrupt_event_handler(struct work_struct *work)
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 7b14148..bcdbb16 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -806,7 +806,6 @@ static void pcie_cleanup_slot(struct controller *ctrl)
 	struct slot *slot = ctrl->slot;
 	cancel_delayed_work(&slot->work);
 	flush_workqueue(pciehp_wq);
-	flush_workqueue(pciehp_ordered_wq);
 	kfree(slot);
 }
 


