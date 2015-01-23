Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbbAWShr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:37:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:50222 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383AbbAWShm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:37:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,455,1418112000"; 
   d="scan'208";a="516734302"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 03/10] drivers/char: Support compiling out /dev/port
Date: Fri, 23 Jan 2015 12:37:09 -0600
Message-Id: <1d1e64010cd58468d6fa71bf1570ff1a3e66522c.1422035184.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1422035184.git.tom.zanussi@linux.intel.com>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1422035184.git.tom.zanussi@linux.intel.com>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's already a CONFIG_DEVPORT option, but it isn't accessible to
users.  Give it some menu and help text and allow it to be toggled
off.

Aside from giving embedded systems that don't need it the ability to
turn it off, it also allows the code shared between it and other
options to be compiled out (open_port() shared with /dev/mem, and
memory_lseek() shared with /dev/mem and /dev/kmem; both functions have
been changed to __maybe_unused for when all of the above are compiled
out).

bloat-o-meter (based on tinyconfig):

add/remove: 0/3 grow/shrink: 0/0 up/down: 0/-330 (-330)
function                                     old     new   delta
read_port                                     98       -     -98
write_port                                   116       -    -116
port_fops                                    116       -    -116

bloat-o-meter showing the difference between both CONFIG_DEVKMEM and
CONFIG_DEVMEM off and that plus CONFIG_DEVPORT off:

add/remove: 0/5 grow/shrink: 0/0 up/down: 0/-471 (-471)
function                                     old     new   delta
open_port                                     19       -     -19
read_port                                     98       -     -98
write_port                                   116       -    -116
port_fops                                    116       -    -116
memory_lseek                                 122       -    -122

So with all three configured out, we see the mutually shared open_port
and memory_lseek drop out.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 drivers/char/Kconfig | 7 ++++++-
 drivers/char/mem.c   | 5 +++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 73e2bb8..5a6c060 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -595,11 +595,16 @@ config TELCLOCK
 	  controlling the behavior of this hardware.
 
 config DEVPORT
-	bool
+	bool "/dev/port virtual device support"
 	depends on !M68K
 	depends on ISA || PCI
 	depends on DEVMEM_BASE
 	default y
+	help
+	  Say Y here if you want to support the /dev/port device. The
+	  /dev/port device is a character device that allows userspace
+	  access to I/O ports, which may be needed by some programs.
+	  When in doubt, say "Y".
 
 source "drivers/s390/char/Kconfig"
 
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 9b7b04e..5944d87 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -682,7 +682,8 @@ static loff_t null_lseek(struct file *file, loff_t offset, int orig)
  * also note that seeking relative to the "end of file" isn't supported:
  * it has no meaning, so it returns -EINVAL.
  */
-static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
+static loff_t __maybe_unused memory_lseek(struct file *file, loff_t offset,
+					  int orig)
 {
 	loff_t ret;
 
@@ -707,7 +708,7 @@ static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
 	return ret;
 }
 
-static int open_port(struct inode *inode, struct file *filp)
+static int __maybe_unused open_port(struct inode *inode, struct file *filp)
 {
 	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
 }
-- 
1.9.3

