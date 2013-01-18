Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab3ARWMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 17:12:34 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:53815 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab3ARWMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 17:12:32 -0500
Date: Fri, 18 Jan 2013 14:12:27 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 5/5] async, kmod: warn on synchronous request_module() from
 async workers
Message-ID: <20130118221227.GG24579@htj.dyndns.org>
References: <20130116164832.GP2668@htj.dyndns.org>
 <50F6DD4D.3070808@linux.intel.com>
 <CA+55aFyjrXzKMqmOuMo9z24OZj3kD4O4M4y_O-h=r6udCz2MyA@mail.gmail.com>
 <20130116213032.GS2668@htj.dyndns.org>
 <CA+55aFzdf44QOZn4KS6tT09COFsmCg80sTah1XpeoErJxAzbRQ@mail.gmail.com>
 <20130118012503.GH16568@mtj.dyndns.org>
 <CA+55aFyCihvZqOo=83UwWq3AgJEfVqpNjsY2iCFOEm8o6Un-YA@mail.gmail.com>
 <20130118025936.GJ16568@mtj.dyndns.org>
 <20130118030407.GK16568@mtj.dyndns.org>
 <CA+55aFwAwX_o6ocGhd1WwUwxfOnh+S6aKeZdEpeeHVAnBm4uVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwAwX_o6ocGhd1WwUwxfOnh+S6aKeZdEpeeHVAnBm4uVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4983f3b51e18d008956dd113e0ea2f252774cefc Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 18 Jan 2013 14:05:57 -0800

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
 kernel/kmod.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 1c317e3..ecd42b4 100644
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
+	WARN_ON_ONCE(wait && current_is_async());
+
 	va_start(args, fmt);
 	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
 	va_end(args);
-- 
1.8.0.2

