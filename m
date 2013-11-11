Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab3KKTYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:24:03 -0500
Received: from smtp.outflux.net ([198.145.64.163]:40912 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab3KKTX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:23:57 -0500
Date: Mon, 11 Nov 2013 11:23:49 -0800
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH] lkdtm: clean up sparse warnings
Message-ID: <20131111192349.GA26599@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since lkdtm intentionally does "bad" things, we need to convince sparse
that we're doing these things on purpose. This adds an explicit cast
to the call to copy_to_user() and marks the spin lock as expecting
to dead-lock.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index a2edb2ee0921..a9a203d5f8d9 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -334,9 +334,10 @@ static void execute_location(void *dst)
 
 static void execute_user_location(void *dst)
 {
+	/* Intentionally crossing kernel/user memory boundary. */
 	void (*func)(void) = dst;
 
-	if (copy_to_user(dst, do_nothing, EXEC_SIZE))
+	if (copy_to_user((void __user *)dst, do_nothing, EXEC_SIZE))
 		return;
 	func();
 }
@@ -408,6 +409,8 @@ static void lkdtm_do_action(enum ctype which)
 	case CT_SPINLOCKUP:
 		/* Must be called twice to trigger. */
 		spin_lock(&lock_me_up);
+		/* Let sparse know we intended to exit holding the lock. */
+		__release(&lock_me_up);
 		break;
 	case CT_HUNG_TASK:
 		set_current_state(TASK_UNINTERRUPTIBLE);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
