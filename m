Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab3LSPF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:05:27 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:54072 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab3LSPFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:05:23 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Paul Mundt <lethal@linux-sh.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org
Subject: [PATCH 29/38] superhyway: maple: add missing put_device call
Date: Thu, 19 Dec 2013 16:03:40 +0100
Message-Id: <1387465429-3568-30-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465429-3568-2-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.
Also rework maple_release_device to use maple_free_dev instead, avoiding
same code being in two functions at the same time.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/sh/maple/maple.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/sh/maple/maple.c b/drivers/sh/maple/maple.c
index bec81c2..c4afb7e 100644
--- a/drivers/sh/maple/maple.c
+++ b/drivers/sh/maple/maple.c
@@ -134,16 +134,18 @@ static int maple_dma_done(void)
 	return (__raw_readl(MAPLE_STATE) & 1) == 0;
 }
 
+static void maple_free_dev(struct maple_device *mdev)
+{
+	kmem_cache_free(maple_queue_cache, mdev->mq->recvbuf);
+	kfree(mdev->mq);
+	kfree(mdev);
+}
+
 static void maple_release_device(struct device *dev)
 {
 	struct maple_device *mdev;
-	struct mapleq *mq;
-
 	mdev = to_maple_dev(dev);
-	mq = mdev->mq;
-	kmem_cache_free(maple_queue_cache, mq->recvbuf);
-	kfree(mq);
-	kfree(mdev);
+	maple_free_dev(mdev);
 }
 
 /**
@@ -234,13 +236,6 @@ static struct maple_device *maple_alloc_dev(int port, int unit)
 	return mdev;
 }
 
-static void maple_free_dev(struct maple_device *mdev)
-{
-	kmem_cache_free(maple_queue_cache, mdev->mq->recvbuf);
-	kfree(mdev->mq);
-	kfree(mdev);
-}
-
 /* process the command queue into a maple command block
  * terminating command has bit 32 of first long set to 0
  */
@@ -393,7 +388,7 @@ static void maple_attach_driver(struct maple_device *mdev)
 		dev_warn(&mdev->dev, "could not register device at"
 			" (%d, %d), with error 0x%X\n", mdev->unit,
 			mdev->port, error);
-		maple_free_dev(mdev);
+		put_device(&mdev->dev);
 		mdev = NULL;
 		return;
 	}
-- 
1.8.3.1

