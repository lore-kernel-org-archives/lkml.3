Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbbAMFMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:12:30 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:49112 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbbAMFM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:12:28 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Rob Clark <robdclark@gmail.com>
Subject: [PATCH] next: drm/atomic: Use copy_from_user to copy 64 bit data from user space
Date: Mon, 12 Jan 2015 21:12:17 -0800
Message-Id: <1421125937-27394-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 2.1.0
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.54B4A93C.005A,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copying 64 bit data from user space using get_user is not supported
on all architectures, and may result in the following build error.

ERROR: "__get_user_bad" [drivers/gpu/drm/drm.ko] undefined!

Avoid the problem by using copy_from_user.

Fixes: d34f20d6e2f2 ("drm: Atomic modeset ioctl")
Cc: Rob Clark <robdclark@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Compile tested only.

 drivers/gpu/drm/drm_atomic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
index 1e38dfc..af3f3df 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -1259,7 +1259,9 @@ retry:
 				goto fail;
 			}
 
-			if (get_user(prop_value, prop_values_ptr + copied_props)) {
+			if (copy_from_user(&prop_value,
+					   prop_values_ptr + copied_props,
+					   sizeof(prop_value))) {
 				ret = -EFAULT;
 				goto fail;
 			}
-- 
2.1.0

