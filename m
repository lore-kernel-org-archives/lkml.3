Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab3JJPpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:45:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52687 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab3JJPp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:45:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>, Jerome Glisse <jglisse@redhat.com>,
        Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 051/104] drm/ttm: fix the tt_populated check in ttm_tt_destroy()
Date: Thu, 10 Oct 2013 08:41:39 -0700
Message-Id: <1381419752-29733-52-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/ttm/ttm_tt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index 7d759a4..cacf2e4 100644
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
1.8.1.2

