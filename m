Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbaHLC2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 22:28:12 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:41494
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbaHLC2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 22:28:10 -0400
x-originating-ip: 72.167.245.219
From: Dexuan Cui <decui@microsoft.com>
To: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Cc: kys@microsoft.com, haiyangz@microsoft.com
Subject: [PATCH] Input: serio: make HYPERV_KEYBOARD depend on SERIO_I8042=y
Date: Mon, 11 Aug 2014 20:30:40 -0700
Message-Id: <1407814240-4275-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hyperv_keyboard invokes serio_interrupt(), which needs a valid serio driver
like atkbd.c.
atkbd.c depends on libps2.c because it invokes ps2_command().
libps2.c depends on i8042.c because it invokes i8042_check_port_owner().
As a result, hyperv_keyboard actually depends on i8042.c.

For a Generation 2 Hyper-V VM (meaning no i8042 device emulated), if a Linux
VM (like Arch Linux) happens to configure CONFIG_SERIO_I8042=m rather than
=y, atkbd.ko can't load because i8042.ko can't load(due to no i8042 device
emulated) and finally hyperv_keyboard can't work and the user can't input:
https://bugs.archlinux.org/task/39820
(Ubuntu/RHEL/SUSE aren't affected since they use CONFIG_SERIO_I8042=y)

Decoupling the dependency between hyperv_keyboard and i8042 needs
non-trivial efforts and is hence a long term goal.

For now, let's make the dependency explicit so people can beware of this.

Thank Claudio for the initial reporting, investigation and suggesting the fix.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reported-by: Claudio Latini <claudio.latini@live.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/input/serio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index bc2d474..3277bff 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -273,7 +273,7 @@ config SERIO_OLPC_APSP
 
 config HYPERV_KEYBOARD
 	tristate "Microsoft Synthetic Keyboard driver"
-	depends on HYPERV
+	depends on HYPERV && SERIO_I8042=y
 	default HYPERV
 	help
 	  Select this option to enable the Hyper-V Keyboard driver.
-- 
1.9.1

