Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab3JWJKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:10:01 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48160 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab3JWJJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:09:20 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [PATCH 3/5] drbd: Fix adding of new minors with freshly created meta data
Date: Wed, 23 Oct 2013 10:59:17 +0200
Message-Id: <1382518759-5467-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382518759-5467-1-git-send-email-philipp.reisner@linbit.com>
References: <1382518759-5467-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Online adding of new minors with freshly created meta data
to an resource with an established connection failed, with a
wrong state transition on one side on one side of the new minor.

Freshly created meta-data has a la_size (last agreed size) of 0.
When we online add such devices, the code wrongly got into
the code path for resyncing new storage that was added while
the disk was detached.

Fixed that by making the GREW from ZERO a special case.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h |    3 ++-
 drivers/block/drbd/drbd_nl.c  |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 2d7f608..0e06f0c 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1474,7 +1474,8 @@ enum determine_dev_size {
 	DS_ERROR = -1,
 	DS_UNCHANGED = 0,
 	DS_SHRUNK = 1,
-	DS_GREW = 2
+	DS_GREW = 2,
+	DS_GREW_FROM_ZERO = 3,
 };
 extern enum determine_dev_size
 drbd_determine_dev_size(struct drbd_conf *, enum dds_flags, struct resize_parms *) __must_hold(local);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 8cc1e64..37dad18 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -955,7 +955,7 @@ drbd_determine_dev_size(struct drbd_conf *mdev, enum dds_flags flags, struct res
 	}
 
 	if (size > la_size_sect)
-		rv = DS_GREW;
+		rv = la_size_sect ? DS_GREW : DS_GREW_FROM_ZERO;
 	if (size < la_size_sect)
 		rv = DS_SHRUNK;
 
-- 
1.7.9.5

