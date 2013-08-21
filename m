Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab3HUAUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:20:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:56826 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab3HUAUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:20:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,923,1367996400"; 
   d="scan'208";a="390573786"
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>,
        Mark Asselstine <mark.asselstine@windriver.com>,
        Mike Frysinger <vapier@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>, stable@vger.kernel.org
Subject: [PATCH v2 1/8] turbostat: Don't put unprocessed uapi headers in the include path
Date: Tue, 20 Aug 2013 17:20:12 -0700
Message-Id: <1377044419-15045-2-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377044419-15045-1-git-send-email-josh@joshtriplett.org>
References: <1377044419-15045-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

turbostat's Makefile puts arch/x86/include/uapi/ in the include path, so
that it can include <asm/msr.h> from it.  It isn't in general safe to
include even uapi headers directly from the kernel tree without
processing them through scripts/headers_install.sh, but asm/msr.h
happens to work.

However, that include path can break with some versions of system
headers, by overriding some system headers with the unprocessed versions
directly from the kernel source.  For instance:

In file included from /build/x86-generic/usr/include/bits/sigcontext.h:28:0,
                 from /build/x86-generic/usr/include/signal.h:339,
                 from /build/x86-generic/usr/include/sys/wait.h:31,
                 from turbostat.c:27:
../../../../arch/x86/include/uapi/asm/sigcontext.h:4:28: fatal error: linux/compiler.h: No such file or directory

This occurs because the system bits/sigcontext.h on that build system
includes <asm/sigcontext.h>, and asm/sigcontext.h in the kernel source
includes <linux/compiler.h>, which scripts/headers_install.sh would have
filtered out.

Since turbostat really only wants a single header, just include that one
header rather than putting an entire directory of kernel headers on the
include path.

In the process, switch from msr.h to msr-index.h, since turbostat just
wants the MSR numbers.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: stable@vger.kernel.org
---
 tools/power/x86/turbostat/Makefile    | 2 +-
 tools/power/x86/turbostat/turbostat.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/power/x86/turbostat/Makefile b/tools/power/x86/turbostat/Makefile
index f09641d..d1b3a36 100644
--- a/tools/power/x86/turbostat/Makefile
+++ b/tools/power/x86/turbostat/Makefile
@@ -5,7 +5,7 @@ DESTDIR		:=
 
 turbostat : turbostat.c
 CFLAGS +=	-Wall
-CFLAGS +=	-I../../../../arch/x86/include/uapi/
+CFLAGS +=	-DMSRHEADER='"../../../../arch/x86/include/uapi/asm/msr-index.h"'
 
 %: %.c
 	@mkdir -p $(BUILD_OUTPUT)
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index fe70207..5bf4a67 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -20,7 +20,7 @@
  */
 
 #define _GNU_SOURCE
-#include <asm/msr.h>
+#include MSRHEADER
 #include <stdio.h>
 #include <unistd.h>
 #include <sys/types.h>
-- 
1.8.4.rc3

