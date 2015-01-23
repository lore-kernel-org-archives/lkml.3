Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbbAWSii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:38:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:44936 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204AbbAWSiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:38:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,455,1418112000"; 
   d="scan'208";a="655613630"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 10/10] drivers/char: Support compiling out the getrandom(2) syscall
Date: Fri, 23 Jan 2015 12:37:16 -0600
Message-Id: <87fec26efb0a0e4a8daab238ee39261dca2dc985.1422035184.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1422035184.git.tom.zanussi@linux.intel.com>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1422035184.git.tom.zanussi@linux.intel.com>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many embedded systems have no use for getrandom, and could benefit
from the size savings gained by omitting it.  Add a new EXPERT config
option, CONFIG_GETRANDOM_SYSCALL (default y), to support compiling it
out.

The newly marked __maybe_unused _random_read is shared between
getrandom(2) and /dev/random, and urandom_read is shared between
getrandom(2) and /dev/urandom, and will be compiled out respectively
if either devices and getrandom(2) are disabled.

bloat-o-meter (based on tinyconfig):

add/remove: 0/2 grow/shrink: 1/0 up/down: 163/-384 (-221)
function                                     old     new   delta
random_read                                   20     183    +163
_random_read.part                            173       -    -173
sys_getrandom                                211       -    -211

Here, _random_read is inlined into random_read, which drops the cold
part of the _random_read partial inline _random_read.part.

bloat-o-meter showing the difference between both CONFIG_DEVRANDOM and
CONFIG_DEVURANDOM off and that plus CONFIG_GETRANDOM_SYSCALL off:

add/remove: 0/5 grow/shrink: 1/2 up/down: 332/-1038 (-706)
function                                     old     new   delta
extract_entropy                              114     446    +332
__print_once                                  16      15      -1
mix_pool_bytes                                17      14      -3
xfer_secondary_pool                           60       -     -60
extract_buf                                  164       -    -164
account                                      181       -    -181
extract_entropy_user                         197       -    -197
sys_getrandom                                432       -    -432

Here we see xfer_secondary_pool, extract_buf, and account inlined into
extract_entropy, while extract_entropy_user from _random_read drops
out because _random_read is dropped (random_read and _random_read.part
drop out when only DEVRANDOM and DEVURANDOM are compiled out -
_random_read is inlined into sys_getrandom in that case, which drops
out when GETRANDOM_SYSCALL is disabled).

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 drivers/char/Kconfig  | 13 +++++++++++++
 drivers/char/random.c |  6 ++++--
 kernel/sys_ni.c       |  1 +
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 25fe627..7f7c921 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -103,6 +103,19 @@ config DEVKMSG
 	  be directed to use that interface instead.  When in doubt,
 	  say "Y".
 
+config GETRANDOM_SYSCALL
+	bool "Enable getrandom(2) syscall" if EXPERT
+	default y
+	help
+	  Say Y here if you want to enable the getrandom(2) syscall.
+	  The getrandom(2) syscall provides a means to access the
+	  kernel random number generator in cases where /dev/[u]random
+	  is not available.  It also adds optional blocking semantics
+	  to the /dev/urandom entropy pool for programs that are
+	  designed to use it.  It can be disabled on systems that will
+	  never use it in production, such as many embedded systems.
+	  When in doubt, say "Y".
+
 config SGI_SNSC
 	bool "SGI Altix system controller communication support"
 	depends on (IA64_SGI_SN2 || IA64_GENERIC)
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 7e5a423..2a9955f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1339,7 +1339,7 @@ void rand_initialize_disk(struct gendisk *disk)
 }
 #endif
 
-static ssize_t
+static ssize_t __maybe_unused
 _random_read(int nonblock, char __user *buf, size_t nbytes)
 {
 	ssize_t n;
@@ -1378,7 +1378,7 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 }
 #endif
 
-static ssize_t
+static ssize_t __maybe_unused
 urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
 	int ret;
@@ -1530,6 +1530,7 @@ const struct file_operations urandom_fops = {
 };
 #endif
 
+#ifdef CONFIG_GETRANDOM_SYSCALL
 SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
 		unsigned int, flags)
 {
@@ -1552,6 +1553,7 @@ SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
 	}
 	return urandom_read(NULL, buf, count, NULL);
 }
+#endif
 
 /***************************************************************
  * Random UUID interface
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 5adcb0a..796021b 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -159,6 +159,7 @@ cond_syscall(sys_uselib);
 cond_syscall(sys_fadvise64);
 cond_syscall(sys_fadvise64_64);
 cond_syscall(sys_madvise);
+cond_syscall(sys_getrandom);
 
 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);
-- 
1.9.3

