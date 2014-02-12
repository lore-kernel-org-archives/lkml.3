Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaBLPor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:44:47 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:28345 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbaBLPoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:44:46 -0500
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Robin Holt <holt@sgi.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Chen Gang <gang.chen@asianux.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Emelyanov <xemul@parallels.com>,
        Aditya Kali <adityakali@google.com>, security@kernel.org
Subject: [PATCH] kernel: reduce required permission for prctl_set_mm
Date: Wed, 12 Feb 2014 19:40:11 +0400
Message-Id: <1392219611-13260-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently prctl_set_mm requires the global CAP_SYS_RESOURCE,
this patch reduce requiremence to CAP_SYS_RESOURCE in the current
namespace.

When we restore a task we need to set up text, data and data heap sizes
from userspace to the values a task had at checkpoint time.

Currently we can not restore these parameters, if a task lives in
a non-root user name space, because it has no capabilities in the
parent namespace.

prctl_set_mm() changes parameters of the current task and doesn't affect
other tasks.

This patch affects the RLIMIT_DATA limit, because a consumtiuon is
calculated relatively to mm->end_data, mm->start_data, mm->start_brk.

rlim = rlimit(RLIMIT_DATA);
if (rlim < RLIM_INFINITY && (brk - mm->start_brk) +
		(mm->end_data - mm->start_data) > rlim)
	goto out;

This limit affects calls to brk() and sbrk(), but it doesn't affect
mmap. So I think requirement of CAP_SYS_RESOURCE in the current
namespace is enough for this limit.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Chen Gang <gang.chen@asianux.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Aditya Kali <adityakali@google.com>
Cc: security@kernel.org
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 kernel/sys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index c0a58be..6f36fb3 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1701,7 +1701,7 @@ static int prctl_set_mm(int opt, unsigned long addr,
 	if (arg5 || (arg4 && opt != PR_SET_MM_AUXV))
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_RESOURCE))
+	if (!ns_capable(current_user_ns(), CAP_SYS_RESOURCE))
 		return -EPERM;
 
 	if (opt == PR_SET_MM_EXE_FILE)
-- 
1.8.5.3

