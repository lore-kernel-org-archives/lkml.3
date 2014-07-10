Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaGJVwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:52:10 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:50556 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbaGJVwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:52:04 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 18/83] hsa/radeon: Enable interrupts in KFD scheduler
Date: Fri, 11 Jul 2014 00:50:18 +0300
Message-Id: <1405029027-6085-17-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the use of interrupts in the KFD scheduler when the
scheduler performs its initialization.

It also disables the interrupts when the scheduler stops its work.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_sched_cik_static.c | 28 +++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c b/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
index 5d42e88..9add5e5 100644
--- a/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
+++ b/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
@@ -486,6 +486,32 @@ static void cik_static_destroy(struct kfd_scheduler *scheduler)
 	kfree(priv);
 }
 
+static void
+enable_interrupts(struct cik_static_private *priv)
+{
+	unsigned int i;
+
+	lock_srbm_index(priv);
+	for (i = 0; i < priv->num_pipes; i++) {
+		pipe_select(priv, i);
+		WRITE_REG(priv->dev, CPC_INT_CNTL, DEQUEUE_REQUEST_INT_ENABLE);
+	}
+	unlock_srbm_index(priv);
+}
+
+static void
+disable_interrupts(struct cik_static_private *priv)
+{
+	unsigned int i;
+
+	lock_srbm_index(priv);
+	for (i = 0; i < priv->num_pipes; i++) {
+		pipe_select(priv, i);
+		WRITE_REG(priv->dev, CPC_INT_CNTL, 0);
+	}
+	unlock_srbm_index(priv);
+}
+
 static void cik_static_start(struct kfd_scheduler *scheduler)
 {
 	struct cik_static_private *priv = kfd_scheduler_to_private(scheduler);
@@ -495,6 +521,7 @@ static void cik_static_start(struct kfd_scheduler *scheduler)
 
 	init_pipes(priv);
 	init_ats(priv);
+	enable_interrupts(priv);
 }
 
 static void cik_static_stop(struct kfd_scheduler *scheduler)
@@ -502,6 +529,7 @@ static void cik_static_stop(struct kfd_scheduler *scheduler)
 	struct cik_static_private *priv = kfd_scheduler_to_private(scheduler);
 
 	exit_ats(priv);
+	disable_interrupts(priv);
 
 	radeon_kfd_vidmem_ungpumap(priv->dev, priv->hpd_mem);
 	radeon_kfd_vidmem_ungpumap(priv->dev, priv->mqd_mem);
-- 
1.9.1

