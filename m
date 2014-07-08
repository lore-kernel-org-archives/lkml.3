Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbaGHToX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:44:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54082 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755674AbaGHTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Herrmann" <dh.herrmann@gmail.com>,
        "Dave Airlie" <airlied@redhat.com>,
        "Zhaowei Yuan" <zhaowei.yuan@samsung.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.74667140@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 100/125] drm: fix NULL pointer access by wrong ioctl
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Zhaowei Yuan <zhaowei.yuan@samsung.com>

commit 1539fb9bd405ee32282ea0a38404f9e008ac5b7a upstream.

If user uses wrong ioctl command with _IOC_NONE and argument size
greater than 0, it can cause NULL pointer access from memset of line
463. If _IOC_NONE, don't memset to 0 for kdata.

Signed-off-by: Zhaowei Yuan <zhaowei.yuan@samsung.com>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[bwh: Backported to 3.2: adjust indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/drm_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -456,8 +456,9 @@ long drm_ioctl(struct file *filp,
 				retcode = -EFAULT;
 				goto err_i1;
 			}
-		} else
+		} else if (cmd & IOC_OUT) {
 			memset(kdata, 0, usize);
+		}
 
 		if (ioctl->flags & DRM_UNLOCKED)
 			retcode = func(dev, kdata, file_priv);

