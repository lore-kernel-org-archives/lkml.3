Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaAMQbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:31:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53425 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaAMQDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Durgin <josh.durgin@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 129/208] rbd: ignore unmapped snapshots that no longer exist
Date: Mon, 13 Jan 2014 15:59:30 +0000
Message-Id: <1389628849-1614-130-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Durgin <josh.durgin@inktank.com>

commit efadc98aab674153709cc357ba565f04e3164fcd upstream.

This prevents erroring out while adding a device when a snapshot
unrelated to the current mapping is deleted between reading the
snapshot context and reading the snapshot names. If the mapped
snapshot name is not found an error still occurs as usual.

Signed-off-by: Josh Durgin <josh.durgin@inktank.com>
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/rbd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 0f5307f..9a2e922 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4078,8 +4078,13 @@ static u64 rbd_v2_snap_id_by_name(struct rbd_device *rbd_dev, const char *name)
 
 		snap_id = snapc->snaps[which];
 		snap_name = rbd_dev_v2_snap_name(rbd_dev, snap_id);
-		if (IS_ERR(snap_name))
-			break;
+		if (IS_ERR(snap_name)) {
+			/* ignore no-longer existing snapshots */
+			if (PTR_ERR(snap_name) == -ENOENT)
+				continue;
+			else
+				break;
+		}
 		found = !strcmp(name, snap_name);
 		kfree(snap_name);
 	}
-- 
1.8.3.2

