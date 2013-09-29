Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab3I2Tgo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:36:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107Ab3I2T3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 57/71] drm/radeon: avoid UVD corruptions on AGP cards
Date: Sun, 29 Sep 2013 12:28:09 -0700
Message-Id: <20130929192647.434876787@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 4f66c59922cbcda14c9e103e6c7f4ee616360d43 upstream.

Putting everything into VRAM seems to help.

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_cs.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -80,9 +80,11 @@ static int radeon_cs_parser_relocs(struc
 		p->relocs[i].lobj.bo = p->relocs[i].robj;
 		p->relocs[i].lobj.written = !!r->write_domain;
 
-		/* the first reloc of an UVD job is the
-		   msg and that must be in VRAM */
-		if (p->ring == R600_RING_TYPE_UVD_INDEX && i == 0) {
+		/* the first reloc of an UVD job is the msg and that must be in
+		   VRAM, also but everything into VRAM on AGP cards to avoid
+		   image corruptions */
+		if (p->ring == R600_RING_TYPE_UVD_INDEX &&
+		    (i == 0 || p->rdev->flags & RADEON_IS_AGP)) {
 			/* TODO: is this still needed for NI+ ? */
 			p->relocs[i].lobj.domain =
 				RADEON_GEM_DOMAIN_VRAM;


