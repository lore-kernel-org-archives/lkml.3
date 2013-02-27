Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760314Ab3B0TJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:09:01 -0500
Received: from mail.windriver.com ([147.11.1.11]:36569 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab3B0TJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:09:00 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-usb@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Moiz Sonasath <m-sonasath@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] usb: limit OMAP related USB options to OMAP2PLUS platforms
Date: Wed, 27 Feb 2013 14:08:39 -0500
Message-ID: <1361992119-2465-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 57f6ce072e35770a63be0c5d5e82f90d8da7d665 ("usb: phy:
add a new driver for usb3 phy") added the new Kconfig option
OMAP_USB3, but it had no dependencies whatsoever, and hence
became available across all arch/platforms.

Which presumably caused this to show up in x86 randconfig:

    warning: (USB_MUSB_HDRC && OMAP_USB3) selects \
        OMAP_CONTROL_USB which has unmet direct \
        dependencies (USB_SUPPORT && ARCH_OMAP2PLUS)

Then commit 6992819feb39cb9adac72170555d957d07f869f2 ("usb: phy:
fix Kconfig warning") was added.  However, this just deleted the
ARCH_OMAP2PLUS dependency from OMAP_CONTROL_USB, further
compounding the problem by opening up OMAP_CONTROL_USB to
all arch/platforms as well.

Here we revert the change of 6992819feb to restore the dependency,
and add the same ARCH_OMAP2PLUS dependency to the new OMAP_USB3.

Perhaps a more platform specific dependency could be chosen for
OMAP_USB3, but at least this keeps it from bleeding out to other
architectures and non-OMAP ARM platforms as it is currently doing.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Moiz Sonasath <m-sonasath@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/phy/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 65217a5..40b8463 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -17,6 +17,7 @@ config OMAP_USB2
 
 config OMAP_USB3
 	tristate "OMAP USB3 PHY Driver"
+	depends on ARCH_OMAP2PLUS
 	select USB_OTG_UTILS
 	select OMAP_CONTROL_USB
 	help
@@ -27,6 +28,7 @@ config OMAP_USB3
 
 config OMAP_CONTROL_USB
 	tristate "OMAP CONTROL USB Driver"
+	depends on ARCH_OMAP2PLUS
 	help
 	  Enable this to add support for the USB part present in the control
 	  module. This driver has API to power on the USB2 PHY and to write to
-- 
1.8.1.2

