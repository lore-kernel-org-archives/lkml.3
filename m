Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbaF3P5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:57:00 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:50042 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbaF3PxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:53:13 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 11/18] drbd: re-add lost conf_mutex protection in drbd_set_role
Date: Mon, 30 Jun 2014 17:53:00 +0200
Message-Id: <1404143587-24344-12-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
References: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

The conf_update mutex used to be held while clearing the
net_conf->discard_my_data flag inside drbd_set_role.

It was moved into drbd_adm_set_role with
    drbd: allow parallel promote/demote actions
but then replaced at that location by the newly introduced adm_mutex with
    drbd: Fix a potential deadlock in drbdsetup, introduce resource->adm_mutex

And I simply forgot to put it back in at the original location.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 133e9b3..23670d8 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -661,11 +661,11 @@ drbd_set_role(struct drbd_device *const device, enum drbd_role new_role, int for
 			put_ldev(device);
 		}
 	} else {
-		/* Called from drbd_adm_set_role only.
-		 * We are still holding the conf_update mutex. */
+		mutex_lock(&device->resource->conf_update);
 		nc = connection->net_conf;
 		if (nc)
 			nc->discard_my_data = 0; /* without copy; single bit op is atomic */
+		mutex_unlock(&device->resource->conf_update);
 
 		set_disk_ro(device->vdisk, false);
 		if (get_ldev(device)) {
-- 
1.9.1

