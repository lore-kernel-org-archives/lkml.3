Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbaAGAA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:00:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132AbaAFWi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Anholt <eric@anholt.net>, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.12 068/144] drm/i915: Hold mutex across i915_gem_release
Date: Mon,  6 Jan 2014 14:37:09 -0800
Message-Id: <20140106223747.299886450@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 0d1430a3f4b7cfd8779b78740a4182321f3ca7f3 upstream.

Inorder to serialise the closing of the file descriptor and its
subsequent release of client requests with i915_gem_free_request(), we
need to hold the struct_mutex in i915_gem_release(). Failing to do so
has the potential to trigger an OOPS, later with a use-after-free.

Testcase: igt/gem_close_race
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=70874
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=71029
Reported-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_dma.c         |    2 ++
 drivers/gpu/drm/i915/i915_gem_context.c |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1848,8 +1848,10 @@ void i915_driver_lastclose(struct drm_de
 
 void i915_driver_preclose(struct drm_device * dev, struct drm_file *file_priv)
 {
+	mutex_lock(&dev->struct_mutex);
 	i915_gem_context_close(dev, file_priv);
 	i915_gem_release(dev, file_priv);
+	mutex_unlock(&dev->struct_mutex);
 }
 
 void i915_driver_postclose(struct drm_device *dev, struct drm_file *file)
--- a/drivers/gpu/drm/i915/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/i915_gem_context.c
@@ -328,10 +328,8 @@ void i915_gem_context_close(struct drm_d
 {
 	struct drm_i915_file_private *file_priv = file->driver_priv;
 
-	mutex_lock(&dev->struct_mutex);
 	idr_for_each(&file_priv->context_idr, context_idr_cleanup, NULL);
 	idr_destroy(&file_priv->context_idr);
-	mutex_unlock(&dev->struct_mutex);
 }
 
 static struct i915_hw_context *


