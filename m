Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934929Ab3DHRP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:15:56 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42530 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760775Ab3DHRPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:15:53 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] Add PR_REALLY_SET_TIMERSLACK to fix PR_SET_TIMERSLACK
Date: Mon,  8 Apr 2013 10:15:38 -0700
Message-Id: <06acbdcc6ba2e34c858d65397ebaadc279d967e4.1365441248.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The man page says:

 PR_SET_TIMERSLACK (since Linux 2.6.28)
     Set the current timer slack for the calling thread to the nanosecond
     value supplied in arg2.  If arg2 is less than or equal to zero,
     reset the current timer slack to the thread's default timer slack
     value.

There are two problems here.  First, zero is a perfectly sensible
value for the timer slack, but there's no way to set it.  Second,
arg2 is treated as *unsigned*, so arg2 less than zero is impossible.

Fix it with a new prctl that works better.  Negative *signed* numbers
other than -1 are errors; -1 means "use the default", and zero and
positive numbers set the timer slack.

With this patch, a test program does:

slack=50000
prctl(PR_SET_TIMERSLACK, 1, 0, 0, 0) = 0, errno=0  slack=1
prctl(PR_SET_TIMERSLACK, 0, 0, 0, 0) = 0, errno=0  slack=50000
prctl(PR_SET_TIMERSLACK, 1, 0, 0, 0) = 0, errno=0  slack=1
prctl(PR_SET_TIMERSLACK, 0, 1, 0, 0) = 0, errno=0  slack=50000
prctl(PR_SET_TIMERSLACK, 1, 0, 0, 0) = 0, errno=0  slack=1

prctl(PR_SET_TIMERSLACK, -1, 0, 0, 0) = 0, errno=0  slack=4294967295
prctl(PR_SET_TIMERSLACK, -2, 0, 0, 0) = 0, errno=0  slack=4294967295

[These last two are weird.  The problem is that slack = -1 or -2 looks
 like an error return, so the glibc syscall wrappers get confused.]

prctl(PR_REALLY_SET_TIMERSLACK, 1, 0, 0, 0) = 0, errno=0  slack=1
prctl(PR_REALLY_SET_TIMERSLACK, 0, 0, 0, 0) = 0, errno=0  slack=0
prctl(PR_REALLY_SET_TIMERSLACK, 1, 0, 0, 0) = 0, errno=0  slack=1
prctl(PR_REALLY_SET_TIMERSLACK, 0, 1, 0, 0) = -1, errno=22  slack=1
prctl(PR_REALLY_SET_TIMERSLACK, 1, 0, 0, 0) = 0, errno=0  slack=1
prctl(PR_REALLY_SET_TIMERSLACK, -1, 0, 0, 0) = 0, errno=0  slack=50000
prctl(PR_REALLY_SET_TIMERSLACK, -2, 0, 0, 0) = -1, errno=22  slack=50000

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 include/uapi/linux/prctl.h |  7 +++++++
 kernel/sys.c               | 11 +++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 289760f..8b4f683 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -149,4 +149,11 @@
 
 #define PR_GET_TID_ADDRESS	40
 
+/*
+ * Set the timerslack as used by poll/select/nanosleep better.
+ * A value of -1 means "use default".  A value of zero means zero.
+ * This version returns -EINVAL when invalid parameters are used.
+ */
+#define PR_REALLY_SET_TIMERSLACK 41
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 39c9c4a..d4e6137 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2107,6 +2107,17 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		else
 			current->timer_slack_ns = arg2;
 		break;
+	case PR_REALLY_SET_TIMERSLACK:
+		if (arg3 | arg4 | arg5)
+			return -EINVAL;
+		if (arg2 == -1)
+			current->timer_slack_ns =
+					current->default_timer_slack_ns;
+		else if ((long)arg2 >= 0)
+			current->timer_slack_ns = arg2;
+		else
+			return -EINVAL;
+		break;
 	case PR_MCE_KILL:
 		if (arg4 | arg5)
 			return -EINVAL;
-- 
1.8.1.4

