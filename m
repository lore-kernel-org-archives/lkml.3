Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaGJV4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:56:54 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:51082 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaGJV4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:56:52 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 62/83] hsa/radeon: Fix timeout calculation in sync_with_hw
Date: Fri, 11 Jul 2014 00:54:18 +0300
Message-Id: <1405029279-6894-34-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug in the timeout calculation done in sync_with_hw
functions. The original code assumed that jiffies is incremented in ms.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_kernel_queue.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_kernel_queue.c b/drivers/gpu/hsa/radeon/kfd_kernel_queue.c
index 25528b3..ce3261b 100644
--- a/drivers/gpu/hsa/radeon/kfd_kernel_queue.c
+++ b/drivers/gpu/hsa/radeon/kfd_kernel_queue.c
@@ -222,12 +222,18 @@ static void submit_packet(struct kernel_queue *kq)
 
 static int sync_with_hw(struct kernel_queue *kq, unsigned long timeout_ms)
 {
+	unsigned long org_timeout_ms;
+
 	BUG_ON(!kq);
-	timeout_ms += jiffies;
+
+	org_timeout_ms = timeout_ms;
+	timeout_ms += jiffies * 1000 / HZ;
 	while (*kq->wptr_kernel != *kq->rptr_kernel) {
-		if (time_after(jiffies, timeout_ms)) {
-			pr_err("kfd: kernel_queue %s timeout expired %lu\n", __func__, timeout_ms);
-			pr_err("kfd: wptr: %d rptr: %d\n", *kq->wptr_kernel, *kq->rptr_kernel);
+		if (time_after(jiffies * 1000 / HZ, timeout_ms)) {
+			pr_err("kfd: kernel_queue %s timeout expired %lu\n",
+				__func__, org_timeout_ms);
+			pr_err("kfd: wptr: %d rptr: %d\n",
+				*kq->wptr_kernel, *kq->rptr_kernel);
 			return -ETIME;
 		}
 		cpu_relax();
-- 
1.9.1

