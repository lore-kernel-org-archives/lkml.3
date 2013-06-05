Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742Ab3FEVTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:19:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab3FEVND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:13:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Imre Deak <imre.deak@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 22/44] wait: fix false timeouts when using wait_event_timeout()
Date: Wed,  5 Jun 2013 14:12:20 -0700
Message-Id: <20130605211224.185508053@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605211221.858177087@linuxfoundation.org>
References: <20130605211221.858177087@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 4c663cfc523a88d97a8309b04a089c27dc57fd7e upstream.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/wait.h |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

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


