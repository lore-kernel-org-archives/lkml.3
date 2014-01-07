Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbaAGAzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:55:39 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:64739 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744AbaAGAzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 19:55:36 -0500
Subject: [PATCH v7 03/15] PCI: Add pci_bus_address() to get bus address of a
 BAR
To: linux-pci@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Airlie <airlied@linux.ie>, Yinghai Lu <yinghai@kernel.org>,
        Guo Chao <yan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 17:55:33 -0700
Message-ID: <20140107005533.10786.78922.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We store BAR information as a struct resource, which contains the CPU
address, not the bus address.  Drivers often need the bus address, and
there's currently no convenient way to get it, so they often read the
BAR directly, or use the resource address (which doesn't work if there's
any translation between CPU and bus addresses).

Add pci_bus_address() to make this convenient.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 include/linux/pci.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index bf32412704a7..966b286b5d53 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1077,6 +1077,14 @@ int __must_check pci_bus_alloc_resource(struct pci_bus *bus,
 						  resource_size_t),
 			void *alignf_data);
 
+static inline dma_addr_t pci_bus_address(struct pci_dev *pdev, int bar)
+{
+	struct pci_bus_region region;
+
+	pcibios_resource_to_bus(pdev->bus, &region, &pdev->resource[bar]);
+	return region.start;
+}
+
 /* Proper probing supporting hot-pluggable devices */
 int __must_check __pci_register_driver(struct pci_driver *, struct module *,
 				       const char *mod_name);

