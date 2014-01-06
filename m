Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbaAFXEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:04:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933179AbaAFWlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Elder <alex.elder@linaro.org>,
        Josh Durgin <josh.durgin@inktank.com>, Alex Elder <elder@linaro.org>
Subject: [PATCH 3.10 118/129] rbd: fix error handling from rbd_snap_name()
Date: Mon,  6 Jan 2014 14:39:07 -0800
Message-Id: <20140106223902.971848371@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Durgin <josh.durgin@inktank.com>

commit da6a6b63978d45f9ae582d1f362f182012da3a22 upstream.

rbd_snap_name() calls rbd_dev_v{1,2}_snap_name() depending on the
format of the image. The format 1 version returns NULL on error, which
is handled by the caller. The format 2 version returns an ERR_PTR,
which the caller of rbd_snap_name() does not expect.

Fortunately this is unlikely to occur in practice because
rbd_snap_id_by_name() is called before rbd_snap_name(). This would hit
similar errors to rbd_snap_name() (like the snapshot not existing) and
return early, so rbd_snap_name() would not hit an error unless the
snapshot was removed between the two calls or memory was exhausted.

Use an ERR_PTR in rbd_dev_v1_snap_name() so that the specific error
can be propagated, and it is consistent with rbd_dev_v2_snap_name().
Handle the ERR_PTR in the only rbd_snap_name() caller.

Suggested-by: Alex Elder <alex.elder@linaro.org>
Signed-off-by: Josh Durgin <josh.durgin@inktank.com>
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/rbd.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -937,12 +937,14 @@ static const char *rbd_dev_v1_snap_name(
 					u64 snap_id)
 {
 	u32 which;
+	const char *snap_name;
 
 	which = rbd_dev_snap_index(rbd_dev, snap_id);
 	if (which == BAD_SNAP_INDEX)
-		return NULL;
+		return ERR_PTR(-ENOENT);
 
-	return _rbd_dev_v1_snap_name(rbd_dev, which);
+	snap_name = _rbd_dev_v1_snap_name(rbd_dev, which);
+	return snap_name ? snap_name : ERR_PTR(-ENOMEM);
 }
 
 static const char *rbd_snap_name(struct rbd_device *rbd_dev, u64 snap_id)
@@ -4140,8 +4142,8 @@ static int rbd_dev_spec_update(struct rb
 	/* Look up the snapshot name, and make a copy */
 
 	snap_name = rbd_snap_name(rbd_dev, spec->snap_id);
-	if (!snap_name) {
-		ret = -ENOMEM;
+	if (IS_ERR(snap_name)) {
+		ret = PTR_ERR(snap_name);
 		goto out_err;
 	}
 


