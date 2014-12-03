Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaLCLjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:39:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbaLCL1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:40 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joe Schultz <jschultz@xes-inc.com>,
        Aaron Sierra <asierra@xes-inc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 081/101] vme_tsi148: Fix PCI address mapping assumption
Date: Wed,  3 Dec 2014 12:26:43 +0100
Message-Id: <8a8f33b2f640e1e7d0486888293817f56505aa4f.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Schultz <jschultz@xes-inc.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 226572b110ab6083cb8c1d6afb191166b4178179 upstream.

Previously, tsi148_master_set() assumed the address contained in its
PCI bus resource represented the actual PCI bus address. This is a fine
assumption on some platforms. However, on platforms that don't use a
1:1 (CPU:PCI) mapping this results in the tsi148 driver configuring an
invalid master window translation.

This patch updates the vme_tsi148 driver to first convert the address
contained in the PCI bus resource into a PCI bus address before using
it.

[asierra: account for pcibios_resource_to_bus() prototype change]
Signed-off-by: Joe Schultz <jschultz@xes-inc.com>
Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/vme/bridges/vme_tsi148.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/vme/bridges/vme_tsi148.c b/drivers/vme/bridges/vme_tsi148.c
index 7db4e6395e23..6783ad0d1875 100644
--- a/drivers/vme/bridges/vme_tsi148.c
+++ b/drivers/vme/bridges/vme_tsi148.c
@@ -910,11 +910,15 @@ static int tsi148_master_set(struct vme_master_resource *image, int enabled,
 	unsigned long long pci_bound, vme_offset, pci_base;
 	struct vme_bridge *tsi148_bridge;
 	struct tsi148_driver *bridge;
+	struct pci_bus_region region;
+	struct pci_dev *pdev;
 
 	tsi148_bridge = image->parent;
 
 	bridge = tsi148_bridge->driver_priv;
 
+	pdev = container_of(tsi148_bridge->parent, struct pci_dev, dev);
+
 	/* Verify input data */
 	if (vme_base & 0xFFFF) {
 		dev_err(tsi148_bridge->parent, "Invalid VME Window "
@@ -949,7 +953,9 @@ static int tsi148_master_set(struct vme_master_resource *image, int enabled,
 		pci_bound = 0;
 		vme_offset = 0;
 	} else {
-		pci_base = (unsigned long long)image->bus_resource.start;
+		pcibios_resource_to_bus(pdev, &region,
+					&image->bus_resource);
+		pci_base = region.start;
 
 		/*
 		 * Bound address is a valid address for the window, adjust
-- 
2.1.3

