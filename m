Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab3LTLH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 06:07:56 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:49483 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab3LTLHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 06:07:55 -0500
From: Wenliang Fan <fanwlexca@gmail.com>
To: dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        klmckinney1@gmail.com, tulinizer@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Wenliang Fan <fanwlexca@gmail.com>
Subject: [PATCH] drivers/staging/bcm: Integer overflow
Date: Fri, 20 Dec 2013 19:07:38 +0800
Message-Id: <1387537658-32640-1-git-send-email-fanwlexca@gmail.com>
X-Mailer: git-send-email 1.8.5.rc1.28.g7061504
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The checking condition in 'validateFlash2xReadWrite()' is not
sufficient. A large number invalid would cause an integer overflow and
pass the condition, which could cause further integer overflows in
'Bcmchar.c:bcm_char_ioctl()'.

Signed-off-by: Wenliang Fan <fanwlexca@gmail.com>
---
 drivers/staging/bcm/nvm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/staging/bcm/nvm.c b/drivers/staging/bcm/nvm.c
index 9e5f955..3165da8 100644
--- a/drivers/staging/bcm/nvm.c
+++ b/drivers/staging/bcm/nvm.c
@@ -3944,6 +3944,15 @@ int validateFlash2xReadWrite(struct bcm_mini_adapter *Adapter, struct bcm_flash2
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, NVM_RW, DBG_LVL_ALL, "End offset :%x\n", uiSectEndOffset);
 
+	/* psFlash2xReadWrite->offset and uiNumOfBytes are user controlled and can lead to integer overflows */
+	if (psFlash2xReadWrite->offset > uiSectEndOffset) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Invalid Request....");
+		return false;
+	}
+	if (uiNumOfBytes > uiSectEndOffset) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Invalid Request....");
+		return false;
+	}
 	/* Checking the boundary condition */
 	if ((uiSectStartOffset + psFlash2xReadWrite->offset + uiNumOfBytes) <= uiSectEndOffset)
 		return TRUE;
-- 
1.8.5.rc1.28.g7061504

