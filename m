Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab3JRTzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 15:55:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757518Ab3JRTwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 15:52:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 03/11] random: run random_int_secret_init() run after all late_initcalls
Date: Fri, 18 Oct 2013 12:53:32 -0700
Message-Id: <20131018195049.303462687@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131018195049.069623827@linuxfoundation.org>
References: <20131018195049.069623827@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 47d06e532e95b71c0db3839ebdef3fe8812fca2c upstream.

The some platforms (e.g., ARM) initializes their clocks as
late_initcalls for some unknown reason.  So make sure
random_int_secret_init() is run after all of the late_initcalls are
run.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/random.c  |    3 +--
 include/linux/random.h |    1 +
 init/main.c            |    2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1435,12 +1435,11 @@ ctl_table random_table[] = {
 
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
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -56,6 +56,7 @@ extern void add_interrupt_randomness(int
 extern void get_random_bytes(void *buf, int nbytes);
 extern void get_random_bytes_arch(void *buf, int nbytes);
 void generate_random_uuid(unsigned char uuid_out[16]);
+extern int random_int_secret_init(void);
 
 #ifndef MODULE
 extern const struct file_operations random_fops, urandom_fops;
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


