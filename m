Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396Ab3EBBgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 21:36:20 -0400
Received: from mail-yh0-f74.google.com ([209.85.213.74]:49196 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758466Ab3EBBfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 21:35:24 -0400
From: Colin Cross <ccross@android.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Colin Cross <ccross@android.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 08/10] nanosleep: use freezable blocking call
Date: Wed,  1 May 2013 18:35:06 -0700
Message-Id: <1367458508-9133-9-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367458508-9133-1-git-send-email-ccross@android.com>
References: <1367458508-9133-1-git-send-email-ccross@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid waking up every thread sleeping in a nanosleep call during
suspend and resume by calling a freezable blocking call.  Previous
patches modified the freezer to avoid sending wakeups to threads
that are blocked in freezable blocking calls.

This call was selected to be converted to a freezable call because
it doesn't hold any locks or release any resources when interrupted
that might be needed by another freezing task or a kernel driver
during suspend, and is a common site where idle userspace tasks are
blocked.

Signed-off-by: Colin Cross <ccross@android.com>
---
 kernel/hrtimer.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 14be27f..e036276 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -47,6 +47,7 @@
 #include <linux/sched/sysctl.h>
 #include <linux/sched/rt.h>
 #include <linux/timer.h>
+#include <linux/freezer.h>
 
 #include <asm/uaccess.h>
 
@@ -1525,7 +1526,7 @@ static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mod
 			t->task = NULL;
 
 		if (likely(t->task))
-			schedule();
+			freezable_schedule();
 
 		hrtimer_cancel(&t->timer);
 		mode = HRTIMER_MODE_ABS;
-- 
1.8.2.1

