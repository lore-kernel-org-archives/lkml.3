Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab3A1QsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:48:15 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:53431 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab3A1Qrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:47:49 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH 2/2] hibernate: Disable in a Secure Boot environment
Date: Mon, 28 Jan 2013 11:47:42 -0500
Message-Id: <1359391662-26120-3-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1359391662-26120-1-git-send-email-matthew.garrett@nebula.com>
References: <1359391662-26120-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

There is currently no way to verify the resume image when returning
from hibernate.  This might compromise the secure boot trust model,
so until we can work with signed hibernate images we disable it in
a Secure Boot environment.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 kernel/power/hibernate.c | 14 +++++++++++++-
 kernel/power/main.c      |  7 ++++++-
 kernel/power/user.c      |  3 +++
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index b26f5f1..14b6344 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -632,6 +632,10 @@ int hibernate(void)
 {
 	int error;
 
+	if (!capable(CAP_COMPROMISE_KERNEL)) {
+		return -EPERM;
+	}
+
 	lock_system_sleep();
 	/* The snapshot device should not be opened while we're running */
 	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
@@ -723,7 +727,7 @@ static int software_resume(void)
 	/*
 	 * If the user said "noresume".. bail out early.
 	 */
-	if (noresume)
+	if (noresume || !capable(CAP_COMPROMISE_KERNEL))
 		return 0;
 
 	/*
@@ -889,6 +893,11 @@ static ssize_t disk_show(struct kobject *kobj, struct kobj_attribute *attr,
 	int i;
 	char *start = buf;
 
+	if (!cap_capable(CAP_COMPROMISE_KERNEL)) {
+		buf += sprintf(buf, "[%s]\n", "disabled");
+		return buf-start;
+	}
+
 	for (i = HIBERNATION_FIRST; i <= HIBERNATION_MAX; i++) {
 		if (!hibernation_modes[i])
 			continue;
@@ -923,6 +932,9 @@ static ssize_t disk_store(struct kobject *kobj, struct kobj_attribute *attr,
 	char *p;
 	int mode = HIBERNATION_INVALID;
 
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return -EPERM;
+
 	p = memchr(buf, '\n', n);
 	len = p ? p - buf : n;
 
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 1c16f91..42f5d94 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -15,6 +15,7 @@
 #include <linux/workqueue.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
+#include <linux/efi.h>
 
 #include "power.h"
 
@@ -301,7 +302,11 @@ static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 	}
 #endif
 #ifdef CONFIG_HIBERNATION
-	s += sprintf(s, "%s\n", "disk");
+	if (capable(CAP_COMPROMISE_KERNEL) {
+		s += sprintf(s, "%s\n", "disk");
+	} else {
+		s += sprintf(s, "\n");
+	}
 #else
 	if (s != buf)
 		/* convert the last space to a newline */
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 4ed81e7..b11a0f4 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -48,6 +48,9 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 	struct snapshot_data *data;
 	int error;
 
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return -EPERM;
+
 	lock_system_sleep();
 
 	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
-- 
1.8.0.2

