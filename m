Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855Ab3D2VvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:51:22 -0400
Received: from mail-qe0-f74.google.com ([209.85.128.74]:48350 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759202Ab3D2VvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:51:18 -0400
From: Colin Cross <ccross@android.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, Colin Cross <ccross@android.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 08/10] nanosleep: use freezable blocking call
Date: Mon, 29 Apr 2013 14:45:44 -0700
Message-Id: <1367271946-7239-9-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367271946-7239-1-git-send-email-ccross@android.com>
References: <1367271946-7239-1-git-send-email-ccross@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid waking up every thread sleeping in a nanosleep call during
suspend and resume by calling a freezable blocking call.

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

