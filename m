Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaGJVux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:50:53 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:40483 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbaGJVuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:50:51 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 05/83] drm/radeon: Add kfd-->kgd interface to get virtual ram size
Date: Fri, 11 Jul 2014 00:50:05 +0300
Message-Id: <1405029027-6085-4-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new interface to kfd2kgd_calls structure so that
the kfd driver could get the virtual ram size of a specific
radeon device.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/radeon_kfd.c | 12 ++++++++++++
 include/linux/radeon_kfd.h          |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
index 7c7f808..1b859b5 100644
--- a/drivers/gpu/drm/radeon/radeon_kfd.c
+++ b/drivers/gpu/drm/radeon/radeon_kfd.c
@@ -25,7 +25,10 @@
 #include <drm/drmP.h>
 #include "radeon.h"
 
+static uint64_t get_vmem_size(struct kgd_dev *kgd);
+
 static const struct kfd2kgd_calls kfd2kgd = {
+	.get_vmem_size = get_vmem_size,
 };
 
 static const struct kgd2kfd_calls *kgd2kfd;
@@ -92,3 +95,12 @@ void radeon_kfd_device_fini(struct radeon_device *rdev)
 		rdev->kfd = NULL;
 	}
 }
+
+static uint64_t get_vmem_size(struct kgd_dev *kgd)
+{
+	struct radeon_device *rdev = (struct radeon_device *)kgd;
+
+	BUG_ON(kgd == NULL);
+
+	return rdev->mc.real_vram_size;
+}
diff --git a/include/linux/radeon_kfd.h b/include/linux/radeon_kfd.h
index 59785e9..28cddf5 100644
--- a/include/linux/radeon_kfd.h
+++ b/include/linux/radeon_kfd.h
@@ -57,6 +57,7 @@ struct kgd2kfd_calls {
 };
 
 struct kfd2kgd_calls {
+	uint64_t (*get_vmem_size)(struct kgd_dev *kgd);
 };
 
 bool kgd2kfd_init(unsigned interface_version,
-- 
1.9.1

