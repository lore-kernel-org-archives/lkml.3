Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbaDQDNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 23:13:00 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:45266 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbaDQDM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 23:12:59 -0400
Subject: [PATCH v2] kernel/panic: Add "crash_kexec_post_notifiers" option
 for kdump after panic_notifers
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Satoru MORIYA <satoru.moriya.br@hitachi.com>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Date: Thu, 17 Apr 2014 12:12:50 +0900
Message-ID: <20140417031250.1150.26322.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a "crash_kexec_post_notifiers" option to run kdump after running
panic_notifiers and dump kmsg. This can help rare situations which
kdump drops in failure because of unstable crashed kernel or hardware
failure (memory corruption on critical data/code), or the 2nd kernel
is already broken by the 1st kernel (it's a broken behavior, but who
can guarantee that the "crashed" kernel works correctly?).

Usage: add "crash_kexec_post_notifiers" to kernel boot option.

Note that this actually increases risks of the failure of kdump.
This option should be set only if you worry about the rare case
of kdump failure rather than increasing the chance of success.

Changes from v1:
 - Rename late_kdump option to crash_kexec_post_notifiers.
 - Remove unneeded warning message.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Satoru MORIYA <satoru.moriya.br@hitachi.com>
Cc: Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>
Cc: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
---
 Documentation/kernel-parameters.txt |    8 ++++++++
 kernel/panic.c                      |   25 +++++++++++++++++++++++--
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 03e50b4..1df416b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2339,6 +2339,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			timeout < 0: reboot immediately
 			Format: <timeout>
 
+	crash_kexec_post_notifiers
+			Run kdump after running panic-notifiers and dumping
+			kmsg. This only for the users who doubt kdump always
+			succeeds in any situation.
+			Note that this also increases risks of kdump failure,
+			because some panic notifiers can make the crashed
+			kernel more unstable.
+
 	parkbd.port=	[HW] Parallel port number the keyboard adapter is
 			connected to, default is 0.
 			Format: <parport#>
diff --git a/kernel/panic.c b/kernel/panic.c
index d02fa9f..0c99c8c 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -32,6 +32,7 @@ static unsigned long tainted_mask;
 static int pause_on_oops;
 static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
+static bool crash_kexec_post_notifiers;
 
 int panic_timeout = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
@@ -112,9 +113,13 @@ void panic(const char *fmt, ...)
 	/*
 	 * If we have crashed and we have a crash kernel loaded let it handle
 	 * everything else.
-	 * Do we want to call this before we try to display a message?
+	 * If we want to run this after calling panic_notifiers, pass
+	 * the "crash_kexec_post_notifiers" option to the kernel.
 	 */
-	crash_kexec(NULL);
+	if (!crash_kexec_post_notifiers)
+		crash_kexec(NULL);
+	else
+		pr_emerg("Warning: crash_kexec_post_notifiers is set.\n");
 
 	/*
 	 * Note smp_send_stop is the usual smp shutdown function, which
@@ -131,6 +136,15 @@ void panic(const char *fmt, ...)
 
 	kmsg_dump(KMSG_DUMP_PANIC);
 
+	/*
+	 * If you doubt kdump always works fine in any situation,
+	 * "crash_kexec_post_notifiers" offers you a chance to run 
+	 * panic_notifiers and dumping kmsg before kdump.
+	 * Note: since some panic_notifiers can make crashed kernel
+	 * more unstable, it can increase risks of the kdump failure too.
+	 */
+	crash_kexec(NULL);
+
 	bust_spinlocks(0);
 
 	if (!panic_blink)
@@ -472,6 +486,13 @@ EXPORT_SYMBOL(__stack_chk_fail);
 core_param(panic, panic_timeout, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
 
+static int __init setup_crash_kexec_post_notifiers(char *s)
+{
+	crash_kexec_post_notifiers = true;
+	return 0;
+}
+early_param("crash_kexec_post_notifiers", setup_crash_kexec_post_notifiers);
+
 static int __init oops_setup(char *s)
 {
 	if (!s)


