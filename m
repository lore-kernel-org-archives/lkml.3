Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbbAWShj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:37:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:38728 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbbAWShg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:37:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,455,1418112000"; 
   d="scan'208";a="655613504"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 01/10] drivers/char: Support compiling out memory-access char devices
Date: Fri, 23 Jan 2015 12:37:07 -0600
Message-Id: <15b4b4209511c374b6c06f4248d0528b22078a9b.1422035184.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1422035184.git.tom.zanussi@linux.intel.com>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1422035184.git.tom.zanussi@linux.intel.com>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many embedded systems can get by without the complete set of
memory-access char devices: /dev/mem, /dev/kmem, /dev/zero, /dev/null,
/dev/full, /dev/random, /dev/urandom, /dev/port, and /dev/kmsg.

Omitting them all can be accomplished by disabling DEVMEM_BASE, a new
EMBEDDED config option.

If DEVMEM_BASE is enabled, each of those devices can still be enabled
individually.

bloat-o-meter (based on tinyconfig):

add/remove: 0/51 grow/shrink: 2/1 up/down: 313/-5820 (-5507)
function                                     old     new   delta
sys_getrandom                                211     432    +221
do_syslog                                   1027    1119     +92
write_null                                     3       -      -3
read_null                                      3       -      -3
aio_read_null                                  3       -      -3
pipe_to_null                                   4       -      -4
mem_class                                      4       -      -4
write_full                                     6       -      -6
devkmsg_release                               15       -     -15
random_fasync                                 16       -     -16
mmap_zero                                     16       -     -16
aio_write_null                                18       -     -18
open_port                                     19       -     -19
random_read                                   20       -     -20
splice_write_null                             24       -     -24
null_lseek                                    25       -     -25
mmap_mem_ops                                  32       -     -32
mem_devnode                                   35       -     -35
mmap_kmem                                     37       -     -37
random_write                                  42       -     -42
write_pool                                    82       -     -82
random_poll                                   83       -     -83
read_iter_zero                                95       -     -95
urandom_read                                  96       -     -96
memory_open                                   96       -     -96
devkmsg_poll                                  97       -     -97
read_port                                     98       -     -98
mmap_mem                                     103       -    -103
devkmsg_open                                 112       -    -112
check_syslog_permissions                     114       -    -114
zero_fops                                    116       -    -116
write_port                                   116       -    -116
urandom_fops                                 116       -    -116
random_fops                                  116       -    -116
port_fops                                    116       -    -116
null_fops                                    116       -    -116
memory_fops                                  116       -    -116
mem_fops                                     116       -    -116
kmsg_fops                                    116       -    -116
kmem_fops                                    116       -    -116
full_fops                                    116       -    -116
memory_lseek                                 122       -    -122
devkmsg_llseek                               144       -    -144
chr_dev_init                                 162       3    -159
read_mem                                     162       -    -162
_random_read.part                            173       -    -173
write_mem                                    184       -    -184
devlist                                      192       -    -192
devkmsg_write                                209       -    -209
zero_bdi                                     244       -    -244
read_kmem                                    290       -    -290
random_ioctl                                 319       -    -319
write_kmem                                   349       -    -349
devkmsg_read                                 699       -    -699

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 arch/x86/Kconfig.debug |  1 +
 drivers/char/Kconfig   | 12 ++++++++++++
 drivers/char/mem.c     |  7 +++++++
 3 files changed, 20 insertions(+)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 61bd2ad..34a781a 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -7,6 +7,7 @@ source "lib/Kconfig.debug"
 
 config STRICT_DEVMEM
 	bool "Filter access to /dev/mem"
+	depends on DEVMEM_BASE
 	---help---
 	  If this option is disabled, you allow userspace (root) access to all
 	  of memory, including kernel and userspace memory. Accidental
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index efefd12..7a8204a 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -6,8 +6,19 @@ menu "Character devices"
 
 source "drivers/tty/Kconfig"
 
+config DEVMEM_BASE
+	bool "Base support for memory-access char devices" if EMBEDDED
+	default y
+	help
+	  Say Y here if you want to support the various character
+	  devices used to access memory, such as /dev/mem, /dev/null,
+	  /dev/zero, /dev/random, etc.  Many embedded systems can get
+	  by without these devices; doing so will save memory.  When
+	  in doubt, say "Y".
+
 config DEVKMEM
 	bool "/dev/kmem virtual device support"
+	depends on DEVMEM_BASE
 	default y
 	help
 	  Say Y here if you want to support the /dev/kmem device. The
@@ -577,6 +588,7 @@ config DEVPORT
 	bool
 	depends on !M68K
 	depends on ISA || PCI
+	depends on DEVMEM_BASE
 	default y
 
 source "drivers/s390/char/Kconfig"
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 4c58333..c141c0f 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -34,6 +34,7 @@
 # include <linux/efi.h>
 #endif
 
+#ifdef CONFIG_DEVMEM_BASE
 #define DEVPORT_MINOR	4
 
 static inline unsigned long size_inside_page(unsigned long start,
@@ -876,5 +877,11 @@ static int __init chr_dev_init(void)
 
 	return tty_init();
 }
+#else
+static int __init chr_dev_init(void)
+{
+	return tty_init();
+}
+#endif /* CONFIG_DEVMEM_BASE */
 
 fs_initcall(chr_dev_init);
-- 
1.9.3

