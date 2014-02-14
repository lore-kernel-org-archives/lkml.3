Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaBNOP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 09:15:27 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:35465 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbaBNOPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 09:15:23 -0500
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Emelyanov <xemul@parallels.com>,
        Aditya Kali <adityakali@google.com>
Subject: [PATCH 1/3] prctl: reduce permissions to change boundaries of data, brk and stack
Date: Fri, 14 Feb 2014 18:13:27 +0400
Message-Id: <1392387209-330-2-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392387209-330-1-git-send-email-avagin@openvz.org>
References: <1392387209-330-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently this operation requires the global CAP_SYS_RESOURCE.
It's required, because a task can exceed limits (RLIMIT_DATA,
RLIMIT_STACK).

So let's allow task to change these parameters if a proper limit is
unlimited.

When we restore a task we need to set up text, data and data heap sizes
from userspace to the values a task had at checkpoint time.

Currently we can not restore these parameters, if a task lives in
a non-root user name space, because it has no capabilities in the
parent namespace.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Aditya Kali <adityakali@google.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 kernel/sys.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index c0a58be..939370c 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1701,8 +1701,23 @@ static int prctl_set_mm(int opt, unsigned long addr,
 	if (arg5 || (arg4 && opt != PR_SET_MM_AUXV))
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_RESOURCE))
-		return -EPERM;
+	if (!capable(CAP_SYS_RESOURCE)) {
+		switch (opt) {
+		case PR_SET_MM_START_DATA:
+		case PR_SET_MM_END_DATA:
+		case PR_SET_MM_START_BRK:
+		case PR_SET_MM_BRK:
+			if (rlim < RLIM_INFINITY)
+				return -EPERM;
+			break;
+		case PR_SET_MM_START_STACK:
+			if (rlimit(RLIMIT_STACK) < RLIM_INFINITY)
+				return -EPERM;
+			break;
+		default:
+			return -EPERM;
+		}
+	}
 
 	if (opt == PR_SET_MM_EXE_FILE)
 		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
-- 
1.8.5.3

