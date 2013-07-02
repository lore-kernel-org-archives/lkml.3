Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3GBLIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:08:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36289 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab3GBLI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 32/50] drm/radeon: update lockup tracking when scheduling in empty ring
Date: Tue,  2 Jul 2013 12:07:20 +0100
Message-Id: <1372763258-20664-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 8444d5c69549aa0f0b574cc608742d4669e1cc01 upstream.

There might be issue with lockup detection when scheduling on an
empty ring that have been sitting idle for a while. Thus update
the lockup tracking data when scheduling new work in an empty ring.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Tested-by: Andy Lutomirski <luto@amacapital.net>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_ring.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index 727ebfe..03c203f 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -224,6 +224,13 @@ int radeon_ring_alloc(struct radeon_device *rdev, struct radeon_ring *ring, unsi
 		return -ENOMEM;
 	/* Align requested size with padding so unlock_commit can
 	 * pad safely */
+	radeon_ring_free_size(rdev, ring);
+	if (ring->ring_free_dw == (ring->ring_size / 4)) {
+		/* This is an empty ring update lockup info to avoid
+		 * false positive.
+		 */
+		radeon_ring_lockup_update(ring);
+	}
 	ndw = (ndw + ring->align_mask) & ~ring->align_mask;
 	while (ndw > (ring->ring_free_dw - 1)) {
 		radeon_ring_free_size(rdev, ring);
-- 
1.8.1.2

