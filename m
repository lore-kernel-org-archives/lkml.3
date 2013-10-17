Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761978Ab3JQCS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 22:18:57 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:54362 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760975Ab3JQCS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 22:18:56 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH] usb: usb_phy_gen: refine conditional declaration of usb_nop_xceiv_register
Date: Wed, 16 Oct 2013 19:18:41 -0700
Message-Id: <1381976321-11547-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3fa4d734 (usb: phy: rename nop_usb_xceiv => usb_phy_gen_xceiv)
changed the conditional around the declaration of usb_nop_xceiv_register
from
	#if defined(CONFIG_NOP_USB_XCEIV) ||
		(defined(CONFIG_NOP_USB_XCEIV_MODULE) && defined(MODULE))
to
	#if IS_ENABLED(CONFIG_NOP_USB_XCEIV)

While that looks the same, it is semantically different. The first expression
is true if CONFIG_NOP_USB_XCEIV is built as module and if the including
code is built as module. The second expression is true if code depending on
CONFIG_NOP_USB_XCEIV if built as module or into the kernel.

As a result, the arm:allmodconfig build fails with

arch/arm/mach-omap2/built-in.o: In function `omap3_evm_init':
arch/arm/mach-omap2/board-omap3evm.c:703: undefined reference to
	`usb_nop_xceiv_register'

Fix the problem by reverting to the old conditional.

Cc: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 include/linux/usb/usb_phy_gen_xceiv.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/usb/usb_phy_gen_xceiv.h b/include/linux/usb/usb_phy_gen_xceiv.h
index f9a7e7b..11d85b9 100644
--- a/include/linux/usb/usb_phy_gen_xceiv.h
+++ b/include/linux/usb/usb_phy_gen_xceiv.h
@@ -12,7 +12,7 @@ struct usb_phy_gen_xceiv_platform_data {
 	unsigned int needs_reset:1;
 };
 
-#if IS_ENABLED(CONFIG_NOP_USB_XCEIV)
+#if defined(CONFIG_NOP_USB_XCEIV) || (defined(CONFIG_NOP_USB_XCEIV_MODULE) && defined(MODULE))
 /* sometimes transceivers are accessed only through e.g. ULPI */
 extern void usb_nop_xceiv_register(void);
 extern void usb_nop_xceiv_unregister(void);
-- 
1.7.9.7

