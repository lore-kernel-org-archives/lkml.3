Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146Ab3HJXo5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 19:44:57 -0400
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:60365 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab3HJXox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 19:44:53 -0400
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Aug 2013 19:44:53 EDT
X-Originating-IP: 50.43.39.152
Date: Sat, 10 Aug 2013 16:36:29 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>,
        Mark Asselstine <mark.asselstine@windriver.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH] turbostat: Don't put unprocessed uapi headers in the include
 path
Message-ID: <20130810233627.GA8161@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
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

CCing this to stable because it fixes a broken build on some systems.
Applies as far back as 3.8.

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
1.8.4.rc1

