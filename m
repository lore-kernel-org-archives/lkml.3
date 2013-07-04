Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab3GDFlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 01:41:01 -0400
Received: from mail1.windriver.com ([147.11.146.13]:39978 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab3GDFk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 01:40:59 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
CC: <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Moiz Sonasath <m-sonasath@ti.com>
Subject: [PATCH 1/4] usb: limit OMAP related USB options to OMAP2PLUS platforms
Date: Thu, 4 Jul 2013 01:39:10 -0400
Message-ID: <1372916353-24050-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372916353-24050-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372916353-24050-1-git-send-email-paul.gortmaker@windriver.com>
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

Earlier it was suggested[1] that we revert the change of 6992819feb
to restore the dependency, and add a same ARCH_OMAP2PLUS dependency
to the new OMAP_USB3 entry.  However that was discouraged on the
grounds of people wanting the extra sanity compile testing on x86,
even though the driver could probably never be used there.

Now we have CONFIG_COMPILE_TEST, so developers who value the ability
to compile drivers on an architecture that it never can be used for
can have that, and people who want dependencies to shield them from
seeing options that aren't relevant to their platform get what they
want too.

Here we restore the dependency but couple it with COMPILE_TEST, in
order to achieve both of the above goals.

[1] https://patchwork.kernel.org/patch/2194511/

Cc: Felipe Balbi <balbi@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Moiz Sonasath <m-sonasath@ti.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/phy/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index a5a9552..f061f28 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -65,6 +65,7 @@ config NOP_USB_XCEIV
 
 config OMAP_CONTROL_USB
 	tristate "OMAP CONTROL USB Driver"
+	depends on ARCH_OMAP2PLUS || COMPILE_TEST
 	help
 	  Enable this to add support for the USB part present in the control
 	  module. This driver has API to power on the USB2 PHY and to write to
@@ -84,6 +85,7 @@ config OMAP_USB2
 
 config OMAP_USB3
 	tristate "OMAP USB3 PHY Driver"
+	depends on ARCH_OMAP2PLUS || COMPILE_TEST
 	select OMAP_CONTROL_USB
 	help
 	  Enable this to support the USB3 PHY that is part of SOC. This
-- 
1.8.1.2

