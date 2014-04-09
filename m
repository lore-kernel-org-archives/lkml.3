Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbaDILQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:16:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39032 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801AbaDILQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:16:50 -0400
Date: Wed, 9 Apr 2014 13:16:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Regression with wait_event_timeout in next-20140226
Message-ID: <20140409111638.GS11096@twins.programming.kicks-ass.net>
References: <530E17C7.1030504@free-electrons.com>
 <20140226165043.GA22802@laptop.programming.kicks-ass.net>
 <20140226142534.3b8c6eb1652d000206948ae0@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226142534.3b8c6eb1652d000206948ae0@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 02:25:34PM -0800, Andrew Morton wrote:
> Is there anything we can do to make all this clearer?  Simply using a
> distinctive variable name ("__wait_var__"?) in place of __ret (and
> documenting it) would help a lot.
> 
> Some __ret's are long and some are int.  Maybe that's a glitch, maybe
> it's because some __ret's are used for inter-macro communications and
> some are not, which just makes things worse.
> 
> I started to do a patch, got all confused and gave up.  We've made
> quite a tangly mess in there, alas.

Something like so?

---
Subject: wait: Explain the shadowing and type inconsistencies
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed Apr  9 12:50:34 CEST 2014

Stick in a comment before someone else tries to fix the sparse warning
this generates.

Requested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-o2ro6f3vkxklni0bc8f7m68s@git.kernel.org
---
 include/linux/wait.h |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -191,11 +191,23 @@ wait_queue_head_t *bit_waitqueue(void *,
 	(!__builtin_constant_p(state) ||				\
 		state == TASK_INTERRUPTIBLE || state == TASK_KILLABLE)	\
 
+/*
+ * The below macro ___wait_event() has an explicit shadow of the __ret
+ * variable when used from the wait_event_*() macros.
+ *
+ * This is so that both can use the ___wait_cond_timeout() construct
+ * to wrap the condition.
+ *
+ * The type inconsistency of the wait_event_*() __ret variable is also
+ * on purpose; we use long where we can return timeout values and int
+ * otherwise.
+ */
+
 #define ___wait_event(wq, condition, state, exclusive, ret, cmd)	\
 ({									\
 	__label__ __out;						\
 	wait_queue_t __wait;						\
-	long __ret = ret;						\
+	long __ret = ret;	/* explicit shadow */			\
 									\
 	INIT_LIST_HEAD(&__wait.task_list);				\
 	if (exclusive)							\
