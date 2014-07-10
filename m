Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaGJWBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:01:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53214 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbaGJV5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:57:11 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 69/83] hsa/radeon: Fix initialization of sh_mem registers
Date: Fri, 11 Jul 2014 00:54:25 +0300
Message-Id: <1405029279-6894-41-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug in the code flow that caused an override of the sh_mem
registers.
The bug resulted in sh_mem registers being not initialized properly and
overwrite over sh_mem registers for vmid 0 (which is a vmid of non-HSA processes).

Reviewed-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_device_queue_manager.c | 48 ++++++++++++-----------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
index 5ec8da7..56875f9 100644
--- a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
@@ -87,21 +87,25 @@ static void init_process_memory(struct device_queue_manager *dqm, struct qcm_pro
 	unsigned int temp;
 	BUG_ON(!dqm || !qpd);
 
+	/* check if sh_mem_config register already configured */
+	if (qpd->sh_mem_config == 0) {
+		qpd->sh_mem_config =
+			ALIGNMENT_MODE(SH_MEM_ALIGNMENT_MODE_UNALIGNED) |
+			DEFAULT_MTYPE(MTYPE_NONCACHED) |
+			APE1_MTYPE(MTYPE_NONCACHED);
+		qpd->sh_mem_ape1_limit = 0;
+		qpd->sh_mem_ape1_base = 0;
+	}
+
 	if (qpd->pqm->process->is_32bit_user_mode) {
 		temp = get_sh_mem_bases_32(qpd->pqm->process, dqm->dev);
 		qpd->sh_mem_bases = SHARED_BASE(temp);
-		qpd->sh_mem_config = PTR32;
+		qpd->sh_mem_config |= PTR32;
 	} else {
 		temp = get_sh_mem_bases_nybble_64(qpd->pqm->process, dqm->dev);
 		qpd->sh_mem_bases = compute_sh_mem_bases_64bit(temp);
-		qpd->sh_mem_config = 0;
 	}
 
-	qpd->sh_mem_config |= ALIGNMENT_MODE(SH_MEM_ALIGNMENT_MODE_UNALIGNED);
-	qpd->sh_mem_config |= DEFAULT_MTYPE(MTYPE_NONCACHED);
-	qpd->sh_mem_ape1_limit = 0;
-	qpd->sh_mem_ape1_base = 0;
-
 	pr_debug("kfd: is32bit process: %d sh_mem_bases nybble: 0x%X and register 0x%X\n",
 		qpd->pqm->process->is_32bit_user_mode, temp, qpd->sh_mem_bases);
 }
@@ -110,6 +114,8 @@ static void program_sh_mem_settings(struct device_queue_manager *dqm, struct qcm
 {
 	struct mqd_manager *mqd;
 
+	BUG_ON(qpd->vmid < KFD_VMID_START_OFFSET);
+
 	mqd = dqm->get_mqd_manager(dqm, KFD_MQD_TYPE_CIK_COMPUTE);
 	if (mqd == NULL)
 		return;
@@ -139,12 +145,6 @@ static int create_queue_nocpsch(struct device_queue_manager *dqm, struct queue *
 	print_queue(q);
 
 	mutex_lock(&dqm->lock);
-	/* later memory apertures should be initialized in lazy mode */
-	if (!is_mem_initialized)
-		if (init_memory(dqm) != 0) {
-			retval = -ENODATA;
-			goto init_memory_failed;
-		}
 
 	if (dqm->vmid_bitmap == 0 && qpd->vmid == 0) {
 		retval = -ENOMEM;
@@ -217,7 +217,6 @@ no_hqd:
 		*allocate_vmid = qpd->vmid = q->properties.vmid = 0;
 	}
 no_vmid:
-init_memory_failed:
 	mutex_unlock(&dqm->lock);
 	return retval;
 }
@@ -951,20 +950,25 @@ static bool set_cache_memory_policy(struct device_queue_manager *dqm,
 		qpd->sh_mem_ape1_limit = limit >> 16;
 	}
 
-	default_mtype = (default_policy == cache_policy_coherent) ? MTYPE_NONCACHED : MTYPE_CACHED;
-	ape1_mtype = (alternate_policy == cache_policy_coherent) ? MTYPE_NONCACHED : MTYPE_CACHED;
+	default_mtype = (default_policy == cache_policy_coherent) ?
+			MTYPE_NONCACHED :
+			MTYPE_CACHED;
+
+	ape1_mtype = (alternate_policy == cache_policy_coherent) ?
+			MTYPE_NONCACHED :
+			MTYPE_CACHED;
 
-	qpd->sh_mem_config = ALIGNMENT_MODE(SH_MEM_ALIGNMENT_MODE_UNALIGNED)
+	qpd->sh_mem_config = (qpd->sh_mem_config & PTR32)
+			| ALIGNMENT_MODE(SH_MEM_ALIGNMENT_MODE_UNALIGNED)
 			| DEFAULT_MTYPE(default_mtype)
 			| APE1_MTYPE(ape1_mtype);
 
-
-	if (sched_policy == KFD_SCHED_POLICY_NO_HWS)
+	if ((sched_policy == KFD_SCHED_POLICY_NO_HWS) && (qpd->vmid != 0))
 		program_sh_mem_settings(dqm, qpd);
 
-
-	pr_debug("kfd: sh_mem_config: 0x%x, ape1_base: 0x%x, ape1_limit: 0x%x\n", qpd->sh_mem_config,
-		 qpd->sh_mem_ape1_base, qpd->sh_mem_ape1_limit);
+	pr_debug("kfd: sh_mem_config: 0x%x, ape1_base: 0x%x, ape1_limit: 0x%x\n",
+		qpd->sh_mem_config, qpd->sh_mem_ape1_base,
+		qpd->sh_mem_ape1_limit);
 
 	mutex_unlock(&dqm->lock);
 	return true;
-- 
1.9.1

