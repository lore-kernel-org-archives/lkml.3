Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbaBKUnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:43:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaBKTFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.13 098/120] drm/gem: Always initialize the gem object in object_init
Date: Tue, 11 Feb 2014 11:05:39 -0800
Message-Id: <20140211184826.416672621@linuxfoundation.org>
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

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 6ab11a2635ce988ebc2e798947beb72cf7324119 upstream.

At least drm/i915 expects that the obj->dev pointer is set even in
failure paths. Specifically when the shmem initialization fails we
call i915_gem_object_free which needs to deref obj->base.dev to get at
the slab pointer in the device private structure. And the shmem
allocation can easily fail when userspace is hitting open file limits.

Doing the structure init even when the shmem file allocation fails
prevents this Oops.

This is a regression from

commit 89c8233f82d9c8af5b20e72e4a185a38a7d3c50b
Author: David Herrmann <dh.herrmann@gmail.com>
Date:   Thu Jul 11 11:56:32 2013 +0200

    drm/gem: simplify object initialization

v2: Add regression note which Chris supplied.

Testcase: igt/gem_fd_exhaustion
Reported-and-Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
References: http://lists.freedesktop.org/archives/intel-gfx/2014-January/038433.html
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Cc: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_gem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -129,11 +129,12 @@ int drm_gem_object_init(struct drm_devic
 {
 	struct file *filp;
 
+	drm_gem_private_object_init(dev, obj, size);
+
 	filp = shmem_file_setup("drm mm object", size, VM_NORESERVE);
 	if (IS_ERR(filp))
 		return PTR_ERR(filp);
 
-	drm_gem_private_object_init(dev, obj, size);
 	obj->filp = filp;
 
 	return 0;


