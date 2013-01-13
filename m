Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3AMRvb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:51:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35034 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755449Ab3AMRph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:37 -0500
Message-Id: <20130113174303.320089125@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:31 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 36/49] ftrace: Do not function trace inlined functions
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit 45959ee7aa645815a5ce303a0ea1e48a21e67c6a upstream.

When gcc inlines a function, it does not mark it with the mcount
prologue, which in turn means that inlined functions are not traced
by the function tracer. But if CONFIG_OPTIMIZE_INLINING is set, then
gcc is allowed not to inline a function that is marked inline.

Depending on the options and the compiler, a function may or may
not be traced by the function tracer, depending on whether gcc
decides to inline a function or not. This has caused several
problems in the pass becaues gcc is not always consistent with
what it decides to inline between different gcc versions.

Some places should not be traced (like paravirt native_* functions)
and these are mostly marked as inline. When gcc decides not to
inline the function, and if that function should not be traced, then
the ftrace function tracer will suddenly break when it use to work
fine. This becomes even harder to debug when different versions of
gcc will not inline that function, making the same kernel and config
work for some gcc versions and not work for others.

By making all functions marked inline to not be traced will remove
the ambiguity that gcc adds when it comes to tracing functions marked
inline. All gcc versions will be consistent with what functions are
traced and having volatile working code will be removed.

Note, only the inline macro when CONFIG_OPTIMIZE_INLINING is set needs
to have notrace added, as the attribute __always_inline will force
the function to be inlined and then not traced.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/compiler-gcc.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 59e4028..3fd17c2 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -50,6 +50,11 @@
 # define inline		inline		__attribute__((always_inline))
 # define __inline__	__inline__	__attribute__((always_inline))
 # define __inline	__inline	__attribute__((always_inline))
+#else
+/* A lot of inline functions can cause havoc with function tracing */
+# define inline		inline		notrace
+# define __inline__	__inline__	notrace
+# define __inline	__inline	notrace
 #endif
 
 #define __deprecated			__attribute__((deprecated))


