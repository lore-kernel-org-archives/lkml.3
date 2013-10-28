Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab3J1Oso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:48:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51010 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab3J1Osh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:48:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 04/64] random: run random_int_secret_init() run after all late_initcalls
Date: Mon, 28 Oct 2013 14:47:23 +0000
Message-Id: <1382971703-17393-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 47d06e532e95b71c0db3839ebdef3fe8812fca2c upstream.

The some platforms (e.g., ARM) initializes their clocks as
late_initcalls for some unknown reason.  So make sure
random_int_secret_init() is run after all of the late_initcalls are
run.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/char/random.c  | 3 +--
 include/linux/random.h | 1 +
 init/main.c            | 2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 395d2e8..e0b3680 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1447,12 +1447,11 @@ ctl_table random_table[] = {
 
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
index ac621ce..7e58ad2 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -56,6 +56,7 @@ extern void add_interrupt_randomness(int irq, int irq_flags);
 extern void get_random_bytes(void *buf, int nbytes);
 extern void get_random_bytes_arch(void *buf, int nbytes);
 void generate_random_uuid(unsigned char uuid_out[16]);
+extern int random_int_secret_init(void);
 
 #ifndef MODULE
 extern const struct file_operations random_fops, urandom_fops;
diff --git a/init/main.c b/init/main.c
index 9a053de..0b62dae 100644
--- a/init/main.c
+++ b/init/main.c
@@ -68,6 +68,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
 #include <linux/perf_event.h>
+#include <linux/random.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -779,6 +780,7 @@ static void __init do_basic_setup(void)
 	do_ctors();
 	usermodehelper_enable();
 	do_initcalls();
+	random_int_secret_init();
 }
 
 static void __init do_pre_smp_initcalls(void)
-- 
1.8.3.2

