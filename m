Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbaGJV5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:57:00 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:45565 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbaGJV45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:56:57 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 64/83] hsa/radeon: update queue fault handling
Date: Fri, 11 Jul 2014 00:54:20 +0300
Message-Id: <1405029279-6894-36-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

This commit adding fault handling for process queue manager update queue

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_process_queue_manager.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_process_queue_manager.c b/drivers/gpu/hsa/radeon/kfd_process_queue_manager.c
index fe74dd7..2034d2b 100644
--- a/drivers/gpu/hsa/radeon/kfd_process_queue_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_process_queue_manager.c
@@ -334,6 +334,7 @@ int pqm_destroy_queue(struct process_queue_manager *pqm, unsigned int qid)
 
 int pqm_update_queue(struct process_queue_manager *pqm, unsigned int qid, struct queue_properties *p)
 {
+	int retval;
 	struct process_queue_node *pqn;
 
 	BUG_ON(!pqm);
@@ -346,9 +347,17 @@ int pqm_update_queue(struct process_queue_manager *pqm, unsigned int qid, struct
 	pqn->q->properties.queue_percent = p->queue_percent;
 	pqn->q->properties.priority = p->priority;
 
-	pqn->q->device->dqm->destroy_queues(pqn->q->device->dqm);
-	pqn->q->device->dqm->update_queue(pqn->q->device->dqm, pqn->q);
-	pqn->q->device->dqm->execute_queues(pqn->q->device->dqm);
+	retval = pqn->q->device->dqm->destroy_queues(pqn->q->device->dqm);
+	if (retval != 0)
+		return retval;
+
+	retval = pqn->q->device->dqm->update_queue(pqn->q->device->dqm, pqn->q);
+	if (retval != 0)
+		return retval;
+
+	retval = pqn->q->device->dqm->execute_queues(pqn->q->device->dqm);
+	if (retval != 0)
+		return retval;
 
 	return 0;
 }
-- 
1.9.1

