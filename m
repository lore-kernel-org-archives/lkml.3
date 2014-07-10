Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbaGJVz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:55:29 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56491 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbaGJVzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:55:22 -0400
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
Subject: [PATCH 39/83] drm/radeon: Extending kfd interface
Date: Fri, 11 Jul 2014 00:53:55 +0300
Message-Id: <1405029279-6894-11-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeny Pinchuk <evgeny.pinchuk@amd.com>

Adding new function to the interface used by kfd.
The new function retrieves the max engine clock speed.

Signed-off-by: Evgeny Pinchuk <evgeny.pinchuk@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/radeon_kfd.c | 11 +++++++++++
 include/linux/radeon_kfd.h          |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
index 6dba170..8b6d497 100644
--- a/drivers/gpu/drm/radeon/radeon_kfd.c
+++ b/drivers/gpu/drm/radeon/radeon_kfd.c
@@ -50,6 +50,8 @@ static void unlock_srbm_gfx_cntl(struct kgd_dev *kgd);
 static void lock_grbm_gfx_idx(struct kgd_dev *kgd);
 static void unlock_grbm_gfx_idx(struct kgd_dev *kgd);
 
+static uint32_t get_max_engine_clock_in_mhz(struct kgd_dev *kgd);
+
 
 static const struct kfd2kgd_calls kfd2kgd = {
 	.allocate_mem = allocate_mem,
@@ -64,6 +66,7 @@ static const struct kfd2kgd_calls kfd2kgd = {
 	.unlock_srbm_gfx_cntl = unlock_srbm_gfx_cntl,
 	.lock_grbm_gfx_idx = lock_grbm_gfx_idx,
 	.unlock_grbm_gfx_idx = unlock_grbm_gfx_idx,
+	.get_max_engine_clock_in_mhz = get_max_engine_clock_in_mhz,
 };
 
 static const struct kgd2kfd_calls *kgd2kfd;
@@ -307,3 +310,11 @@ static uint64_t get_gpu_clock_counter(struct kgd_dev *kgd)
 
 	return rdev->asic->get_gpu_clock_counter(rdev);
 }
+
+static uint32_t get_max_engine_clock_in_mhz(struct kgd_dev *kgd)
+{
+	struct radeon_device *rdev = (struct radeon_device *)kgd;
+
+	/* The sclk is in quantas of 10kHz */
+	return rdev->pm.power_state->clock_info->sclk / 100;
+}
diff --git a/include/linux/radeon_kfd.h b/include/linux/radeon_kfd.h
index 4c7e923..4114c8e 100644
--- a/include/linux/radeon_kfd.h
+++ b/include/linux/radeon_kfd.h
@@ -93,6 +93,8 @@ struct kfd2kgd_calls {
 	/* GRBM_GFX_INDEX mutex */
 	void (*lock_grbm_gfx_idx)(struct kgd_dev *kgd);
 	void (*unlock_grbm_gfx_idx)(struct kgd_dev *kgd);
+
+	uint32_t (*get_max_engine_clock_in_mhz)(struct kgd_dev *kgd);
 };
 
 bool kgd2kfd_init(unsigned interface_version,
-- 
1.9.1

