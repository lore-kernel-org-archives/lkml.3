Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaBZDt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 22:49:28 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:50989 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaBZDtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 22:49:25 -0500
X-Originating-IP: 50.43.14.201
Date: Tue, 25 Feb 2014 19:49:19 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] bug: Use a common definition of BUG_ON regardless of
 CONFIG_BUG
Message-ID: <6ce38c3701f8ed1d30bfc1661ede7eade46a79c6.1393385236.git.josh@joshtriplett.org>
References: <469b5dc113cb468232291527642f8dc47663e945.1393385236.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469b5dc113cb468232291527642f8dc47663e945.1393385236.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/asm-generic/bug.h defines BUG_ON to call BUG() if CONFIG_BUG=y,
or as a no-op if !CONFIG_BUG.  However, BUG() is already a no-op if
!CONFIG_BUG, making this pointless.  Use a common definition that always
calls BUG().

This does not change the compiled code at all.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 include/asm-generic/bug.h | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index a97fa11..653c44a 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -51,10 +51,6 @@ struct bug_entry {
 } while (0)
 #endif
 
-#ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
-#endif
-
 /*
  * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
  * significant issues that need prompt attention if they should ever
@@ -141,10 +137,6 @@ extern void warn_slowpath_null(const char *file, const int line);
 #define BUG() do {} while (0)
 #endif
 
-#ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (condition) ; } while (0)
-#endif
-
 #ifndef HAVE_ARCH_WARN_ON
 #define WARN_ON(condition) ({						\
 	int __ret_warn_on = !!(condition);				\
@@ -167,6 +159,10 @@ extern void warn_slowpath_null(const char *file, const int line);
 
 #endif
 
+#ifndef HAVE_ARCH_BUG_ON
+#define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
+#endif
+
 /*
  * WARN_ON_SMP() is for cases that the warning is either
  * meaningless for !SMP or may even cause failures.
-- 
1.9.0

