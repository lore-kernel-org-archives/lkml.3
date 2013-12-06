Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986Ab3LFOWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:22:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43586 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973Ab3LFM7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:59:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 016/272] drm/radeon/vm: don't attempt to update ptes if ib allocation fails
Date: Fri,  6 Dec 2013 12:55:05 +0000
Message-Id: <1386334761-25517-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4cc948b94a222c310ae089c36718aac7a03aec90 upstream.

If we fail to allocate an indirect buffer (ib) when updating
the ptes, return an error instead of trying to use the ib.
Avoids a null pointer dereference.

Bug:
https://bugzilla.kernel.org/show_bug.cgi?id=58621

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_gart.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
index b990b1a..3b1de72 100644
--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -1156,6 +1156,8 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
 		return -ENOMEM;
 
 	r = radeon_ib_get(rdev, ridx, &ib, NULL, ndw * 4);
+	if (r)
+		return r;
 	ib.length_dw = 0;
 
 	r = radeon_vm_update_pdes(rdev, vm, &ib, bo_va->soffset, bo_va->eoffset);
-- 
1.8.3.2

