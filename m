Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbaF3QBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:01:32 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:50035 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbaF3PxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:53:12 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/18] drbd: stop the meta data sync timer before open coded meta data sync
Date: Mon, 30 Jun 2014 17:52:59 +0200
Message-Id: <1404143587-24344-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
References: <1404143587-24344-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

If we re-write all meta data due to resize, we have open-coded write-out
of our meta data super block. Stop the md_sync_timer, it would just
trigger scary but in this case spurious "timer expired" messages.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 52221f6..133e9b3 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -967,6 +967,10 @@ drbd_determine_dev_size(struct drbd_device *device, enum dds_flags flags, struct
 	if (la_size_changed || md_moved || rs) {
 		u32 prev_flags;
 
+		/* We do some synchronous IO below, which may take some time.
+		 * Clear the timer, to avoid scary "timer expired!" messages,
+		 * "Superblock" is written out at least twice below, anyways. */
+		del_timer(&device->md_sync_timer);
 		drbd_al_shrink(device); /* All extents inactive. */
 
 		prev_flags = md->flags;
-- 
1.9.1

