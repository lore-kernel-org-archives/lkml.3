Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab3LBUAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:00:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39211 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab3LBTR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matthew Stapleton <matthew4196@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.12 100/212] drm/qxl: fix memory leak in release list handling
Date: Mon,  2 Dec 2013 11:14:51 -0800
Message-Id: <20131202191258.553616801@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 1b28c3e628315ac0d9ef2d3fac0403f05ae692db upstream.

wow no idea how I got this far without seeing this,
leaking the entries in the list makes kmalloc-64 slab grow.

References: https://bugzilla.kernel.org/show_bug.cgi?id=65121
Reported-by: Matthew Stapleton <matthew4196@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/qxl/qxl_release.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/qxl/qxl_release.c
+++ b/drivers/gpu/drm/qxl/qxl_release.c
@@ -92,6 +92,7 @@ qxl_release_free(struct qxl_device *qdev
 						- DRM_FILE_OFFSET);
 		qxl_fence_remove_release(&bo->fence, release->id);
 		qxl_bo_unref(&bo);
+		kfree(entry);
 	}
 	spin_lock(&qdev->release_idr_lock);
 	idr_remove(&qdev->release_idr, release->id);


