Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab3JKLKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:10:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58387 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608Ab3JKKme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>, Jerome Glisse <jglisse@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 014/100] drm/ttm: fix the tt_populated check in ttm_tt_destroy()
Date: Fri, 11 Oct 2013 11:40:44 +0100
Message-Id: <1381488130-30235-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 182b17c8dc4e83aab000ce86587b6810e515da87 upstream.

After a vmalloc failure in ttm_dma_tt_alloc_page_directory(),
ttm_dma_tt_init() will call ttm_tt_destroy() to cleanup, and end up
inside the driver's unpopulate() hook when populate() has never yet
been called.

On nouveau, the first issue to be hit because of this is that
dma_address[] may be a NULL pointer.  After working around this,
ttm_pool_unpopulate() may potentially hit the same issue with
the pages[] array.

It seems to make more sense to avoid calling unpopulate on already
unpopulated TTMs than to add checks to all the implementations.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/ttm/ttm_tt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index fa09daf..ea10bbe 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -170,7 +170,7 @@ void ttm_tt_destroy(struct ttm_tt *ttm)
 		ttm_tt_unbind(ttm);
 	}
 
-	if (likely(ttm->pages != NULL)) {
+	if (ttm->state == tt_unbound) {
 		ttm->bdev->driver->ttm_tt_unpopulate(ttm);
 	}
 
-- 
1.8.3.2

