Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451AbaJ2SP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 14:15:27 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41302 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262AbaJ2SPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 14:15:23 -0400
X-Originating-IP: 173.246.103.110
Date: Wed, 29 Oct 2014 11:15:17 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] CodingStyle: Add a chapter on conditional compilation
Message-ID: <430ce084b015d22a597ef7e4f6436dadaea7b23d.1414606455.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document several common practices and conventions regarding conditional
compilation, most notably the preference for ifdefs in headers rather
than .c files.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

I found myself explaining a few of these unwritten rules in patch
feedback, so I figured I'd document them.

 Documentation/CodingStyle | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 3171822..9f28b14 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -845,6 +845,49 @@ next instruction in the assembly output:
 	     : /* outputs */ : /* inputs */ : /* clobbers */);
 
 
+		Chapter 20: Conditional Compilation
+
+Wherever possible, don't use preprocessor conditionals (#if, #ifdef) in .c
+files; doing so makes code harder to read and logic harder to follow.  Instead,
+use such conditionals in a header file defining functions for use in those .c
+files, providing no-op stub versions in the #else case, and then call those
+functions unconditionally from .c files.  The compiler will avoid generating
+any code for the stub calls, producing identical results, but the logic will
+remain easy to follow.
+
+Prefer to compile out entire functions, rather than portions of functions or
+portions of expressions.  Rather than putting an ifdef in an expression, factor
+out part or all of the expression into a separate helper function and apply the
+conditional to that function.
+
+If you have a function or variable which may potentially go unused in a
+particular configuration, and the compiler would warn about its definition
+going unused, mark the definition as __maybe_unused rather than wrapping it in
+a preprocessor conditional.  (However, if a function or variable *always* goes
+unused, delete it.)
+
+Within code, where possible, use the IS_ENABLED macro to convert a Kconfig
+symbol into a C boolean expression, and use it in a normal C conditional:
+
+	if (IS_ENABLED(CONFIG_SOMETHING)) {
+		...
+	}
+
+The compiler will constant-fold the conditional away, and include or exclude
+the block of code just as with an #ifdef, so this will not add any runtime
+overhead.  However, this approach still allows the C compiler to see the code
+inside the block, and check it for correctness (syntax, types, symbol
+references, etc).  Thus, you still have to use an #ifdef if the code inside the
+block references symbols that will not exist if the condition is not met.
+
+At the end of any non-trivial #if or #ifdef block (more than a few lines),
+place a comment after the #endif on the same line, noting the conditional
+expression used.  For instance:
+
+#ifdef CONFIG_SOMETHING
+...
+#endif /* CONFIG_SOMETHING */
+
 
 		Appendix I: References
 
-- 
2.1.1

