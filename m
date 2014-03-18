Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251AbaCRUx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:53:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:18752 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932748AbaCRUxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:53:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,680,1389772800"; 
   d="scan'208";a="475172513"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc-next 11/13] mei: me: use runtime PG pm domain for non wakeable devices
Date: Tue, 18 Mar 2014 22:52:05 +0200
Message-Id: <1395175927-10562-12-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
References: <1395175927-10562-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For non wakeable devices we can't use pci runtime framework
as we are not able to wakeup from D3 states.
Instead we create new pg runtime domain that only drives ME power
gating protocol to reduce the power consumption.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/misc/mei/mei_dev.h |  3 +++
 drivers/misc/mei/pci-me.c  | 50 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index fe76e5b..beff9ef 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -419,6 +419,9 @@ struct mei_device {
 	 * Power Gating support
 	 */
 	enum mei_pg_event pg_event;
+#ifdef CONFIG_PM_RUNTIME
+	struct dev_pm_domain pg_domain;
+#endif /* CONFIG_PM_RUNTIME */
 
 	unsigned char rd_msg_buf[MEI_RD_MSG_BUF_SIZE];	/* control messages */
 	u32 rd_msg_hdr;
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 967f2f2..bc3e043 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -87,6 +87,14 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, mei_me_pci_tbl);
 
+#ifdef CONFIG_PM_RUNTIME
+static inline void mei_me_set_pm_domain(struct mei_device *dev);
+static inline void mei_me_unset_pm_domain(struct mei_device *dev);
+#else
+static inline void mei_me_set_pm_domain(struct mei_device *dev) {}
+static inline void mei_me_unset_pm_domain(struct mei_device *dev) {}
+#endif /* CONFIG_PM_RUNTIME */
+
 /**
  * mei_quirk_probe - probe for devices that doesn't valid ME interface
  *
@@ -209,6 +217,14 @@ static int mei_me_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	schedule_delayed_work(&dev->timer_work, HZ);
 
+	/*
+	* For not wake-able HW runtime pm framework
+	* can't be used on pci device level.
+	* Use domain runtime pm callbacks instead.
+	*/
+	if (!pci_dev_run_wake(pdev))
+		mei_me_set_pm_domain(dev);
+
 	if (mei_pg_is_enabled(dev))
 		pm_runtime_put_noidle(&pdev->dev);
 
@@ -260,6 +276,9 @@ static void mei_me_remove(struct pci_dev *pdev)
 	dev_dbg(&pdev->dev, "stop\n");
 	mei_stop(dev);
 
+	if (!pci_dev_run_wake(pdev))
+		mei_me_unset_pm_domain(dev);
+
 	/* disable interrupts */
 	mei_disable_interrupts(dev);
 
@@ -405,6 +424,37 @@ static int mei_me_pm_runtime_resume(struct device *device)
 
 	return ret;
 }
+
+/**
+ * mei_me_set_pm_domain - fill and set pm domian stucture for device
+ *
+ * @dev: mei_device
+ */
+static inline void mei_me_set_pm_domain(struct mei_device *dev)
+{
+	struct pci_dev *pdev  = dev->pdev;
+
+	if (pdev->dev.bus && pdev->dev.bus->pm) {
+		dev->pg_domain.ops = *pdev->dev.bus->pm;
+
+		dev->pg_domain.ops.runtime_suspend = mei_me_pm_runtime_suspend;
+		dev->pg_domain.ops.runtime_resume = mei_me_pm_runtime_resume;
+		dev->pg_domain.ops.runtime_idle = mei_me_pm_runtime_idle;
+
+		pdev->dev.pm_domain = &dev->pg_domain;
+	}
+}
+
+/**
+ * mei_me_unset_pm_domain - clean pm domian stucture for device
+ *
+ * @dev: mei_device
+ */
+static inline void mei_me_unset_pm_domain(struct mei_device *dev)
+{
+	/* stop using pm callbacks if any */
+	dev->pdev->dev.pm_domain = NULL;
+}
 #endif /* CONFIG_PM_RUNTIME */
 
 #ifdef CONFIG_PM
-- 
1.8.5.3

