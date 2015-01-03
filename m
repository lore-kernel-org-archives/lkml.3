Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbbACXbo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 18:31:44 -0500
Received: from mail.ispras.ru ([83.149.199.45]:50957 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbbACXbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 18:31:43 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] drm/radeon: do not left queue acquired if timeout happens in kgd_hqd_destroy()
Date: Sun,  4 Jan 2015 02:31:20 +0300
Message-Id: <1420327880-25415-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If timeout happens, kgd_hqd_destroy() just returns -ETIME leaving queue acquired.
It may cause a deadlock, so the patch proposes to release queue before return.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/gpu/drm/radeon/radeon_kfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
index 242fd8b1b221..335e29dbab05 100644
--- a/drivers/gpu/drm/radeon/radeon_kfd.c
+++ b/drivers/gpu/drm/radeon/radeon_kfd.c
@@ -556,6 +556,7 @@ static int kgd_hqd_destroy(struct kgd_dev *kgd, uint32_t reset_type,
 		if (timeout == 0) {
 			pr_err("kfd: cp queue preemption time out (%dms)\n",
 				temp);
+			release_queue(kgd);
 			return -ETIME;
 		}
 		msleep(20);
-- 
1.9.1

