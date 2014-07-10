Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbaGJV5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:57:08 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:48960 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbaGJV5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:57:00 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 65/83] hsa/radeon: fixing a bug to support 32b processes
Date: Fri, 11 Jul 2014 00:54:21 +0300
Message-Id: <1405029279-6894-37-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

This commit is a bug fix for 32b hsa processes support

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/cik_regs.h                 | 1 +
 drivers/gpu/hsa/radeon/kfd_device_queue_manager.c | 8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/cik_regs.h b/drivers/gpu/hsa/radeon/cik_regs.h
index fa5ec01..a6404e3 100644
--- a/drivers/gpu/hsa/radeon/cik_regs.h
+++ b/drivers/gpu/hsa/radeon/cik_regs.h
@@ -45,6 +45,7 @@
 /* if PTR32, this is the upper limit of GPUVM */
 #define	SH_MEM_CONFIG					0x8C34
 #define	PTR32						(1 << 0)
+#define PRIVATE_ATC					(1 << 1)
 #define	ALIGNMENT_MODE(x)				((x) << 2)
 #define	SH_MEM_ALIGNMENT_MODE_DWORD			0
 #define	SH_MEM_ALIGNMENT_MODE_DWORD_STRICT		1
diff --git a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
index 01573b1..3e1def1 100644
--- a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
@@ -90,15 +90,17 @@ static void init_process_memory(struct device_queue_manager *dqm, struct qcm_pro
 	if (qpd->pqm->process->is_32bit_user_mode) {
 		temp = get_sh_mem_bases_32(qpd->pqm->process, dqm->dev);
 		qpd->sh_mem_bases = SHARED_BASE(temp);
+		qpd->sh_mem_config = PTR32;
 	} else {
 		temp = get_sh_mem_bases_nybble_64(qpd->pqm->process, dqm->dev);
 		qpd->sh_mem_bases = compute_sh_mem_bases_64bit(temp);
+		qpd->sh_mem_config = 0;
 	}
 
-	qpd->sh_mem_config = ALIGNMENT_MODE(SH_MEM_ALIGNMENT_MODE_UNALIGNED);
+	qpd->sh_mem_config |= ALIGNMENT_MODE(SH_MEM_ALIGNMENT_MODE_UNALIGNED);
 	qpd->sh_mem_config |= DEFAULT_MTYPE(MTYPE_NONCACHED);
 	qpd->sh_mem_ape1_limit = 0;
-	qpd->sh_mem_ape1_base = 1;
+	qpd->sh_mem_ape1_base = 0;
 
 	pr_debug("kfd: is32bit process: %d sh_mem_bases nybble: 0x%X and register 0x%X\n",
 		qpd->pqm->process->is_32bit_user_mode, temp, qpd->sh_mem_bases);
@@ -854,7 +856,7 @@ static int execute_queues_cpsch(struct device_queue_manager *dqm)
 	}
 
 	if (dqm->queue_count <= 0 || dqm->processes_count <= 0)
-				return 0;
+		return 0;
 
 	mutex_lock(&dqm->lock);
 	if (dqm->active_runlist) {
-- 
1.9.1

