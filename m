Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab3GXSp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:45:57 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:36781 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3GXSp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:45:56 -0400
Message-ID: <51F020DB.3090909@linux.vnet.ibm.com>
Date: Wed, 24 Jul 2013 13:45:47 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        linuxppc-dev@lists.ozlabs.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 7/8]  Add memory hot add/remove notifier handlers for pwoerpc
References: <51F01E06.6090800@linux.vnet.ibm.com>
In-Reply-To: <51F01E06.6090800@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072418-3864-0000-0000-0000093DC4FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add memory hot add/remove notifier handlers for powerpc/pseries.

This patch allows the powerpc/pseries platforms to perform memory DLPAR
int the kernel. The handlers for add and remove do the work of
acquiring/releasing the memory to firmware and updating the device tree.

This is only used when memory is specified in the
ibm,dynamic-reconfiguration-memory device tree node so the memory notifiers
are registered contingent on its existence.

Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/dlpar.c |  103 +++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

Index: linux/arch/powerpc/platforms/pseries/dlpar.c
===================================================================
--- linux.orig/arch/powerpc/platforms/pseries/dlpar.c
+++ linux/arch/powerpc/platforms/pseries/dlpar.c
@@ -15,6 +15,7 @@
 #include <linux/notifier.h>
 #include <linux/spinlock.h>
 #include <linux/cpu.h>
+#include <linux/memory.h>
 #include <linux/slab.h>
 #include <linux/of.h>
 #include "offline_states.h"
@@ -531,11 +532,113 @@ out:
 	return rc ? rc : count;
 }
 
+static struct of_drconf_cell *dlpar_get_drconf_cell(struct device_node *dn,
+						    unsigned long phys_addr)
+{
+	struct of_drconf_cell *drmem;
+	u32 entries;
+	u32 *prop;
+	int i;
+
+	prop = (u32 *)of_get_property(dn, "ibm,dynamic-memory", NULL);
+	of_node_put(dn);
+	if (!prop)
+		return NULL;
+
+	entries = *prop++;
+	drmem = (struct of_drconf_cell *)prop;
+
+	for (i = 0; i < entries; i++) {
+		if (drmem[i].base_addr == phys_addr)
+			return &drmem[i];
+	}
+
+	return NULL;
+}
+
+static int dlpar_mem_probe(unsigned long phys_addr)
+{
+	struct device_node *dn;
+	struct of_drconf_cell *drmem;
+	int rc;
+
+	dn = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
+	if (!dn)
+		return -EINVAL;
+
+	drmem = dlpar_get_drconf_cell(dn, phys_addr);
+	of_node_put(dn);
+
+	if (!drmem)
+		return -EINVAL;
+
+	if (drmem->flags & DRCONF_MEM_ASSIGNED)
+		return 0;
+
+	drmem->flags |= DRCONF_MEM_ASSIGNED;
+
+	rc = dlpar_acquire_drc(drmem->drc_index);
+	return rc;
+}
+
+static int dlpar_mem_release(unsigned long phys_addr)
+{
+	struct device_node *dn;
+	struct of_drconf_cell *drmem;
+	int rc;
+
+	dn = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
+	if (!dn)
+		return -EINVAL;
+
+	drmem = dlpar_get_drconf_cell(dn, phys_addr);
+	of_node_put(dn);
+
+	if (!drmem)
+		return -EINVAL;
+
+	if (!drmem->flags & DRCONF_MEM_ASSIGNED)
+		return 0;
+
+	drmem->flags &= ~DRCONF_MEM_ASSIGNED;
+
+	rc = dlpar_release_drc(drmem->drc_index);
+	return rc;
+}
+
+static int pseries_dlpar_mem_callback(struct notifier_block *nb,
+				      unsigned long action, void *hp_arg)
+{
+	struct memory_notify *arg = hp_arg;
+	unsigned long phys_addr = arg->start_pfn << PAGE_SHIFT;
+	int rc = 0;
+
+
+	switch (action) {
+	case MEM_BEING_HOT_ADDED:
+		rc = dlpar_mem_probe(phys_addr);
+		break;
+	case MEM_HOT_REMOVED:
+		rc = dlpar_mem_release(phys_addr);
+		break;
+	}
+
+	return notifier_from_errno(rc);
+}
+
 static int __init pseries_dlpar_init(void)
 {
+	struct device_node *dn;
+
 	ppc_md.cpu_probe = dlpar_cpu_probe;
 	ppc_md.cpu_release = dlpar_cpu_release;
 
+	dn = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
+	if (dn) {
+		hotplug_memory_notifier(pseries_dlpar_mem_callback, 0);
+		of_node_put(dn);
+	}
+
 	return 0;
 }
 machine_device_initcall(pseries, pseries_dlpar_init);


