Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab3HEQ3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:29:24 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40043 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab3HEQ3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:29:22 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>
Cc: =?ISO-8859-2?Q?Zbigniew_J=EAdrzejewski=2DSzmek?= 
	<zbyszek@in.waw.pl>,
        systemd-devel@lists.freedesktop.org,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        linux-hotplug@vger.kernel.org,
        Intel Linux Wireless <ilw@linux.intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] Change CONFIG_FW_LOADER_USER_HELPER to default n and don't select it
Date: Mon,  5 Aug 2013 09:29:17 -0700
Message-Id: <325b19bb936d7ebae11edad86aac8f0931e8abd9.1375719828.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <CALCETrXSnFPFVPkXHwz+FFA3=+pmz9V=cMHWwtN+jG1QJALWSQ@mail.gmail.com>
References: <CALCETrXSnFPFVPkXHwz+FFA3=+pmz9V=cMHWwtN+jG1QJALWSQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The systemd commit below can delay firmware loading by multiple
minutes if CONFIG_FW_LOADER_USER_HELPER=y.  Unfortunately no one
noticed that the systemd-udev change would break new kernels as well
as old kernels.

Since the kernel apparently can't count on reasonable userspace
support, turn this thing off by default.

commit a3bd8447be4ea2ce230eb8ae0e815c04d85fa15a
Author: Tom Gundersen <teg@jklm.no>
Date:   Mon Mar 18 15:12:18 2013 +0100

    udev: make firmware loading optional and disable by default

    Distros that whish to support old kernels should set
      --with-firmware-dirs="/usr/lib/firmware/updates:/usr/lib/firmware"
    to retain the old behaviour.
---
 drivers/base/Kconfig     | 15 +++++++++++----
 drivers/firmware/Kconfig |  1 -
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 5daa259..de3903e 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -146,13 +146,20 @@ config EXTRA_FIRMWARE_DIR
 config FW_LOADER_USER_HELPER
 	bool "Fallback user-helper invocation for firmware loading"
 	depends on FW_LOADER
-	default y
+	default n
 	help
 	  This option enables / disables the invocation of user-helper
 	  (e.g. udev) for loading firmware files as a fallback after the
-	  direct file loading in kernel fails.  The user-mode helper is
-	  no longer required unless you have a special firmware file that
-	  resides in a non-standard path.
+	  direct file loading in kernel fails.
+
+	  Since March 2013, a default udev build does not understand
+	  firmware loading requests.  These udev versions will not
+	  even indicate failure; instead they cause long timeouts.
+	  This can dramatically slow down the boot process.
+
+	  Say Y only if you have special firmware-loading requirements
+	  and if you have a non-standard helper that will handle these
+	  requests.
 
 config DEBUG_DRIVER
 	bool "Driver Core verbose debug messages"
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 07478728..9387630 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -64,7 +64,6 @@ config DELL_RBU
 	tristate "BIOS update support for DELL systems via sysfs"
 	depends on X86
 	select FW_LOADER
-	select FW_LOADER_USER_HELPER
 	help
 	 Say m if you want to have the option of updating the BIOS for your
 	 DELL system. Note you need a Dell OpenManage or Dell Update package (DUP)
-- 
1.8.3.1

