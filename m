Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbaBKUmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:42:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbaBKTFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 3.13 100/120] drm/gma500: Lock struct_mutex around cursor updates
Date: Tue, 11 Feb 2014 11:05:41 -0800
Message-Id: <20140211184826.478638184@linuxfoundation.org>
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

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

commit 631794b44bd3dbfba37074954d5c584c9e8725f0 upstream.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=64361
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/gma500/gma_display.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/gma500/gma_display.c
+++ b/drivers/gpu/drm/gma500/gma_display.c
@@ -349,6 +349,7 @@ int gma_crtc_cursor_set(struct drm_crtc
 	/* If we didn't get a handle then turn the cursor off */
 	if (!handle) {
 		temp = CURSOR_MODE_DISABLE;
+		mutex_lock(&dev->struct_mutex);
 
 		if (gma_power_begin(dev, false)) {
 			REG_WRITE(control, temp);
@@ -365,6 +366,7 @@ int gma_crtc_cursor_set(struct drm_crtc
 			gma_crtc->cursor_obj = NULL;
 		}
 
+		mutex_unlock(&dev->struct_mutex);
 		return 0;
 	}
 
@@ -374,9 +376,12 @@ int gma_crtc_cursor_set(struct drm_crtc
 		return -EINVAL;
 	}
 
+	mutex_lock(&dev->struct_mutex);
 	obj = drm_gem_object_lookup(dev, file_priv, handle);
-	if (!obj)
-		return -ENOENT;
+	if (!obj) {
+		ret = -ENOENT;
+		goto unlock;
+	}
 
 	if (obj->size < width * height * 4) {
 		dev_dbg(dev->dev, "Buffer is too small\n");
@@ -440,10 +445,13 @@ int gma_crtc_cursor_set(struct drm_crtc
 	}
 
 	gma_crtc->cursor_obj = obj;
+unlock:
+	mutex_unlock(&dev->struct_mutex);
 	return ret;
 
 unref_cursor:
 	drm_gem_object_unreference(obj);
+	mutex_unlock(&dev->struct_mutex);
 	return ret;
 }
 


