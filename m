Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab3DYOZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:25:05 -0400
Received: from mail.openrapids.net ([64.15.138.104]:37667 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757698Ab3DYOZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:25:04 -0400
Date: Thu, 25 Apr 2013 10:24:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Howells <dhowells@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] Fix: remove stale include/linux/version.h in toplevel
	Makefile
Message-ID: <20130425142458.GA5869@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a kernel tree that contains a generated include/linux/version.h, if
someone just does a git pull to update to a newer kernel version that
includes

commit 10b63956fce7f369cc37fd4d994f09bd5203efe4

"UAPI: Plumb the UAPI Kbuilds into the user header installation and
checking"

and
commit d183e6f570f3c0c23d253fd262c90244e72d7ffd

"UAPI: Move linux/version.h"

Any newer build will fail to overwrite or remove the stale version.h
file. The new include/generated/uapi/linux/version.h is indeed
generated, but the stale file in include/linux has precedence.

This leads to very unfortunate consequences for any user relying on
version.h to expose the kernel version accurately, since the old "stale"
kernel version will be seen by the build.

Ensure that stale include/linux/version.h is removed whenever the new
version.h is generated.

This patch should be backported to 3.7 and 3.8 stable branches after it
gets into mainline.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: David Howells <dhowells@redhat.com>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Dave Jones <davej@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
---
 Makefile |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/Makefile
===================================================================
--- linux.orig/Makefile
+++ linux/Makefile
@@ -823,8 +823,10 @@ endif
 # prepare2 creates a makefile if using a separate output directory
 prepare2: prepare3 outputmakefile asm-generic
 
+# Includes removal of stale version.h from earlier kernel versions.
 prepare1: prepare2 $(version_h) include/generated/utsrelease.h \
                    include/config/auto.conf
+	$(Q)rm -f include/linux/version.h
 	$(cmd_crmodverdir)
 
 archprepare: archheaders archscripts prepare1 scripts_basic

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
