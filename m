Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbaFDCUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 22:20:04 -0400
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:39355 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753159AbaFDCUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 22:20:01 -0400
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jun 2014 22:20:01 EDT
From: Josh Hunt <johunt@akamai.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: jbaron@akamai.com, Josh Hunt <johunt@akamai.com>
Subject: [PATCH] panic: add TAINT_SOFTLOCKUP
Date: Tue,  3 Jun 2014 22:12:35 -0400
Message-Id: <1401847955-3345-1-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This taint flag will be set if the system has ever entered a softlockup
state. Similar to TAINT_WARN it is useful to know whether or not the system
has been in a softlockup state when debugging.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 Documentation/oops-tracing.txt  |    2 ++
 Documentation/sysctl/kernel.txt |    1 +
 include/linux/kernel.h          |    1 +
 kernel/panic.c                  |    1 +
 kernel/watchdog.c               |    1 +
 5 files changed, 6 insertions(+)

diff --git a/Documentation/oops-tracing.txt b/Documentation/oops-tracing.txt
index e315599..beefb9f 100644
--- a/Documentation/oops-tracing.txt
+++ b/Documentation/oops-tracing.txt
@@ -268,6 +268,8 @@ characters, each representing a particular tainted value.
  14: 'E' if an unsigned module has been loaded in a kernel supporting
      module signature.
 
+ 15: 'L' if a soft lockup has previously occurred on the system.
+
 The primary reason for the 'Tainted: ' string is to tell kernel
 debuggers if this is a clean kernel or if anything unusual has
 occurred.  Tainting is permanent: even if an offending module is
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 9886c3d..8dfdf2f 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -788,6 +788,7 @@ can be ORed together:
 4096 - An out-of-tree module has been loaded.
 8192 - An unsigned module has been loaded in a kernel supporting module
        signature.
+16384 - A soft lockup has previously occurred on the system.
 
 ==============================================================
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4c52907..eb7b074 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -470,6 +470,7 @@ extern enum system_states {
 #define TAINT_FIRMWARE_WORKAROUND	11
 #define TAINT_OOT_MODULE		12
 #define TAINT_UNSIGNED_MODULE		13
+#define TAINT_SOFTLOCKUP		14
 
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
diff --git a/kernel/panic.c b/kernel/panic.c
index d02fa9f..d68c5d8 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -212,6 +212,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_FIRMWARE_WORKAROUND,	'I', ' ' },
 	{ TAINT_OOT_MODULE,		'O', ' ' },
 	{ TAINT_UNSIGNED_MODULE,	'E', ' ' },
+	{ TAINT_SOFTLOCKUP,		'L', ' ' },
 };
 
 /**
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 516203e..09ac67c 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -329,6 +329,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 
 		if (softlockup_panic)
 			panic("softlockup: hung tasks");
+		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
 		__this_cpu_write(soft_watchdog_warn, true);
 	} else
 		__this_cpu_write(soft_watchdog_warn, false);
-- 
1.7.9.5

