Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbaGAVzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:55:54 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:35183 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429AbaGAVx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:53:59 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 49/50] mars: generic pre-patch for mars
Date: Tue,  1 Jul 2014 23:47:29 +0200
Message-Id: <1404251250-22992-50-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Schoebel-Theuer <schoebel@bell.site>

Mostly introduces missing EXPORT_SYMBOL().
Should have no impact onto the kernel.

This is the generic version which exports all sys_*() system
calls. This should not introduce any additional maintenance pain
because that interfaces has to be stable anyway due to POSIX etc.

Signed-off-by: Thomas Schoebel-Theuer <schoebel@bell.site>
---
 fs/open.c                  | 1 -
 fs/utimes.c                | 2 ++
 include/linux/syscalls.h   | 3 +++
 include/uapi/linux/major.h | 1 +
 mm/page_alloc.c            | 3 +++
 5 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index 36662d0..3b21b76 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1064,7 +1064,6 @@ SYSCALL_DEFINE1(close, unsigned int, fd)
 
 	return retval;
 }
-EXPORT_SYMBOL(sys_close);
 
 /*
  * This routine simulates a hangup on the tty, to arrange that users
diff --git a/fs/utimes.c b/fs/utimes.c
index aa138d6..4a1f4a8 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -1,3 +1,4 @@
+#include <linux/module.h>
 #include <linux/compiler.h>
 #include <linux/file.h>
 #include <linux/fs.h>
@@ -181,6 +182,7 @@ retry:
 out:
 	return error;
 }
+EXPORT_SYMBOL(do_utimes);
 
 SYSCALL_DEFINE4(utimensat, int, dfd, const char __user *, filename,
 		struct timespec __user *, utimes, int, flags)
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b0881a0..c674309 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -75,6 +75,7 @@ struct sigaltstack;
 #include <linux/sem.h>
 #include <asm/siginfo.h>
 #include <linux/unistd.h>
+#include <linux/export.h>
 #include <linux/quota.h>
 #include <linux/key.h>
 #include <trace/syscall.h>
@@ -176,6 +177,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 
 #define SYSCALL_DEFINE0(sname)					\
 	SYSCALL_METADATA(_##sname, 0);				\
+	EXPORT_SYMBOL(sys_##sname);				\
 	asmlinkage long sys_##sname(void)
 
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
@@ -202,6 +204,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		__PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));	\
 		return ret;						\
 	}								\
+	EXPORT_SYMBOL(sys##name);					\
 	static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 
 asmlinkage long sys32_quotactl(unsigned int cmd, const char __user *special,
diff --git a/include/uapi/linux/major.h b/include/uapi/linux/major.h
index 620252e..61a665c 100644
--- a/include/uapi/linux/major.h
+++ b/include/uapi/linux/major.h
@@ -148,6 +148,7 @@
 #define UNIX98_PTY_SLAVE_MAJOR	(UNIX98_PTY_MASTER_MAJOR+UNIX98_PTY_MAJOR_COUNT)
 
 #define DRBD_MAJOR		147
+#define MARS_MAJOR		148
 #define RTF_MAJOR		150
 #define RAW_MAJOR		162
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4f59fa2..e55e7c5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -205,6 +205,8 @@ static char * const zone_names[MAX_NR_ZONES] = {
 };
 
 int min_free_kbytes = 1024;
+EXPORT_SYMBOL(min_free_kbytes);
+
 int user_min_free_kbytes = -1;
 
 static unsigned long __meminitdata nr_kernel_pages;
@@ -5692,6 +5694,7 @@ static void __setup_per_zone_wmarks(void)
 	/* update totalreserve_pages */
 	calculate_totalreserve_pages();
 }
+EXPORT_SYMBOL(setup_per_zone_wmarks);
 
 /**
  * setup_per_zone_wmarks - called when min_free_kbytes changes
-- 
2.0.0

