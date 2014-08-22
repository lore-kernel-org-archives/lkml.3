Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbaHVQ0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:26:39 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:51736 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaHVQ0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:26:37 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2] checkpatch.pl: New instances of ENOSYS are errors
Date: Fri, 22 Aug 2014 09:26:31 -0700
Message-Id: <72714b6b69d00496d6e55453423c4070de292bf4.1408724662.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ENOSYS means that a nonexistent system call was called.  We have a
bad habit of using it for things like invalid operations on
otherwise valid syscalls.  We should avoid this in new code.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

Pervasive incorrect usage of ENOSYS came up at the kernel summit ABI
review discussion.  Let's see if checkpatch can help.

I'll submit a separate patch for include/uapi/asm-generic/errno.h.

Changes from v1:
 - Moved later so that it won't warn on context lines.
 - Use $herecur.
 - Improve regex pattern.

 scripts/checkpatch.pl | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 182be0f..0a68a29 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2931,6 +2931,14 @@ sub process {
 			     "Prefer dev_$level(... to dev_printk(KERN_$orig, ...\n" . $herecurr);
 		}
 
+# ENOSYS means "bad syscall nr" and nothing else
+# (note that this doesn't run on assembly files, so entry*.S is okay)
+		if ($line =~ /\bENOSYS\b/) {
+			ERROR("ENOSYS",
+			      "ENOSYS means 'invalid syscall nr' and nothing else\n" .
+			      "       (ignore if this really is syscall entry code)\n" . $herecurr);
+		}
+
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
 		if (($line=~/$Type\s*$Ident\(.*\).*\s{/) and
-- 
1.9.3

