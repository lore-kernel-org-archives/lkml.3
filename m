Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbaHVSFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 14:05:34 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:51656 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbaHVSFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 14:05:33 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3] checkpatch.pl: New instances of ENOSYS are errors
Date: Fri, 22 Aug 2014 11:05:25 -0700
Message-Id: <5eb299021dec23c1a48fa7d9f2c8b794e967766d.1408730669.git.luto@amacapital.net>
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

Changes from v2:
 - Reduce severity to WARN.
 - Remove unnecessary clarification.
 - Rebase onto Linus' tree instead of v3.16.

Changes from v1:
 - Moved later so that it won't warn on context lines.
 - Use $herecur.
 - Improve regex pattern.

 scripts/checkpatch.pl | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 31a731e..448d075 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3214,6 +3214,14 @@ sub process {
 			     "Prefer dev_$level(... to dev_printk(KERN_$orig, ...\n" . $herecurr);
 		}
 
+# ENOSYS means "bad syscall nr" and nothing else.  This will have a small
+# number of false positives, but assembly files are not checked, so at
+# least the arch entry code will not trigger this warning.
+		if ($line =~ /\bENOSYS\b/) {
+			WARN("ENOSYS",
+			     "ENOSYS means 'invalid syscall nr' and nothing else\n" . $herecurr);
+		}
+
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
 		if (($line=~/$Type\s*$Ident\(.*\).*\s*{/) and
-- 
1.9.3

