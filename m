Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab3CNUHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 16:07:12 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:60741 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab3CNUHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 16:07:10 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH] Allow optional module parameters
Date: Thu, 14 Mar 2013 13:07:05 -0700
Message-Id: <b6b1676fd5bcd6b0ef47b0e0a1c26b1c05684135.1363291511.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current parameter behavior is odd.  Boot parameters that have values
and don't match anything become environment variables, with no
warning.  Boot parameters without values that don't match anything
go into argv_init.  Everything goes into /proc/cmdline.

The init_module and finit_module syscalls, however, are strict:
parameters that don't match result in -ENOENT.

kmod (and hence modprobe), when loading a module called foo, look in
/proc/cmdline for foo.x or foo.x=y, strip off the foo., and pass the
rest to init_module.

The upshot is that booting with module.nonexistent_parameter=1 is
okay if module is built in or missing entirely but prevents module
from loading if it's an actual module.  Similarly, option module
nonexistent_parameter=1 in /etc/modprobe.d prevents the module from
loading the parameter goes away.  This means that removing module
parameters unnecessarily breaks things.

With this patch, module parameters can be made explicitly optional.
This approach is IMO silly, but it's unlikely to break anything,
since I doubt that anyone needs init parameters or init environment
variables that end in a tilde.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

This is, IMO, rather ugly.  Better ideas are welcome, but I think that this
is a significant improvement over the status quo.

 Documentation/kernel-parameters.txt | 11 +++++++++++
 kernel/params.c                     | 29 ++++++++++++++++++++++-------
 2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..605240c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -22,6 +22,17 @@ Hyphens (dashes) and underscores are equivalent in parameter names, so
 can also be entered as
 	log-buf-len=1M print_fatal_signals=1
 
+Parameter settings may be suffixed by '~' to make them optional; non-optional
+parameters that don't match anything can cause modprobe to fail.  For example,
+modprobe usbcore typoedlights=1 will fail, but modprobe usbcore typoedlights~=1
+or modprobe usbcore typoedlights~ will merely print a warning.
+
+Note that module parameters on the kernel command line are parsed internally
+by the kernel if the module is built in and by kmod if not.  In either case,
+
+	usbcore.typoedlights~=1
+
+will result in an optional parameter setting.
 
 This document may not be entirely up to date and comprehensive. The command
 "modinfo -p ${modulename}" shows a current list of all parameters of a loadable
diff --git a/kernel/params.c b/kernel/params.c
index ed35345..83664b3 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -126,9 +126,9 @@ static int parse_one(char *param,
 
 /* You can use " around spaces, but can't escape ". */
 /* Hyphens and underscores equivalent in parameter names. */
-static char *next_arg(char *args, char **param, char **val)
+static char *next_arg(char *args, char **param, char **val, bool *optional)
 {
-	unsigned int i, equals = 0;
+	unsigned int i, equals = 0, param_len;
 	int in_quote = 0, quoted = 0;
 	char *next;
 
@@ -150,11 +150,13 @@ static char *next_arg(char *args, char **param, char **val)
 	}
 
 	*param = args;
-	if (!equals)
+	if (!equals) {
 		*val = NULL;
-	else {
+		param_len = i;
+	} else {
 		args[equals] = '\0';
 		*val = args + equals + 1;
+		param_len = equals;
 
 		/* Don't include quotes in value. */
 		if (**val == '"') {
@@ -166,6 +168,13 @@ static char *next_arg(char *args, char **param, char **val)
 			args[i-1] = '\0';
 	}
 
+	if (param_len && (*param)[param_len-1] == '~') {
+		*optional = true;
+		(*param)[param_len-1] = '\0';
+	} else {
+		*optional = false;
+	}
+
 	if (args[i]) {
 		args[i] = '\0';
 		next = args + i + 1;
@@ -196,8 +205,9 @@ int parse_args(const char *doing,
 	while (*args) {
 		int ret;
 		int irq_was_disabled;
+		bool optional;
 
-		args = next_arg(args, &param, &val);
+		args = next_arg(args, &param, &val, &optional);
 		irq_was_disabled = irqs_disabled();
 		ret = parse_one(param, val, doing, params, num,
 				min_level, max_level, unknown);
@@ -207,8 +217,13 @@ int parse_args(const char *doing,
 
 		switch (ret) {
 		case -ENOENT:
-			pr_err("%s: Unknown parameter `%s'\n", doing, param);
-			return ret;
+			if (optional) {
+				pr_warn("%s: Ignoring unknown optional parameter `%s'\n", doing, param);
+				break;
+			} else {
+				pr_err("%s: Unknown parameter `%s'\n", doing, param);
+				return ret;
+			}
 		case -ENOSPC:
 			pr_err("%s: `%s' too large for parameter `%s'\n",
 			       doing, val ?: "", param);
-- 
1.8.1.4

