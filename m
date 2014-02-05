Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbaBEUMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:12:51 -0500
Received: from mail.windriver.com ([147.11.1.11]:55687 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbaBEUIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:08:18 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Darren Hart <dvhart@linux.intel.com>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 200/213] futex: Forbid uaddr == uaddr2 in futex_wait_requeue_pi()
Date: Wed, 5 Feb 2014 15:02:35 -0500
Message-ID: <1391630568-49251-201-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhart@linux.intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6f7b0a2a5c0fb03be7c25bd1745baa50582348ef upstream.

If uaddr == uaddr2, then we have broken the rule of only requeueing
from a non-pi futex to a pi futex with this call. If we attempt this,
as the trinity test suite manages to do, we miss early wakeups as
q.key is equal to key2 (because they are the same uaddr). We will then
attempt to dereference the pi_mutex (which would exist had the futex_q
been properly requeued to a pi futex) and trigger a NULL pointer
dereference.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>
Link: http://lkml.kernel.org/r/ad82bfe7f7d130247fbe2b5b4275654807774227.1342809673.git.dvhart@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/futex.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 8b467b4a437f..4a8f72850152 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2204,11 +2204,11 @@ int handle_early_requeue_pi_wakeup(struct futex_hash_bucket *hb,
  * @uaddr2:	the pi futex we will take prior to returning to user-space
  *
  * The caller will wait on uaddr and will be requeued by futex_requeue() to
- * uaddr2 which must be PI aware.  Normal wakeup will wake on uaddr2 and
- * complete the acquisition of the rt_mutex prior to returning to userspace.
- * This ensures the rt_mutex maintains an owner when it has waiters; without
- * one, the pi logic wouldn't know which task to boost/deboost, if there was a
- * need to.
+ * uaddr2 which must be PI aware and unique from uaddr.  Normal wakeup will wake
+ * on uaddr2 and complete the acquisition of the rt_mutex prior to returning to
+ * userspace.  This ensures the rt_mutex maintains an owner when it has waiters;
+ * without one, the pi logic would not know which task to boost/deboost, if
+ * there was a need to.
  *
  * We call schedule in futex_wait_queue_me() when we enqueue and return there
  * via the following:
@@ -2245,6 +2245,9 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	struct futex_q q;
 	int res, ret;
 
+	if (uaddr == uaddr2)
+		return -EINVAL;
+
 	if (!bitset)
 		return -EINVAL;
 
-- 
1.8.5.2

