Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab3AYSuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:50:10 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:59128 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab3AYSuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:50:05 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Bernie Thompson <bernie@plugable.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Alexander Holler <holler@ahsoftware.de>, <stable@vger.kernel.org>
Subject: [PATCH 2/3 v2] fb: udlfb: fix hang at disconnect
Date: Fri, 25 Jan 2013 19:49:27 +0100
Message-Id: <1359139768-32294-2-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1359139768-32294-1-git-send-email-holler@ahsoftware.de>
References: <50F2A310.5010006@ahsoftware.de>
 <1359139768-32294-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a device was disconnected the driver may hang at waiting for urbs it never
will get. Fix this by using a timeout while waiting for the used semaphore.

There is still a memory leak if a timeout happens, but at least the driver
now continues his disconnect routine.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/video/udlfb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index 86d449e..db6cc66 100644
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -1832,8 +1832,9 @@ static void dlfb_free_urb_list(struct dlfb_data *dev)
 	/* keep waiting and freeing, until we've got 'em all */
 	while (count--) {
 
-		/* Getting interrupted means a leak, but ok at disconnect */
-		ret = down_interruptible(&dev->urbs.limit_sem);
+		/* Timeout likely occurs at disconnect (resulting in a leak) */
+		ret = down_timeout_killable(&dev->urbs.limit_sem,
+						FREE_URB_TIMEOUT);
 		if (ret)
 			break;
 
-- 
1.7.11.7

