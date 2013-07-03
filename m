Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab3GCOD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:03:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:16372 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab3GCOCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:02:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,988,1363158000"; 
   d="scan'208";a="263621132"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Yinghai Lu <yinghai@kernel.org>,
        john.ronciak@intel.com, miles.j.penner@intel.com,
        bruce.w.allan@intel.com,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, x86@kernel.org
Subject: [PATCH v2 1/8] x86/PCI: prevent re-allocation of already existing bridge and ROM resources
Date: Wed,  3 Jul 2013 17:04:48 +0300
Message-Id: <1372860295-8306-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In hotplug case (especially with Thunderbolt enabled systems) we might need
to call pcibios_resource_survey_bus() several times for a bus. The function
ends up calling pci_claim_resource() for each bridge resource that then
fails claiming that the resource exists already (which it does). Once this
happens the resource is invalidated thus preventing devices behind the
bridge to allocate their resources.

To fix this we do what has been done in pcibios_allocate_dev_resources()
and check 'parent' of the given resource. If it is non-NULL it means that
the resource has been allocated already and we can skip it. We do the same
for ROM resources as well.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 arch/x86/pci/i386.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 94919e3..db6b1ab 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -210,6 +210,8 @@ static void pcibios_allocate_bridge_resources(struct pci_dev *dev)
 		r = &dev->resource[idx];
 		if (!r->flags)
 			continue;
+		if (r->parent)	/* Already allocated */
+			continue;
 		if (!r->start || pci_claim_resource(dev, idx) < 0) {
 			/*
 			 * Something is wrong with the region.
@@ -318,6 +320,8 @@ static void pcibios_allocate_dev_rom_resource(struct pci_dev *dev)
 	r = &dev->resource[PCI_ROM_RESOURCE];
 	if (!r->flags || !r->start)
 		return;
+	if (r->parent) /* Already allocated */
+		return;
 
 	if (pci_claim_resource(dev, PCI_ROM_RESOURCE) < 0) {
 		r->end -= r->start;
-- 
1.8.3.2

