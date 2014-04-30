Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbaD3BAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 21:00:09 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:42975 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbaD3BAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 21:00:00 -0400
Subject: [PATCH 3/7] PCI: Don't convert BAR address to resource if
 dma_addr_t is too small
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 29 Apr 2014 18:59:59 -0600
Message-ID: <20140430005958.13138.17945.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140430005642.13138.99577.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140430005642.13138.99577.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If dma_addr_t is too small to represent the BAR value,
pcibios_bus_to_resource() will fail, so just remember the BAR size directly
in the resource.  The resource is already marked UNSET, so we know the
address isn't valid anyway.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/probe.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index afae3bf405fa..82cd75f6118a 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -258,9 +258,10 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 			pci_write_config_dword(dev, pos, 0);
 			pci_write_config_dword(dev, pos + 4, 0);
 			res->flags |= IORESOURCE_UNSET;
-			region.start = 0;
-			region.end = sz64;
+			res->start = 0;
+			res->end = sz64;
 			bar_disabled = true;
+			goto out;
 		} else {
 			region.start = l64;
 			region.end = l64 + sz64;

