Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbaBKTo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:44:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbaBKTHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 3.10 06/79] Revert "EISA: Initialize device before its resources"
Date: Tue, 11 Feb 2014 11:05:10 -0800
Message-Id: <20140211184721.118086153@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184720.928667275@linuxfoundation.org>
References: <20140211184720.928667275@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/eisa/eisa-bus.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

--- a/drivers/eisa/eisa-bus.c
+++ b/drivers/eisa/eisa-bus.c
@@ -275,11 +275,13 @@ static int __init eisa_request_resources
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
@@ -326,19 +328,20 @@ static int __init eisa_probe(struct eisa
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
 
@@ -361,11 +364,6 @@ static int __init eisa_probe(struct eisa
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
@@ -373,6 +371,12 @@ static int __init eisa_probe(struct eisa
 			kfree(edev);
 			continue;
 		}
+
+		if (eisa_init_device(root, edev, i)) {
+			eisa_release_resources(edev);
+			kfree(edev);
+			continue;
+		}
 
 		if (edev->state == (EISA_CONFIG_ENABLED | EISA_CONFIG_FORCED))
 			enabled_str = " (forced enabled)";


