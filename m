Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935766Ab3IEMSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 08:18:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934668Ab3IEMSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 08:18:52 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] random, Add user configurable get_bytes_random()
Date: Thu,  5 Sep 2013 08:18:44 -0400
Message-Id: <1378383524-27983-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code has two exported functions, get_bytes_random() and
get_bytes_random_arch().  The first function only calls the entropy
store to get random data, and the second only calls the arch specific
hardware random number generator.

The problem is that no code is using the get_bytes_random_arch() and switching
over will require a significant code change.  Even if the change is
made it will be static forcing a recompile of code if/when a user has a
system with a trusted random HW source.  A better thing to do is allow
users to decide whether they trust their hardare random number generator.

This patchset adds a kernel parameter, hw_random_bytes, and a kernel config
option, CONFIG_HW_RANDOM_BYTES, which allows the enabling and disabling
of the hardware random number generator at boot time and at compile time.
This will allow distributions to decide if they want to use the hardware
random number generator while allowing individual users to enable or
disable generator.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
---
 Documentation/kernel-parameters.txt |    5 +++++
 drivers/char/Kconfig                |    8 ++++++++
 drivers/char/random.c               |   37 +++++++++++++++++++++++++++--------
 3 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 31a9e51..310663c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1029,6 +1029,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			       If specified, z/VM IUCV HVC accepts connections
 			       from listed z/VM user IDs only.
 
+	hw_random_bytes=  [HW] Enable/Disable use of arch specific hardware
+			       random number generator in calls to
+			       get_random_bytes()
+			       Format: 0 (disable/default) | 1 (enable)
+
 	hwthread_map=	[METAG] Comma-separated list of Linux cpu id to
 			        hardware thread id mappings.
 				Format: <cpu>:<hwthread>
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 1421997..1de2a0d 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -235,6 +235,14 @@ config NWFLASH
 	  If you're not sure, say N.
 
 source "drivers/char/hw_random/Kconfig"
+config HW_RANDOM_BYTES
+	bool "Enable Hardware Random Number Generator for get_random_bytes()"
+	default "n"
+	help
+	  Some architectures provide a default hardware random number
+	  generator.  By default, get_random_bytes() does not use this
+	  generator to provide data.  Setting this to "y" switches
+	  get_random_bytes() to use the hardware random number generator.
 
 config NVRAM
 	tristate "/dev/nvram support"
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0d91fe5..44ab100 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1049,19 +1049,27 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
 }
 
 /*
- * This function is the exported kernel interface.  It returns some
- * number of good random numbers, suitable for key generation, seeding
- * TCP sequence numbers, etc.  It does not use the hw random number
- * generator, if available; use get_random_bytes_arch() for that.
+ * Setting of hw_random_bytes will force get_random_bytes() to use the
+ * arch-specific hardware random number generator.
  */
-void get_random_bytes(void *buf, int nbytes)
+#ifdef CONFIG_HW_RANDOM_BYTES
+static int hw_random_bytes = 1;
+#else
+static int hw_random_bytes = 0;
+#endif
+static __init int set_hw_random_bytes(char *s)
 {
-	extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
+	get_option(&s, &hw_random_bytes);
+	if (hw_random_bytes)
+		pr_info("get_random_bytes() using HW RNG\n");
+	else
+		pr_info("get_random_bytes() not using HW RNG\n");
+	return 0;
 }
-EXPORT_SYMBOL(get_random_bytes);
+__setup("hw_random_bytes=", set_hw_random_bytes);
 
 /*
- * This function will use the architecture-specific hardware random
+ * This function will always use the architecture-specific hardware random
  * number generator if it is available.  The arch-specific hw RNG will
  * almost certainly be faster than what we can do in software, but it
  * is impossible to verify that it is implemented securely (as
@@ -1092,6 +1100,19 @@ void get_random_bytes_arch(void *buf, int nbytes)
 }
 EXPORT_SYMBOL(get_random_bytes_arch);
 
+/*
+ * This function is the well-known exported kernel interface.  It returns some
+ * number of good random numbers, suitable for key generation, seeding
+ * TCP sequence numbers, etc.
+ */
+void get_random_bytes(void *buf, int nbytes)
+{
+	if (hw_random_bytes)
+		get_random_bytes_arch(buf, nbytes);
+	else
+		extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
+}
+EXPORT_SYMBOL(get_random_bytes);
 
 /*
  * init_std_data - initialize pool with system data
-- 
1.7.9.3

