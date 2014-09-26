Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaIZAz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 20:55:28 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:59580 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbaIZAz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 20:55:27 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] init: Add strictinit to disable init= fallbacks
Date: Thu, 25 Sep 2014 17:55:20 -0700
Message-Id: <0df43a7e86c386129905b679014acd1cd7b61220.1411692874.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a user puts init=/whatever on the command line and /whatever
can't be run, then the kernel will try a few default options before
giving up.  If init=/whatever came from a bootloader prompt, then
this probably makes sense.  On the other hand, if it comes from a
script (e.g. a tool like virtme or perhaps a future kselftest
script), then the fallbacks are likely to exist, but they'll do the
wrong thing.  For example, they might unexpectedly invoke systemd.

This adds a new option called strictinit.  If init= and strictinit
are both set, and the init= binary is not executable, then the
kernel will panic immediately.  If strictinit is set but init= is
not set, then strictinit will have no effect, because the only real
alternative would be to panic regardless of the contents of the root
fs.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 Documentation/kernel-parameters.txt |  8 ++++++++
 init/main.c                         | 10 ++++++++++
 2 files changed, 18 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 10d51c2f10d7..60f8b3a7a506 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3236,6 +3236,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	stifb=		[HW]
 			Format: bpp:<bpp1>[:<bpp2>[:<bpp3>...]]
 
+	strictinit	[KNL,BOOT]
+			Normally, the kernel can't find the init binary
+			specified by rdinit= and/or init=, then it will
+			try several fallbacks.  If strictinit is set
+			and the value specified by init= does not work,
+			then the kernel will panic instead.
+			This has no effect if init= is not specified.
+
 	sunrpc.min_resvport=
 	sunrpc.max_resvport=
 			[NFS,SUNRPC]
diff --git a/init/main.c b/init/main.c
index bb1aed928f21..4fd80dcef9d0 100644
--- a/init/main.c
+++ b/init/main.c
@@ -131,6 +131,7 @@ static char *initcall_command_line;
 
 static char *execute_command;
 static char *ramdisk_execute_command;
+static bool strictinit;
 
 /*
  * Used to generate warnings if static_key manipulation functions are used
@@ -347,6 +348,13 @@ static int __init rdinit_setup(char *str)
 }
 __setup("rdinit=", rdinit_setup);
 
+static int __init strictinit_setup(char *str)
+{
+	strictinit = true;
+	return 1;
+}
+__setup("strictinit", strictinit_setup);
+
 #ifndef CONFIG_SMP
 static const unsigned int setup_max_cpus = NR_CPUS;
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -962,6 +970,8 @@ static int __ref kernel_init(void *unused)
 			return 0;
 		pr_err("Failed to execute %s (error %d).  Attempting defaults...\n",
 			execute_command, ret);
+		if (strictinit)
+			panic("Requested init failed and strictinit was set.");
 	}
 	if (!try_to_run_init_process("/sbin/init") ||
 	    !try_to_run_init_process("/etc/init") ||
-- 
1.9.3

