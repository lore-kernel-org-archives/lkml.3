Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573AbaJDASh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:18:37 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:50447 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168AbaJCVoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:44:55 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, tiwai@suse.de,
        tj@kernel.org, arjan@linux.intel.com
Cc: teg@jklm.no, rmilasan@suse.com, werner@suse.com, oleg@redhat.com,
        hare@suse.com, bpoirier@suse.de, santosh@chelsio.com, pmladek@suse.cz,
        dbueso@suse.com, mcgrof@suse.com, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH v2 1/7] taint: add TAINT_DEBUG for invasive debugging features
Date: Fri,  3 Oct 2014 14:44:37 -0700
Message-Id: <1412372683-2003-2-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412372683-2003-1-git-send-email-mcgrof@do-not-panic.com>
References: <1412372683-2003-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

At times we may add module parameters or debugging / testing
kernel features, when enabled though we don't really want
to be spending time debugging them. Add a taint flag for
this to avoid spurious bug reports.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 Documentation/sysctl/kernel.txt | 1 +
 include/linux/kernel.h          | 1 +
 kernel/module.c                 | 4 ++--
 kernel/panic.c                  | 2 ++
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index f79eb96..1780a68 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -827,6 +827,7 @@ can be ORed together:
 8192 - An unsigned module has been loaded in a kernel supporting module
        signature.
 16384 - A soft lockup has previously occurred on the system.
+32768 - A possibly disruptive testing / debug kernel feature has been enabled
 
 ==============================================================
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 95624be..8901809 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -471,6 +471,7 @@ extern enum system_states {
 #define TAINT_OOT_MODULE		12
 #define TAINT_UNSIGNED_MODULE		13
 #define TAINT_SOFTLOCKUP		14
+#define TAINT_DEBUG			15
 
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
diff --git a/kernel/module.c b/kernel/module.c
index 03214bd2..3f7d02a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1013,8 +1013,8 @@ static size_t module_flags_taint(struct module *mod, char *buf)
 		buf[l++] = 'E';
 	/*
 	 * TAINT_FORCED_RMMOD: could be added.
-	 * TAINT_CPU_OUT_OF_SPEC, TAINT_MACHINE_CHECK, TAINT_BAD_PAGE don't
-	 * apply to modules.
+	 * TAINT_CPU_OUT_OF_SPEC, TAINT_MACHINE_CHECK, TAINT_BAD_PAGE
+	 * and TAINT_DEBUG don't apply to modules.
 	 */
 	return l;
 }
diff --git a/kernel/panic.c b/kernel/panic.c
index d09dc5c..8e5a77b 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -225,6 +225,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_OOT_MODULE,		'O', ' ' },
 	{ TAINT_UNSIGNED_MODULE,	'E', ' ' },
 	{ TAINT_SOFTLOCKUP,		'L', ' ' },
+	{ TAINT_DEBUG,			'T', ' ' },
 };
 
 /**
@@ -244,6 +245,7 @@ static const struct tnt tnts[] = {
  *  'I' - Working around severe firmware bug.
  *  'O' - Out-of-tree module has been loaded.
  *  'E' - Unsigned module has been loaded.
+ *  'T' - System has enabled an intrusive testing / debug kernel feature.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
-- 
2.1.1

