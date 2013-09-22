Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3IVUje (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 16:39:34 -0400
Received: from imap.thunk.org ([74.207.234.97]:35992 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab3IVUjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 16:39:20 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: hpa@zytor.com, joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
        dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
        smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de,
        "Theodore Ts'o" <tytso@mit.edu>, stable@vger.kernel.org
Subject: [PATCH, RFC 01/12] random: run random_int_secret_init() run after all late_initcalls
Date: Sun, 22 Sep 2013 16:38:47 -0400
Message-Id: <1379882338-7209-2-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.12.rc0.22.gcdd159b
In-Reply-To: <1379882338-7209-1-git-send-email-tytso@mit.edu>
References: <1379882338-7209-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The some platforms (e.g., ARM) initializes their clocks as
late_initcalls for some unknown reason.  So make sure
random_int_secret_init() is run all of the late_initcalls are run.

Cc: stable@vger.kernel.org
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c  | 3 +--
 include/linux/random.h | 1 +
 init/main.c            | 2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0d91fe5..92e6c67 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1462,12 +1462,11 @@ struct ctl_table random_table[] = {
 
 static u32 random_int_secret[MD5_MESSAGE_BYTES / 4] ____cacheline_aligned;
 
-static int __init random_int_secret_init(void)
+int random_int_secret_init(void)
 {
 	get_random_bytes(random_int_secret, sizeof(random_int_secret));
 	return 0;
 }
-late_initcall(random_int_secret_init);
 
 /*
  * Get a random word for internal kernel use only. Similar to urandom but
diff --git a/include/linux/random.h b/include/linux/random.h
index 3b9377d..6312dd9 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -17,6 +17,7 @@ extern void add_interrupt_randomness(int irq, int irq_flags);
 extern void get_random_bytes(void *buf, int nbytes);
 extern void get_random_bytes_arch(void *buf, int nbytes);
 void generate_random_uuid(unsigned char uuid_out[16]);
+extern int random_int_secret_init(void);
 
 #ifndef MODULE
 extern const struct file_operations random_fops, urandom_fops;
diff --git a/init/main.c b/init/main.c
index d03d2ec..586cd33 100644
--- a/init/main.c
+++ b/init/main.c
@@ -75,6 +75,7 @@
 #include <linux/blkdev.h>
 #include <linux/elevator.h>
 #include <linux/sched_clock.h>
+#include <linux/random.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -778,6 +779,7 @@ static void __init do_basic_setup(void)
 	do_ctors();
 	usermodehelper_enable();
 	do_initcalls();
+	random_int_secret_init();
 }
 
 static void __init do_pre_smp_initcalls(void)
-- 
1.7.12.rc0.22.gcdd159b

