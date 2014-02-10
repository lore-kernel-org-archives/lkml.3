Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbaBJUMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:12:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34709 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaBJTnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:43:40 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 095/124] drm/ast: do not attempt to acquire a reservation while in an interrupt handler
Date: Mon, 10 Feb 2014 11:40:35 -0800
Message-Id: <1392061264-28124-96-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <m.b.lankhorst@gmail.com>

commit 8ade2b8281d58a8336a1742a44ceffd9d07d6629 upstream.

Mutexes should not be acquired in interrupt context. While the trylock
fastpath is arguably safe on all implementations, the slowpath
unlock path definitely isn't.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/ast/ast_fb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_fb.c b/drivers/gpu/drm/ast/ast_fb.c
index 9138678..66ecc16 100644
--- a/drivers/gpu/drm/ast/ast_fb.c
+++ b/drivers/gpu/drm/ast/ast_fb.c
@@ -50,7 +50,7 @@ static void ast_dirty_update(struct ast_fbdev *afbdev,
 	struct ast_bo *bo;
 	int src_offset, dst_offset;
 	int bpp = (afbdev->afb.base.bits_per_pixel + 7)/8;
-	int ret;
+	int ret = -EBUSY;
 	bool unmap = false;
 	bool store_for_later = false;
 	int x2, y2;
@@ -64,7 +64,8 @@ static void ast_dirty_update(struct ast_fbdev *afbdev,
 	 * then the BO is being moved and we should
 	 * store up the damage until later.
 	 */
-	ret = ast_bo_reserve(bo, true);
+	if (!in_interrupt())
+		ret = ast_bo_reserve(bo, true);
 	if (ret) {
 		if (ret != -EBUSY)
 			return;
-- 
1.8.3.2

