Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbbALSSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:18:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57645 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbbALSGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 076/216] drm/vmwgfx: Fix error printout on signals pending
Date: Mon, 12 Jan 2015 18:03:13 +0000
Message-Id: <1421085933-32536-77-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit e338c4c2b620ba4e75fd3576f8142eb93be12ce3 upstream.

The function vmw_master_check() might return -ERESTARTSYS if there is a
signal pending, indicating that the IOCTL should be rerun, potentially from
user-space. At that point we shouldn't print out an error message since that
is not an error condition. In short, avoid bloating the kernel log when a
process refuses to die on SIGTERM.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 440b814046fb..68e45146e27f 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -1070,8 +1070,12 @@ static long vmw_generic_ioctl(struct file *filp, unsigned int cmd,
 
 	vmaster = vmw_master_check(dev, file_priv, flags);
 	if (unlikely(IS_ERR(vmaster))) {
-		DRM_INFO("IOCTL ERROR %d\n", nr);
-		return PTR_ERR(vmaster);
+		ret = PTR_ERR(vmaster);
+
+		if (ret != -ERESTARTSYS)
+			DRM_INFO("IOCTL ERROR Command %d, Error %ld.\n",
+				 nr, ret);
+		return ret;
 	}
 
 	ret = ioctl_func(filp, cmd, arg);
-- 
2.1.4

