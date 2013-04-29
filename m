Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059Ab3D2WId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 18:08:33 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:36859 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758944Ab3D2WIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 18:08:31 -0400
From: Colin Cross <ccross@android.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, Colin Cross <ccross@android.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 07/10] futex: use freezable blocking call
Date: Mon, 29 Apr 2013 14:45:43 -0700
Message-Id: <1367271946-7239-8-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367271946-7239-1-git-send-email-ccross@android.com>
References: <1367271946-7239-1-git-send-email-ccross@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid waking up every thread sleeping in a futex_wait call during
suspend and resume by calling a freezable blocking call.

Signed-off-by: Colin Cross <ccross@android.com>
---
 kernel/futex.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index b26dcfc..d710fae 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -61,6 +61,7 @@
 #include <linux/nsproxy.h>
 #include <linux/ptrace.h>
 #include <linux/sched/rt.h>
+#include <linux/freezer.h>
 
 #include <asm/futex.h>
 
@@ -1807,7 +1808,7 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
 		 * is no timeout, or if it has yet to expire.
 		 */
 		if (!timeout || timeout->task)
-			schedule();
+			freezable_schedule();
 	}
 	__set_current_state(TASK_RUNNING);
 }
-- 
1.8.2.1

