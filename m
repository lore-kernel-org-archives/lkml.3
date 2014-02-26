Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaBZTh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:37:56 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:59859 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaBZThx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:37:53 -0500
Subject: [PATCH 7/9] PCI: Don't try to claim IORESOURCE_UNSET resources
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2014 12:37:51 -0700
Message-ID: <20140226193751.10125.5434.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the IORESOURCE_UNSET bit is set, it means we haven't assigned an address
yet, so don't try to claim the region.

Also, make the error messages more uniform and add info about which BAR is
involved.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/setup-res.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 7f7652176fc5..6e443135ba24 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -111,18 +111,23 @@ int pci_claim_resource(struct pci_dev *dev, int resource)
 	struct resource *res = &dev->resource[resource];
 	struct resource *root, *conflict;
 
+	if (res->flags & IORESOURCE_UNSET) {
+		dev_info(&dev->dev, "can't claim BAR %d %pR: no address assigned\n",
+			 resource, res);
+		return -EINVAL;
+	}
+
 	root = pci_find_parent_resource(dev, res);
 	if (!root) {
-		dev_info(&dev->dev, "no compatible bridge window for %pR\n",
-			 res);
+		dev_info(&dev->dev, "can't claim BAR %d %pR: no compatible bridge window\n",
+			 resource, res);
 		return -EINVAL;
 	}
 
 	conflict = request_resource_conflict(root, res);
 	if (conflict) {
-		dev_info(&dev->dev,
-			 "address space collision: %pR conflicts with %s %pR\n",
-			 res, conflict->name, conflict);
+		dev_info(&dev->dev, "can't claim BAR %d %pR: address conflict with %s %pR\n",
+			 resource, res, conflict->name, conflict);
 		return -EBUSY;
 	}
 

