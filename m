Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbaGOBhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 21:37:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588AbaGOBhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 21:37:36 -0400
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Seth Jennings <sjenning@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, kpatch@redhat.com
Subject: [PATCH v2 1/2] kpatch: add TAINT_KPATCH flag
Date: Mon, 14 Jul 2014 20:37:06 -0500
Message-Id: <f3e31aa0b479054830dff25e147bc3276f87844a.1405374204.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1405374204.git.jpoimboe@redhat.com>
References: <cover.1405374204.git.jpoimboe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a TAINT_KPATCH flag to be set whenever a kpatch patch module
successfully replaces a function.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>
---
 Documentation/oops-tracing.txt  | 3 +++
 Documentation/sysctl/kernel.txt | 1 +
 include/linux/kernel.h          | 1 +
 kernel/panic.c                  | 2 ++
 4 files changed, 7 insertions(+)

diff --git a/Documentation/oops-tracing.txt b/Documentation/oops-tracing.txt
index e315599..cd89895 100644
--- a/Documentation/oops-tracing.txt
+++ b/Documentation/oops-tracing.txt
@@ -268,6 +268,9 @@ characters, each representing a particular tainted value.
  14: 'E' if an unsigned module has been loaded in a kernel supporting
      module signature.
 
+ 15: 'K' if a kpatch hot patch module has replaced any functions in the
+     running kernel.
+
 The primary reason for the 'Tainted: ' string is to tell kernel
 debuggers if this is a clean kernel or if anything unusual has
 occurred.  Tainting is permanent: even if an offending module is
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index c14374e..1009d22 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -826,6 +826,7 @@ can be ORed together:
 4096 - An out-of-tree module has been loaded.
 8192 - An unsigned module has been loaded in a kernel supporting module
        signature.
+16384 - A kpatch module has replaced a function in the running kernel.
 
 ==============================================================
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4c52907..cdfbe73 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -470,6 +470,7 @@ extern enum system_states {
 #define TAINT_FIRMWARE_WORKAROUND	11
 #define TAINT_OOT_MODULE		12
 #define TAINT_UNSIGNED_MODULE		13
+#define TAINT_KPATCH			14
 
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
diff --git a/kernel/panic.c b/kernel/panic.c
index 62e16ce..e780909 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -224,6 +224,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_FIRMWARE_WORKAROUND,	'I', ' ' },
 	{ TAINT_OOT_MODULE,		'O', ' ' },
 	{ TAINT_UNSIGNED_MODULE,	'E', ' ' },
+	{ TAINT_KPATCH,			'K', ' ' },
 };
 
 /**
@@ -243,6 +244,7 @@ static const struct tnt tnts[] = {
  *  'I' - Working around severe firmware bug.
  *  'O' - Out-of-tree module has been loaded.
  *  'E' - Unsigned module has been loaded.
+ *  'K' - kpatch replaced a function.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
-- 
1.9.3

