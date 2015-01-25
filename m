Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbbAYSxE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:53:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664AbbAYSJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jakob Bornecrantz <jakob@vmware.com>
Subject: [PATCH 3.18 027/183] drm/vmwgfx: Fix error printout on signals pending
Date: Sun, 25 Jan 2015 10:05:49 -0800
Message-Id: <20150125180811.350464916@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -1063,8 +1063,12 @@ static long vmw_generic_ioctl(struct fil
 
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


