Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab3HMLMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:12:54 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:35214 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486Ab3HMLMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:12:41 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>
Subject: [RFC 2/3] ARM: Introduce pci_common_exit()
Date: Tue, 13 Aug 2013 13:12:25 +0200
Message-Id: <1376392346-14127-3-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1376392346-14127-1-git-send-email-treding@nvidia.com>
References: <1376392346-14127-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to support building PCI host drivers as modules, functionality
is required to undo the steps performed by pci_common_init(). The PCI
core provides much of the functionality already, so add a function that
can be called by drivers to wrap the ARM specific bits.

This patch does a number of things to achieve this: it adds a .nr field
to struct pci_sys_data to keep track of the controller number that was
used to initialize it during pci_common_init(). That field is passed to
the new .teardown() callback during cleanup to undo what .setup() did.

Furthermore the list of pci_sys_data structures setup can optionally be
returned via the hw_pci structure's .sys field. If a driver initializes
it, then it is assumed to be an empty list that pci_common_init() will
append to. Otherwise the old behaviour of keeping a local list only is
preserved.

If a driver wants to support unloading, then it needs access to this
list and pass it to pci_common_exit(). This will iterate over the list,
call the new .teardown() callback and remove the root bus associated
with each entry.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm/include/asm/mach/pci.h |  6 ++++++
 arch/arm/kernel/bios32.c        | 29 ++++++++++++++++++++++++++---
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/mach/pci.h b/arch/arm/include/asm/mach/pci.h
index 454d642..d6c352a 100644
--- a/arch/arm/include/asm/mach/pci.h
+++ b/arch/arm/include/asm/mach/pci.h
@@ -25,6 +25,7 @@ struct hw_pci {
 	struct pci_ops	*ops;
 	int		nr_controllers;
 	void		**private_data;
+	struct list_head *sys;
 	int		(*setup)(int nr, struct pci_sys_data *);
 	struct pci_bus *(*scan)(int nr, struct pci_sys_data *);
 	void		(*preinit)(void);
@@ -38,6 +39,7 @@ struct hw_pci {
 					  resource_size_t align);
 	void		(*add_bus)(struct pci_bus *bus);
 	void		(*remove_bus)(struct pci_bus *bus);
+	void		(*teardown)(int nr, struct pci_sys_data *);
 };
 
 /*
@@ -49,6 +51,7 @@ struct pci_sys_data {
 #endif
 	struct list_head node;
 	int		busnr;		/* primary bus number			*/
+	int		nr;		/* controller number			*/
 	u64		mem_offset;	/* bus->cpu memory mapping offset	*/
 	unsigned long	io_offset;	/* bus->cpu IO mapping offset		*/
 	struct pci_bus	*bus;		/* PCI bus				*/
@@ -67,6 +70,7 @@ struct pci_sys_data {
 					  resource_size_t align);
 	void		(*add_bus)(struct pci_bus *bus);
 	void		(*remove_bus)(struct pci_bus *bus);
+	void		(*teardown)(int nr, struct pci_sys_data *);
 	void		*private_data;	/* platform controller private data	*/
 };
 
@@ -84,6 +88,8 @@ static inline void pci_common_init(struct hw_pci *hw)
 	pci_common_init_dev(NULL, hw);
 }
 
+void pci_common_exit(struct list_head *head);
+
 /*
  * Setup early fixed I/O mapping.
  */
diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 1ec9c87..6895520 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -475,11 +475,13 @@ static void pcibios_init_hw(struct device *parent, struct hw_pci *hw,
 		sys->domain  = hw->domain;
 #endif
 		sys->busnr   = busnr;
+		sys->nr      = nr;
 		sys->swizzle = hw->swizzle;
 		sys->map_irq = hw->map_irq;
 		sys->align_resource = hw->align_resource;
 		sys->add_bus = hw->add_bus;
 		sys->remove_bus = hw->remove_bus;
+		sys->teardown = hw->teardown;
 		INIT_LIST_HEAD(&sys->resources);
 
 		if (hw->private_data)
@@ -517,18 +519,24 @@ static void pcibios_init_hw(struct device *parent, struct hw_pci *hw,
 void pci_common_init_dev(struct device *parent, struct hw_pci *hw)
 {
 	struct pci_sys_data *sys;
-	LIST_HEAD(head);
+	struct list_head *head;
+	LIST_HEAD(list);
+
+	if (hw->sys)
+		head = hw->sys;
+	else
+		head = &list;
 
 	pci_add_flags(PCI_REASSIGN_ALL_RSRC);
 	if (hw->preinit)
 		hw->preinit();
-	pcibios_init_hw(parent, hw, &head);
+	pcibios_init_hw(parent, hw, head);
 	if (hw->postinit)
 		hw->postinit();
 
 	pci_fixup_irqs(pcibios_swizzle, pcibios_map_irq);
 
-	list_for_each_entry(sys, &head, node) {
+	list_for_each_entry(sys, head, node) {
 		struct pci_bus *bus = sys->bus;
 
 		if (!pci_has_flag(PCI_PROBE_ONLY)) {
@@ -555,6 +563,21 @@ void pci_common_init_dev(struct device *parent, struct hw_pci *hw)
 	}
 }
 
+void pci_common_exit(struct list_head *head)
+{
+	struct pci_sys_data *sys, *tmp;
+
+	list_for_each_entry_safe(sys, tmp, head, node) {
+		if (sys->teardown)
+			sys->teardown(sys->nr, sys);
+
+		pci_stop_root_bus(sys->bus);
+		pci_remove_root_bus(sys->bus);
+		list_del(&sys->node);
+		kfree(sys);
+	}
+}
+
 #ifndef CONFIG_PCI_HOST_ITE8152
 void pcibios_set_master(struct pci_dev *dev)
 {
-- 
1.8.3.4

