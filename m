Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3ALNUz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 08:20:55 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:45245 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab3ALNUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 08:20:54 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, Bernie Thompson <bernie@plugable.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Dave Airlie <airlied@redhat.com>,
        Alexander Holler <holler@ahsoftware.de>, <stable@vger.kernel.org>
Subject: [PATCH] fb: udlfb: fix hang at disconnect
Date: Sat, 12 Jan 2013 14:20:22 +0100
Message-Id: <1357996822-13072-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.11.7
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
 drivers/video/udlfb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index 86d449e..cc4a8d1 100644
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -1832,8 +1832,8 @@ static void dlfb_free_urb_list(struct dlfb_data *dev)
 	/* keep waiting and freeing, until we've got 'em all */
 	while (count--) {
 
-		/* Getting interrupted means a leak, but ok at disconnect */
-		ret = down_interruptible(&dev->urbs.limit_sem);
+		/* Timeout likely occurs at disconnect (resulting in a leak) */
+		ret = down_timeout(&dev->urbs.limit_sem, GET_URB_TIMEOUT);
 		if (ret)
 			break;
 
-- 
1.7.11.7

