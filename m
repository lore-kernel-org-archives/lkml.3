Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbaGJWJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:09:59 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:55253 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbaGJVyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:54:53 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 31/83] drm/radeon: extending kfd-kgd interface
Date: Fri, 11 Jul 2014 00:53:47 +0300
Message-Id: <1405029279-6894-3-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeny Pinchuk <evgeny.pinchuk@amd.com>

Adding API for KFD to be able to query the GPU clock counter.

Signed-off-by: Evgeny Pinchuk <evgeny.pinchuk@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/radeon_kfd.c | 9 +++++++++
 include/linux/radeon_kfd.h          | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
index f4cc3c5..121e67b 100644
--- a/drivers/gpu/drm/radeon/radeon_kfd.c
+++ b/drivers/gpu/drm/radeon/radeon_kfd.c
@@ -42,6 +42,7 @@ static int kmap_mem(struct kgd_dev *kgd, struct kgd_mem *mem, void **ptr);
 static void unkmap_mem(struct kgd_dev *kgd, struct kgd_mem *mem);
 
 static uint64_t get_vmem_size(struct kgd_dev *kgd);
+static uint64_t get_gpu_clock_counter(struct kgd_dev *kgd);
 
 static void lock_srbm_gfx_cntl(struct kgd_dev *kgd);
 static void unlock_srbm_gfx_cntl(struct kgd_dev *kgd);
@@ -55,6 +56,7 @@ static const struct kfd2kgd_calls kfd2kgd = {
 	.kmap_mem = kmap_mem,
 	.unkmap_mem = unkmap_mem,
 	.get_vmem_size = get_vmem_size,
+	.get_gpu_clock_counter = get_gpu_clock_counter,
 	.lock_srbm_gfx_cntl = lock_srbm_gfx_cntl,
 	.unlock_srbm_gfx_cntl = unlock_srbm_gfx_cntl,
 };
@@ -275,3 +277,10 @@ static void unlock_srbm_gfx_cntl(struct kgd_dev *kgd)
 
 	mutex_unlock(&rdev->srbm_mutex);
 }
+
+static uint64_t get_gpu_clock_counter(struct kgd_dev *kgd)
+{
+	struct radeon_device *rdev = (struct radeon_device *)kgd;
+
+	return rdev->asic->get_gpu_clock_counter(rdev);
+}
diff --git a/include/linux/radeon_kfd.h b/include/linux/radeon_kfd.h
index 63b7bac..fcb6c7a 100644
--- a/include/linux/radeon_kfd.h
+++ b/include/linux/radeon_kfd.h
@@ -84,6 +84,7 @@ struct kfd2kgd_calls {
 	void (*unkmap_mem)(struct kgd_dev *kgd, struct kgd_mem *mem);
 
 	uint64_t (*get_vmem_size)(struct kgd_dev *kgd);
+	uint64_t (*get_gpu_clock_counter)(struct kgd_dev *kgd);
 
 	/* SRBM_GFX_CNTL mutex */
 	void (*lock_srbm_gfx_cntl)(struct kgd_dev *kgd);
-- 
1.9.1

