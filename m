Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbaDBSmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 14:42:23 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:31026 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932494AbaDBSmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 14:42:22 -0400
Date: Wed, 2 Apr 2014 14:42:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
Message-ID: <20140402144219.4cafbe37@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has come to our attention that a system running a specific user
space init program will not boot if you add "debug" to the kernel
command line. What happens is that the user space tool parses the
kernel command line, and if it sees "debug" it will spit out so much
information that the system fails to boot. This basically renders the
"debug" option for the kernel useless.

This bug has been reported to the developers of said tool
here:

  https://bugs.freedesktop.org/show_bug.cgi?id=76935

The response is:

"Generic terms are generic, not the first user owns them."

That is, the "debug" statement on the *kernel* command line is not
owned by the kernel just because it was the first user of it, and
they refuse to fix their bug.

Well, my response is, we OWN the kernel command line, and as such, we
can keep the users from seeing stuff on it if we so choose. And with
that, I propose this patch, which hides "debug" from /proc/cmdline,
such that we don't have to worry about tools parsing for it and causing
hardship for those trying to debug the kernel.

Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
diff --git a/fs/proc/cmdline.c b/fs/proc/cmdline.c
index cbd82df..fdb75f7 100644
--- a/fs/proc/cmdline.c
+++ b/fs/proc/cmdline.c
@@ -5,7 +5,7 @@
 
 static int cmdline_proc_show(struct seq_file *m, void *v)
 {
-	seq_printf(m, "%s\n", saved_command_line);
+	seq_printf(m, "%s\n", proc_command_line);
 	return 0;
 }
 
diff --git a/include/linux/init.h b/include/linux/init.h
index a3ba270..daf978a 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -145,6 +145,7 @@ typedef void (*ctor_fn_t)(void);
 extern int do_one_initcall(initcall_t fn);
 extern char __initdata boot_command_line[];
 extern char *saved_command_line;
+extern char *proc_command_line;
 extern unsigned int reset_devices;
 
 /* used by init/main.c */
diff --git a/init/main.c b/init/main.c
index 9c7fd4c..6c2022f 100644
--- a/init/main.c
+++ b/init/main.c
@@ -121,8 +121,10 @@ void (*__initdata late_time_init)(void);
 
 /* Untouched command line saved by arch-specific code. */
 char __initdata boot_command_line[COMMAND_LINE_SIZE];
-/* Untouched saved command line (eg. for /proc) */
+/* Untouched saved command line */
 char *saved_command_line;
+/* Slightly touched command line (for /proc) */
+char *proc_command_line;
 /* Command line for parameter parsing */
 static char *static_command_line;
 /* Command line for per-initcall parameter parsing */
@@ -349,13 +351,44 @@ static inline void smp_prepare_cpus(unsigned int maxcpus) { }
  */
 static void __init setup_command_line(char *command_line)
 {
-	saved_command_line =
-		memblock_virt_alloc(strlen(boot_command_line) + 1, 0);
-	initcall_command_line =
-		memblock_virt_alloc(strlen(boot_command_line) + 1, 0);
+	char *str;
+	int len = strlen(boot_command_line);
+
+	saved_command_line = memblock_virt_alloc(len + 1, 0);
+	initcall_command_line = memblock_virt_alloc(len + 1, 0);
 	static_command_line = memblock_virt_alloc(strlen(command_line) + 1, 0);
 	strcpy (saved_command_line, boot_command_line);
 	strcpy (static_command_line, command_line);
+
+	proc_command_line = saved_command_line;
+
+	/*
+	 * To keep user processes from abusing 'debug', we strip it
+	 * from what /proc/cmdline shows.
+	 */
+	str = saved_command_line;
+	do {
+		int index;
+
+		str = strstr(str, "debug");
+		if (!str)
+			break;
+
+		/* Make sure debug is by itself */
+		if ((str != saved_command_line && str[-1] != ' ') ||
+		    (str[5] != '\0' && str[5] != ' ')) {
+			str += 5;
+			continue;
+		}
+
+		/* Remove "debug" from command line */
+		index = str - saved_command_line;
+		proc_command_line = memblock_virt_alloc(len - 4, 0);
+		strncpy(proc_command_line, boot_command_line, index);
+		strncpy(proc_command_line + index,
+			boot_command_line + index + 5, len - (index + 5));
+		break;
+	} while (*str != '\0');
 }
 
 /*
