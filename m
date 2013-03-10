Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab3CJPfd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 11:35:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14857 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3CJPfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 11:35:31 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=bOw0rCnj6fUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=hvPZd8-0_SkA:10 a=pGLkceISAAAA:8 a=uPQSh6UaeudgMO0wq1kA:9 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=MSl-tDqOz04A:10 a=r6f16yGqrQFz9S-c:21 a=AXidNZedOwmo_XK_:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130310153527.494385283@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 10 Mar 2013 11:27:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [for-next][PATCH 2/4] tracing: Optimize trace_printk() with one arg to use trace_puts()
References: <20130310152752.848922120@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Optimize-trace_printk-with-one-arg-to-use-tr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Although trace_printk() is extremely fast, especially when it uses
trace_bprintk() (writes args straight to buffer instead of inserting
into string), it still has the overhead of calling one of the printf
sprintf() functions, that need to scan the fmt string to determine
what, if any args it has.

This is a waste of precious CPU cycles if the printk format has no
args but a single constant string. It is better to use trace_puts()
which does not have the overhead of the fmt scanning.

But wouldn't it be nice if the developer didn't have to think about
such things, and the compile would just do it for them?

  trace_printk("this string has no args\n");
  [...]
  trace_printk("this sting does %p %d\n", foo, bar);

As tracing is critical to have the least amount of overhead,
especially when dealing with race conditions, and you want to
eliminate any "Heisenbugs", you want the trace_printk() to use the
fastest possible means of tracing.

Currently the macro magic determines if it will use trace_bprintk()
or if the fmt is a dynamic string (a variable), it will fall
back to the slow trace_printk() method that does a full snprintf()
before copying it into the buffer, where as trace_bprintk() only
copys the pointer to the fmt and the args into the buffer.

Well, now there's a way to spend some more Hogwarts cash and come
up with new fancy macro magic.

  #define trace_printk(fmt, ...)			\
  do {							\
	char _______STR[] = __stringify((__VA_ARGS__));	\
	if (sizeof(_______STR) > 3)			\
		do_trace_printk(fmt, ##__VA_ARGS__);	\
	else						\
		trace_puts(fmt);			\
  } while (0)

The above needs a bit of explaining (both here and in the comments).

By stringifying the __VA_ARGS__, we can, at compile time, determine
the number of args that are being passed to trace_printk(). The extra
parenthesis are required, otherwise the compiler complains about
too many parameters for __stringify if there is more than one arg.

When there are no args, the __stringify((__VA_ARGS__)) converts into
"()\0", a string of 3 characters. Anything else, will be a string
containing more than 3 characters. Now we assign that string to a
dynamic char array, and then take the sizeof() of that array.
If it is greater than 3 characters, we know trace_printk() has args
and we need to do the full "do_trace_printk()" on them, otherwise
it was only passed a single arg and we can optimize to use trace_puts().

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven "The King of Nasty Macros!" Rostedt <rostedt@goodmis.org>
---
 include/linux/kernel.h |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index a3a5574..d0a16fe 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -516,9 +516,30 @@ do {									\
  * Please refrain from leaving trace_printks scattered around in
  * your code. (Extra memory is used for special buffers that are
  * allocated when trace_printk() is used)
+ *
+ * A little optization trick is done here. If there's only one
+ * argument, there's no need to scan the string for printf formats.
+ * The trace_puts() will suffice. But how can we take advantage of
+ * using trace_puts() when trace_printk() has only one argument?
+ * By stringifying the args and checking the size we can tell
+ * whether or not there are args. __stringify((__VA_ARGS__)) will
+ * turn into "()\0" with a size of 3 when there are no args, anything
+ * else will be bigger. All we need to do is define a string to this,
+ * and then take its size and compare to 3. If it's bigger, use
+ * do_trace_printk() otherwise, optimize it to trace_puts(). Then just
+ * let gcc optimize the rest.
  */
 
-#define trace_printk(fmt, args...)					\
+#define trace_printk(fmt, ...)				\
+do {							\
+	char _______STR[] = __stringify((__VA_ARGS__));	\
+	if (sizeof(_______STR) > 3)			\
+		do_trace_printk(fmt, ##__VA_ARGS__);	\
+	else						\
+		trace_puts(fmt);			\
+} while (0)
+
+#define do_trace_printk(fmt, args...)					\
 do {									\
 	static const char *trace_printk_fmt				\
 		__attribute__((section("__trace_printk_fmt"))) =	\
-- 
1.7.10.4


