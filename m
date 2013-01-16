Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab3APQKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:10:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36844 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884Ab3APQKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:10:07 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 196/222] rtlwifi: fix incorrect use of usb_alloc_coherent with usb_control_msg
Date: Wed, 16 Jan 2013 13:56:36 -0200
Message-Id: <1358351822-7675-197-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

commit 4c3de5920c486b8eefa6187ee6a181864c161100 upstream.

Incorrect use of usb_alloc_coherent memory as input buffer to usb_control_msg
can cause problems in arch DMA code, for example kernel BUG at
'arch/arm/include/asm/dma-mapping.h:321' on ARM (linux-3.4).

Change _usb_writeN_sync use kmalloc'd buffer instead.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/rtlwifi/usb.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index aa970fc..8fa144f 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -210,17 +210,16 @@ static void _usb_writeN_sync(struct rtl_priv *rtlpriv, u32 addr, void *data,
 	u16 index = REALTEK_USB_VENQT_CMD_IDX;
 	int pipe = usb_sndctrlpipe(udev, 0); /* write_out */
 	u8 *buffer;
-	dma_addr_t dma_addr;
 
-	wvalue = (u16)(addr&0x0000ffff);
-	buffer = usb_alloc_coherent(udev, (size_t)len, GFP_ATOMIC, &dma_addr);
+	wvalue = (u16)(addr & 0x0000ffff);
+	buffer = kmalloc(len, GFP_ATOMIC);
 	if (!buffer)
 		return;
 	memcpy(buffer, data, len);
 	usb_control_msg(udev, pipe, request, reqtype, wvalue,
 			index, buffer, len, 50);
 
-	usb_free_coherent(udev, (size_t)len, buffer, dma_addr);
+	kfree(buffer);
 }
 
 static void _rtl_usb_io_handler_init(struct device *dev,
-- 
1.7.9.5

