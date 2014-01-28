Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbaA1XWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:22:11 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:44291 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbaA1XWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:22:07 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com,
        Tejun Heo <tj@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH 08/11] pci: use device_remove_file_self() instead of device_schedule_callback()
Date: Tue, 28 Jan 2014 18:21:48 -0500
Message-Id: <1390951311-15325-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390951311-15325-1-git-send-email-tj@kernel.org>
References: <1390951311-15325-1-git-send-email-tj@kernel.org>
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
 drivers/pci/pci-sysfs.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 276ef9c..4e0acef 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -351,28 +351,17 @@ static struct device_attribute dev_rescan_attr = __ATTR(rescan,
 							(S_IWUSR|S_IWGRP),
 							NULL, dev_rescan_store);
 
-static void remove_callback(struct device *dev)
-{
-	pci_stop_and_remove_bus_device_locked(to_pci_dev(dev));
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
+	if (val && device_remove_file_self(dev, attr))
+		pci_stop_and_remove_bus_device_locked(to_pci_dev(dev));
 	return count;
 }
 static struct device_attribute dev_remove_attr = __ATTR(remove,
-- 
1.8.5.3

