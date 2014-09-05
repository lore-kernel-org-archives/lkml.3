Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbaIEJQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:16:36 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58241 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaIEJQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:16:35 -0400
From: bharata.rao@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [PATCH] pseries: Make CPU hotplug path endian safe
Date: Fri,  5 Sep 2014 14:46:17 +0530
Message-Id: <1409908577-10648-1-git-send-email-bharata.rao@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

- ibm,rtas-configure-connector should treat the RTAS data as big endian.
- Treat ibm,ppc-interrupt-server#s as big-endian when setting
  smp_processor_id during hotplug.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/dlpar.c       | 10 +++++-----
 arch/powerpc/platforms/pseries/hotplug-cpu.c |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
index 2d0b4d6..dc55f9c 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -48,11 +48,11 @@ static struct property *dlpar_parse_cc_property(struct cc_workarea *ccwa)
 	if (!prop)
 		return NULL;
 
-	name = (char *)ccwa + ccwa->name_offset;
+	name = (char *)ccwa + be32_to_cpu(ccwa->name_offset);
 	prop->name = kstrdup(name, GFP_KERNEL);
 
-	prop->length = ccwa->prop_length;
-	value = (char *)ccwa + ccwa->prop_offset;
+	prop->length = be32_to_cpu(ccwa->prop_length);
+	value = (char *)ccwa + be32_to_cpu(ccwa->prop_offset);
 	prop->value = kmemdup(value, prop->length, GFP_KERNEL);
 	if (!prop->value) {
 		dlpar_free_cc_property(prop);
@@ -78,7 +78,7 @@ static struct device_node *dlpar_parse_cc_node(struct cc_workarea *ccwa,
 	if (!dn)
 		return NULL;
 
-	name = (char *)ccwa + ccwa->name_offset;
+	name = (char *)ccwa + be32_to_cpu(ccwa->name_offset);
 	dn->full_name = kasprintf(GFP_KERNEL, "%s/%s", path, name);
 	if (!dn->full_name) {
 		kfree(dn);
@@ -148,7 +148,7 @@ struct device_node *dlpar_configure_connector(u32 drc_index,
 		return NULL;
 
 	ccwa = (struct cc_workarea *)&data_buf[0];
-	ccwa->drc_index = drc_index;
+	ccwa->drc_index = cpu_to_be32(drc_index);
 	ccwa->zero = 0;
 
 	do {
diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index 20d6297..447f8c6 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -247,7 +247,7 @@ static int pseries_add_processor(struct device_node *np)
 	unsigned int cpu;
 	cpumask_var_t candidate_mask, tmp;
 	int err = -ENOSPC, len, nthreads, i;
-	const u32 *intserv;
+	const __be32 *intserv;
 
 	intserv = of_get_property(np, "ibm,ppc-interrupt-server#s", &len);
 	if (!intserv)
@@ -293,7 +293,7 @@ static int pseries_add_processor(struct device_node *np)
 	for_each_cpu(cpu, tmp) {
 		BUG_ON(cpu_present(cpu));
 		set_cpu_present(cpu, true);
-		set_hard_smp_processor_id(cpu, *intserv++);
+		set_hard_smp_processor_id(cpu, be32_to_cpu(*intserv++));
 	}
 	err = 0;
 out_unlock:
-- 
1.7.11.7

