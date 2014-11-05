Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327AbaKEQLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:11:39 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:48385 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbaKEQLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:11:37 -0500
From: Daniel Dressler <danieru.dressler@gmail.com>
To: danieru.dressler@gmail.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthew Casey <mdcasey@chabloom.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] Staging: rtl8192e: Fix segfault upon alloc failure
Date: Thu,  6 Nov 2014 01:11:17 +0900
Message-Id: <1415203879-17261-1-git-send-email-danieru.dressler@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <danieru.dressler@gmail.com>
References: <danieru.dressler@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel space allocations can fail. This patch
fixes a crash condition upon allocation failure.

Should this condition occur init_firmware() will
goto its error handler and declare download failure.

Of interesting note is that prior to this patch
fw_download_code() could never fail yet our caller
checked the return value.

Reported-by: RUC_Soft_Sec <rucsoftsec@gmail.com>
Signed-off-by: Daniel Dressler <danieru.dressler@gmail.com>
---
 drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
index 2e28744..e4257fe 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
@@ -61,6 +61,9 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 		}
 
 		skb  = dev_alloc_skb(frag_length + 4);
+		if (!skb)
+			return false;
+
 		memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
 		tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 		tcb_desc->queue_index = TXCMD_QUEUE;
-- 
2.1.0

