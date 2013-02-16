Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab3BPJx4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 04:53:56 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:51999 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab3BPJxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 04:53:52 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 3/5] coredump: use a freezable_schedule for the coredump_finish wait
Date: Sat, 16 Feb 2013 01:53:24 -0800
Message-Id: <1361008406-2307-3-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1361008406-2307-1-git-send-email-msb@chromium.org>
References: <1361008406-2307-1-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevents hung_task detector from panicing the machine. This is also
needed to prevent this wait from blocking suspend.

(It doesnt' currently block suspend but it would once the next
patch in this series is applied.)

Changes since v1:
* <20130215145323.GA30829@redhat.com> Oleg Nesterov
 * Rebased after dropping earlier cleanup patch.

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
index 88a706c..89532e8 100644
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
@@ -483,7 +484,7 @@ static void exit_mm(struct task_struct * tsk)
 			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 			if (!self.task) /* see coredump_finish() */
 				break;
-			schedule();
+			freezable_schedule();
 		}
 		__set_task_state(tsk, TASK_RUNNING);
 		down_read(&mm->mmap_sem);
-- 
1.7.12.4

