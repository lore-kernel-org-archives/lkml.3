Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab3I2UBO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 16:01:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3I2T1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:27:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 08/22] drm/ttm: fix the tt_populated check in ttm_tt_destroy()
Date: Sun, 29 Sep 2013 12:26:54 -0700
Message-Id: <20130929191159.456302102@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929191158.889693326@linuxfoundation.org>
References: <20130929191158.889693326@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ttm/ttm_tt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -170,7 +170,7 @@ void ttm_tt_destroy(struct ttm_tt *ttm)
 		ttm_tt_unbind(ttm);
 	}
 
-	if (likely(ttm->pages != NULL)) {
+	if (ttm->state == tt_unbound) {
 		ttm->bdev->driver->ttm_tt_unpopulate(ttm);
 	}
 


