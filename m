Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890AbaICVX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:23:58 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:46805 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641AbaICVXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:23:12 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pinskia@gmail.com
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 19/24] ptrace: Allow compat to use the native siginfo
Date: Wed,  3 Sep 2014 14:19:13 -0700
Message-Id: <1409779158-30963-20-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1409779158-30963-1-git-send-email-apinski@cavium.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With ARM64 ILP32 ABI, we want to use the non-compat
siginfo as we want to simplify signal handling for this new ABI.
This patch just adds a new define COMPAT_USE_NATIVE_SIGINFO and
if it is true then read/write in the compat case as it was the
non-compat case.

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 include/linux/compat.h |    4 ++++
 kernel/ptrace.c        |   25 ++++++++++++++++++-------
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index e649426..2d8c535 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -24,6 +24,10 @@
 #define COMPAT_USE_64BIT_TIME 0
 #endif
 
+#ifndef COMPAT_USE_NATIVE_SIGINFO
+#define COMPAT_USE_NATIVE_SIGINFO 0
+#endif
+
 #ifndef __SC_DELOUSE
 #define __SC_DELOUSE(t,v) ((t)(unsigned long)(v))
 #endif
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 54e7522..40ae023 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -657,7 +657,7 @@ static int ptrace_peek_siginfo(struct task_struct *child,
 			break;
 
 #ifdef CONFIG_COMPAT
-		if (unlikely(is_compat_task())) {
+		if (unlikely(is_compat_task() && !COMPAT_USE_NATIVE_SIGINFO)) {
 			compat_siginfo_t __user *uinfo = compat_ptr(data);
 
 			if (copy_siginfo_to_user32(uinfo, &info) ||
@@ -1126,16 +1126,27 @@ int compat_ptrace_request(struct task_struct *child, compat_long_t request,
 
 	case PTRACE_GETSIGINFO:
 		ret = ptrace_getsiginfo(child, &siginfo);
-		if (!ret)
-			ret = copy_siginfo_to_user32(
-				(struct compat_siginfo __user *) datap,
-				&siginfo);
+		if (!ret) {
+			if (COMPAT_USE_NATIVE_SIGINFO)
+				ret = copy_siginfo_to_user(
+					(struct siginfo __user *) datap,
+					&siginfo);
+			else
+				ret = copy_siginfo_to_user32(
+					(struct compat_siginfo __user *) datap,
+					&siginfo);
+		}
 		break;
 
 	case PTRACE_SETSIGINFO:
 		memset(&siginfo, 0, sizeof siginfo);
-		if (copy_siginfo_from_user32(
-			    &siginfo, (struct compat_siginfo __user *) datap))
+		if (COMPAT_USE_NATIVE_SIGINFO)
+			ret = copy_from_user(&siginfo, datap, sizeof(siginfo));
+		else
+			ret = copy_siginfo_from_user32(
+				 &siginfo,
+				 (struct compat_siginfo __user *) datap);
+		if (ret)
 			ret = -EFAULT;
 		else
 			ret = ptrace_setsiginfo(child, &siginfo);
-- 
1.7.2.5

