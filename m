Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258Ab3GCSxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:53:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8187 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933217Ab3GCSk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:57 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=uFjbtOkMytYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=hU3z_etLCN4A:10 a=QyXUC8HyAAAA:8 a=e5mUnYsNAAAA:8 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=e0gVtgZ23HrhdBXb4dMA:9 a=dGJ0OcVc7YAA:10 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184049.028871665@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Imre Deak <imre.deak@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [027/141] wait: fix false timeouts when using wait_event_timeout()
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0027-wait-fix-false-timeouts-when-using-wait_event_timeou.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit 4c663cfc523a88d97a8309b04a089c27dc57fd7e ]

Many callers of the wait_event_timeout() and
wait_event_interruptible_timeout() expect that the return value will be
positive if the specified condition becomes true before the timeout
elapses.  However, at the moment this isn't guaranteed.  If the wake-up
handler is delayed enough, the time remaining until timeout will be
calculated as 0 - and passed back as a return value - even if the
condition became true before the timeout has passed.

Fix this by returning at least 1 if the condition becomes true.  This
semantic is in line with what wait_for_condition_timeout() does; see
commit bb10ed09 ("sched: fix wait_for_completion_timeout() spurious
failure under heavy load").

Daniel said "We have 3 instances of this bug in drm/i915.  One case even
where we switch between the interruptible and not interruptible
wait_event_timeout variants, foolishly presuming they have the same
semantics.  I very much like this."

One such bug is reported at
  https://bugs.freedesktop.org/show_bug.cgi?id=64133

Signed-off-by: Imre Deak <imre.deak@intel.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: David Howells <dhowells@redhat.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Cc: "Paul E.  McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/wait.h |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 1dee81c..6c6c20e 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -233,6 +233,8 @@ do {									\
 		if (!ret)						\
 			break;						\
 	}								\
+	if (!ret && (condition))					\
+		ret = 1;						\
 	finish_wait(&wq, &__wait);					\
 } while (0)
 
@@ -249,8 +251,9 @@ do {									\
  * wake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  *
- * The function returns 0 if the @timeout elapsed, and the remaining
- * jiffies if the condition evaluated to true before the timeout elapsed.
+ * The function returns 0 if the @timeout elapsed, or the remaining
+ * jiffies (at least 1) if the @condition evaluated to %true before
+ * the @timeout elapsed.
  */
 #define wait_event_timeout(wq, condition, timeout)			\
 ({									\
@@ -318,6 +321,8 @@ do {									\
 		ret = -ERESTARTSYS;					\
 		break;							\
 	}								\
+	if (!ret && (condition))					\
+		ret = 1;						\
 	finish_wait(&wq, &__wait);					\
 } while (0)
 
@@ -334,9 +339,10 @@ do {									\
  * wake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  *
- * The function returns 0 if the @timeout elapsed, -ERESTARTSYS if it
- * was interrupted by a signal, and the remaining jiffies otherwise
- * if the condition evaluated to true before the timeout elapsed.
+ * Returns:
+ * 0 if the @timeout elapsed, -%ERESTARTSYS if it was interrupted by
+ * a signal, or the remaining jiffies (at least 1) if the @condition
+ * evaluated to %true before the @timeout elapsed.
  */
 #define wait_event_interruptible_timeout(wq, condition, timeout)	\
 ({									\
-- 
1.7.10.4


