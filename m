Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaBKUlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:41:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbaBKTFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.13 104/120] drm/mgag200: fix oops in cursor code.
Date: Tue, 11 Feb 2014 11:05:45 -0800
Message-Id: <20140211184826.598434860@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 53dac830537b51df555ba5e7ebb236705b7eaa7c upstream.

In some cases we enter the cursor code with file_priv = NULL causing an oops,
we also can try to unpin something that isn't pinned, and this is a good fix for it.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/mgag200/mgag200_cursor.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/mgag200/mgag200_cursor.c
+++ b/drivers/gpu/drm/mgag200/mgag200_cursor.c
@@ -22,8 +22,10 @@ static void mga_hide_cursor(struct mga_d
 {
 	WREG8(MGA_CURPOSXL, 0);
 	WREG8(MGA_CURPOSXH, 0);
-	mgag200_bo_unpin(mdev->cursor.pixels_1);
-	mgag200_bo_unpin(mdev->cursor.pixels_2);
+	if (mdev->cursor.pixels_1->pin_count)
+		mgag200_bo_unpin(mdev->cursor.pixels_1);
+	if (mdev->cursor.pixels_2->pin_count)
+		mgag200_bo_unpin(mdev->cursor.pixels_2);
 }
 
 int mga_crtc_cursor_set(struct drm_crtc *crtc,
@@ -32,7 +34,7 @@ int mga_crtc_cursor_set(struct drm_crtc
 			uint32_t width,
 			uint32_t height)
 {
-	struct drm_device *dev = (struct drm_device *)file_priv->minor->dev;
+	struct drm_device *dev = crtc->dev;
 	struct mga_device *mdev = (struct mga_device *)dev->dev_private;
 	struct mgag200_bo *pixels_1 = mdev->cursor.pixels_1;
 	struct mgag200_bo *pixels_2 = mdev->cursor.pixels_2;


