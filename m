Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaEXHDT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:03:19 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:45589 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaEXHC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:02:26 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 20/24] ptrace: Allow compat to use the native siginfo.
Date: Sat, 24 May 2014 00:02:15 -0700
Message-Id: <1400914939-9708-21-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400914939-9708-1-git-send-email-apinski@cavium.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
To: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With ARM64 ILP32 ABI, we want to use the non-compat siginfo as we want to simplify signal handling for this new ABI.  This patch just adds a new define COMPAT_USE_NATIVE_SIGINFO and if it is true then read/write in the compat case as it was the non-compat case.

Thanks,
Andrew Pinski

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 include/linux/compat.h |    4 ++++
 kernel/ptrace.c        |   24 +++++++++++++++++-------
 2 files changed, 21 insertions(+), 7 deletions(-)

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
index adf9862..5f8bb5c 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -663,7 +663,7 @@ static int ptrace_peek_siginfo(struct task_struct *child,
 			break;
 
 #ifdef CONFIG_COMPAT
-		if (unlikely(is_compat_task())) {
+		if (unlikely(is_compat_task() && !COMPAT_USE_NATIVE_SIGINFO)) {
 			compat_siginfo_t __user *uinfo = compat_ptr(data);
 
 			if (copy_siginfo_to_user32(uinfo, &info) ||
@@ -1132,16 +1132,26 @@ int compat_ptrace_request(struct task_struct *child, compat_long_t request,
 
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
+				 &siginfo, (struct compat_siginfo __user *) datap);
+		if (ret)
 			ret = -EFAULT;
 		else
 			ret = ptrace_setsiginfo(child, &siginfo);
-- 
1.7.2.5

