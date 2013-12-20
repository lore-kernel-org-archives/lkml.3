Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab3LTKUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:20:17 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33305 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab3LTKUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:20:14 -0500
From: Wenliang Fan <fanwlexca@gmail.com>
To: dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        klmckinney1@gmail.com, tulinizer@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Wenliang Fan <fanwlexca@gmail.com>
Subject: [PATCH] drivers/staging/bcm: Integer overflow
Date: Fri, 20 Dec 2013 18:19:56 +0800
Message-Id: <1387534796-31901-1-git-send-email-fanwlexca@gmail.com>
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
 drivers/staging/bcm/nvm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/bcm/nvm.c b/drivers/staging/bcm/nvm.c
index 9e5f955..7f3dd4b 100644
--- a/drivers/staging/bcm/nvm.c
+++ b/drivers/staging/bcm/nvm.c
@@ -3944,6 +3944,11 @@ int validateFlash2xReadWrite(struct bcm_mini_adapter *Adapter, struct bcm_flash2
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, NVM_RW, DBG_LVL_ALL, "End offset :%x\n", uiSectEndOffset);
 
+	/* psFlash2xReadWrite->offset and uiNumOfBytes are user controlled and can lead to integer overflows */
+	if (uiSectStartOffset + psFlash2xReadWrite->offset < uiSectStartOffset)
+		return false;
+	if (uiSectStartOffset + psFlash2xReadWrite->offset + uiNumOfBytes < uiNumOfBytes)
+		return false;
 	/* Checking the boundary condition */
 	if ((uiSectStartOffset + psFlash2xReadWrite->offset + uiNumOfBytes) <= uiSectEndOffset)
 		return TRUE;
-- 
1.8.5.rc1.28.g7061504

