Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab3J2S0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:26:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59234 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab3J2SFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:05:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 02/81] random: run random_int_secret_init() run after all late_initcalls
Date: Tue, 29 Oct 2013 11:03:23 -0700
Message-Id: <1383069882-11437-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 47d06e532e95b71c0db3839ebdef3fe8812fca2c upstream.

The some platforms (e.g., ARM) initializes their clocks as
late_initcalls for some unknown reason.  So make sure
random_int_secret_init() is run after all of the late_initcalls are
run.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/char/random.c  | 3 +--
 include/linux/random.h | 1 +
 init/main.c            | 2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index b7dc45c..5b0c1cd 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1462,12 +1462,11 @@ ctl_table random_table[] = {
 
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
index d984608..6069225 100644
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
index cee4b5c..c29292c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -70,6 +70,7 @@
 #include <linux/perf_event.h>
 #include <linux/file.h>
 #include <linux/ptrace.h>
+#include <linux/random.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -784,6 +785,7 @@ static void __init do_basic_setup(void)
 	do_ctors();
 	usermodehelper_enable();
 	do_initcalls();
+	random_int_secret_init();
 }
 
 static void __init do_pre_smp_initcalls(void)
-- 
1.8.1.2

