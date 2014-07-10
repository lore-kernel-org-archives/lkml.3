Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaGJV7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:59:49 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62800 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbaGJV51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:57:27 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 75/83] hsa/radeon: Fixing minor issues with kernel queues (DIQ)
Date: Fri, 11 Jul 2014 00:54:31 +0300
Message-Id: <1405029279-6894-47-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

* re-execute runlist on kernel queues destruction.
* delete kernel queues from pqm's queues list on pqm unint

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_device_queue_manager.c  | 4 ++++
 drivers/gpu/hsa/radeon/kfd_process_queue_manager.c | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
index 4c53e57..12b8b33 100644
--- a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
@@ -759,6 +759,10 @@ static void destroy_kernel_queue_cpsch(struct device_queue_manager *dqm,
 {
 	BUG_ON(!dqm || !kq);
 
+	pr_debug("kfd: In %s\n", __func__);
+
+	dqm->destroy_queues(dqm);
+
 	mutex_lock(&dqm->lock);
 	list_del(&kq->list);
 	dqm->queue_count--;
diff --git a/drivers/gpu/hsa/radeon/kfd_process_queue_manager.c b/drivers/gpu/hsa/radeon/kfd_process_queue_manager.c
index 89461ab..5d7c46d 100644
--- a/drivers/gpu/hsa/radeon/kfd_process_queue_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_process_queue_manager.c
@@ -273,10 +273,10 @@ int pqm_destroy_queue(struct process_queue_manager *pqm, unsigned int qid)
 		if (retval != 0)
 			return retval;
 
-		list_del(&pqn->process_queue_list);
 		uninit_queue(pqn->q);
 	}
 
+	list_del(&pqn->process_queue_list);
 	kfree(pqn);
 	clear_bit(qid, pqm->queue_slot_bitmap);
 
-- 
1.9.1

