Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbaEFMtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:49:21 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:35338 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbaEFMtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:49:17 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH/RFC] usb: gadget: CONFIG_USB_S3C_HSOTG should depend on HAS_DMA
Date: Tue,  6 May 2014 14:49:14 +0200
Message-Id: <1399380554-3746-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `s3c_hsotg_map_dma':
s3c-hsotg.c:(.text+0x375b2c): undefined reference to `usb_gadget_map_request'
drivers/built-in.o: In function `s3c_hsotg_unmap_dma':
s3c-hsotg.c:(.text+0x376a32): undefined reference to `usb_gadget_unmap_request'
make[3]: *** [vmlinux] Error 1

Note that all callers of s3c_hsotg_map_dma()/s3c_hsotg_unmap_dma() are
protected by a call into the using_dma() checking function:

static inline bool using_dma(struct s3c_hsotg *hsotg)
{
        return false;   /* support is not complete */
}

but not all versions of gcc manage to optimize the check away, causing a
link error.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Perhaps the DMA code should be removed completely, as its unused, or be
protected by #ifdef CONFIG_HAS_DMA instead?

 drivers/usb/gadget/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 3557c7e5040d..0e9dead51a27 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -302,6 +302,7 @@ config USB_PXA27X
 
 config USB_S3C_HSOTG
 	tristate "Designware/S3C HS/OtG USB Device controller"
+	depends on HAS_DMA
 	help
 	  The Designware USB2.0 high-speed gadget controller
 	  integrated into many SoCs.
-- 
1.7.9.5

