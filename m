Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548Ab3JOTcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:32:05 -0400
Received: from sauhun.de ([89.238.76.85]:36421 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932555Ab3JOTcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:32:03 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Subject: [RFC RESEND 1/3] sched: replace INIT_COMPLETION with reinit_completion
Date: Tue, 15 Oct 2013 21:31:18 +0200
Message-Id: <1381865480-3013-2-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381865480-3013-1-git-send-email-wsa@the-dreams.de>
References: <1381865480-3013-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the casual device driver writer, it is hard to remember when to use
init_completion (to init a completion structure) or INIT_COMPLETION (to
*reinit* a completion structure). Furthermore, while all other
completion functions exepct a pointer as a parameter, INIT_COMPLETION
does not. To make it easier to remember which function to use and to
make code more readable, introduce a new inline function with the proper
name and consistent argument type. Update the kernel-doc for
init_completion while we are here.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
---
 include/linux/completion.h | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/completion.h b/include/linux/completion.h
index 3cd574d..2195e32 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -19,8 +19,8 @@
  *
  * See also:  complete(), wait_for_completion() (and friends _timeout,
  * _interruptible, _interruptible_timeout, and _killable), init_completion(),
- * and macros DECLARE_COMPLETION(), DECLARE_COMPLETION_ONSTACK(), and
- * INIT_COMPLETION().
+ * reinit_completion(), and macros DECLARE_COMPLETION(),
+ * DECLARE_COMPLETION_ONSTACK().
  */
 struct completion {
 	unsigned int done;
@@ -65,7 +65,7 @@ struct completion {
 
 /**
  * init_completion - Initialize a dynamically allocated completion
- * @x:  completion structure that is to be initialized
+ * @x:  pointer to completion structure that is to be initialized
  *
  * This inline function will initialize a dynamically created completion
  * structure.
@@ -76,6 +76,18 @@ static inline void init_completion(struct completion *x)
 	init_waitqueue_head(&x->wait);
 }
 
+/**
+ * reinit_completion - reinitialize a completion structure
+ * @x:  pointer to completion structure that is to be reinitialized
+ *
+ * This inline function should be used to reinitialize a completion structure so it can
+ * be reused. This is especially important after complete_all() is used.
+ */
+static inline void reinit_completion(struct completion *x)
+{
+	x->done = 0;
+}
+
 extern void wait_for_completion(struct completion *);
 extern void wait_for_completion_io(struct completion *);
 extern int wait_for_completion_interruptible(struct completion *x);
-- 
1.8.4.rc3

