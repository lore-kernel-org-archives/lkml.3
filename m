Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935162Ab3BNXin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 18:38:43 -0500
Received: from mail-vb0-f74.google.com ([209.85.212.74]:35891 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935134Ab3BNXij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 18:38:39 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 4/5] coredump: use a freezable_schedule for the coredump_finish wait
Date: Thu, 14 Feb 2013 15:38:15 -0800
Message-Id: <1360885096-21207-4-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360885096-21207-1-git-send-email-msb@chromium.org>
References: <1360885096-21207-1-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevents hung_task detector from panicing the machine. This is also
needed to prevent this wait from blocking suspend.

(It doesnt' currently block suspend but it would once the next
patch in this series is applied.)

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: Ingo Molnar <mingo@redhat.com>
---
 kernel/exit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index f215198..04d9db0 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -20,6 +20,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
+#include <linux/freezer.h>
 #include <linux/binfmts.h>
 #include <linux/nsproxy.h>
 #include <linux/pid_namespace.h>
@@ -481,7 +482,7 @@ static void exit_mm(struct task_struct * tsk)
 
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 		if (self.task) /* see coredump_finish() */
-			schedule();
+			freezable_schedule();
 		__set_task_state(tsk, TASK_RUNNING);
 		down_read(&mm->mmap_sem);
 	}
-- 
1.8.1

