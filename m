Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbbAWSjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:39:00 -0500
Received: from mga14.intel.com ([192.55.52.115]:15256 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756456AbbAWShz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:37:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,455,1418112000"; 
   d="scan'208";a="641732095"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 07/10] drivers/char: Support compiling out /dev/random
Date: Fri, 23 Jan 2015 12:37:13 -0600
Message-Id: <ff386ab25078a3cfabd14714a46a8bedf4dd444f.1422035184.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1422035184.git.tom.zanussi@linux.intel.com>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1422035184.git.tom.zanussi@linux.intel.com>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some embedded systems with tightly controlled userspace have no use
for /dev/random, and could benefit from the size savings gained by
omitting it.  Add a new EMBEDDED config option to disable it.

The newly marked __maybe_unused functions, random_write, random_ioctl,
and random_fasync are shared between /dev/random and /dev/urandom, and
will be compiled out if both devices are disabled.

bloat-o-meter (based on tinyconfig):

add/remove: 0/4 grow/shrink: 1/0 up/down: 139/-392 (-253)
function                                     old     new   delta
sys_getrandom                                211     350    +139
random_read                                   20       -     -20
random_poll                                   83       -     -83
random_fops                                  116       -    -116
_random_read.part                            173       -    -173

bloat-o-meter showing the difference between only CONFIG_DEVURANDOM
off and both CONFIG_DEVURANDOM and CONFIG_DEVRANDOM off:

add/remove: 0/8 grow/shrink: 1/0 up/down: 144/-851 (-707)
function                                     old     new   delta
sys_getrandom                                288     432    +144
random_fasync                                 16       -     -16
random_read                                   20       -     -20
random_write                                  42       -     -42
write_pool                                    82       -     -82
random_poll                                   83       -     -83
random_fops                                  116       -    -116
_random_read.part                            173       -    -173
random_ioctl                                 319       -    -319

So we see the extra symbols drop, while _random_read is inlined into
sys_getrandom.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 drivers/char/Kconfig  | 11 +++++++++++
 drivers/char/mem.c    |  2 ++
 drivers/char/random.c | 16 ++++++++++++----
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 62290e0..9416b7e 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -67,6 +67,17 @@ config DEVFULL
 	  never use it in production, such as many embedded systems.
 	  When in doubt, say "Y".
 
+config DEVRANDOM
+	bool "/dev/random virtual device support" if EMBEDDED
+	depends on DEVMEM_BASE
+	default y
+	help
+	  Say Y here if you want to support the /dev/random
+	  device. The /dev/random device is the blocking userspace
+	  interface to the kernel random number generator, and can be
+	  disabled on systems that will never use it in production,
+	  such as many embedded systems.  When in doubt, say "Y".
+
 config SGI_SNSC
 	bool "SGI Altix system controller communication support"
 	depends on (IA64_SGI_SN2 || IA64_GENERIC)
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 5b60003..f226714 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -826,7 +826,9 @@ static const struct memdev {
 #ifdef CONFIG_DEVFULL
 	 [7] = { "full", 0666, &full_fops, NULL },
 #endif
+#ifdef CONFIG_DEVRANDOM
 	 [8] = { "random", 0666, &random_fops, NULL },
+#endif
 	 [9] = { "urandom", 0666, &urandom_fops, NULL },
 #ifdef CONFIG_PRINTK
 	[11] = { "kmsg", 0644, &kmsg_fops, NULL },
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 04645c0..8547056 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1370,11 +1370,13 @@ _random_read(int nonblock, char __user *buf, size_t nbytes)
 	}
 }
 
+#ifdef CONFIG_DEVRANDOM
 static ssize_t
 random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
 	return _random_read(file->f_flags & O_NONBLOCK, buf, nbytes);
 }
+#endif
 
 static ssize_t
 urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
@@ -1394,6 +1396,7 @@ urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 	return ret;
 }
 
+#ifdef CONFIG_DEVRANDOM
 static unsigned int
 random_poll(struct file *file, poll_table * wait)
 {
@@ -1408,6 +1411,7 @@ random_poll(struct file *file, poll_table * wait)
 		mask |= POLLOUT | POLLWRNORM;
 	return mask;
 }
+#endif
 
 static int
 write_pool(struct entropy_store *r, const char __user *buffer, size_t count)
@@ -1431,8 +1435,9 @@ write_pool(struct entropy_store *r, const char __user *buffer, size_t count)
 	return 0;
 }
 
-static ssize_t random_write(struct file *file, const char __user *buffer,
-			    size_t count, loff_t *ppos)
+static ssize_t __maybe_unused random_write(struct file *file,
+					   const char __user *buffer,
+					   size_t count, loff_t *ppos)
 {
 	size_t ret;
 
@@ -1446,7 +1451,8 @@ static ssize_t random_write(struct file *file, const char __user *buffer,
 	return (ssize_t)count;
 }
 
-static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
+static long __maybe_unused random_ioctl(struct file *f, unsigned int cmd,
+					unsigned long arg)
 {
 	int size, ent_count;
 	int __user *p = (int __user *)arg;
@@ -1498,11 +1504,12 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 	}
 }
 
-static int random_fasync(int fd, struct file *filp, int on)
+static int __maybe_unused random_fasync(int fd, struct file *filp, int on)
 {
 	return fasync_helper(fd, filp, on, &fasync);
 }
 
+#ifdef CONFIG_DEVRANDOM
 const struct file_operations random_fops = {
 	.read  = random_read,
 	.write = random_write,
@@ -1511,6 +1518,7 @@ const struct file_operations random_fops = {
 	.fasync = random_fasync,
 	.llseek = noop_llseek,
 };
+#endif
 
 const struct file_operations urandom_fops = {
 	.read  = urandom_read,
-- 
1.9.3

