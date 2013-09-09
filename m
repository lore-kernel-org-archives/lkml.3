Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab3IIVdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 17:33:37 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:33629 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab3IIVdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 17:33:10 -0400
From: Andrew Pinski <pinskia@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/5] FS: Export poll_select_copy_remaining and rename poll_select_copy_remaining in compat.c so it does not pick the wrong copy.
Date: Mon,  9 Sep 2013 14:32:57 -0700
Message-Id: <1378762380-13152-3-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1378762380-13152-1-git-send-email-apinski@cavium.com>
References: <1378762380-13152-1-git-send-email-apinski@cavium.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  The ILP32 ABI in ARM64 uses a slightly different pselect from either the compat or even the native LP64 ABI.  We would want to reuse some of the code path that are used as the size of the timespec is the same, so this patch exports poll_select_copy_remaining from fs/select.c and renames the copy in fs/compat.c to make sure that it is not being used.

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 fs/compat.c |    8 ++++----
 fs/select.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 6af20de..298e3e1 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1088,7 +1088,7 @@ COMPAT_SYSCALL_DEFINE4(openat, int, dfd, const char __user *, filename, int, fla
 
 #define __COMPAT_NFDBITS       (8 * sizeof(compat_ulong_t))
 
-static int poll_select_copy_remaining(struct timespec *end_time, void __user *p,
+static int compat_poll_select_copy_remaining(struct timespec *end_time, void __user *p,
 				      int timeval, int ret)
 {
 	struct timespec ts;
@@ -1307,7 +1307,7 @@ asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
 	}
 
 	ret = compat_core_sys_select(n, inp, outp, exp, to);
-	ret = poll_select_copy_remaining(&end_time, tvp, 1, ret);
+	ret = compat_poll_select_copy_remaining(&end_time, tvp, 1, ret);
 
 	return ret;
 }
@@ -1362,7 +1362,7 @@ static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 	}
 
 	ret = compat_core_sys_select(n, inp, outp, exp, to);
-	ret = poll_select_copy_remaining(&end_time, tsp, 0, ret);
+	ret = compat_poll_select_copy_remaining(&end_time, tsp, 0, ret);
 
 	if (ret == -ERESTARTNOHAND) {
 		/*
@@ -1448,7 +1448,7 @@ asmlinkage long compat_sys_ppoll(struct pollfd __user *ufds,
 	} else if (sigmask)
 		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
 
-	ret = poll_select_copy_remaining(&end_time, tsp, 0, ret);
+	ret = compat_poll_select_copy_remaining(&end_time, tsp, 0, ret);
 
 	return ret;
 }
diff --git a/fs/select.c b/fs/select.c
index 35d4adc7..aef2c10 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -287,8 +287,8 @@ int poll_select_set_timeout(struct timespec *to, long sec, long nsec)
 	return 0;
 }
 
-static int poll_select_copy_remaining(struct timespec *end_time, void __user *p,
-				      int timeval, int ret)
+int poll_select_copy_remaining(struct timespec *end_time, void __user *p,
+			       int timeval, int ret)
 {
 	struct timespec rts;
 	struct timeval rtv;
-- 
1.7.2.5

