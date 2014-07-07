Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbaGHBIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:08:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaGGXx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:53:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zhaowei Yuan <zhaowei.yuan@samsung.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.15 048/122] drm: fix NULL pointer access by wrong ioctl
Date: Mon,  7 Jul 2014 16:56:50 -0700
Message-Id: <20140707235735.725289062@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhaowei Yuan <zhaowei.yuan@samsung.com>

commit 1539fb9bd405ee32282ea0a38404f9e008ac5b7a upstream.

If user uses wrong ioctl command with _IOC_NONE and argument size
greater than 0, it can cause NULL pointer access from memset of line
463. If _IOC_NONE, don't memset to 0 for kdata.

Signed-off-by: Zhaowei Yuan <zhaowei.yuan@samsung.com>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -419,8 +419,9 @@ long drm_ioctl(struct file *filp,
 			retcode = -EFAULT;
 			goto err_i1;
 		}
-	} else
+	} else if (cmd & IOC_OUT) {
 		memset(kdata, 0, usize);
+	}
 
 	if (ioctl->flags & DRM_UNLOCKED)
 		retcode = func(dev, kdata, file_priv);


