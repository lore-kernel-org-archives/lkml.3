Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbaF3P4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:56:09 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:50045 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbaF3PxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:53:14 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 13/18] drbd: move set_disk_ro() to after we persisted the new role
Date: Mon, 30 Jun 2014 17:53:02 +0200
Message-Id: <1404143587-24344-14-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
References: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

This probably does not have any real life impact,
but we should first persist any potentially new UUID
and other meta data flags, as well as our new role,
before we allow/disallow write access.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 23670d8..ceebd31 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -655,7 +655,6 @@ drbd_set_role(struct drbd_device *const device, enum drbd_role new_role, int for
 	/* FIXME also wait for all pending P_BARRIER_ACK? */
 
 	if (new_role == R_SECONDARY) {
-		set_disk_ro(device->vdisk, true);
 		if (get_ldev(device)) {
 			device->ldev->md.uuid[UI_CURRENT] &= ~(u64)1;
 			put_ldev(device);
@@ -667,7 +666,6 @@ drbd_set_role(struct drbd_device *const device, enum drbd_role new_role, int for
 			nc->discard_my_data = 0; /* without copy; single bit op is atomic */
 		mutex_unlock(&device->resource->conf_update);
 
-		set_disk_ro(device->vdisk, false);
 		if (get_ldev(device)) {
 			if (((device->state.conn < C_CONNECTED ||
 			       device->state.pdsk <= D_FAILED)
@@ -690,7 +688,7 @@ drbd_set_role(struct drbd_device *const device, enum drbd_role new_role, int for
 	}
 
 	drbd_md_sync(device);
-
+	set_disk_ro(device->vdisk, new_role == R_SECONDARY);
 	kobject_uevent(&disk_to_dev(device->vdisk)->kobj, KOBJ_CHANGE);
 out:
 	mutex_unlock(device->state_mutex);
-- 
1.9.1

