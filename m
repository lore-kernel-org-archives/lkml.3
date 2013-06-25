Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab3FYTGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:06:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab3FYSdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jerome Glisse <jglisse@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 38/95] drm/radeon: update lockup tracking when scheduling in empty ring
Date: Tue, 25 Jun 2013 11:32:25 -0700
Message-Id: <20130625182157.952460307@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_ring.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -402,6 +402,13 @@ int radeon_ring_alloc(struct radeon_devi
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


