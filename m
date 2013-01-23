Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab3AWAvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 19:51:51 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:63227 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab3AWAvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 19:51:48 -0500
Date: Tue, 22 Jan 2013 16:51:42 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH v2 2/2] block: don't request module during elevator init
Message-ID: <20130123005142.GD5359@htj.dyndns.org>
References: <CA+55aFzm4k2CyQ_mZVHyeasjw4ybqfO2SpJrZZNZeUsSW8PB=g@mail.gmail.com>
 <CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com>
 <20130116025251.GM2668@htj.dyndns.org>
 <CA+55aFxttTkWG0gfUz3=V8A-9az3+qY3j0JZEAoKv0ne-QupZw@mail.gmail.com>
 <20130116032502.GN2668@htj.dyndns.org>
 <CA+55aFxCudzOv8e2XjHiT=Qhy9q+mrxUfSYAT=eU6Gq8uyNORw@mail.gmail.com>
 <20130116164832.GP2668@htj.dyndns.org>
 <50F6DD4D.3070808@linux.intel.com>
 <CA+55aFyjrXzKMqmOuMo9z24OZj3kD4O4M4y_O-h=r6udCz2MyA@mail.gmail.com>
 <20130116213104.GT2668@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116213104.GT2668@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 21c3c5d2800733b7a276725b8e1ae49a694adc1a Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 22 Jan 2013 16:48:03 -0800

Block layer allows selecting an elevator which is built as a module to
be selected as system default via kernel param "elevator=".  This is
achieved by automatically invoking request_module() whenever a new
block device is initialized and the elevator is not available.

This led to an interesting deadlock problem involving async and module
init.  Block device probing running off an async job invokes
request_module().  While the module is being loaded, it performs
async_synchronize_full() which ends up waiting for the async job which
is already waiting for request_module() to finish, leading to
deadlock.

Invoking request_module() from deep in block device init path is
already nasty in itself.  It seems best to avoid these situations from
the beginning by moving on-demand module loading out of block init
path.

The previous patch made sure that the default elevator module is
loaded early during boot if available.  This patch removes on-demand
loading of the default elevator from elevator init path.  As the
module would have been loaded during boot, userland-visible behavior
difference should be minimal.

For more details, please refer to the following thread.

  http://thread.gmane.org/gmane.linux.kernel/1420814

v2: The bool parameter was named @request_module which conflicted with
    request_module().  This built okay w/ CONFIG_MODULES because
    request_module() was defined as a macro.  W/o CONFIG_MODULES, it
    causes build breakage.  Rename the parameter to @try_loading.
    Reported by Fengguang.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Riesen <raa.lkml@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
---
Minor revision to fix build breakage on !CONFIG_MODULES reported by
Fengguang.  The patch has been queued to
wq/for-3.9-async-deadlock-fixes.

Thanks.

 block/elevator.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index c2d61d5..603b2c1 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -100,14 +100,14 @@ static void elevator_put(struct elevator_type *e)
 	module_put(e->elevator_owner);
 }
 
-static struct elevator_type *elevator_get(const char *name)
+static struct elevator_type *elevator_get(const char *name, bool try_loading)
 {
 	struct elevator_type *e;
 
 	spin_lock(&elv_list_lock);
 
 	e = elevator_find(name);
-	if (!e) {
+	if (!e && try_loading) {
 		spin_unlock(&elv_list_lock);
 		request_module("%s-iosched", name);
 		spin_lock(&elv_list_lock);
@@ -207,25 +207,30 @@ int elevator_init(struct request_queue *q, char *name)
 	q->boundary_rq = NULL;
 
 	if (name) {
-		e = elevator_get(name);
+		e = elevator_get(name, true);
 		if (!e)
 			return -EINVAL;
 	}
 
+	/*
+	 * Use the default elevator specified by config boot param or
+	 * config option.  Don't try to load modules as we could be running
+	 * off async and request_module() isn't allowed from async.
+	 */
 	if (!e && *chosen_elevator) {
-		e = elevator_get(chosen_elevator);
+		e = elevator_get(chosen_elevator, false);
 		if (!e)
 			printk(KERN_ERR "I/O scheduler %s not found\n",
 							chosen_elevator);
 	}
 
 	if (!e) {
-		e = elevator_get(CONFIG_DEFAULT_IOSCHED);
+		e = elevator_get(CONFIG_DEFAULT_IOSCHED, false);
 		if (!e) {
 			printk(KERN_ERR
 				"Default I/O scheduler not found. " \
 				"Using noop.\n");
-			e = elevator_get("noop");
+			e = elevator_get("noop", false);
 		}
 	}
 
@@ -967,7 +972,7 @@ int elevator_change(struct request_queue *q, const char *name)
 		return -ENXIO;
 
 	strlcpy(elevator_name, name, sizeof(elevator_name));
-	e = elevator_get(strstrip(elevator_name));
+	e = elevator_get(strstrip(elevator_name), true);
 	if (!e) {
 		printk(KERN_ERR "elevator: type %s not found\n", elevator_name);
 		return -EINVAL;
-- 
1.8.1

