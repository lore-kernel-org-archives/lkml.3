Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab3AMXx3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 18:53:29 -0500
Received: from mail-qa0-f73.google.com ([209.85.216.73]:38251 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab3AMXx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 18:53:28 -0500
X-Greylist: delayed 1069 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jan 2013 18:53:27 EST
Subject: [PATCH v7 3/4] PCI: shpchp: Handle push button event asynchronously
To: Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, Daniel J Blueman <daniel@quora.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Date: Sun, 13 Jan 2013 16:27:48 -0700
Message-ID: <20130113232748.7225.66704.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20130113232606.7225.94802.stgit@bhelgaas.mtv.corp.google.com>
References: <20130113232606.7225.94802.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/pci/hotplug/shpchp.h      |    1 -
 drivers/pci/hotplug/shpchp_core.c |   10 ----------
 drivers/pci/hotplug/shpchp_ctrl.c |    2 +-
 3 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/hotplug/shpchp.h b/drivers/pci/hotplug/shpchp.h
index ca64932..1b69d95 100644
--- a/drivers/pci/hotplug/shpchp.h
+++ b/drivers/pci/hotplug/shpchp.h
@@ -47,7 +47,6 @@ extern bool shpchp_poll_mode;
 extern int shpchp_poll_time;
 extern bool shpchp_debug;
 extern struct workqueue_struct *shpchp_wq;
-extern struct workqueue_struct *shpchp_ordered_wq;
 
 #define dbg(format, arg...)						\
 do {									\
diff --git a/drivers/pci/hotplug/shpchp_core.c b/drivers/pci/hotplug/shpchp_core.c
index 59ca86c..3774e0d 100644
--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
@@ -40,7 +40,6 @@ bool shpchp_debug;
 bool shpchp_poll_mode;
 int shpchp_poll_time;
 struct workqueue_struct *shpchp_wq;
-struct workqueue_struct *shpchp_ordered_wq;
 
 #define DRIVER_VERSION	"0.4"
 #define DRIVER_AUTHOR	"Dan Zink <dan.zink@compaq.com>, Greg Kroah-Hartman <greg@kroah.com>, Dely Sy <dely.l.sy@intel.com>"
@@ -181,7 +180,6 @@ void cleanup_slots(struct controller *ctrl)
 		list_del(&slot->slot_list);
 		cancel_delayed_work(&slot->work);
 		flush_workqueue(shpchp_wq);
-		flush_workqueue(shpchp_ordered_wq);
 		pci_hp_deregister(slot->hotplug_slot);
 	}
 }
@@ -370,17 +368,10 @@ static int __init shpcd_init(void)
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
@@ -390,7 +381,6 @@ static void __exit shpcd_cleanup(void)
 {
 	dbg("unload_shpchpd()\n");
 	pci_unregister_driver(&shpc_driver);
-	destroy_workqueue(shpchp_ordered_wq);
 	destroy_workqueue(shpchp_wq);
 	info(DRIVER_DESC " version: " DRIVER_VERSION " unloaded\n");
 }
diff --git a/drivers/pci/hotplug/shpchp_ctrl.c b/drivers/pci/hotplug/shpchp_ctrl.c
index f9b5a52..fd2cae9 100644
--- a/drivers/pci/hotplug/shpchp_ctrl.c
+++ b/drivers/pci/hotplug/shpchp_ctrl.c
@@ -453,7 +453,7 @@ void shpchp_queue_pushbutton_work(struct work_struct *work)
 		kfree(info);
 		goto out;
 	}
-	queue_work(shpchp_ordered_wq, &info->work);
+	queue_work(shpchp_wq, &info->work);
  out:
 	mutex_unlock(&p_slot->lock);
 }

