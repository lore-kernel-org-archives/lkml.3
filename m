Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaGJVvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:51:03 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62696 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaGJVvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:51:00 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 07/83] drm/radeon: Add kfd-->kgd interface of locking srbm_gfx_cntl register
Date: Fri, 11 Jul 2014 00:50:07 +0300
Message-Id: <1405029027-6085-6-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new interface to kfd2kgd_calls structure, which
allows the kfd to lock and unlock the srbm_gfx_cntl register

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/radeon_kfd.c | 20 ++++++++++++++++++++
 include/linux/radeon_kfd.h          |  4 ++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
index 66ee36b..594020e 100644
--- a/drivers/gpu/drm/radeon/radeon_kfd.c
+++ b/drivers/gpu/drm/radeon/radeon_kfd.c
@@ -43,6 +43,10 @@ static void unkmap_mem(struct kgd_dev *kgd, struct kgd_mem *mem);
 
 static uint64_t get_vmem_size(struct kgd_dev *kgd);
 
+static void lock_srbm_gfx_cntl(struct kgd_dev *kgd);
+static void unlock_srbm_gfx_cntl(struct kgd_dev *kgd);
+
+
 static const struct kfd2kgd_calls kfd2kgd = {
 	.allocate_mem = allocate_mem,
 	.free_mem = free_mem,
@@ -51,6 +55,8 @@ static const struct kfd2kgd_calls kfd2kgd = {
 	.kmap_mem = kmap_mem,
 	.unkmap_mem = unkmap_mem,
 	.get_vmem_size = get_vmem_size,
+	.lock_srbm_gfx_cntl = lock_srbm_gfx_cntl,
+	.unlock_srbm_gfx_cntl = unlock_srbm_gfx_cntl,
 };
 
 static const struct kgd2kfd_calls *kgd2kfd;
@@ -233,3 +239,17 @@ static uint64_t get_vmem_size(struct kgd_dev *kgd)
 
 	return rdev->mc.real_vram_size;
 }
+
+static void lock_srbm_gfx_cntl(struct kgd_dev *kgd)
+{
+	struct radeon_device *rdev = (struct radeon_device *)kgd;
+
+	mutex_lock(&rdev->srbm_mutex);
+}
+
+static void unlock_srbm_gfx_cntl(struct kgd_dev *kgd)
+{
+	struct radeon_device *rdev = (struct radeon_device *)kgd;
+
+	mutex_unlock(&rdev->srbm_mutex);
+}
diff --git a/include/linux/radeon_kfd.h b/include/linux/radeon_kfd.h
index c7997d4..40b691c 100644
--- a/include/linux/radeon_kfd.h
+++ b/include/linux/radeon_kfd.h
@@ -81,6 +81,10 @@ struct kfd2kgd_calls {
 	void (*unkmap_mem)(struct kgd_dev *kgd, struct kgd_mem *mem);
 
 	uint64_t (*get_vmem_size)(struct kgd_dev *kgd);
+
+	/* SRBM_GFX_CNTL mutex */
+	void (*lock_srbm_gfx_cntl)(struct kgd_dev *kgd);
+	void (*unlock_srbm_gfx_cntl)(struct kgd_dev *kgd);
 };
 
 bool kgd2kfd_init(unsigned interface_version,
-- 
1.9.1

