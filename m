Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab3KIGuF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:50:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab3KIGty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:49:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@redhat.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 3.4 25/26] drm: Prevent overwriting from userspace underallocating core ioctl structs
Date: Fri,  8 Nov 2013 22:51:54 -0800
Message-Id: <20131109065051.955981364@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065050.089866597@linuxfoundation.org>
References: <20131109065050.089866597@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_drv.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -420,9 +420,16 @@ long drm_ioctl(struct file *filp,
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
 


