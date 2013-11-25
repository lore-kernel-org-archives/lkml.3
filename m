Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab3KYO0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:26:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58868 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753945Ab3KYNxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:39 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Theodore Ts'o" <tytso@mit.edu>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.701442343@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 37/87] random: run random_int_secret_init() run after
 all late_initcalls
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 47d06e532e95b71c0db3839ebdef3fe8812fca2c upstream.

The some platforms (e.g., ARM) initializes their clocks as
late_initcalls for some unknown reason.  So make sure
random_int_secret_init() is run after all of the late_initcalls are
run.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/random.c  | 3 +--
 include/linux/random.h | 1 +
 init/main.c            | 2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1480,12 +1480,11 @@ ctl_table random_table[] = {
 
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
@@ -58,6 +58,7 @@ extern void add_interrupt_randomness(int
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
@@ -732,6 +733,7 @@ static void __init do_basic_setup(void)
 	do_ctors();
 	usermodehelper_enable();
 	do_initcalls();
+	random_int_secret_init();
 }
 
 static void __init do_pre_smp_initcalls(void)

