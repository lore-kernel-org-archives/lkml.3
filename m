Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab3HMQLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:11:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4969 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758597Ab3HMP61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:27 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=O60dzJiuj78A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=SXyxDdgiApYA:10 a=zd2uoN0lAAAA:8 a=VwQbUJbxAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155824.766256836@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Subject: [07/88] drm/radeon: prevent crash in the ring space allocation
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0007-drm-radeon-prevent-crash-in-the-ring-space-allocatio.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit fd5d93a0015ce1a7db881382022b2fcdfdc61760 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/radeon_ring.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index 43c431a..f2017fc 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -361,6 +361,9 @@ int radeon_ring_alloc(struct radeon_device *rdev, struct radeon_ring *ring, unsi
 {
 	int r;
 
+	/* make sure we aren't trying to allocate more space than there is on the ring */
+	if (ndw > (ring->ring_size / 4))
+		return -ENOMEM;
 	/* Align requested size with padding so unlock_commit can
 	 * pad safely */
 	ndw = (ndw + ring->align_mask) & ~ring->align_mask;
-- 
1.7.10.4


