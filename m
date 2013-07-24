Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3GXSrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:47:19 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49326 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab3GXSrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:47:17 -0400
Message-ID: <51F02129.8010506@linux.vnet.ibm.com>
Date: Wed, 24 Jul 2013 13:47:05 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        linuxppc-dev@lists.ozlabs.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 8/8] Remove no longer needed powerpc memory node update handler
References: <51F01E06.6090800@linux.vnet.ibm.com>
In-Reply-To: <51F01E06.6090800@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072418-4790-0000-0000-0000097208C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the update_node handler for powerpc/pseries.

Now that we can do memory dlpar in the kernel we no longer need the of
update node notifier to update the ibm,dynamic-memory property of the
ibm,dynamic-reconfiguration-memory node. This work is now handled by
the memory notification handlers for powerpc/pseries.

This patch also conditionally registers the handler for of node remove
if we are not using the ibm,dynamic-reconfiguration-memory device tree
layout. That handler is only needed for handling memory@XXX nodes
in the device tree.

Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/hotplug-memory.c |   60 +++---------------------
 1 file changed, 8 insertions(+), 52 deletions(-)

Index: linux/arch/powerpc/platforms/pseries/hotplug-memory.c
===================================================================
--- linux.orig/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ linux/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -166,67 +166,15 @@ static inline int pseries_remove_memory(
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
-static int pseries_update_drconf_memory(struct of_prop_reconfig *pr)
-{
-	struct of_drconf_cell *new_drmem, *old_drmem;
-	unsigned long memblock_size;
-	u32 entries;
-	u32 *p;
-	int i, rc = -EINVAL;
-
-	memblock_size = get_memblock_size();
-	if (!memblock_size)
-		return -EINVAL;
-
-	p = (u32 *)of_get_property(pr->dn, "ibm,dynamic-memory", NULL);
-	if (!p)
-		return -EINVAL;
-
-	/* The first int of the property is the number of lmb's described
-	 * by the property. This is followed by an array of of_drconf_cell
-	 * entries. Get the niumber of entries and skip to the array of
-	 * of_drconf_cell's.
-	 */
-	entries = *p++;
-	old_drmem = (struct of_drconf_cell *)p;
-
-	p = (u32 *)pr->prop->value;
-	p++;
-	new_drmem = (struct of_drconf_cell *)p;
-
-	for (i = 0; i < entries; i++) {
-		if ((old_drmem[i].flags & DRCONF_MEM_ASSIGNED) &&
-		    (!(new_drmem[i].flags & DRCONF_MEM_ASSIGNED))) {
-			rc = pseries_remove_memblock(old_drmem[i].base_addr,
-						     memblock_size);
-			break;
-		} else if ((!(old_drmem[i].flags & DRCONF_MEM_ASSIGNED)) &&
-			   (new_drmem[i].flags & DRCONF_MEM_ASSIGNED)) {
-			rc = memblock_add(old_drmem[i].base_addr,
-					  memblock_size);
-			rc = (rc < 0) ? -EINVAL : 0;
-			break;
-		}
-	}
-
-	return rc;
-}
-
 static int pseries_memory_notifier(struct notifier_block *nb,
 				   unsigned long action, void *node)
 {
-	struct of_prop_reconfig *pr;
 	int err = 0;
 
 	switch (action) {
 	case OF_RECONFIG_DETACH_NODE:
 		err = pseries_remove_memory(node);
 		break;
-	case OF_RECONFIG_UPDATE_PROPERTY:
-		pr = (struct of_prop_reconfig *)node;
-		if (!strcmp(pr->prop->name, "ibm,dynamic-memory"))
-			err = pseries_update_drconf_memory(pr);
-		break;
 	}
 	return notifier_from_errno(err);
 }
@@ -237,6 +185,14 @@ static struct notifier_block pseries_mem
 
 static int __init pseries_memory_hotplug_init(void)
 {
+	struct device_node *dn;
+
+	dn = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
+	if (dn) {
+		of_node_put(dn);
+		return 0;
+	}
+
 	if (firmware_has_feature(FW_FEATURE_LPAR))
 		of_reconfig_notifier_register(&pseries_mem_nb);
 


