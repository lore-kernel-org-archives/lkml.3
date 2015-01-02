Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbbABA1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 19:27:34 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45719 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbbABA1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 19:27:32 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Sasha Levin <sasha.levin@oracle.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org (open list:PCI SUBSYSTEM)
Subject: [PATCH] PCI/sysfs: off by two and memory corruption in driver_override parameter
Date: Thu,  1 Jan 2015 19:27:12 -0500
Message-Id: <1420158432-645-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two different issues fixed here:

 - On nun-NULL terminated input a random byte of memory would get flipped
from '\n' to '\0'.
 - When printing the driver_override parameter when it is 4095 and 4094 bytes
long the printing code would access invalid memory.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/pci/pci-sysfs.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index aa012fb..be6b2b1 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -521,17 +521,17 @@ static ssize_t driver_override_store(struct device *dev,
 	struct pci_dev *pdev = to_pci_dev(dev);
 	char *driver_override, *old = pdev->driver_override, *cp;
 
-	if (count > PATH_MAX)
+	/* We need to keep extra room for a newline */
+	if (count >= (PATH_MAX - 1))
 		return -EINVAL;
 
 	driver_override = kstrndup(buf, count, GFP_KERNEL);
 	if (!driver_override)
 		return -ENOMEM;
 
-	cp = strchr(driver_override, '\n');
-	if (cp)
-		*cp = '\0';
-
+	driver_override[count] = '\0';
+	if (driver_override[count - 1] == '\n')
+		driver_override[count - 1] = 0;
 	if (strlen(driver_override)) {
 		pdev->driver_override = driver_override;
 	} else {
-- 
1.7.10.4

