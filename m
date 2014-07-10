Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbaGJV5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:57:24 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34421 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbaGJV5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:57:21 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Yair Shachar <yair.shachar@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 73/83] hsa/radeon: Adding qcm fence return status
Date: Fri, 11 Jul 2014 00:54:29 +0300
Message-Id: <1405029279-6894-45-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yair Shachar <yair.shachar@amd.com>

Waiting on fence returns status

Signed-off-by: Yair Shachar <yair.shachar@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_device_queue_manager.c | 6 ++++--
 drivers/gpu/hsa/radeon/kfd_priv.h                 | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
index 4931f8a..4c53e57 100644
--- a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
@@ -800,7 +800,7 @@ out:
 	return retval;
 }
 
-static void fence_wait_timeout(unsigned int *fence_addr, unsigned int fence_value, unsigned long timeout)
+int fence_wait_timeout(unsigned int *fence_addr, unsigned int fence_value, unsigned long timeout)
 {
 	BUG_ON(!fence_addr);
 	timeout += jiffies;
@@ -808,10 +808,12 @@ static void fence_wait_timeout(unsigned int *fence_addr, unsigned int fence_valu
 	while (*fence_addr != fence_value) {
 		if (time_after(jiffies, timeout)) {
 			pr_err("kfd: qcm fence wait loop timeout expired\n");
-			break;
+			return -ETIME;
 		}
 		cpu_relax();
 	}
+
+	return 0;
 }
 
 static int destroy_queues_cpsch(struct device_queue_manager *dqm)
diff --git a/drivers/gpu/hsa/radeon/kfd_priv.h b/drivers/gpu/hsa/radeon/kfd_priv.h
index 97bf58a..b61187a 100644
--- a/drivers/gpu/hsa/radeon/kfd_priv.h
+++ b/drivers/gpu/hsa/radeon/kfd_priv.h
@@ -463,6 +463,8 @@ int pqm_update_queue(struct process_queue_manager *pqm, unsigned int qid, struct
 struct kernel_queue *pqm_get_kernel_queue(struct process_queue_manager *pqm, unsigned int qid);
 void test_diq(struct kfd_dev *dev, struct process_queue_manager *pqm);
 
+int fence_wait_timeout(unsigned int *fence_addr, unsigned int fence_value, unsigned long timeout);
+
 /* Packet Manager */
 
 #define KFD_HIQ_TIMEOUT (500)
-- 
1.9.1

