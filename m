Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbaBKVFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:05:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaBKTFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, Len Brown <len.brown@intel.com>
Subject: [PATCH 3.13 026/120] turbostat: Dont put unprocessed uapi headers in the include path
Date: Tue, 11 Feb 2014 11:04:27 -0800
Message-Id: <20140211184824.301344317@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/power/x86/turbostat/Makefile    |    2 +-
 tools/power/x86/turbostat/turbostat.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/power/x86/turbostat/Makefile
+++ b/tools/power/x86/turbostat/Makefile
@@ -5,7 +5,7 @@ DESTDIR		:=
 
 turbostat : turbostat.c
 CFLAGS +=	-Wall
-CFLAGS +=	-I../../../../arch/x86/include/uapi/
+CFLAGS +=	-DMSRHEADER='"../../../../arch/x86/include/uapi/asm/msr-index.h"'
 
 %: %.c
 	@mkdir -p $(BUILD_OUTPUT)
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


