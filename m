Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaAROf5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 09:35:57 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34667 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbaAROfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 09:35:24 -0500
Subject: [PATCH 2/2] Revert "EISA: Initialize device before its resources"
To: linux-kernel@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org,
        Joseph Salisbury <joseph.salisbury@canonical.com>
Date: Sat, 18 Jan 2014 07:35:23 -0700
Message-ID: <20140118143523.32751.41079.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140118143308.32751.27410.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140118143308.32751.27410.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
CC: stable@vger.kernel.org	# v3.10+ a2080d0c561c: Revert "EISA: Log device resources in dmesg"
---
 drivers/eisa/eisa-bus.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/eisa/eisa-bus.c b/drivers/eisa/eisa-bus.c
index 1b86fe0c2e80..612afeaec3cb 100644
--- a/drivers/eisa/eisa-bus.c
+++ b/drivers/eisa/eisa-bus.c
@@ -277,11 +277,13 @@ static int __init eisa_request_resources(struct eisa_root_device *root,
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
@@ -327,19 +329,20 @@ static int __init eisa_probe(struct eisa_root_device *root)
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
 
@@ -362,11 +365,6 @@ static int __init eisa_probe(struct eisa_root_device *root)
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
@@ -375,6 +373,12 @@ static int __init eisa_probe(struct eisa_root_device *root)
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

