Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbaBGM2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:28:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42094 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaBGLvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:01 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 143/233] Revert "EISA: Initialize device before its resources"
Date: Fri,  7 Feb 2014 11:46:02 +0000
Message-Id: <1391773652-25214-144-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit 765ee51f9a3f652959b4c7297d198a28e37952b4 upstream.

This reverts commit 26abfeed4341872364386c6a52b9acef8c81a81a.

In the eisa_probe() force_probe path, if we were unable to request slot
resources (e.g., [io 0x800-0x8ff]), we skipped the slot with "Cannot
allocate resource for EISA slot %d" before reading the EISA signature in
eisa_init_device().

Commit 26abfeed4341 moved eisa_init_device() earlier, so we tried to read
the EISA signature before requesting the slot resources, and this caused
hangs during boot.

Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1251816
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/eisa/eisa-bus.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/eisa/eisa-bus.c b/drivers/eisa/eisa-bus.c
index 272a3ec..0314dde 100644
--- a/drivers/eisa/eisa-bus.c
+++ b/drivers/eisa/eisa-bus.c
@@ -275,11 +275,13 @@ static int __init eisa_request_resources(struct eisa_root_device *root,
 		}
 		
 		if (slot) {
+			edev->res[i].name  = NULL;
 			edev->res[i].start = SLOT_ADDRESS(root, slot)
 					     + (i * 0x400);
 			edev->res[i].end   = edev->res[i].start + 0xff;
 			edev->res[i].flags = IORESOURCE_IO;
 		} else {
+			edev->res[i].name  = NULL;
 			edev->res[i].start = SLOT_ADDRESS(root, slot)
 					     + EISA_VENDOR_ID_OFFSET;
 			edev->res[i].end   = edev->res[i].start + 3;
@@ -326,19 +328,20 @@ static int __init eisa_probe(struct eisa_root_device *root)
 		return -ENOMEM;
 	}
 		
-	if (eisa_init_device(root, edev, 0)) {
+	if (eisa_request_resources(root, edev, 0)) {
+		dev_warn(root->dev,
+		         "EISA: Cannot allocate resource for mainboard\n");
 		kfree(edev);
 		if (!root->force_probe)
-			return -ENODEV;
+			return -EBUSY;
 		goto force_probe;
 	}
 
-	if (eisa_request_resources(root, edev, 0)) {
-		dev_warn(root->dev,
-		         "EISA: Cannot allocate resource for mainboard\n");
+	if (eisa_init_device(root, edev, 0)) {
+		eisa_release_resources(edev);
 		kfree(edev);
 		if (!root->force_probe)
-			return -EBUSY;
+			return -ENODEV;
 		goto force_probe;
 	}
 
@@ -361,11 +364,6 @@ static int __init eisa_probe(struct eisa_root_device *root)
 			continue;
 		}
 
-		if (eisa_init_device(root, edev, i)) {
-			kfree(edev);
-			continue;
-		}
-
 		if (eisa_request_resources(root, edev, i)) {
 			dev_warn(root->dev,
 			         "Cannot allocate resource for EISA slot %d\n",
@@ -374,6 +372,12 @@ static int __init eisa_probe(struct eisa_root_device *root)
 			continue;
 		}
 
+		if (eisa_init_device(root, edev, i)) {
+			eisa_release_resources(edev);
+			kfree(edev);
+			continue;
+		}
+
 		if (edev->state == (EISA_CONFIG_ENABLED | EISA_CONFIG_FORCED))
 			enabled_str = " (forced enabled)";
 		else if (edev->state == EISA_CONFIG_FORCED)
-- 
1.8.3.2

