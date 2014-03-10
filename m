Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaCJBA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 21:00:28 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:40226 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaCJBA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 21:00:26 -0400
X-Originating-IP: 50.43.32.211
Date: Sun, 9 Mar 2014 18:00:19 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/5] bug: When !CONFIG_BUG, simplify WARN_ON_ONCE and
 family
Message-ID: <17c859aa7dcccec43df0a0c8908911b982764c76.1394412745.git.josh@joshtriplett.org>
References: <469b5dc113cb468232291527642f8dc47663e945.1393385236.git.josh@joshtriplett.org>
 <201402272019.47554.arnd@arndb.de>
 <20140228001645.GA29605@thin>
 <6915585.VegnvotSUi@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6915585.VegnvotSUi@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When !CONFIG_BUG, WARN_ON and family become simple passthroughs of their
condition argument; however, WARN_ON_ONCE and family still have
conditions and a boolean to detect one-time invocation, even though the
warning they'd emit doesn't exist.  Make the existing definitions
conditional on CONFIG_BUG, and add definitions for !CONFIG_BUG that map
to the passthrough versions of WARN and WARN_ON.

This saves 4.4k on a minimized configuration (smaller than
allnoconfig), and 20.6k with defconfig plus CONFIG_BUG=n.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
v3: Patch unchanged from v2.

Andrew, can you please replace the entire v2 series currently in -mm
with this new series?

 include/asm-generic/bug.h | 57 +++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 7d10f96..7ecd398 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -106,33 +106,6 @@ extern void warn_slowpath_null(const char *file, const int line);
 	unlikely(__ret_warn_on);					\
 })
 
-#else /* !CONFIG_BUG */
-#ifndef HAVE_ARCH_BUG
-#define BUG() do {} while(0)
-#endif
-
-#ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (condition) ; } while(0)
-#endif
-
-#ifndef HAVE_ARCH_WARN_ON
-#define WARN_ON(condition) ({						\
-	int __ret_warn_on = !!(condition);				\
-	unlikely(__ret_warn_on);					\
-})
-#endif
-
-#ifndef WARN
-#define WARN(condition, format...) ({					\
-	int __ret_warn_on = !!(condition);				\
-	unlikely(__ret_warn_on);					\
-})
-#endif
-
-#define WARN_TAINT(condition, taint, format...) WARN_ON(condition)
-
-#endif
-
 #define WARN_ON_ONCE(condition)	({				\
 	static bool __section(.data.unlikely) __warned;		\
 	int __ret_warn_once = !!(condition);			\
@@ -163,6 +136,36 @@ extern void warn_slowpath_null(const char *file, const int line);
 	unlikely(__ret_warn_once);				\
 })
 
+#else /* !CONFIG_BUG */
+#ifndef HAVE_ARCH_BUG
+#define BUG() do {} while(0)
+#endif
+
+#ifndef HAVE_ARCH_BUG_ON
+#define BUG_ON(condition) do { if (condition) ; } while(0)
+#endif
+
+#ifndef HAVE_ARCH_WARN_ON
+#define WARN_ON(condition) ({						\
+	int __ret_warn_on = !!(condition);				\
+	unlikely(__ret_warn_on);					\
+})
+#endif
+
+#ifndef WARN
+#define WARN(condition, format...) ({					\
+	int __ret_warn_on = !!(condition);				\
+	unlikely(__ret_warn_on);					\
+})
+#endif
+
+#define WARN_ON_ONCE(condition) WARN_ON(condition)
+#define WARN_ONCE(condition, format...) WARN(condition, format)
+#define WARN_TAINT(condition, taint, format...) WARN(condition, format)
+#define WARN_TAINT_ONCE(condition, taint, format...) WARN(condition, format)
+
+#endif
+
 /*
  * WARN_ON_SMP() is for cases that the warning is either
  * meaningless for !SMP or may even cause failures.
-- 
1.9.0

