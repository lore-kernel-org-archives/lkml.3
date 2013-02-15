Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935997Ab3BOMpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:45:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935977Ab3BOMp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 06/13] ghes_edac: Allow registering more than once
Date: Fri, 15 Feb 2013 10:44:54 -0200
Message-Id: <743f00a375a5578041459edff2c511263f710178.1360931635.git.mchehab@redhat.com>
In-Reply-To: <cover.1360931635.git.mchehab@redhat.com>
References: <cover.1360931635.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was expecting that the GHES register call would happen only
once, but it is registered once per-cpu. So, we need to create
several memory controllers, one by cpu.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/ghes_edac.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index 6952bdf..1badac6 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -5,6 +5,9 @@
 #define GHES_PFX   "ghes_edac: "
 #define GHES_EDAC_REVISION " Ver: 1.0.0"
 
+static DEFINE_MUTEX(ghes_edac_lock);
+static int ghes_edac_mc_num;
+
 void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
                                struct cper_sec_mem_err *mem_err)
 {
@@ -22,9 +25,16 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 	layers[0].type = EDAC_MC_LAYER_ALL_MEM;
 	layers[0].size = 1;
 	layers[0].is_virt_csrow = true;
-	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, 0);
+
+	/*
+	 * We need to serialize edac_mc_alloc() and edac_mc_add_mc(),
+	 * to avoid duplicated memory controller numbers
+	 */
+	mutex_lock(&ghes_edac_lock);
+	mci = edac_mc_alloc(ghes_edac_mc_num, ARRAY_SIZE(layers), layers, 0);
 	if (!mci) {
 		pr_info(GHES_PFX "Can't allocate memory for EDAC data\n");
+		mutex_unlock(&ghes_edac_lock);
 		return -ENOMEM;
 	}
 
@@ -53,11 +63,14 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 	if (rc < 0) {
 		pr_info(GHES_PFX "Can't register at EDAC core\n");
 		edac_mc_free(mci);
-
+		mutex_unlock(&ghes_edac_lock);
 		return -ENODEV;
 	}
 
+
 	ghes->mci = mci;
+	ghes_edac_mc_num++;
+	mutex_unlock(&ghes_edac_lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ghes_edac_register);
-- 
1.8.1.2

