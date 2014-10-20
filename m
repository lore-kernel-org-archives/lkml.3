Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaJTMAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:00:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaJTMAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:00:42 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Fabian Frederick <fabf@skynet.be>, linux-doc@vger.kernel.org
Subject: [PATCH] kernel, add bug_on_warn
Date: Mon, 20 Oct 2014 08:00:20 -0400
Message-Id: <1413806420-31828-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There have been several times where I have had to rebuild a kernel to
cause a panic when hitting a WARN() in the code in order to get a crash
dump from a system.  Sometimes this is easy to do, other times (such as
in the case of a remote admin) it is not trivial to send new images to the
user.

A much easier method would be a switch to change the WARN() over to a
BUG().  This makes debugging easier in that I can now test the actual
image the WARN() was seen on and I do not have to engage in remote
debugging.

This patch adds a bug_on_warn kernel parameter, which calls BUG() in the
warn_slowpath_common() path.  The function will still print out the
location of the warning.

Successfully tested by me.

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 Documentation/kernel-parameters.txt |    2 ++
 kernel/panic.c                      |   16 +++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7dbe5ec..2967542 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -553,6 +553,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	bttv.pll=	See Documentation/video4linux/bttv/Insmod-options
 	bttv.tuner=
 
+	bug_on_warn	BUG() instead of WARN()
+
 	bulk_remove=off	[PPC]  This parameter disables the use of the pSeries
 			firmware feature for flushing multiple hpte entries
 			at a time.
diff --git a/kernel/panic.c b/kernel/panic.c
index d09dc5c..258a7be 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -33,6 +33,7 @@ static int pause_on_oops;
 static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
 static bool crash_kexec_post_notifiers;
+static bool bug_on_warn;
 
 int panic_timeout = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
@@ -420,13 +421,19 @@ static void warn_slowpath_common(const char *file, int line, void *caller,
 {
 	disable_trace_on_warning();
 
-	pr_warn("------------[ cut here ]------------\n");
+	if (!bug_on_warn)
+		pr_warn("------------[ cut here ]------------\n");
 	pr_warn("WARNING: CPU: %d PID: %d at %s:%d %pS()\n",
 		raw_smp_processor_id(), current->pid, file, line, caller);
 
 	if (args)
 		vprintk(args->fmt, args->args);
 
+	if (bug_on_warn) {
+		pr_warn("bug_on_warn set, calling BUG()...\n");
+		BUG();
+	}
+
 	print_modules();
 	dump_stack();
 	print_oops_end_marker();
@@ -501,3 +508,10 @@ static int __init oops_setup(char *s)
 	return 0;
 }
 early_param("oops", oops_setup);
+
+static int __init bug_on_warn_setup(char *s)
+{
+	bug_on_warn = true;
+	return 0;
+}
+early_param("bug_on_warn", bug_on_warn_setup);
-- 
1.7.9.3

