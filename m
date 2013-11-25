Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab3KYN4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:56:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58981 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754387Ab3KYNyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:54:02 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, dri-devel@lists.freedesktop.org,
        "Ville =?UTF-8?Q?Syrj=C3=A4l=C3=A4?=" <ville.syrjala@linux.intel.com>,
        "Dave Airlie" <airlied@redhat.com>,
        "Chris Wilson" <chris@chris-wilson.co.uk>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.39926199@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 74/87] drm: Prevent overwriting from userspace
 underallocating core ioctl structs
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/drm_drv.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -408,9 +408,16 @@ long drm_ioctl(struct file *filp,
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
 

