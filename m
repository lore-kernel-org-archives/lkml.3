Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab3EJJGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:06:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab3EJJGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:06:47 -0400
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Cong Wang <amwang@redhat.com>
Subject: [Patch] block: do not leak info to user-space
Date: Fri, 10 May 2013 17:06:28 +0800
Message-Id: <1368176789-1973-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <amwang@redhat.com>

There is a hole in struct hd_geometry, so we have to
zero the struct on stack before copying it to user-space.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Cong Wang <amwang@redhat.com>

---
diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index 7c668c8..7e5d474 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -59,6 +59,7 @@ static int compat_hdio_getgeo(struct gendisk *disk, struct block_device *bdev,
 	if (!disk->fops->getgeo)
 		return -ENOTTY;
 
+	memset(&geo, 0, sizeof(geo));
 	/*
 	 * We need to set the startsect first, the driver may
 	 * want to override it.
