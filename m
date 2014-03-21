Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030252AbaCUBUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:20:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760427AbaCUADp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.13 057/149] DRM: armada: fix use of kfifo_put()
Date: Thu, 20 Mar 2014 17:03:40 -0700
Message-Id: <20140321000438.936695826@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit d13c46c67e546bb1dc1c4dc7c43e388d0119276b upstream.

The kfifo_put() API changed in 498d319bb512 (kfifo API type safety)
which now results in the wrong pointer being added to the kfifo ring,
which then causes an oops.  Fix this.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/armada/armada_drv.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/drivers/gpu/drm/armada/armada_drv.c
+++ b/drivers/gpu/drm/armada/armada_drv.c
@@ -68,15 +68,7 @@ void __armada_drm_queue_unref_work(struc
 {
 	struct armada_private *priv = dev->dev_private;
 
-	/*
-	 * Yes, we really must jump through these hoops just to store a
-	 * _pointer_ to something into the kfifo.  This is utterly insane
-	 * and idiotic, because it kfifo requires the _data_ pointed to by
-	 * the pointer const, not the pointer itself.  Not only that, but
-	 * you have to pass a pointer _to_ the pointer you want stored.
-	 */
-	const struct drm_framebuffer *silly_api_alert = fb;
-	WARN_ON(!kfifo_put(&priv->fb_unref, &silly_api_alert));
+	WARN_ON(!kfifo_put(&priv->fb_unref, fb));
 	schedule_work(&priv->fb_unref_work);
 }
 


