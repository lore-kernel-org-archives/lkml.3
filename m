Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424Ab3BSSvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:51:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54256 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934089Ab3BSSvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:51:35 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 25/81] drm/radeon: prevent crash in the ring space allocation
Date: Tue, 19 Feb 2013 15:48:48 -0300
Message-Id: <1361299784-8830-26-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit fd5d93a0015ce1a7db881382022b2fcdfdc61760 upstream.

If the requested number of DWs on the ring is larger than
the size of the ring itself, return an error.

In testing with large VM updates, we've seen crashes when we
try and allocate more space on the ring than the total size
of the ring without checking.

This prevents the crash but for large VM updates or bo moves
of very large buffers, we will need to break the transaction
down into multiple batches.  I have patches to use IBs for
the next kernel.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_ring.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index 7843b36..727ebfe 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -219,6 +219,9 @@ int radeon_ring_alloc(struct radeon_device *rdev, struct radeon_ring *ring, unsi
 {
 	int r;
 
+	/* make sure we aren't trying to allocate more space than there is on the ring */
+	if (ndw > (ring->ring_size / 4))
+		return -ENOMEM;
 	/* Align requested size with padding so unlock_commit can
 	 * pad safely */
 	ndw = (ndw + ring->align_mask) & ~ring->align_mask;
-- 
1.7.9.5

