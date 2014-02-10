Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaBJUCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:02:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34937 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbaBJTqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:46:15 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Triplett <josh@joshtriplett.org>, Len Brown <len.brown@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 073/124] turbostat: Don't put unprocessed uapi headers in the include path
Date: Mon, 10 Feb 2014 11:40:13 -0800
Message-Id: <1392061264-28124-74-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Triplett <josh@joshtriplett.org>

commit b731f3119de57144e16c19fd593b8daeb637843e upstream.

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
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
index ce6d460..10f4d14 100644
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
1.8.3.2

