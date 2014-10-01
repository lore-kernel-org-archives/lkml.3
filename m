Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbaJAW4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 18:56:47 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45071 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaJAW4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 18:56:46 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>
Cc: frowand.list@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>, josh@joshtriplett.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v5] init: Allow CONFIG_INIT_FALLBACK=n to disable defaults if init= fails
Date: Wed,  1 Oct 2014 15:56:41 -0700
Message-Id: <3c2331ea2aaffcde808995cdd93aa48f6455dd93.1412204084.git.luto@amacapital.net>
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

This adds a config option CONFIG_INIT_FALLBACK.  If unset,
then a failure to run the specified init= process be fatal.

The intent is to switch the default to N after a while and to
possibly even remove the option entirely

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

Changes from v4:
 - Switch the default to y

Changes from v3:
 - Get rid of the strictinit option.  Now the new behavior is the default
   unless CONFIG_INIT_FALLBACK=y (Rob Landley)

Changes from v2:
 - Improve docs further, to leave the door open to giving strictinit
   some sensible semantics if init= is not set.
 - Improve error output in the failure case (Shuah Khan).

Changes from v1:
 - Add missing "if" to the docs (Randy Dunlap)

 init/Kconfig | 16 ++++++++++++++++
 init/main.c  |  7 ++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index e84c6423a2e5..ebbd5846478e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1299,6 +1299,22 @@ source "usr/Kconfig"
 
 endif
 
+config INIT_FALLBACK
+	bool "Fall back to defaults if init= parameter is bad"
+	default y
+	help
+	  If enabled, the kernel will try the default init binaries if an
+	  explicit request from the init= parameter fails.
+
+	  This can have unexpected effects.  For example, booting
+	  with init=/sbin/kiosk_app will run /sbin/init or even /bin/sh
+	  if /sbin/kiosk_app cannot be executed.
+
+	  The default value of Y is consistent with historical behavior.
+	  Selecting N is likely to be more appropriate for most uses,
+	  especially on kiosks and on kernels that are indended to be
+	  run under the control of a script.
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

