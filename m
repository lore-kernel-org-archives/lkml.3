Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbaCDPv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 10:51:57 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51594 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754472AbaCDPuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:50:55 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v5 4/7] pci: Introduce a domain number for pci_host_bridge.
Date: Tue,  4 Mar 2014 15:50:01 +0000
Message-Id: <1393948204-11555-5-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393948204-11555-1-git-send-email-Liviu.Dudau@arm.com>
References: <1393948204-11555-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it easier to discover the domain number of a bus by storing
the number in pci_host_bridge for the root bus. Several architectures
have their own way of storing this information, so it makes sense
to try to unify the code. While at this, add a new function that
creates a root bus in a given domain and make pci_create_root_bus()
a wrapper around this function.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>

---
Arnd, I know you have Acked the previous version of this patch, but now I have
added ERR_PTR() calls to it. Do I get to keep the Ack?

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 78ccba0..26237a0 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1714,8 +1714,9 @@ void __weak pcibios_remove_bus(struct pci_bus *bus)
 {
 }
 
-struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
-		struct pci_ops *ops, void *sysdata, struct list_head *resources)
+struct pci_bus *pci_create_root_bus_in_domain(struct device *parent,
+		int domain, int bus, struct pci_ops *ops, void *sysdata,
+		struct list_head *resources)
 {
 	int error;
 	struct pci_host_bridge *bridge;
@@ -1728,14 +1729,15 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 
 	bridge = pci_alloc_host_bridge();
 	if (!bridge)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	bridge->dev.parent = parent;
 	bridge->dev.release = pci_release_host_bridge_dev;
+	bridge->domain_nr = domain;
 	error = pcibios_root_bridge_prepare(bridge);
 	if (error) {
 		kfree(bridge);
-		return NULL;
+		return ERR_PTR(error);
 	}
 
 	b = pci_alloc_bus();
@@ -1745,7 +1747,7 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	b->sysdata = sysdata;
 	b->ops = ops;
 	b->number = b->busn_res.start = bus;
-	b2 = pci_find_bus(pci_domain_nr(b), bus);
+	b2 = pci_find_bus(bridge->domain_nr, bus);
 	if (b2) {
 		/* If we already got to this bus through a different bridge, ignore it */
 		dev_dbg(&b2->dev, "bus already known\n");
@@ -1753,7 +1755,7 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	}
 
 	bridge->bus = b;
-	dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(b), bus);
+	dev_set_name(&bridge->dev, "pci%04x:%02x", bridge->domain_nr, bus);
 	error = device_register(&bridge->dev);
 	if (error) {
 		put_device(&bridge->dev);
@@ -1768,7 +1770,7 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 
 	b->dev.class = &pcibus_class;
 	b->dev.parent = b->bridge;
-	dev_set_name(&b->dev, "%04x:%02x", pci_domain_nr(b), bus);
+	dev_set_name(&b->dev, "%04x:%02x", bridge->domain_nr, bus);
 	error = device_register(&b->dev);
 	if (error)
 		goto class_dev_reg_err;
@@ -1818,7 +1820,27 @@ err_bus_out:
 	kfree(b);
 err_out:
 	kfree(bridge);
-	return NULL;
+	return ERR_PTR(error);
+}
+
+struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
+		struct pci_ops *ops, void *sysdata, struct list_head *resources)
+{
+	int domain_nr;
+	struct pci_bus *b = pci_alloc_bus();
+	if (!b)
+		return NULL;
+
+	b->sysdata = sysdata;
+	domain_nr = pci_domain_nr(b);
+	kfree(b);
+
+	b = pci_create_root_bus_in_domain(parent, domain_nr, bus,
+				ops, sysdata, resources);
+	if (IS_ERR(b))
+		return NULL;
+
+	return b;
 }
 
 int pci_bus_insert_busn_res(struct pci_bus *b, int bus, int bus_max)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 33aa2ca..1eed009 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -394,6 +394,7 @@ struct pci_host_bridge_window {
 struct pci_host_bridge {
 	struct device dev;
 	struct pci_bus *bus;		/* root bus */
+	int domain_nr;
 	struct list_head windows;	/* pci_host_bridge_windows */
 	void (*release_fn)(struct pci_host_bridge *);
 	void *release_data;
@@ -747,6 +748,9 @@ struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops, void *sysdata);
 struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 				    struct pci_ops *ops, void *sysdata,
 				    struct list_head *resources);
+struct pci_bus *pci_create_root_bus_in_domain(struct device *parent,
+			int domain, int bus, struct pci_ops *ops,
+			void *sysdata, struct list_head *resources);
 int pci_bus_insert_busn_res(struct pci_bus *b, int bus, int busmax);
 int pci_bus_update_busn_res_end(struct pci_bus *b, int busmax);
 void pci_bus_release_busn_res(struct pci_bus *b);
-- 
1.9.0

