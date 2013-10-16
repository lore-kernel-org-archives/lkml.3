Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935121Ab3JPSDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:03:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933857Ab3JPRqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 05/50] random: run random_int_secret_init() run after all late_initcalls
Date: Wed, 16 Oct 2013 10:44:51 -0700
Message-Id: <20131016174359.003595309@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -17,6 +17,7 @@ extern void add_interrupt_randomness(int
 extern void get_random_bytes(void *buf, int nbytes);
 extern void get_random_bytes_arch(void *buf, int nbytes);
 void generate_random_uuid(unsigned char uuid_out[16]);
+extern int random_int_secret_init(void);
 
 #ifndef MODULE
 extern const struct file_operations random_fops, urandom_fops;
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


