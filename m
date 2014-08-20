Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaHTLrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:47:12 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59043 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752648AbaHTLoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:12 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Laurent Dufour <ldufour@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 098/104] PCI: rphahp: Fix endianess issues
Date: Wed, 20 Aug 2014 13:44:01 +0200
Message-Id: <520b3a651e2b629faac8e6765e51b7b0366a3026.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Dufour <ldufour@linux.vnet.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 761ce53330a4f02c58768631027d1c1dd0d538f7 upstream.

Numerical values stored in the device tree are encoded in Big Endian and
should be byte swapped when running in Little Endian.

The RPA hotplug module should convert those values as well.

Note that in rpaphp_get_drc_props(), the comparison between indexes[i+1]
and *index is done using the BE values (whatever is the current endianess).
This doesn't matter since we are checking for equality here.  This way only
the returned value is byte swapped.

RPA also made RTAS calls which implies BE values to be used.  According to
the patch done in RTAS (http://patchwork.ozlabs.org/patch/336865), no
additional conversion is required in RPA.

Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/pci/hotplug/rpaphp_core.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/hotplug/rpaphp_core.c b/drivers/pci/hotplug/rpaphp_core.c
index 127d6e600185..d023af8260a2 100644
--- a/drivers/pci/hotplug/rpaphp_core.c
+++ b/drivers/pci/hotplug/rpaphp_core.c
@@ -223,16 +223,16 @@ int rpaphp_get_drc_props(struct device_node *dn, int *drc_index,
 	type_tmp = (char *) &types[1];
 
 	/* Iterate through parent properties, looking for my-drc-index */
-	for (i = 0; i < indexes[0]; i++) {
+	for (i = 0; i < be32_to_cpu(indexes[0]); i++) {
 		if ((unsigned int) indexes[i + 1] == *my_index) {
 			if (drc_name)
                 		*drc_name = name_tmp;
 			if (drc_type)
 				*drc_type = type_tmp;
 			if (drc_index)
-				*drc_index = *my_index;
+				*drc_index = be32_to_cpu(*my_index);
 			if (drc_power_domain)
-				*drc_power_domain = domains[i+1];
+				*drc_power_domain = be32_to_cpu(domains[i+1]);
 			return 0;
 		}
 		name_tmp += (strlen(name_tmp) + 1);
@@ -321,16 +321,19 @@ int rpaphp_add_slot(struct device_node *dn)
 	/* register PCI devices */
 	name = (char *) &names[1];
 	type = (char *) &types[1];
-	for (i = 0; i < indexes[0]; i++) {
+	for (i = 0; i < be32_to_cpu(indexes[0]); i++) {
+		int index;
 
-		slot = alloc_slot_struct(dn, indexes[i + 1], name, power_domains[i + 1]);
+		index = be32_to_cpu(indexes[i + 1]);
+		slot = alloc_slot_struct(dn, index, name,
+					 be32_to_cpu(power_domains[i + 1]));
 		if (!slot)
 			return -ENOMEM;
 
 		slot->type = simple_strtoul(type, NULL, 10);
 				
 		dbg("Found drc-index:0x%x drc-name:%s drc-type:%s\n",
-				indexes[i + 1], name, type);
+				index, name, type);
 
 		retval = rpaphp_enable_slot(slot);
 		if (!retval)
-- 
2.0.4

