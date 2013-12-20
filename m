Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab3LTHNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 02:13:34 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:55315 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3LTHNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 02:13:33 -0500
From: Wenliang Fan <fanwlexca@gmail.com>
To: gregkh@linuxfoundation.org, klmckinney1@gmail.com, tulinizer@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Wenliang Fan <fanwlexca@gmail.com>
Subject: [PATCH] drivers/staging/bcm: Integer overflow
Date: Fri, 20 Dec 2013 15:13:16 +0800
Message-Id: <1387523596-29543-1-git-send-email-fanwlexca@gmail.com>
X-Mailer: git-send-email 1.8.5.rc1.28.g7061504
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The checking condition in 'validateFlash2xReadWrite()' is not sufficient.
A large number invalid would cause an integer overflow and pass
the condition, which could cause further integer overflows in
'Bcmchar.c:bcm_char_ioctl()'.

Signed-off-by: Wenliang Fan <fanwlexca@gmail.com>
---
 drivers/staging/bcm/nvm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/bcm/nvm.c b/drivers/staging/bcm/nvm.c
index 9e5f955..0615609 100644
--- a/drivers/staging/bcm/nvm.c
+++ b/drivers/staging/bcm/nvm.c
@@ -3945,7 +3945,9 @@ int validateFlash2xReadWrite(struct bcm_mini_adapter *Adapter, struct bcm_flash2
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, NVM_RW, DBG_LVL_ALL, "End offset :%x\n", uiSectEndOffset);
 
 	/* Checking the boundary condition */
-	if ((uiSectStartOffset + psFlash2xReadWrite->offset + uiNumOfBytes) <= uiSectEndOffset)
+	if (((uiSectStartOffset + psFlash2xReadWrite->offset + uiNumOfBytes) <= uiSectEndOffset)
+			&& (uiSectStartOffset + psFlash2xReadWrite->offset > uiSectStartOffset)
+			&& (uiSectStartOffset + psFlash2xReadWrite->offset + uiNumBytes > uiNumBytes))
 		return TRUE;
 	else {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Invalid Request....");
-- 
1.8.5.rc1.28.g7061504

