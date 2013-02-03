Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3BCO4H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:56:07 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34274 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754092Ab3BCO4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:56:03 -0500
Message-Id: <20130203144648.493915164@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:34 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Bjorn Helgaas <bhelgaas@google.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: [ 050/128] PCI: shpchp: Handle push button event asynchronously
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit d347e75847c1fb299c97736638f45e6ea39702d4 upstream.

Use non-ordered workqueue for attention button events.

Attention button events on each slot can be handled asynchronously. So
we should use non-ordered workqueue. This patch also removes ordered
workqueue in shpchp as a result.

486b10b9f4 ("PCI: pciehp: Handle push button event asynchronously") made
the same change to pciehp.  I split this out from a patch by Yijing Wang
<wangyijing@huawei.com> so we fix one thing at a time and to make the
shpchp history correspond more closely with the pciehp history.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/hotplug/shpchp.h      |    1 -
 drivers/pci/hotplug/shpchp_core.c |   10 ----------
 drivers/pci/hotplug/shpchp_ctrl.c |    2 +-
 3 files changed, 1 insertion(+), 12 deletions(-)

--- a/drivers/pci/hotplug/shpchp.h
+++ b/drivers/pci/hotplug/shpchp.h
@@ -47,7 +47,6 @@ extern int shpchp_poll_mode;
 extern int shpchp_poll_time;
 extern int shpchp_debug;
 extern struct workqueue_struct *shpchp_wq;
-extern struct workqueue_struct *shpchp_ordered_wq;
 
 #define dbg(format, arg...)						\
 do {									\
--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
@@ -40,7 +40,6 @@ int shpchp_debug;
 int shpchp_poll_mode;
 int shpchp_poll_time;
 struct workqueue_struct *shpchp_wq;
-struct workqueue_struct *shpchp_ordered_wq;
 
 #define DRIVER_VERSION	"0.4"
 #define DRIVER_AUTHOR	"Dan Zink <dan.zink@compaq.com>, Greg Kroah-Hartman <greg@kroah.com>, Dely Sy <dely.l.sy@intel.com>"
@@ -175,7 +174,6 @@ void cleanup_slots(struct controller *ct
 		list_del(&slot->slot_list);
 		cancel_delayed_work(&slot->work);
 		flush_workqueue(shpchp_wq);
-		flush_workqueue(shpchp_ordered_wq);
 		pci_hp_deregister(slot->hotplug_slot);
 	}
 }
@@ -364,17 +362,10 @@ static int __init shpcd_init(void)
 	if (!shpchp_wq)
 		return -ENOMEM;
 
-	shpchp_ordered_wq = alloc_ordered_workqueue("shpchp_ordered", 0);
-	if (!shpchp_ordered_wq) {
-		destroy_workqueue(shpchp_wq);
-		return -ENOMEM;
-	}
-
 	retval = pci_register_driver(&shpc_driver);
 	dbg("%s: pci_register_driver = %d\n", __func__, retval);
 	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 	if (retval) {
-		destroy_workqueue(shpchp_ordered_wq);
 		destroy_workqueue(shpchp_wq);
 	}
 	return retval;
@@ -384,7 +375,6 @@ static void __exit shpcd_cleanup(void)
 {
 	dbg("unload_shpchpd()\n");
 	pci_unregister_driver(&shpc_driver);
-	destroy_workqueue(shpchp_ordered_wq);
 	destroy_workqueue(shpchp_wq);
 	info(DRIVER_DESC " version: " DRIVER_VERSION " unloaded\n");
 }
--- a/drivers/pci/hotplug/shpchp_ctrl.c
+++ b/drivers/pci/hotplug/shpchp_ctrl.c
@@ -456,7 +456,7 @@ void shpchp_queue_pushbutton_work(struct
 		kfree(info);
 		goto out;
 	}
-	queue_work(shpchp_ordered_wq, &info->work);
+	queue_work(shpchp_wq, &info->work);
  out:
 	mutex_unlock(&p_slot->lock);
 }


