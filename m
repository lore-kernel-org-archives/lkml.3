Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaI2Ckh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 22:40:37 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:57835 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbaI2Ckg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 22:40:36 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>, Rob Landley <rob@landley.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v5] init: Disable defaults if init= fails
Date: Sun, 28 Sep 2014 19:40:31 -0700
Message-Id: <5c6381879bea68aebb13530442f1cf8a052be97f.1411958379.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a user puts init=/whatever on the command line and /whatever
can't be run, then the kernel will try a few default options before
giving up.  If init=/whatever came from a bootloader prompt, then
this is unexpected but probably harmless.  On the other hand, if it
comes from a script (e.g. a tool like virtme or perhaps a future
kselftest script), then the fallbacks are likely to exist, but
they'll do the wrong thing.  For example, they might unexpectedly
invoke systemd.

This makes a failure to run the specified init= process be fatal.

As a temporary measure, users can set CONFIG_INIT_FALLBACK=y to
preserve the old behavior.  If no one speaks up, we can remove that
option entirely after a release or two.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

Changes from v4:
 - Update the panic message (sorry for the noise)

Changes from v3:
 - Get rid of the strictinit option.  Now the new behavior is the default
   unless CONFIG_INIT_FALLBACK=y (Rob Landley)

Changes from v2:
 - Improve docs further, to leave the door open to giving strictinit
   some sensible semantics if init= is not set.
 - Improve error output in the failure case (Shuah Khan).

Changes from v1:
 - Add missing "if" to the docs (Randy Dunlap)

 init/Kconfig | 11 +++++++++++
 init/main.c  |  7 ++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index e84c6423a2e5..063029a1556f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1299,6 +1299,17 @@ source "usr/Kconfig"
 
 endif
 
+config INIT_FALLBACK
+	bool "Fall back to defaults if init= parameter is bad"
+	help
+	  If enabled, the kernel will try the default init binaries if an
+	  explicit request from the init= parameter fails.
+
+	  This is a temporary measure to allow broken configurations
+	  to continue to boot.
+
+	  If unsure, say N.
+
 config CC_OPTIMIZE_FOR_SIZE
 	bool "Optimize for size"
 	help
diff --git a/init/main.c b/init/main.c
index bb1aed928f21..2bd6105e5dc5 100644
--- a/init/main.c
+++ b/init/main.c
@@ -960,8 +960,13 @@ static int __ref kernel_init(void *unused)
 		ret = run_init_process(execute_command);
 		if (!ret)
 			return 0;
+#ifndef CONFIG_INIT_FALLBACK
+		panic("Requested init %s failed (error %d).",
+		      execute_command, ret);
+#else
 		pr_err("Failed to execute %s (error %d).  Attempting defaults...\n",
-			execute_command, ret);
+		       execute_command, ret);
+#endif
 	}
 	if (!try_to_run_init_process("/sbin/init") ||
 	    !try_to_run_init_process("/etc/init") ||
-- 
1.9.3

