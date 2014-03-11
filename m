Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbaCKRms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:42:48 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:55133 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbaCKRmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:42:45 -0400
Subject: [PATCH 1/5] PCI: Don't check resource_size() in
 pci_bus_alloc_resource()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 11 Mar 2014 11:42:43 -0600
Message-ID: <20140311174243.23084.77689.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140311173556.23084.57635.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140311173556.23084.57635.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul reported that after f75b99d5a77d ("PCI: Enforce bus address limits in
resource allocation") on a 32-bit kernel (CONFIG_PHYS_ADDR_T_64BIT not
set), intel-gtt complained "can't ioremap flush page - no chipset
flushing".  In addition, other PCI resource allocations, e.g., for bridge
windows, failed.

This happens because we incorrectly skip bus resources of
[mem 0x00000000-0xffffffff] because we think they are of size zero.
When resource_size_t is 32 bits wide, resource_size() on
[mem 0x00000000-0xffffffff] returns 0 because (r->end - r->start + 1)
overflows.

Therefore, we can't use "resource_size() == 0" to decide that allocation
from this resource will fail.  allocate_resource() should fail anyway if it
can't satisfy the address constraints, so we should just depend on that.

A [mem 0x00000000-0xffffffff] bus resource is obviously not really valid,
but we do fall back to it as a default when we don't have information about
host bridge apertures.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=71611
Fixes: f75b99d5a77d PCI: Enforce bus address limits in resource allocation
Reported-and-tested-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/bus.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 00660cc502c5..38901665c770 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -162,8 +162,6 @@ static int pci_bus_alloc_from_region(struct pci_bus *bus, struct resource *res,
 
 		avail = *r;
 		pci_clip_resource_to_region(bus, &avail, region);
-		if (!resource_size(&avail))
-			continue;
 
 		/*
 		 * "min" is typically PCIBIOS_MIN_IO or PCIBIOS_MIN_MEM to

