Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaCKRnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:43:46 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:46274 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbaCKRnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:43:13 -0400
Subject: [PATCH 5/5] PCI: Log IDE resource quirk in dmesg
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 11 Mar 2014 11:43:12 -0600
Message-ID: <20140311174311.23084.15128.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140311173556.23084.57635.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140311173556.23084.57635.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make a note in dmesg when we overwrite legacy IDE BAR info.  We previously
logged something like this:

  pci 0000:00:1f.1: reg 0x10: [io  0x0000-0x0007]

and then silently overwrote the resource.  There's an example in the
bugzilla below.  This doesn't fix the bugzilla; it just makes what's going
on more obvious.

No functional change; merely adds some dev_info() calls.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=48451
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/probe.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 02654b5ec1b9..6c69c9bb31fb 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1131,10 +1131,10 @@ int pci_setup_device(struct pci_dev *dev)
 		pci_read_config_word(dev, PCI_SUBSYSTEM_ID, &dev->subsystem_device);
 
 		/*
-		 *	Do the ugly legacy mode stuff here rather than broken chip
-		 *	quirk code. Legacy mode ATA controllers have fixed
-		 *	addresses. These are not always echoed in BAR0-3, and
-		 *	BAR0-3 in a few cases contain junk!
+		 * Do the ugly legacy mode stuff here rather than broken chip
+		 * quirk code. Legacy mode ATA controllers have fixed
+		 * addresses. These are not always echoed in BAR0-3, and
+		 * BAR0-3 in a few cases contain junk!
 		 */
 		if (class == PCI_CLASS_STORAGE_IDE) {
 			u8 progif;
@@ -1145,11 +1145,15 @@ int pci_setup_device(struct pci_dev *dev)
 				res = &dev->resource[0];
 				res->flags = LEGACY_IO_RESOURCE;
 				pcibios_bus_to_resource(dev->bus, res, &region);
+				dev_info(&dev->dev, "legacy IDE quirk: reg 0x10: %pR\n",
+					 res);
 				region.start = 0x3F6;
 				region.end = 0x3F6;
 				res = &dev->resource[1];
 				res->flags = LEGACY_IO_RESOURCE;
 				pcibios_bus_to_resource(dev->bus, res, &region);
+				dev_info(&dev->dev, "legacy IDE quirk: reg 0x14: %pR\n",
+					 res);
 			}
 			if ((progif & 4) == 0) {
 				region.start = 0x170;
@@ -1157,11 +1161,15 @@ int pci_setup_device(struct pci_dev *dev)
 				res = &dev->resource[2];
 				res->flags = LEGACY_IO_RESOURCE;
 				pcibios_bus_to_resource(dev->bus, res, &region);
+				dev_info(&dev->dev, "legacy IDE quirk: reg 0x18: %pR\n",
+					 res);
 				region.start = 0x376;
 				region.end = 0x376;
 				res = &dev->resource[3];
 				res->flags = LEGACY_IO_RESOURCE;
 				pcibios_bus_to_resource(dev->bus, res, &region);
+				dev_info(&dev->dev, "legacy IDE quirk: reg 0x1c: %pR\n",
+					 res);
 			}
 		}
 		break;

