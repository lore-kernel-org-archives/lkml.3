Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab3GXVhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 17:37:33 -0400
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:34078 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3GXVhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 17:37:32 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jul 2013 17:37:31 EDT
From: Daniel Nilsson <daniel@dnil.se>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Nilsson <daniel@dnil.se>
Subject: [PATCH] VFS: Prevent core dump with core_pattern set to empty string
Date: Wed, 24 Jul 2013 23:30:50 +0200
Message-Id: <1374701450-88005-1-git-send-email-daniel@dnil.se>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the core_pattern (proc/sys/core_pattern) is set to an empty string
a core dump is still made but to a file with a filename set by an
uninitialized buffer in format_corename(). This patch fixes the use of the
uninitialized buffer and also aborts the core dump with a warning message
when core_pattern is set to an empty string.

Tested and developed against 3.11-rc2

Signed-off-by: Daniel Nilsson <daniel@dnil.se>
---
 fs/coredump.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/coredump.c b/fs/coredump.c
index 72f816d..5035402 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -170,6 +170,11 @@ static int format_corename(struct core_name *cn, struct coredump_params *cprm)
 	if (ispipe)
 		++pat_ptr;
 
+	if (*pat_ptr == '\0') {
+		err = cn_printf(cn, "");
+		goto out;
+	}
+
 	/* Repeat as long as we have more pattern to process and more output
 	   space */
 	while (*pat_ptr) {
@@ -617,6 +622,13 @@ void do_coredump(siginfo_t *siginfo)
 			goto fail_unlock;
 		}
 
+		if (cn.corename[0] == '\0') {
+			printk(KERN_WARNING
+			       "core_pattern contains an empty string!\n");
+			printk(KERN_WARNING "Skipping core dump\n");
+			goto fail_unlock;
+		}
+
 		cprm.file = filp_open(cn.corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
-- 
1.7.9.5

