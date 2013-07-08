Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab3GHRDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 13:03:12 -0400
Received: from smtp.outflux.net ([198.145.64.163]:33756 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab3GHRDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 13:03:11 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ankita Garg <ankita@in.ibm.com>,
        Simon Kagstrom <simon.kagstrom@netinsight.net>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 3/4] lkdtm: add "SPINLOCKUP" trigger
Date: Mon,  8 Jul 2013 10:01:32 -0700
Message-Id: <1373302893-4990-3-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373302893-4990-1-git-send-email-keescook@chromium.org>
References: <1373302893-4990-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For additional lockup testing, add "SPINLOCKUP" to trigger a spinlock
deadlock when triggered twice.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index b1323fc..8bc7f0b 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -78,6 +78,7 @@ enum ctype {
 	CT_WRITE_AFTER_FREE,
 	CT_SOFTLOCKUP,
 	CT_HARDLOCKUP,
+	CT_SPINLOCKUP,
 	CT_HUNG_TASK,
 };
 
@@ -106,6 +107,7 @@ static char* cp_type[] = {
 	"WRITE_AFTER_FREE",
 	"SOFTLOCKUP",
 	"HARDLOCKUP",
+	"SPINLOCKUP",
 	"HUNG_TASK",
 };
 
@@ -123,6 +125,7 @@ static enum cname cpoint = CN_INVALID;
 static enum ctype cptype = CT_NONE;
 static int count = DEFAULT_COUNT;
 static DEFINE_SPINLOCK(count_lock);
+static DEFINE_SPINLOCK(lock_me_up);
 
 module_param(recur_count, int, 0644);
 MODULE_PARM_DESC(recur_count, " Recursion level for the stack overflow test, "\
@@ -345,6 +348,10 @@ static void lkdtm_do_action(enum ctype which)
 		for (;;)
 			cpu_relax();
 		break;
+	case CT_SPINLOCKUP:
+		/* Must be called twice to trigger. */
+		spin_lock(&lock_me_up);
+		break;
 	case CT_HUNG_TASK:
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule();
-- 
1.7.9.5

