Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab3ASBdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:33:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:56379 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107Ab3ASBR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:17:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        CAI Qian <caiqian@redhat.com>
Subject: [ 16/33] drm/radeon: fix NULL pointer dereference in UMS mode
Date: Fri, 18 Jan 2013 17:16:41 -0800
Message-Id: <20130119010351.457566020@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010345.885772698@linuxfoundation.org>
References: <20130119010345.885772698@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilija Hadzic <ihadzic@research.bell-labs.com>

commit ff4bd0827764e10a428a9d39e6814c5478863f94 upstream.

In UMS mode parser->rdev is NULL, so dereferencing
will cause an oops.

Signed-off-by: Ilija Hadzic <ihadzic@research.bell-labs.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_cs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -266,7 +266,7 @@ int radeon_cs_parser_init(struct radeon_
 				  p->chunks[p->chunk_ib_idx].length_dw);
 			return -EINVAL;
 		}
-		if ((p->rdev->flags & RADEON_IS_AGP)) {
+		if (p->rdev && (p->rdev->flags & RADEON_IS_AGP)) {
 			p->chunks[p->chunk_ib_idx].kpage[0] = kmalloc(PAGE_SIZE, GFP_KERNEL);
 			p->chunks[p->chunk_ib_idx].kpage[1] = kmalloc(PAGE_SIZE, GFP_KERNEL);
 			if (p->chunks[p->chunk_ib_idx].kpage[0] == NULL ||
@@ -570,7 +570,8 @@ static int radeon_cs_update_pages(struct
 	struct radeon_cs_chunk *ibc = &p->chunks[p->chunk_ib_idx];
 	int i;
 	int size = PAGE_SIZE;
-	bool copy1 = (p->rdev->flags & RADEON_IS_AGP) ? false : true;
+	bool copy1 = (p->rdev && (p->rdev->flags & RADEON_IS_AGP)) ?
+		false : true;
 
 	for (i = ibc->last_copied_page + 1; i < pg_idx; i++) {
 		if (DRM_COPY_FROM_USER(p->ib.ptr + (i * (PAGE_SIZE/4)),


