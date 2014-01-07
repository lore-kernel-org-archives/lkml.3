Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaAGSAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:00:44 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:65314 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbaAGSAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:00:18 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com,
        Tejun Heo <tj@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH 09/12] pci: use device_remove_file_self() instead of device_schedule_callback()
Date: Tue,  7 Jan 2014 12:59:47 -0500
Message-Id: <1389117590-25705-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389117590-25705-1-git-send-email-tj@kernel.org>
References: <1389117590-25705-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

driver-core now supports synchrnous self-deletion of attributes and
the asynchrnous removal mechanism is scheduled for removal.  Use it
instead of device_schedule_callback().  This makes "remove" behave
synchronously.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/pci-sysfs.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index c91e6c1..94d1cb8 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -352,32 +352,20 @@ static struct device_attribute dev_rescan_attr = __ATTR(rescan,
 							(S_IWUSR|S_IWGRP),
 							NULL, dev_rescan_store);
 
-static void remove_callback(struct device *dev)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-
-	mutex_lock(&pci_remove_rescan_mutex);
-	pci_stop_and_remove_bus_device(pdev);
-	mutex_unlock(&pci_remove_rescan_mutex);
-}
-
 static ssize_t
-remove_store(struct device *dev, struct device_attribute *dummy,
+remove_store(struct device *dev, struct device_attribute *attr,
 	     const char *buf, size_t count)
 {
-	int ret = 0;
 	unsigned long val;
 
 	if (kstrtoul(buf, 0, &val) < 0)
 		return -EINVAL;
 
-	/* An attribute cannot be unregistered by one of its own methods,
-	 * so we have to use this roundabout approach.
-	 */
-	if (val)
-		ret = device_schedule_callback(dev, remove_callback);
-	if (ret)
-		count = ret;
+	if (val && device_remove_file_self(dev, attr)) {
+		mutex_lock(&pci_remove_rescan_mutex);
+		pci_stop_and_remove_bus_device(to_pci_dev(dev));
+		mutex_unlock(&pci_remove_rescan_mutex);
+	}
 	return count;
 }
 static struct device_attribute dev_remove_attr = __ATTR(remove,
-- 
1.8.4.2

