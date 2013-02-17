Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3BQWzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:55:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45584 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754302Ab3BQWy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:54:56 -0500
Message-Id: <20130217225003.539234343@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:17 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Alex Deucher <alexander.deucher@amd.com>
Subject: [ 16/66] drm/radeon: prevent crash in the ring space allocation
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: use rdev->cp.ring_size instead of ring->ring_size]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_ring.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -306,6 +306,9 @@ int radeon_ring_alloc(struct radeon_devi
 {
 	int r;
 
+	/* make sure we aren't trying to allocate more space than there is on the ring */
+	if (ndw > (rdev->cp.ring_size / 4))
+		return -ENOMEM;
 	/* Align requested size with padding so unlock_commit can
 	 * pad safely */
 	ndw = (ndw + rdev->cp.align_mask) & ~rdev->cp.align_mask;


