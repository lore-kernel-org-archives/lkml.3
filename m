Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaBIVtL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 16:49:11 -0500
Received: from smtp.outflux.net ([198.145.64.163]:34601 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbaBIVtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 16:49:05 -0500
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        keescook@chromium.org
Subject: [PATCH 2/3] lkdtm: flush icache and report actions
Date: Sun,  9 Feb 2014 13:48:47 -0800
Message-Id: <1391982528-21083-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391982528-21083-1-git-send-email-keescook@chromium.org>
References: <1391982528-21083-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some CPUs explicitly need to have their icache flushed after making
executable code copies for the memory region execution tests.
Additionally, report the specific address targets being used so that
debugging non-crash failures is easier.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index e910b3c5331c..d6ee1aae3e72 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -329,7 +329,12 @@ static void execute_location(void *dst)
 {
 	void (*func)(void) = dst;
 
+	pr_info("attempting ok execution at %p\n", do_nothing);
+	do_nothing();
+
 	memcpy(dst, do_nothing, EXEC_SIZE);
+	flush_icache_range((unsigned long)dst, (unsigned long)dst + EXEC_SIZE);
+	pr_info("attempting bad execution at %p\n", func);
 	func();
 }
 
@@ -338,8 +343,13 @@ static void execute_user_location(void *dst)
 	/* Intentionally crossing kernel/user memory boundary. */
 	void (*func)(void) = dst;
 
+	pr_info("attempting ok execution at %p\n", do_nothing);
+	do_nothing();
+
 	if (copy_to_user((void __user *)dst, do_nothing, EXEC_SIZE))
 		return;
+	flush_icache_range((unsigned long)dst, (unsigned long)dst + EXEC_SIZE);
+	pr_info("attempting bad execution at %p\n", func);
 	func();
 }
 
@@ -464,8 +474,12 @@ static void lkdtm_do_action(enum ctype which)
 		}
 
 		ptr = (unsigned long *)user_addr;
+
+		pr_info("attempting bad read at %p\n", ptr);
 		tmp = *ptr;
 		tmp += 0xc0dec0de;
+
+		pr_info("attempting bad write at %p\n", ptr);
 		*ptr = tmp;
 
 		vm_munmap(user_addr, PAGE_SIZE);
@@ -476,6 +490,8 @@ static void lkdtm_do_action(enum ctype which)
 		unsigned long *ptr;
 
 		ptr = (unsigned long *)&rodata;
+
+		pr_info("attempting bad write at %p\n", ptr);
 		*ptr ^= 0xabcd1234;
 
 		break;
-- 
1.7.9.5

