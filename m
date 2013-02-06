Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475Ab3BFT4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:56:07 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:58386 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030245Ab3BFTvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:51:08 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>
Subject: [PATCH 65/77] uio: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:37 -0800
Message-Id: <1360179649-22465-66-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>
---
 drivers/uio/uio.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 5110f36..c8b9262 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -369,26 +369,15 @@ static void uio_dev_del_attributes(struct uio_device *idev)
 static int uio_get_minor(struct uio_device *idev)
 {
 	int retval = -ENOMEM;
-	int id;
 
 	mutex_lock(&minor_lock);
-	if (idr_pre_get(&uio_idr, GFP_KERNEL) == 0)
-		goto exit;
-
-	retval = idr_get_new(&uio_idr, idev, &id);
-	if (retval < 0) {
-		if (retval == -EAGAIN)
-			retval = -ENOMEM;
-		goto exit;
-	}
-	if (id < UIO_MAX_DEVICES) {
-		idev->minor = id;
-	} else {
+	retval = idr_alloc(&uio_idr, idev, 0, UIO_MAX_DEVICES, GFP_KERNEL);
+	if (retval >= 0) {
+		idev->minor = retval;
+	} else if (retval == -ENOSPC) {
 		dev_err(idev->dev, "too many uio devices\n");
 		retval = -EINVAL;
-		idr_remove(&uio_idr, id);
 	}
-exit:
 	mutex_unlock(&minor_lock);
 	return retval;
 }
-- 
1.8.1

