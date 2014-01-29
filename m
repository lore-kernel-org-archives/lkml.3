Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaA2SRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:17:42 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:60241 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbaA2SRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:17:37 -0500
Subject: [PATCH 01/17] x86/PCI: Drop pcibios_scan_root() check for bus
 already scanned
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-acpi@vger.kernel.org, x86@kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Jan 2014 11:17:33 -0700
Message-ID: <20140129181732.15476.79292.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI core checks to see whether we've already scanned a bus, so we don't
need to do it in pcibios_scan_root().  Here's where it happens in the core:

  pcibios_scan_root
    pci_scan_bus_on_node
      pci_scan_root_bus
        pci_create_root_bus
	  b2 = pci_find_bus(pci_domain_nr(b), bus)
	  if (b2)
	    goto err_out;    # already scanned this bus

This removes the check from pcibios_scan_root().

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/pci/common.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 981c2dbd72cc..c47bb2288bb9 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -458,15 +458,6 @@ void __init dmi_check_pciprobe(void)
 
 struct pci_bus *pcibios_scan_root(int busnum)
 {
-	struct pci_bus *bus = NULL;
-
-	while ((bus = pci_find_next_bus(bus)) != NULL) {
-		if (bus->number == busnum) {
-			/* Already scanned */
-			return bus;
-		}
-	}
-
 	return pci_scan_bus_on_node(busnum, &pci_root_ops,
 					get_mp_bus_to_node(busnum));
 }

