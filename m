Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394Ab3BHA5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:57:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759112Ab3BHA5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 09/34] drm/radeon: prevent crash in the ring space allocation
Date: Thu,  7 Feb 2013 16:57:05 -0800
Message-Id: <20130208004629.044380677@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.375461662@linuxfoundation.org>
References: <20130208004627.375461662@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_ring.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -377,6 +377,9 @@ int radeon_ring_alloc(struct radeon_devi
 {
 	int r;
 
+	/* make sure we aren't trying to allocate more space than there is on the ring */
+	if (ndw > (ring->ring_size / 4))
+		return -ENOMEM;
 	/* Align requested size with padding so unlock_commit can
 	 * pad safely */
 	ndw = (ndw + ring->align_mask) & ~ring->align_mask;


