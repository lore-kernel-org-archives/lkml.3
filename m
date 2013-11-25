Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab3KYN16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:27:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57000 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab3KYNH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:07:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 13/78] drm: Prevent overwriting from userspace underallocating core ioctl structs
Date: Mon, 25 Nov 2013 13:06:00 +0000
Message-Id: <1385384825-21681-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit b062672e305ce071f21eb9e18b102c2a430e0999 upstream.

Apply the protections from

commit 1b2f1489633888d4a06028315dc19d65768a1c05
Author: Dave Airlie <airlied@redhat.com>
Date:   Sat Aug 14 20:20:34 2010 +1000

    drm: block userspace under allocating buffer and having drivers overwrite it (v2)

to the core ioctl structs as well, for we found one instance where there
is a 32-/64-bit size mismatch and were guilty of writing beyond the end
of the user's buffer.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@redhat.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/drm_drv.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 8a9d079..df54da9 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -422,9 +422,16 @@ long drm_ioctl(struct file *filp,
 			asize = drv_size;
 	}
 	else if ((nr >= DRM_COMMAND_END) || (nr < DRM_COMMAND_BASE)) {
+		u32 drv_size;
+
 		ioctl = &drm_ioctls[nr];
-		cmd = ioctl->cmd;
+
+		drv_size = _IOC_SIZE(ioctl->cmd);
 		usize = asize = _IOC_SIZE(cmd);
+		if (drv_size > asize)
+			asize = drv_size;
+
+		cmd = ioctl->cmd;
 	} else
 		goto err_i1;
 
-- 
1.8.3.2

