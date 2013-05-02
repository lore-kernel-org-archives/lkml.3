Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127Ab3EBBgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 21:36:41 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:35279 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176Ab3EBBfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 21:35:19 -0400
From: Colin Cross <ccross@android.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Colin Cross <ccross@android.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 06/10] select: use freezable blocking call
Date: Wed,  1 May 2013 18:35:04 -0700
Message-Id: <1367458508-9133-7-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367458508-9133-1-git-send-email-ccross@android.com>
References: <1367458508-9133-1-git-send-email-ccross@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid waking up every thread sleeping in a select call during
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
 fs/select.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/select.c b/fs/select.c
index 8c1c96c..6b14dc7 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -27,6 +27,7 @@
 #include <linux/rcupdate.h>
 #include <linux/hrtimer.h>
 #include <linux/sched/rt.h>
+#include <linux/freezer.h>
 
 #include <asm/uaccess.h>
 
@@ -236,7 +237,8 @@ int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
 
 	set_current_state(state);
 	if (!pwq->triggered)
-		rc = schedule_hrtimeout_range(expires, slack, HRTIMER_MODE_ABS);
+		rc = freezable_schedule_hrtimeout_range(expires, slack,
+							HRTIMER_MODE_ABS);
 	__set_current_state(TASK_RUNNING);
 
 	/*
-- 
1.8.2.1

