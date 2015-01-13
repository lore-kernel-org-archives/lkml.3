Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbbAMJH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:07:26 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:53953 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbbAMJHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:07:21 -0500
Date: Tue, 13 Jan 2015 17:07:10 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        Andrew Murray <amurray@embedded-bits.co.uk>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 09/10] PCI, powerpc: clip firmware assigned resource
 under parent bridge's
Message-ID: <20150113090710.GA20771@richard>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1421090600-9750-1-git-send-email-yinghai@kernel.org>
 <1421090600-9750-10-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421090600-9750-10-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011309-0013-0000-0000-000000ABCA26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did a quick test, looks good on my machine.

Thanks :-)

On Mon, Jan 12, 2015 at 11:23:19AM -0800, Yinghai Lu wrote:
>Some bios put range that is not fully coverred by root bus resources.
>Try to clip them and update them in pci bridge bars.
>
>We'd like to fix other arches instead of just x86.
>
>Link: https://bugzilla.kernel.org/show_bug.cgi?id=85491
>Reported-by: Marek Kordik <kordikmarek@gmail.com>
>Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources")
>Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>Cc: Paul Mackerras <paulus@samba.org>
>Cc: Michael Ellerman <mpe@ellerman.id.au>
>Cc: Gavin Shan <gwshan@linux.vnet.ibm.com>
>Cc: Anton Blanchard <anton@samba.org>
>Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
>Cc: Wei Yang <weiyang@linux.vnet.ibm.com>
>Cc: Andrew Murray <amurray@embedded-bits.co.uk>
>Cc: linuxppc-dev@lists.ozlabs.org
>---
> arch/powerpc/kernel/pci-common.c | 43 +++++++++++++++++++++++++++++++++++++++-
> 1 file changed, 42 insertions(+), 1 deletion(-)
>
>diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
>index 37d512d..6909546 100644
>--- a/arch/powerpc/kernel/pci-common.c
>+++ b/arch/powerpc/kernel/pci-common.c
>@@ -1148,6 +1148,7 @@ static void pcibios_allocate_bus_resources(struct pci_bus *bus)
> 	struct pci_bus *b;
> 	int i;
> 	struct resource *res, *pr;
>+	bool changed = false;
>
> 	pr_debug("PCI: Allocating bus resources for %04x:%02x...\n",
> 		 pci_domain_nr(bus), bus->number);
>@@ -1184,6 +1185,8 @@ static void pcibios_allocate_bus_resources(struct pci_bus *bus)
> 			 pr, (pr && pr->name) ? pr->name : "nil");
>
> 		if (pr && !(pr->flags & IORESOURCE_UNSET)) {
>+			struct pci_dev *dev = bus->self;
>+
> 			if (request_resource(pr, res) == 0)
> 				continue;
> 			/*
>@@ -1193,6 +1196,16 @@ static void pcibios_allocate_bus_resources(struct pci_bus *bus)
> 			 */
> 			if (reparent_resources(pr, res) == 0)
> 				continue;
>+
>+			if (dev && i >= PCI_BRIDGE_RESOURCES &&
>+			    i < PCI_NUM_RESOURCES &&
>+			    (dev->class >> 8) == PCI_CLASS_BRIDGE_PCI &&
>+			    pci_bus_clip_resource(dev, res)) {
>+				changed = true;
>+				if (pci_claim_resource(dev, i) >= 0)
>+					continue;
>+			}
>+
> 		}
> 		pr_warning("PCI: Cannot allocate resource region "
> 			   "%d of PCI bridge %d, will remap\n", i, bus->number);
>@@ -1208,6 +1221,9 @@ static void pcibios_allocate_bus_resources(struct pci_bus *bus)
> 		res->flags = 0;
> 	}
>
>+	if (changed)
>+		pci_setup_bridge(bus);
>+
> 	list_for_each_entry(b, &bus->children, node)
> 		pcibios_allocate_bus_resources(b);
> }
>@@ -1225,6 +1241,13 @@ static inline void alloc_resource(struct pci_dev *dev, int idx)
> 	pr = pci_find_parent_resource(dev, r);
> 	if (!pr || (pr->flags & IORESOURCE_UNSET) ||
> 	    request_resource(pr, r) < 0) {
>+		/* try again with clip */
>+		if (idx != PCI_ROM_RESOURCE && pci_bus_clip_resource(dev, r)) {
>+			pci_update_resource(dev, idx);
>+			if (pci_claim_resource(dev, idx) >= 0)
>+				return;
>+		}
>+
> 		printk(KERN_WARNING "PCI: Cannot allocate resource region %d"
> 		       " of device %s, will remap\n", idx, pci_name(dev));
> 		if (pr)
>@@ -1386,6 +1409,7 @@ void pcibios_claim_one_bus(struct pci_bus *bus)
> 	struct pci_bus *child_bus;
>
> 	list_for_each_entry(dev, &bus->devices, bus_list) {
>+		bool changed = false;
> 		int i;
>
> 		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
>@@ -1401,8 +1425,25 @@ void pcibios_claim_one_bus(struct pci_bus *bus)
> 				 (unsigned long long)r->end,
> 				 (unsigned int)r->flags);
>
>-			pci_claim_resource(dev, i);
>+			if (pci_claim_resource(dev, i) >= 0)
>+				continue;
>+
>+			if (dev->subordinate &&
>+			    i >= PCI_BRIDGE_RESOURCES &&
>+			    i < PCI_NUM_RESOURCES &&
>+			    (dev->class >> 8) == PCI_CLASS_BRIDGE_PCI &&
>+			    pci_bus_clip_resource(dev, r)) {
>+				changed = true;
>+				pci_claim_resource(dev, i);
>+			} else if (i < PCI_BRIDGE_RESOURCES &&
>+				   i != PCI_ROM_RESOURCE &&
>+				   pci_bus_clip_resource(dev, r)) {
>+					pci_update_resource(dev, i);
>+					pci_claim_resource(dev, i);
>+			}
> 		}
>+		if (changed)
>+			pci_setup_bridge(dev->subordinate);
> 	}
>
> 	list_for_each_entry(child_bus, &bus->children, node)
>-- 
>1.8.4.5

-- 
Richard Yang
Help you, Help me

