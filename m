Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbaGJV5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:57:34 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:55784 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbaGJV5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:57:31 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 76/83] hsa/radeon: Check oversubscription before destroying runlist
Date: Fri, 11 Jul 2014 00:54:32 +0300
Message-Id: <1405029279-6894-48-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug when using the mode of CP hardware
scheduling without oversubscription.

The bug was that the oversubscription check was performed
_after_ the current runlist was destroyed, which caused
the current HSA application to stop working.

This patch moves the oversubscription check before the call
to destroy the current runlist. If there is oversubscription,
the function prints an error to dmesg and simply exits.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_packet_manager.c        | 3 ---
 drivers/gpu/hsa/radeon/kfd_process_queue_manager.c | 9 +++++++++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_packet_manager.c b/drivers/gpu/hsa/radeon/kfd_packet_manager.c
index 5cd23b0..0aef907 100644
--- a/drivers/gpu/hsa/radeon/kfd_packet_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_packet_manager.c
@@ -88,9 +88,6 @@ static int pm_allocate_runlist_ib(struct packet_manager *pm, unsigned int **rl_b
 	BUG_ON(is_over_subscription == NULL);
 
 	pm_calc_rlib_size(pm, rl_buffer_size, is_over_subscription);
-	if (*is_over_subscription &&
-			sched_policy == KFD_SCHED_POLICY_HWS_NO_OVERSUBSCRIPTION)
-		return -EFAULT;
 
 	retval = radeon_kfd_vidmem_alloc_map(pm->dqm->dev, &pm->ib_buffer_obj, (void **)rl_buffer,
 					     rl_gpu_buffer, ALIGN(*rl_buffer_size, PAGE_SIZE));
diff --git a/drivers/gpu/hsa/radeon/kfd_process_queue_manager.c b/drivers/gpu/hsa/radeon/kfd_process_queue_manager.c
index 5d7c46d..97b3cc6 100644
--- a/drivers/gpu/hsa/radeon/kfd_process_queue_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_process_queue_manager.c
@@ -174,6 +174,15 @@ int pqm_create_queue(struct process_queue_manager *pqm,
 
 	switch (type) {
 	case KFD_QUEUE_TYPE_COMPUTE:
+		/* check if there is over subscription */
+		if ((sched_policy == KFD_SCHED_POLICY_HWS_NO_OVERSUBSCRIPTION) &&
+		((dev->dqm->processes_count >= VMID_PER_DEVICE) ||
+		(dev->dqm->queue_count >= PIPE_PER_ME_CP_SCHEDULING * QUEUES_PER_PIPE))) {
+			pr_err("kfd: over-subscription is not allowed in radeon_kfd.sched_policy == 1\n");
+			retval = -EPERM;
+			goto err_create_queue;
+		}
+
 		retval = create_cp_queue(pqm, dev, &q, &q_properties, f, *qid);
 		if (retval != 0)
 			goto err_create_queue;
-- 
1.9.1

