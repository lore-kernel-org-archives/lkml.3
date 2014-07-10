Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbaGJWEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:04:31 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39348 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaGJV4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:56:30 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 56/83] hsa/radeon: Queue Management integration with Memory Management
Date: Fri, 11 Jul 2014 00:54:12 +0300
Message-Id: <1405029279-6894-28-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

This patch adding support for LDS aperture for user processes.

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_device_queue_manager.c | 41 +++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
index c2d91c9..01573b1 100644
--- a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
@@ -58,16 +58,50 @@ static inline unsigned int get_pipes_num_cpsch(void)
 	return PIPE_PER_ME_CP_SCHEDULING - 1;
 }
 
+static unsigned int get_sh_mem_bases_nybble_64(struct kfd_process *process, struct kfd_dev *dev)
+{
+	struct kfd_process_device *pdd;
+	uint32_t nybble;
+
+	pdd = radeon_kfd_get_process_device_data(dev, process);
+	nybble = (pdd->lds_base >> 60) & 0x0E;
+
+	return nybble;
+
+}
+
+static unsigned int get_sh_mem_bases_32(struct kfd_process *process, struct kfd_dev *dev)
+{
+	struct kfd_process_device *pdd;
+	unsigned int shared_base;
+
+	pdd = radeon_kfd_get_process_device_data(dev, process);
+	shared_base = (pdd->lds_base >> 16) & 0xFF;
+
+	return shared_base;
+}
+
 static uint32_t compute_sh_mem_bases_64bit(unsigned int top_address_nybble);
 static void init_process_memory(struct device_queue_manager *dqm, struct qcm_process_device *qpd)
 {
+	unsigned int temp;
 	BUG_ON(!dqm || !qpd);
 
+	if (qpd->pqm->process->is_32bit_user_mode) {
+		temp = get_sh_mem_bases_32(qpd->pqm->process, dqm->dev);
+		qpd->sh_mem_bases = SHARED_BASE(temp);
+	} else {
+		temp = get_sh_mem_bases_nybble_64(qpd->pqm->process, dqm->dev);
+		qpd->sh_mem_bases = compute_sh_mem_bases_64bit(temp);
+	}
+
 	qpd->sh_mem_config = ALIGNMENT_MODE(SH_MEM_ALIGNMENT_MODE_UNALIGNED);
 	qpd->sh_mem_config |= DEFAULT_MTYPE(MTYPE_NONCACHED);
-	qpd->sh_mem_bases = compute_sh_mem_bases_64bit(6);
 	qpd->sh_mem_ape1_limit = 0;
 	qpd->sh_mem_ape1_base = 1;
+
+	pr_debug("kfd: is32bit process: %d sh_mem_bases nybble: 0x%X and register 0x%X\n",
+		qpd->pqm->process->is_32bit_user_mode, temp, qpd->sh_mem_bases);
 }
 
 static void program_sh_mem_settings(struct device_queue_manager *dqm, struct qcm_process_device *qpd)
@@ -84,6 +118,7 @@ static void program_sh_mem_settings(struct device_queue_manager *dqm, struct qcm
 
 	WRITE_REG(dqm->dev, SH_MEM_APE1_BASE, qpd->sh_mem_ape1_base);
 	WRITE_REG(dqm->dev, SH_MEM_APE1_LIMIT, qpd->sh_mem_ape1_limit);
+	WRITE_REG(dqm->dev, SH_MEM_BASES, qpd->sh_mem_bases);
 
 	mqd->release_hqd(mqd);
 }
@@ -128,6 +163,8 @@ static int create_queue_nocpsch(struct device_queue_manager *dqm, struct queue *
 		set_pasid_vmid_mapping(dqm, q->process->pasid, q->properties.vmid);
 		qpd->vmid = *allocate_vmid;
 		is_new_vmid = true;
+
+		program_sh_mem_settings(dqm, qpd);
 	}
 	q->properties.vmid = qpd->vmid;
 
@@ -418,7 +455,7 @@ static uint32_t compute_sh_mem_bases_64bit(unsigned int top_address_nybble)
 	 * We don't bother to support different top nybbles for LDS/Scratch and GPUVM.
 	 */
 
-	BUG_ON((top_address_nybble & 1) || top_address_nybble > 0xE);
+	BUG_ON((top_address_nybble & 1) || top_address_nybble > 0xE || top_address_nybble == 0);
 
 	return PRIVATE_BASE(top_address_nybble << 12) | SHARED_BASE(top_address_nybble << 12);
 }
-- 
1.9.1

