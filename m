Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936068Ab3BONMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:12:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935945Ab3BOMpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:22 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 03/13] ghes: add the needed hooks for EDAC error report
Date: Fri, 15 Feb 2013 10:44:51 -0200
Message-Id: <a6aaff7d219b878ca655fde3757ecd0170caec2c.1360931635.git.mchehab@redhat.com>
In-Reply-To: <cover.1360931635.git.mchehab@redhat.com>
References: <cover.1360931635.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to allow reporting errors via EDAC, add hooks for:

1) register an EDAC driver;
2) unregister an EDAC driver;
3) report errors via EDAC.

As the EDAC driver will need to access the ghes structure, adds it
as one of the parameters for ghes_do_proc.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/acpi/apei/ghes.c | 17 ++++++++++++++---
 include/acpi/ghes.h      | 27 +++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 6d0e146..a21d7da 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -409,7 +409,8 @@ static void ghes_clear_estatus(struct ghes *ghes)
 	ghes->flags &= ~GHES_TO_CLEAR;
 }
 
-static void ghes_do_proc(const struct acpi_hest_generic_status *estatus)
+static void ghes_do_proc(struct ghes *ghes,
+			 const struct acpi_hest_generic_status *estatus)
 {
 	int sev, sec_sev;
 	struct acpi_hest_generic_data *gdata;
@@ -421,6 +422,8 @@ static void ghes_do_proc(const struct acpi_hest_generic_status *estatus)
 				 CPER_SEC_PLATFORM_MEM)) {
 			struct cper_sec_mem_err *mem_err;
 			mem_err = (struct cper_sec_mem_err *)(gdata+1);
+			ghes_edac_report_mem_error(ghes, sev, mem_err);
+
 #ifdef CONFIG_X86_MCE
 			apei_mce_report_mem_error(sev == GHES_SEV_CORRECTED,
 						  mem_err);
@@ -639,7 +642,7 @@ static int ghes_proc(struct ghes *ghes)
 		if (ghes_print_estatus(NULL, ghes->generic, ghes->estatus))
 			ghes_estatus_cache_add(ghes->generic, ghes->estatus);
 	}
-	ghes_do_proc(ghes->estatus);
+	ghes_do_proc(ghes, ghes->estatus);
 out:
 	ghes_clear_estatus(ghes);
 	return 0;
@@ -732,7 +735,7 @@ static void ghes_proc_in_irq(struct irq_work *irq_work)
 		estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
 		len = apei_estatus_len(estatus);
 		node_len = GHES_ESTATUS_NODE_LEN(len);
-		ghes_do_proc(estatus);
+		ghes_do_proc(estatus_node->ghes, estatus);
 		if (!ghes_estatus_cached(estatus)) {
 			generic = estatus_node->generic;
 			if (ghes_print_estatus(NULL, generic, estatus))
@@ -821,6 +824,7 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 		estatus_node = (void *)gen_pool_alloc(ghes_estatus_pool,
 						      node_len);
 		if (estatus_node) {
+			estatus_node->ghes = ghes;
 			estatus_node->generic = ghes->generic;
 			estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
 			memcpy(estatus, ghes->estatus, len);
@@ -942,6 +946,10 @@ static int ghes_probe(struct platform_device *ghes_dev)
 	}
 	platform_set_drvdata(ghes_dev, ghes);
 
+	rc = ghes_edac_register(ghes, &ghes_dev->dev);
+	if (rc < 0)
+		goto err;
+
 	return 0;
 err:
 	if (ghes) {
@@ -995,6 +1003,9 @@ static int ghes_remove(struct platform_device *ghes_dev)
 	}
 
 	ghes_fini(ghes);
+
+	ghes_edac_unregister(ghes);
+
 	kfree(ghes);
 
 	platform_set_drvdata(ghes_dev, NULL);
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
index 3eb8dc4..c6fef72 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -22,11 +22,14 @@ struct ghes {
 		struct timer_list timer;
 		unsigned int irq;
 	};
+
+	struct mem_ctl_info *mci;
 };
 
 struct ghes_estatus_node {
 	struct llist_node llnode;
 	struct acpi_hest_generic *generic;
+	struct ghes *ghes;
 };
 
 struct ghes_estatus_cache {
@@ -43,3 +46,27 @@ enum {
 	GHES_SEV_RECOVERABLE = 0x2,
 	GHES_SEV_PANIC = 0x3,
 };
+
+#ifdef CONFIG_EDAC_GHES
+void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
+				struct cper_sec_mem_err *mem_err);
+
+int ghes_edac_register(struct ghes *ghes, struct device *dev);
+
+void ghes_edac_unregister(struct ghes *ghes);
+
+#else
+static inline void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
+				       struct cper_sec_mem_err *mem_err)
+{
+}
+
+static inline int ghes_edac_register(struct ghes *ghes, struct device *dev)
+{
+	return 0;
+}
+
+static inline void ghes_edac_unregister(struct ghes *ghes)
+{
+}
+#endif
-- 
1.8.1.2

