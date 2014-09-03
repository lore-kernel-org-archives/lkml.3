Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934938AbaICXGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:06:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933773AbaICWSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guo Chao <yan@linux.vnet.ibm.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 3.16 068/125] PCI: Keep original resource if we fail to expand it
Date: Wed,  3 Sep 2014 15:07:05 -0700
Message-Id: <20140903220625.722313252@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guo Chao <yan@linux.vnet.ibm.com>

commit c33377082dd9ede1e998f7ce416077e4b1c2276c upstream.

If we have space assigned to a resource, we try to expand the resource
(e.g., to accommodate SR-IOV resources), and the expansion attempt fails,
we should keep the original assignment.

After bd064f0a231a ("PCI: Mark resources as IORESOURCE_UNSET if we can't
assign them"), we left the resource marked IORESOURCE_UNSET when the
expansion failed, even if it had originally been set.  That caused errors
like this:

  pci 0003:00:00.0: can't enable device: BAR 15 [mem size 0x0c000000 64bit pref] not assigned
  pci 0003:00:00.0: Error enabling bridge (-22), continuing

Fix this by restoring the original flags when reassignment fails.

[bhelgaas: reworked to simplify, changelog]
Fixes: bd064f0a231a ("PCI: Mark resources as IORESOURCE_UNSET if we can't assign them")
Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/setup-res.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -320,9 +320,11 @@ int pci_reassign_resource(struct pci_dev
 			resource_size_t min_align)
 {
 	struct resource *res = dev->resource + resno;
+	unsigned long flags;
 	resource_size_t new_size;
 	int ret;
 
+	flags = res->flags;
 	res->flags |= IORESOURCE_UNSET;
 	if (!res->parent) {
 		dev_info(&dev->dev, "BAR %d: can't reassign an unassigned resource %pR\n",
@@ -339,7 +341,12 @@ int pci_reassign_resource(struct pci_dev
 		dev_info(&dev->dev, "BAR %d: reassigned %pR\n", resno, res);
 		if (resno < PCI_BRIDGE_RESOURCES)
 			pci_update_resource(dev, resno);
+	} else {
+		res->flags = flags;
+		dev_info(&dev->dev, "BAR %d: %pR (failed to expand by %#llx)\n",
+			 resno, res, (unsigned long long) addsize);
 	}
+
 	return ret;
 }
 


