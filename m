Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab3ARB1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 20:27:23 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:42715 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3ARB1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 20:27:20 -0500
Date: Thu, 17 Jan 2013 17:27:13 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3/3] async, kmod: warn on synchronous request_module() from
 async workers
Message-ID: <20130118012713.GI16568@mtj.dyndns.org>
References: <CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com>
 <20130116025251.GM2668@htj.dyndns.org>
 <CA+55aFxttTkWG0gfUz3=V8A-9az3+qY3j0JZEAoKv0ne-QupZw@mail.gmail.com>
 <20130116032502.GN2668@htj.dyndns.org>
 <CA+55aFxCudzOv8e2XjHiT=Qhy9q+mrxUfSYAT=eU6Gq8uyNORw@mail.gmail.com>
 <20130116164832.GP2668@htj.dyndns.org>
 <50F6DD4D.3070808@linux.intel.com>
 <CA+55aFyjrXzKMqmOuMo9z24OZj3kD4O4M4y_O-h=r6udCz2MyA@mail.gmail.com>
 <20130116213032.GS2668@htj.dyndns.org>
 <CA+55aFzdf44QOZn4KS6tT09COFsmCg80sTah1XpeoErJxAzbRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzdf44QOZn4KS6tT09COFsmCg80sTah1XpeoErJxAzbRQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Synchronous requet_module() from an async worker can lead to deadlock
because module init path may invoke async_synchronize_full().  The
async worker waits for request_module() to complete and the module
loading waits for the async task to finish.  This bug happened in the
block layer because of default elevator auto-loading.

Block layer has been updated not to do default elevator auto-loading
and it has been decided to disallow synchronous request_module() from
async workers.

Trigger WARN_ON_ONCE() on synchronous request_module() from async
workers.

For more details, please refer to the following thread.

  http://thread.gmane.org/gmane.linux.kernel/1420814

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Alex Riesen <raa.lkml@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
Linus, please note that I dropped system_state == SYSTEM_RUNNING
condition from WARN_ON_ONCE() as the deadlock can happen during system
init too - e.g. libata probing block device using async making block
layer try to load default elevator from initramfs.

Thanks.

 kernel/kmod.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 1c317e3..028287e 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -38,6 +38,7 @@
 #include <linux/suspend.h>
 #include <linux/rwsem.h>
 #include <linux/ptrace.h>
+#include <linux/async.h>
 #include <asm/uaccess.h>
 
 #include <trace/events/module.h>
@@ -130,6 +131,14 @@ int __request_module(bool wait, const char *fmt, ...)
 #define MAX_KMOD_CONCURRENT 50	/* Completely arbitrary value - KAO */
 	static int kmod_loop_msg;
 
+	/*
+	 * We don't allow synchronous module loading from async.  Module
+	 * init may invoke async_synchronize_full() which will end up
+	 * waiting for this task which already is waiting for the module
+	 * loading to complete, leading to a deadlock.
+	 */
+	WARN_ON_ONCE(wait && async_current_func(NULL, NULL));
+
 	va_start(args, fmt);
 	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
 	va_end(args);
-- 
1.8.0.2

