Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab3JGAFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 20:05:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51763 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754992Ab3JGAFw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 20:05:52 -0400
Message-ID: <1381104346.2788.49.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 2/2] sysrq: Allow magic SysRq key functions to be disabled
 through Kconfig
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Dave Jones <davej@redhat.com>, Bastian Blank <waldi@debian.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 07 Oct 2013 01:05:46 +0100
In-Reply-To: <1381103326.2788.45.camel@deadeye.wl.decadent.org.uk>
References: <1381103326.2788.45.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn the initial value of sysctl kernel.sysrq (SYSRQ_DEFAULT_ENABLE)
into a Kconfig variable.

Original version by Bastian Blank <waldi@debian.org>.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
v2:
- Added cross-references between sysrq.txt and Kconfig help
  (and added the hex values with a preparatory patch)
- Removed the redunant SYSRQ_DEFAULT_ENABLE macro
- Renamed the Kconfig symbol because it's not necessarily a mask

 Documentation/sysrq.txt | 13 ++++++-------
 drivers/tty/sysrq.c     |  2 +-
 include/linux/sysrq.h   |  3 ---
 kernel/sysctl.c         |  2 +-
 lib/Kconfig.debug       |  9 +++++++++
 5 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/Documentation/sysrq.txt b/Documentation/sysrq.txt
index 1c0471d..0e307c9 100644
--- a/Documentation/sysrq.txt
+++ b/Documentation/sysrq.txt
@@ -11,11 +11,9 @@ regardless of whatever else it is doing, unless it is completely locked up.
 You need to say "yes" to 'Magic SysRq key (CONFIG_MAGIC_SYSRQ)' when
 configuring the kernel. When running a kernel with SysRq compiled in,
 /proc/sys/kernel/sysrq controls the functions allowed to be invoked via
-the SysRq key. By default the file contains 1 which means that every
-possible SysRq request is allowed (in older versions SysRq was disabled
-by default, and you were required to specifically enable it at run-time
-but this is not the case any more). Here is the list of possible values
-in /proc/sys/kernel/sysrq:
+the SysRq key. The default value in this file is set by the
+CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE config symbol, which itself defaults
+to 1. Here is the list of possible values in /proc/sys/kernel/sysrq:
    0 - disable sysrq completely
    1 - enable all functions of sysrq
   >1 - bitmask of allowed sysrq functions (see below for detailed function
@@ -32,8 +30,9 @@ in /proc/sys/kernel/sysrq:
 You can set the value in the file by the following command:
     echo "number" >/proc/sys/kernel/sysrq
 
-The number may be written either as decimal or as hexadecimal with the
-0x prefix.
+The number may be written here either as decimal or as hexadecimal
+with the 0x prefix. CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE must always be
+written in hexadecimal.
 
 Note that the value of /proc/sys/kernel/sysrq influences only the invocation
 via a keyboard. Invocation of any operation via /proc/sysrq-trigger is always
diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 40a9fe9..ce396ec 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -51,7 +51,7 @@
 #include <asm/irq_regs.h>
 
 /* Whether we react on sysrq keys or just ignore them */
-static int __read_mostly sysrq_enabled = SYSRQ_DEFAULT_ENABLE;
+static int __read_mostly sysrq_enabled = CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE;
 static bool __read_mostly sysrq_always_enabled;
 
 unsigned short platform_sysrq_reset_seq[] __weak = { KEY_RESERVED };
diff --git a/include/linux/sysrq.h b/include/linux/sysrq.h
index 7faf933..387fa7d 100644
--- a/include/linux/sysrq.h
+++ b/include/linux/sysrq.h
@@ -17,9 +17,6 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 
-/* Enable/disable SYSRQ support by default (0==no, 1==yes). */
-#define SYSRQ_DEFAULT_ENABLE	1
-
 /* Possible values of bitmask for enabling sysrq functions */
 /* 0x0001 is reserved for enable everything */
 #define SYSRQ_ENABLE_LOG	0x0002
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b2f06f3..8b80f1b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -190,7 +190,7 @@ static int proc_dostring_coredump(struct ctl_table *table, int write,
 
 #ifdef CONFIG_MAGIC_SYSRQ
 /* Note: sysrq code uses it's own private copy */
-static int __sysrq_enabled = SYSRQ_DEFAULT_ENABLE;
+static int __sysrq_enabled = CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE;
 
 static int sysrq_sysctl_handler(ctl_table *table, int write,
 				void __user *buffer, size_t *lenp,
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 06344d9..2932937 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -312,6 +312,15 @@ config MAGIC_SYSRQ
 	  keys are documented in <file:Documentation/sysrq.txt>. Don't say Y
 	  unless you really know what this hack does.
 
+config MAGIC_SYSRQ_DEFAULT_ENABLE
+	hex "Enable magic SysRq key functions by default"
+	depends on MAGIC_SYSRQ
+	default 0x1
+	help
+	  Specifies which SysRq key functions are enabled by default.
+	  This may be set to 1 or 0 to enable or disable them all, or
+	  to a bitmask as described in Documentation/sysrq.txt.
+
 config DEBUG_KERNEL
 	bool "Kernel debugging"
 	help

-- 
Ben Hutchings
If at first you don't succeed, you're doing about average.
