Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920Ab3JQAMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 20:12:39 -0400
Received: from c60.cesmail.net ([216.154.195.49]:38007 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294Ab3JQAMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 20:12:37 -0400
Subject: [PATCH] drm: never write to the userspace more data than the caller
 wants
From: Pavel Roskin <proski@gnu.org>
To: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Date: Wed, 16 Oct 2013 20:12:35 -0400
Message-ID: <20131017001235.3077.92963.stgit@IRBT4585>
User-Agent: StGit/0.17-1-g7c57
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The amount of data wanted by the userspace caller is encoded in the
ioctl number.  Generic drm ioctls were ignoring it.

As a result, Intel Xorg driver didn't work for i386 userspace on x86_64
kernel on some systems.  sizeof(struct drm_mode_get_connector) is 76
bytes on i686 and 80 bytes on x86_64 due to the tail alignment (the data
positions match).  The userspace was using the 4 bytes after the
structure to hold the result of the ioctl.  Since drm_ioctl() was
copying 80 bytes instead of 76, it was clobbering that data.

A workaround has been committed to xf86-video-intel.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/drm_drv.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index e572dd2..8a1c721 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -403,8 +403,11 @@ long drm_ioctl(struct file *filp,
 	}
 	else if ((nr >= DRM_COMMAND_END) || (nr < DRM_COMMAND_BASE)) {
 		ioctl = &drm_ioctls[nr];
+		usize = _IOC_SIZE(cmd);
 		cmd = ioctl->cmd;
-		usize = asize = _IOC_SIZE(cmd);
+		asize = _IOC_SIZE(cmd);
+		if (unlikely(usize > asize))
+			usize = asize;
 	} else
 		goto err_i1;
 
