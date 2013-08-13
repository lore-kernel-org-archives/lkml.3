Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901Ab3HMQKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:10:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18888 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758599Ab3HMP62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:28 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=27uUvzbNmKoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ocL_Gc5yQ2MA:10 a=20KFwNOVAAAA:8 a=SOq6UgPBAAAA:8 a=VwQbUJbxAAAA:8 a=zd2uoN0lAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=jEp0ucaQiEUA:10 a=5y_flRe8UpcA:10 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155824.929045650@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jerome Glisse <jglisse@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [08/88] drm/radeon: update lockup tracking when scheduling in empty ring
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0008-drm-radeon-update-lockup-tracking-when-scheduling-in.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

[ Upstream commit 8444d5c69549aa0f0b574cc608742d4669e1cc01 ]

There might be issue with lockup detection when scheduling on an
empty ring that have been sitting idle for a while. Thus update
the lockup tracking data when scheduling new work in an empty ring.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Tested-by: Andy Lutomirski <luto@amacapital.net>
Cc: stable@vger.kernel.org
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/radeon_ring.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index f2017fc..69ffa29 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -366,6 +366,13 @@ int radeon_ring_alloc(struct radeon_device *rdev, struct radeon_ring *ring, unsi
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
1.7.10.4


