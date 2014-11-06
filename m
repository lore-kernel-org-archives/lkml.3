Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaKFOj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:39:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbaKFOjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:39:20 -0500
From: Seth Jennings <sjenning@redhat.com>
To: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] kernel: add TAINT_LIVEPATCH
Date: Thu,  6 Nov 2014 08:39:07 -0600
Message-Id: <1415284748-14648-2-git-send-email-sjenning@redhat.com>
In-Reply-To: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a new taint flag to indicate when the kernel or a kernel
module has been live patched.  This will provide a clean indication in
bug reports that live patching was used.

Additionally, if the crash occurs in a live patched function, the live
patch module will appear beside the patched function in the backtrace.

Signed-off-by: Seth Jennings <sjenning@redhat.com>
---
 Documentation/oops-tracing.txt  | 2 ++
 Documentation/sysctl/kernel.txt | 1 +
 include/linux/kernel.h          | 1 +
 kernel/panic.c                  | 2 ++
 4 files changed, 6 insertions(+)

diff --git a/Documentation/oops-tracing.txt b/Documentation/oops-tracing.txt
index beefb9f..f3ac05c 100644
--- a/Documentation/oops-tracing.txt
+++ b/Documentation/oops-tracing.txt
@@ -270,6 +270,8 @@ characters, each representing a particular tainted value.
 
  15: 'L' if a soft lockup has previously occurred on the system.
 
+ 16: 'K' if the kernel has been live patched.
+
 The primary reason for the 'Tainted: ' string is to tell kernel
 debuggers if this is a clean kernel or if anything unusual has
 occurred.  Tainting is permanent: even if an offending module is
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index d7fc4ab..085f73b 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -831,6 +831,7 @@ can be ORed together:
 8192 - An unsigned module has been loaded in a kernel supporting module
        signature.
 16384 - A soft lockup has previously occurred on the system.
+32768 - The kernel has been live patched.
 
 ==============================================================
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 446d76a..a6aa2df 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -473,6 +473,7 @@ extern enum system_states {
 #define TAINT_OOT_MODULE		12
 #define TAINT_UNSIGNED_MODULE		13
 #define TAINT_SOFTLOCKUP		14
+#define TAINT_LIVEPATCH			15
 
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
diff --git a/kernel/panic.c b/kernel/panic.c
index d09dc5c..46bca3d 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -225,6 +225,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_OOT_MODULE,		'O', ' ' },
 	{ TAINT_UNSIGNED_MODULE,	'E', ' ' },
 	{ TAINT_SOFTLOCKUP,		'L', ' ' },
+	{ TAINT_LIVEPATCH,		'K', ' ' },
 };
 
 /**
@@ -244,6 +245,7 @@ static const struct tnt tnts[] = {
  *  'I' - Working around severe firmware bug.
  *  'O' - Out-of-tree module has been loaded.
  *  'E' - Unsigned module has been loaded.
+ *  'K' - Kernel has been live patched.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
-- 
1.9.3

